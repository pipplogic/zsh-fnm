#!/bin/zsh

export FNM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"/fnm

if [ ! -d "$FNM_DIR" ]; then
  echo Installing fnm...
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$FNM_DIR" --skip-shell
  FNM_JUST_INSTALLED=1
fi

export PATH=$FNM_DIR:$PATH
eval "$(fnm env)"

if [ "$FNM_JUST_INSTALLED" = 1 ]; then
  fnm install --lts
  fnm completions --shell=zsh > "$FNM_DIR"/_fnm
fi

fpath+="$FNM_DIR"

FNM_USING_LOCAL=0
load-nvmrc() {
  if [[ -r .nvmrc || -r .node-version ]]; then
    FNM_USING_LOCAL=1
    fnm use
  elif [ $FNM_USING_LOCAL -eq 1 ]; then
    FNM_USING_LOCAL=0
    fnm use default
  fi
}

load-nvmrc

autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc

