# .bashrc

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export PATH="$HOME/.local/bin:$HOME/local/bin:$PATH"

if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

unset rc
