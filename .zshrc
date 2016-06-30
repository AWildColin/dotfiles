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

# source aliases
if [ -f "${HOME}/.aliases" ]; then
    source "${HOME}/.aliases"
fi
if [ -f "${HOME}/.secretaliases" ]; then
    source "${HOME}/.secretaliases"
fi

# source and load the oh-my-zsh library
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

# apply settings
antigen-apply

# autocompletion with arrow key interface
zstyle ':completion:*' menu select

# autocompletion of command line switches for aliases
setopt completealiases

# set environment variables for gpg-agent.
gpg_agent_info="${HOME}/.gnupg/gpg-agent-info"
if [ -f $gpg_agent_info ]
then
	    source $gpg_agent_info
	    export GPG_AGENT_INFO
	    export GPG_TTY=$(tty)
fi

# path additions
PATH=$PATH:/home/chris/bin:/opt/android-sdk:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$HOME/.gem/ruby/2.2.0/bin

# autoconfigure ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# source SSH settings, if applicable

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
