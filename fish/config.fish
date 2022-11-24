set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

set -x -g TERM xterm-256color

set -x -g LC_ALL en_GB.UTF-8
set -x -g LANG en_GB.UTF-8

eval $(/opt/homebrew/bin/brew shellenv)

# Coreutils bin and man folders
set -x -g PATH (brew --prefix coreutils)/libexec/gnubin $PATH
# set -x -g MANPATH (brew --prefix coreutils)/libexec/gnuman $MANPATH

# Findutils bin and man folders
set -x -g PATH (brew --prefix findutils)/libexec/gnubin $PATH
# set -x -g MANPATH (brew --prefix findutils)/libexec/gnuman $MANPATH

# User bin folder
set -x -g PATH ~/bin $PATH /usr/local/sbin

# Composer
set -x -g PATH ~/.composer/vendor/bin $PATH

# Composer
set -x -g PATH ~/.composer/vendor/bin $PATH

set -x -g PATH ~/vendor/apache-maven-3.6.0/bin $PATH

# For Go local
set -x -g GOPATH $HOME/go

# Add go binaries to path
set -x -g PATH $GOPATH/ $PATH
set -x -g PATH $GOPATH/bin $PATH

#bobthefish config
set -g fish_prompt_pwd_dir_length 0

set -g theme_display_cmd_duration yes
set -g theme_display_docker_machine no
set -g theme_nerd_fonts yes
set -g theme_newline_cursor yes

# rbenv
status --is-interactive; and source (rbenv init -|psub)

# if not functions -q fisher
#     set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
#     curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
#     fish -c fisher
# end

set -g fish_user_paths "~/.tfenv/bin" $fish_user_paths

# Pyenv Init
pyenv init - | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# direnv hook fish | source
