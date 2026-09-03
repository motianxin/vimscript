# .bashrc
alias a="alias"
alias una="unalias"
alias g="gvim"
alias la="ls -a"
alias ll="ls -larth --sort=time --color=auto"
cd() { builtin cd "$@" && ll; }
alias b="cd ../"
alias bb="cd ../.."
alias bbb="cd ../../.."
alias rf="rm -rf"
a now="date +%m%d%H%M%S | sed '/^0*//'"
a gitck="git checkout"
a gitst="git status -suno"
a gitcm='git commit -m "update by zghuang"'
a gitpu='git push'
a sc='source ~/.bashrc'
a gc='g ~/vimscript/user.bashrc'
a gv="g ~/vimscript/vimrc"
a gitlog='git log --graph --format="%H->%P <%s> %cn:%ad" -n 10'

USER_COLOR='\[\033[38;2;60;180;220m\]'
HOST_COLOR='\[\033[38;2;255;180;80m\]'
PATH_COLOR='\[\033[38;2;120;230;160m\]'
GIT_COLOR='\[\033[38;2;255;222;129m\]'
TIME_COLOR='\[\033[38;2;220;120;255m\]'
RESET='\[\033[00m\]'

export PS1="${USER_COLOR}\u${RESET}@${HOST_COLOR}\h ${PATH_COLOR}\w${GIT_COLOR} \D{%Y-%m-%d} \t ${RESET}\$"

export PS2="\[\033[1m\]\[\033[30m\]&gt; \[\033[0m\]"
alias go='source ~/vimscript/go.sh'
