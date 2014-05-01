alias c='clear'
alias so='lsb_release -si'
alias g='grep'
alias l='ls'
alias p='ping'
alias x='exit'
alias hmc-eio='ssh hscroot@9.3.191.8'
alias jupiter='ssh root@9.3.190.16'
alias katyFVT='ssh root@9.3.189.58'

function pomodoro () 
{ 
    minutes=${1:-25};
    notify-send --icon=appointment 'Pomodoro' "Start! \n($minutes minutes)";
    sleep $(($minutes * 60));
    notify-send --icon=appointment-missed 'Pomodoro' "Stop. \n($minutes minutes)"
}


function s () 
{ 
    local host="$1";
    shift;
    local args="$@";
    echo $host | grep '@' 2>&1 > /dev/null || local user='root@';
    local command="ssh ${user}${host} $args";
    echo "Command: $command";
    eval $command
}

function gsa () 
{ 
    local gsa_path=${1:-'/gsa/ausgsa/home/d/k/dkreling'};
    local gsa_host=${2:-'ausgsa.ibm.com'};
    local command="sftp $gsa_host:$gsa_path";
    echo "Command: $command";
    eval $command
}

function speck ()
{
    local speck_path=${1:-''};
    #TODO finish this mess
}


function cl () 
{ 
    local cd_args=${1:-'~'};
    local ls_args=${2:-''};
    eval "cd $cd_args";
    eval "ls $ls_args"
}

function bso-auth () 
{ 
    #local host="${1:-9.8.234.104}"; # spv-41.ltc.br.ibm.com - HORTOLANIDA LAB
    local host="${1:-9.3.191.8}"; #hmc-eio.austin.ibm.com
    local ibm_mail="dbkreling@br.ibm.com";
    local ibm_passwd="";
    read -s -p "[BSO] IBM Intranet Password: " ibm_passwd;
    echo;
    wget --no-check-certificate https://"$host":443/ --post-data="au_pxytimetag=1396696820&uname=$ibm_mail&pwd=$ibm_passwd&ok=OK" -O - 2> /dev/null | sed -e 's:.*<H1>::g' -e 's:</H1>.*::g' -e 's:<[^>]*>:\n:g' | head -n 3
}

function blinkWeechat(){
	sudo chmod 666 /sys/class/leds/tpacpi\:\:thinklight/brightness;
	if [ $?=="0" ]; then
		echo; 
		echo 'Success! Light will now blink on all incoming weechat messages.'
	else
		echo;
		echo 'Invalid Password. Try again.'
	fi
}

function monitor(){
	echo "Turn on: 1 | Turn off: 2"
	read option
	if [ $option = 1 ];
		then xrandr --output VGA1 --auto --above LVDS1
	elif [ $option = 2 ];
		then xrandr --output VGA1 --off
	fi
}

function call(){
	grep -i $1 /home/dbkreling/Documents/conferenceCallsPasscodes
}

function mi (){
	grep -i -A 15 $1 /home/dbkreling/Documents/Power_IO/Info/machines_adapters_location.info
}

function rm-host () {
	ssh-keygen -f "/home/dbkreling/.ssh/known_hosts" -R $1
}

function ipr(){
	grep -i -C 2 $1 /home/dbkreling/Documents/Power_IO/Info/ioas.info
}
