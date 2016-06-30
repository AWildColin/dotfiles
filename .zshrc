########################################################
# vim:smd:ar:si:et:bg=dark:ts=4:sw=4
# file: .zshrc
# author: Chris Olin - http://chrisolin.com
# purpose: personal zshrc configuration
# created date: 03-18-2013
# license:
########################################################
autoload -U colors
autoload -U promptinit 
autoload -U compinit
promptinit
compinit 

# Source shell aliases and functions
source ~/.aliases
source ~/.privatealiases
source ~/.functions/*

# Source and load the oh-my-zsh library
if [ ! -d ~/.antigen ]; then
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
fi
source ~/.antigen/antigen.zsh
antigen-use oh-my-zsh

# configure prompt colors
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

# git color settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

# set prompts
PROMPT='$FG[124][%y]%{$reset_color%}%  $FG[032]%~ \
$(git_prompt_info) \
$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

# syntax highlighting bundle
antigen-bundle zsh-users/zsh-syntax-highlighting

# Apply settings
antigen-apply

# Autocompletion with arrow key interface
zstyle ':completion:*' menu select

# Autocompletion of command line switches for aliases
setopt completealiases

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Set environment variables for gpg-agent.
gpg_agent_info="${HOME}/.gnupg/gpg-agent-info"
if [ -f $gpg_agent_info ]
then
	    source $gpg_agent_info
	    export GPG_AGENT_INFO
	    export GPG_TTY=$(tty)
fi

#path additions
PATH=$PATH:/home/chris/bin:/opt/android-sdk:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.gem/ruby/2.2.0/bin

#gpg stuff
export CHRISGPG="F6DD6966"
export CONTACTGPG="02884713"
export EMPLOYMENTGPG="EA1B581C"
export GITHUBGPG="EF002BF9"
export WORDPRESSGPG="C03228FF"
export WORKGPG="0A0F6593"

#oh-my-zsh/af-magic theme customizations
RPROMPT='$FG[241]%n@%m $FG[124][%y]%{$reset_color%}%'

#autoconfigure ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

#other stuff
export PATH=$PATH:/usr/local/bin:$HOME/bin
export TERM=xterm-256color
export LANG="en_US.UTF-8"
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
unset GREP_OPTIONS # getting rid of that godforsaken warning message about this variable being depricated every time I use grep
