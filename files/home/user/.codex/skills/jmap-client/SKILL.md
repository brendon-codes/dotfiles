---
name: jmap-client
description: Rust JMAP mail integration guidance for the jmap-client crate version 0.4.0. Use when implementing or reviewing Rust code that connects to JMAP servers, queries or fetches email, downloads blobs, batches JMAP requests, resolves identities or mailboxes, or sends mail with Email/set and EmailSubmission/set.
---

# JMAP Client

Use this as a compact implementation guide for Rust code using:

```toml
jmap-client = "0.4.0"
```

Prefer compiler-checked local code, the crate source for the pinned version, and integration tests over memory or external examples. External docs for other versions may show different helper paths or method shapes.

## Crate Surface

The crate path is `jmap_client`.

Supported protocol surface:

- RFC 8620 JMAP Core
- RFC 8621 JMAP Mail
- RFC 8887 JMAP over WebSocket
- Sieve helpers are present, but only use them after checking the pinned crate API.

Feature defaults:

| Feature | Default | Use |
|---|---:|---|
| `async` | yes | Normal async client path |
| `blocking` | no | Enable only for synchronous callers |
| `websockets` | yes | WebSocket JMAP support |
| `ring` | yes | Default TLS backend |
| `aws-lc-rs` | no | Alternate TLS backend |
| `debug` | no | Extra internal diagnostics |

High-value modules:

- `client`: `Client`, `ClientBuilder`, session and request entrypoints
- `core::query`: generic filter and comparator wrappers
- `email::query`: mail filters and sort comparators
- `email::get` and `email::helpers`: selected property fetches and accessors
- `blob`: blob download and upload helpers
- `core::request` and `core::response`: batched request mechanics
- `identity`, `mailbox`, `email_submission`: send context and submission flows

## Client Setup

Start every connection with `Client::new()`, attach credentials, restrict redirects, then connect to the JMAP session URL.

```rust
use jmap_client::client::Client;

const TRUSTED_HOSTS: [&str; 2] = ["api.fastmail.com", "jmap.fastmail.com"];

let client = Client::new()
    .credentials(api_token)
    .follow_redirects(TRUSTED_HOSTS)
    .connect(jmap_url)
    .await?;
```

`credentials` accepts bearer tokens or supported credential forms through `Into<Credentials>`. Auth, TLS, network, redirect, and session discovery failures surface when `connect` or later method calls run.

Useful session methods:

```rust
client.session();
client.refresh_session().await?;
client.default_account_id();
client.set_default_account_id(account_id);
client.session_url();
```

Do not assume the default account is correct for every operation. For send flows, resolve the account with the required capabilities and pass it with `client.build().account_id(account_id)`.

## Query Email

Use `email_query` or the request builder for `Email/query`. Compose mail filters with `core::query::Filter` when multiple conditions are needed.

```rust
use jmap_client::{core::query::Filter as CoreFilter, email};

let filter = CoreFilter::and([
    email::query::Filter::from(sender).into(),
    email::query::Filter::after(start_timestamp).into(),
    email::query::Filter::before(end_timestamp).into(),
    email::query::Filter::has_attachment(true).into(),
]);
let sort = [email::query::Comparator::received_at().ascending()];
let mut response = client.email_query(Some(filter), Some(sort)).await?;
let ids = response.take_ids();
```

Common filter conditions:

- `email::query::Filter::from(...)`
- `email::query::Filter::header(name, value)`
- `email::query::Filter::after(timestamp)`
- `email::query::Filter::before(timestamp)`
- `email::query::Filter::has_attachment(true)`
- `email::query::Filter::subject(...)`
- `email::query::Filter::body(...)`
- `email::query::Filter::text(...)`

`email_query` returns IDs and query metadata. Treat an empty ID list as a valid result, not an error.

## Fetch Email

`email_get` can fetch one message with a property allow-list:

