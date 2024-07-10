# vim: set ft=sh:

function g_is_sourced() 
{
	if [ -n "$BASH" ]
	then
		if [ -z "$BASH_ARGV" ]
		then
			return 1
		else
			return 0
		fi
	fi
	# Zsh
	if [ -n "$TTY" ]
	then
		return 1
	fi
	return 0
}
function g_rc_log()
{
	if ! g_is_sourced
	then
		echo -e "$( date "+%d-%m-%Y %H:%M:%S.%N" ) :: \033[1;36m$*\033[0m"
	fi
}

g_rc_log "🚀 Starting Greg's environment ... "
export PATH="$PATH:$HOME/.local/bin/"

#########################################################################
# ALIASES
#########################################################################
alias fucking=sudo
alias a=ansible
alias ap=ansible-playbook
alias es="~/Gitlab/L3/tool3box/bin/esgrep.py"

# cp with a progress bar
# some patches exists with a -g or -B option
alias cP='rsync --partial --progress'

if [ -e ~/.aliases ]
then
    source ~/.aliases
fi

#########################################################################
# COLORS
#########################################################################
# Permet d'avoir les man en couleur
export LESS_TERMCAP_mb=$'\E[01;31m'    # début de blink
export LESS_TERMCAP_md=$'\E[01;31m'    # début de gras
export LESS_TERMCAP_me=$'\E[0m'        # fin
export LESS_TERMCAP_so=$'\E[01;44;33m' # début de la ligne d`état
export LESS_TERMCAP_se=$'\E[0m'        # fin
export LESS_TERMCAP_us=$'\E[01;32m'    # début de souligné
export LESS_TERMCAP_ue=$'\E[0m'        # fin
export LESS=-FSRX 
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

export GREP_COLORS='mt=37;45'
# since grep 2.21:
export GREP_OPTIONS=

export EDITOR="vim"
export VISUAL="vim"


function g_melodyping() { ping $1|awk -F[=\ ] '/me=/{t=$(NF-1);f=3000-14*log(t^20);c="play -q -n synth 0.7s pl " f;print $0;system(c)}'; }

function g_psmem() { ps -e -orss=,pid=,args= | sort -b -k1n | pr -TW$COLUMNS; }

function g_mysql_sniff() { 
	IF=${1-lo}
	PORT=${2-3306}
	ssh root@localhost tcpdump -i $IF -s 0 -l -w - dst port $PORT | strings | perl -e '
		while(<>) { chomp; next if /^[^ ]+[ ]*$/;
		if(/^(SELECT|UPDATE|DELETE|INSERT|SET|COMMIT|ROLLBACK|CREATE|DROP|ALTER|SHOW)/i) {
		if (defined $q) { print "$q\n"; }
		$q=$_;
		} else {
		$_ =~ s/^[ \t]+//; $q.=" $_";
		}
		}'
}

function g_epoch()
{
	date "+%s"
}

function g_timestamp()
{
	epoch
}

function g_epoch2human()
{
	[ -z "$1" ] && echo "Usage $0 epoch_time"
	date -d @$1 
}

function g_human2epoch()
{
	[ -z "$1" ] && echo "Usage $0 date_du_jour"
	#date +%s -d "$*" 
	#echo "$@"
	#date -d "$@" +%s
	date --date "${*}" "+%s"
}

function g_dbus()
{
	# DBUS
	if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]
	then
		#export DBUS_SESSION_BUS_ADDRESS="$( ps ux | grep dbus | grep -Eo -- "--address=(.+)" | cut -d= -f2,3 )"
		export $( cat /proc/*/environ 2>/dev/null | tr '\0' '\n' | grep "DBUS_SESSION_BUS_ADDRESS=[a-z]" | head -1  )
		echo "DBUS set to $DBUS_SESSION_BUS_ADDRESS"
	fi
}

g_rc_log "🕹️  Environment loaded."


