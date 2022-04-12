# Misc
function check() {
  if [ $? -ne 0 ]
  then
    echo "Command failed"
    return 1
  fi
}

alias reset="source ~/.zshrc"

#Formatting
alias sut="cat << EOM |tr -d \"[:blank:]\" |  sort | uniq"
alias cls="clear && printf '\e[3J'"

# Git
alias ga="git add"
alias gb="git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'"
alias gbs="git branch"
alias gc="git checkout"
alias gcom="git commit -m"
alias gdiff="git diff --name-status master"
alias gm="git checkout master"
alias gull="git pull"
alias gush="git push origin"
alias gs="git status"

function initsdkman() {
  export SDKMAN_DIR="/Users/stephen/.sdkman"
  [[ -s "/Users/stephen/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/stephen/.sdkman/bin/sdkman-init.sh"
}

function gco() {
  if [ -z "$1" ]
  then
      git commit -m $(gb)
  else
      git commit -m $1
  fi
  gush
}

function gd() {
  git branch -D $1
  git push origin --delete $1
}

function gf() {
  git checkout -b $1
  git push --set-upstream origin $1
}

function gsubmit() {
  branch=$(gb)
  check || return
  if [[ -n $(git status -s) ]]
  then
    ga .
    gco
    check || return
  fi
  git checkout master
  check || return
  git merge $branch
  check || return
  gush
  check || return
  gd $branch
}

# Repos
export REPOSITORY="$HOME/Repository"

function r() {
  cd "$REPOSITORY/$1"
}

alias rs="ls $REPOSITORY"

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{green} (%b)%f'

setopt PROMPT_SUBST
PROMPT='%F{cyan}%m%f %F{red}%1~%f${vcs_info_msg_0_} # '