```rust
use jmap_client::{email, Get};

let properties = [
    email::Property::Id,
    email::Property::Subject,
    email::Property::From,
    email::Property::To,
    email::Property::ReceivedAt,
    email::Property::Preview,
    email::Property::TextBody,
    email::Property::BodyValues,
    email::Property::Attachments,
    email::Property::HasAttachment,
    email::Property::MessageId,
];
let maybe_email: Option<email::Email<Get>> = client.email_get(email_id, Some(properties)).await?;
```

Use the request builder when the caller needs body value arguments. Requesting `Property::BodyValues` alone is not enough to fetch text values because RFC 8621 defaults body fetch flags to false.

```rust
use jmap_client::email::Property;

let properties = [
    Property::Id,
    Property::Subject,
    Property::From,
    Property::To,
    Property::ReceivedAt,
    Property::Preview,
    Property::TextBody,
    Property::BodyValues,
    Property::Attachments,
    Property::HasAttachment,
    Property::MessageId,
];
let mut request = client.build();
let get_email = request.get_email().ids([email_id]);
get_email.properties(properties);
get_email.arguments().fetch_text_body_values(true);
let mut response = request.send_get_email().await?;
let maybe_email = response.take_list().pop();
```

Build message text from `text_body()` part IDs and matching `body_value(part_id)` entries. Use `preview()` only as a fallback because server previews are short generated text. Leave `maxBodyValueBytes` unset unless truncation is intentional; the RFC default `0` means no truncation.

Handle `Ok(None)` or an empty `take_list()` as a missing or raced message.

## Blob Download

Use attachment metadata from `Email<Get>` to locate `blob_id`, then download raw bytes unchanged:

```rust
let bytes = client.download(blob_id).await?;
```

The caller owns file type checks, MIME checks, persistence, and binary equality expectations.

## Batch Requests

Use `client.build()` when one operation needs method-specific arguments, a specific account, or multiple JMAP calls in one HTTP request.

```rust
let mut request = client.build().account_id(account_id);
```

Important request behaviors in `jmap-client` 0.4.0:

- `Request::new` includes Core and Mail capabilities.
- `account_id(...)` sets the account for method calls built from that request.
- `send()` returns a generic batched response.
- `send_single<T>()` is useful when exactly one typed response is expected.
- `set_email_submission()` adds Submission capability for submission calls.
- `Identity/get` may require manually adding Submission capability for some servers.

For `Identity/get` against servers that require Submission in the `using` list:

```rust
use jmap_client::{identity, URI};

let properties = [identity::Property::Id, identity::Property::Email];
let mut request = client.build().account_id(account_id);
request.add_capability(URI::Submission);
request.get_identity().properties(properties);
let mut response = request.send_get_identity().await?;
```

For `Mailbox/get`, request only what is needed and select by role:

```rust
use jmap_client::mailbox;

let properties = [
    mailbox::Property::Id,
    mailbox::Property::Name,
    mailbox::Property::Role,
];
let mut request = client.build().account_id(account_id);
request.get_mailbox().properties(properties);
let mut response = request.send_get_mailbox().await?;
let mailboxes = response.take_list();
```

## Capabilities And Accounts

Before sending mail, validate both session-level and account-level support for:

- `urn:ietf:params:jmap:core`
- `urn:ietf:params:jmap:mail`
- `urn:ietf:params:jmap:submission`

Use session data to identify the account that supports Mail and Submission. Prefer one account that advertises both capabilities. If a server exposes separate primary accounts, write that handling explicitly rather than relying on the client's default account.

The sending identity must match the desired `from` address. The mailboxes needed for post-submit cleanup usually include roles `drafts` and `sent`.

## Send Flow

The portable send pattern is:

1. Resolve account, identity, drafts mailbox, and sent mailbox.
2. Create a draft with `Email/set`.
3. Submit it with `EmailSubmission/set`.
4. Use `onSuccessUpdateEmail` to remove draft state and add sent mailbox state.
5. Validate every method-level response, including the implicit post-submit update.

