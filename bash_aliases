alias c='clear'
alias g='grep'
alias l='ls'
alias p='ping'
alias x='exit'
alias hmc-eio='ssh hscroot@hmc-eio.austin.ibm.com'
alias jupiter='ssh root@9.3.190.16'
alias katyFVT='ssh root@9.3.189.58'

function compile ()
{

        cd /opt/ibm/ibm-sdk-lop/ibm-java-60/bin/; 
	./javac $1; # this has to be the full path of the .java file to be compiled.
	cd -;
	ls;
}


function pomodoro () 
{ 
    minutes=${1:-25};
    notify-send --icon=appointment 'Pomodoro' "Start! \n($minutes minutes)";
    sleep $(($minutes * 60));
    notify-send --icon=appointment-missed 'Pomodoro' "Stop. \n($minutes minutes)"
}

function rm-gsa () 
{ 
    local force='no';
    if [ "$1" = '-f' ]; then
        force='yes';
        shift;
    fi;
    local gsa_url="$1";
    if [ -z "$gsa_url" ]; then
        echo "[ Error ]  What is the file/dir's URL?";
        return 1;
    fi;
    local gsa_cell='';
    local gsa_path='';
    if echo $gsa_url | grep -E 'https?://'; then
        gsa_cell=$(echo $gsa_url | sed 's/^https\?:\/\/\([^/]\+\).\+/\1/');
        gsa_path=$(echo $gsa_url | sed 's/^https\?:\/\/[^/]\+\(.\+\)/\1/');
    else
        gsa_cell=${2:-'ausgsa.ibm.com'};
        gsa_path=$1;
    fi;
    gsa_url="$gsa_cell:$gsa_path";
    echo "Removing '$gsa_url'";
    if [ "$force" != 'yes' ]; then
        local confirm;
        read -p "Go ahead? [y/N] " confirm;
        if [ "$confirm" != "y" ]; then
            echo "Aborted.";
            return 2;
        fi;
    fi;
    empty_dir=$(mktemp --directory --tmpdir gsa.empty_dir.XXX);
    rsync -rvh --progress --delete --include="$(basename $gsa_url)**" --exclude='**' $empty_dir/ $(dirname $gsa_url);
    rc=$?;
    rm -rf $empty_folder;
    return $rc
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
    local gsa_path=${1:-'/projects/p/perfwklds/'};
    local gsa_host=${2:-'ausgsa.ibm.com'};
    local command="sftp $gsa_host:$gsa_path";
    echo "Command: $command";
    eval $command
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
    #local host="${1:-9.5.8.73}"; # begnap1.rch.stglabs.ibm.com - SDK machine
    local host="${1:-9.3.191.8}"; #hmc-eio.austin.ibm.com
    local ibm_mail="dbkreling@br.ibm.com";
    local ibm_passwd="";
    read -s -p "[BSO] IBM Intranet Password: " ibm_passwd;
    echo;
    wget --no-check-certificate https://"$host":443/ --post-data="au_pxytimetag=1396696820&uname=$ibm_mail&pwd=$ibm_passwd&ok=OK" -O - 2> /dev/null | sed -e 's:.*<H1>::g' -e 's:</H1>.*::g' -e 's:<[^>]*>:\n:g' | head -n 3
}

function jbb2012_scores() {
	local gsa_url=$1
	if [ -z "$gsa_url" ]; then
		echo 'Error. No URL.'
		return 1
	fi

	local gsa_cell=$(echo $gsa_url | sed 's/^https\?:\/\/\([^/]\+\).\+/\1/');
        local gsa_path=$(echo $gsa_url | sed 's/^https\?:\/\/[^/]\+\(.\+\)/\1/');

	local temp_file=$(mktemp --tmpdir jbb2012.scores.XXX)

	scp $gsa_cell:$gsa_path/index.html $temp_file

	local scores=$(sed 's|^        <td class="metricCell">max IR = \([0-9]\+\) ops/sec; critical IR = \([0-9]\+\) ops/sec</td>|SPECjbb2012_SCORES \1\t\2|' $temp_file | grep SPECjbb2012_SCORES)

	echo -e "${scores#* }\t$gsa_url"
}



function blinkWeechat(){
	sudo chmod 666 /sys/class/leds/tpacpi\:\:thinklight/brightness;
	if [ $?=="0" ]; then
		echo; 
		echo 'Sucess! Light will now blink on all incoming weechat messages.'
	else
		echo;
		echo 'Invalid Password. Try again.'
	fi
}

function monitor(){
	echo "Turn on: 1 | Turn off: 2"
	read option
	if [ $option = 1 ];
		then xrandr --output VGA1 --auto --left-of LVDS1
	elif [ $option = 2 ];
		then xrandr --output VGA1 --off
	fi
}

function call(){
	grep -i $1 /home/dbkreling/Documents/conferenceCallsPasscodes
}

function mi (){
	grep -i -a10 $1 /home/dbkreling/Documents/Power_IO/Info/machines.info
}

function rm-host () {
	ssh-keygen -f "/home/dbkreling/.ssh/known_hosts" -R $1
}
