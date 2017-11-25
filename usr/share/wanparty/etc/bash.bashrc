# mfa-wheeze-postinstall - /etc/bash.bashrc
# Fichier lu par bash lancé en tant que shell interractif
# Appelé par /etc/profile pour que les shell de login en profite

# Si ce n'est pas un shell interractif, alors FIN
[ -z "$PS1" ] && return

# Choix de la couleur pour l'affichage
#31 Red; 32 Green; 33 Yellow; 34 Blue; 35 Magenta; 36 Cyan
couleur=32

# Réajuste les valeur de LINES et COLUMNS après changement de la taille de la fenêtre
shopt -s checkwinsize

# Journalise l'histrique des commandes
shopt -s histappend


# Change le PATH  et le prompt en fonction de l'utilisateur
if [ "`id -u`" -eq 0 ];
then
	export PATH="/sbin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11"
	# Affiche en inverse vidéo avec un joli prompt
	PS1='\n\[\033[0;7;'$couleur'm\]\u@\H\[\033[0m\] : \w\n\$ '
else
	export PATH="/sbin/:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games"
	# Affiche normalement avec un joli prompt
	PS1='\n\[\033[0;1;'$couleur'm\]\u@\H\[\033[0m\] : \w\n\$ '
fi

# Si c'est une fenetre xterm, on rajoute un titre
case "$TERM" in
xterm*|rxvt*)
	PS1='\[\033]0;\u@\H : \w\007\]'$PS1
	;;
*)
	;;
esac

export PS1

# Masque 007 pour la création de fichiers (Attention pour apt-mirror à forcer un chmod o+r dans le cron !)
umask 007

# On interdit les messages vers la console
mesg n

# Pour un ls en couleur
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias la='ls $LS_OPTIONS -al'

# Pour éviter les erreurs 
alias rm='rm -i'
alias mv='mv -i'

# Quelques autres alias
alias du='du -h --max-depth=1'
alias df='df -h'

# Auto su pour membres du groupe root !
#if [ "`id -u`" -ne 0 ]; then
#	# si je suis membre du groupe root
#	if [ -n "`groups | grep root`" ]; then
#		# auto root !
#		su -
#	fi
#fi


shopt -s checkwinsize
set show-all-if-ambiguous on
# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups  
# append history entries..
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'