When typed helpers cannot express required `null` patch semantics, post raw JSON. In particular, `jmap-client` 0.4.0 typed email patch helpers can serialize removal patches as boolean `false`, while RFC-compliant mailbox and keyword removals in `onSuccessUpdateEmail` require JSON `null`.

Required raw JSON shape:

```json
{
  "using": [
    "urn:ietf:params:jmap:core",
    "urn:ietf:params:jmap:mail",
    "urn:ietf:params:jmap:submission"
  ],
  "methodCalls": [
    [
      "Email/set",
      {
        "accountId": "<account-id>",
        "create": {
          "draft": {
            "mailboxIds": {
              "<drafts-mailbox-id>": true
            },
            "keywords": {
              "$draft": true
            },
            "from": [
              {
                "name": null,
                "email": "<from-email>"
              }
            ],
            "to": [
              {
                "name": "<to-name-or-null>",
                "email": "<to-email>"
              }
            ],
            "subject": "<subject>",
            "textBody": [
              {
                "partId": "body",
                "type": "text/plain"
              }
            ],
            "bodyValues": {
              "body": {
                "value": "<body>"
              }
            }
          }
        }
      },
      "s0"
    ],
    [
      "EmailSubmission/set",
      {
        "accountId": "<account-id>",
        "create": {
          "submission": {
            "emailId": "#draft",
            "identityId": "<identity-id>"
          }
        },
        "onSuccessUpdateEmail": {
          "#submission": {
            "keywords/$draft": null,
            "mailboxIds/<drafts-mailbox-id>": null,
            "mailboxIds/<sent-mailbox-id>": true
          }
        }
      },
      "s1"
    ]
  ]
}
```

Response validation requirements:

- The `Email/set` response with call id `s0` must contain a created id for `draft`.
- The `EmailSubmission/set` response with call id `s1` must contain a created id for `submission`.
- The implicit post-submit `Email/set` response associated with `s1` must not contain `notUpdated` errors.
- Bubble method-level errors with method names, for example `Identity/get failed`, `Mailbox/get failed`, `Email/set failed`, or `EmailSubmission/set failed`.

## Failure Modes

| Surface | Symptom | Recovery |
|---|---|---|
| Bad or expired token | connect, query, get, or download fails | Refresh credentials and retry |
| Missing Mail capability | query or get fails | Use credentials and account with Mail support |
| Missing Submission capability | identity or submission fails | Use credentials and account with Submission support |
| Missing Submission in `using` for `Identity/get` | server returns `unknownMethod` | Add `URI::Submission` before `get_identity()` |
| Missing identity | no identity matches sender | Add or enable sender identity on the server |
| Missing mailbox role | drafts or sent role lookup fails | Repair mailbox roles or select explicit mailbox IDs |
| Untrusted redirect host | connect rejects redirect | Expand allow-list intentionally |
| Empty query result | no matching messages | Treat as valid and inspect filters if unexpected |
| Missing fetched message | `email_get` returns `None` | Skip or retry according to caller semantics |
| Blob download fails | missing blob, permission, or transport error | Bubble the JMAP error with context |
| Post-submit cleanup fails | submission may already have happened | Check server state before retrying |

## Validation Checklist

Before merging JMAP code:

- Confirm `Cargo.toml` pins `jmap-client = "0.4.0"` unless an intentional upgrade includes API verification.
- Confirm imports use `jmap_client` module paths that compile for the pinned version.
- Confirm redirect hosts are explicitly allow-listed.
- Confirm `Email/get` body fetches set `fetch_text_body_values(true)` when full text is required.
- Confirm missing messages and empty query results are handled without panics.
- Confirm blob bytes are not decoded or transformed by the JMAP layer.
- Confirm send flows validate Core, Mail, and Submission capabilities.
- Confirm `Identity/get` includes `URI::Submission` when the target server requires it.
- Confirm `EmailSubmission/set` cleanup uses JSON `null` for removals.
- Confirm method-level errors identify the failing JMAP method.
- Run focused integration tests against a mock JMAP server or a controlled test account.
