#!/bin/bash

RED="\e[0;31m"
BLUE="\e[0;34m"
GREEN="\e[0;32m"
PURPLE="\e[0;35m"
NC="\033[0m"

usage() {
	echo -e "\
Usage: fish
		${PURPLE}-h${NC}|${PURPLE}--help${NC}   : Show this help message and quit
		${PURPLE}-r${NC}|${PURPLE}--right${NC}  : characters when going right
		${PURPLE}-l${NC}|${PURPLE}--left${NC}   : characters when going left
		${PURPLE}-s${NC}|${PURPLE}--spaces${NC} : number of spaces
		${PURPLE}-t${NC}|${PURPLE}--time${NC}   : sleep time
		${PURPLE}-c${NC}|${PURPLE}--color${NC}  : ${RED}RED${NC} ${GREEN}GREEN${NC} ${BLUE}BLUE${NC} ${PURPLE}PURPLE${NC}"
}

while [[ $# -gt 0 ]]; do
key="$1"
case $key in
    -h|--help)
    usage
    exit
    ;;
    -r|--right)
    R="$2"
    shift
    ;;
    -l|--left)
    L="$2"
    shift
    ;;
    -s|--spaces)
    spaces="$2"
    shift
    ;;
    -t|--time)
    sleeptime="$2"
    shift
    ;;
    -c|--color)
    COL="$2"
    shift
    ;;
    *)
    unknown="$1" # unknown option
    echo "Unknown flag \"$unknown\". Aborting."
    usage
    exit 1
    ;;
esac
shift # past argument or value
done

# default
if 	 [ -z "$R" 			   ]; then R="><(((°>"; fi
if 	 [ -z "$L" 			   ]; then L="<°)))><"; fi
if 	 [ -z "${spaces}" 	   ]; then let spaces=$(stty size | cut -d" " -f2)-${#R}; fi
if 	 [ -z "${sleeptime}"   ]; then sleeptime=$(bc -l <<< 2.5/${spaces}); fi
if   [ -z "${COL}" 		   ]; then COL="${NC}"
elif [ "${COL}" = "RED"    ]; then COL="${RED}"
elif [ "${COL}" = "GREEN"  ]; then COL="${GREEN}"
elif [ "${COL}" = "BLUE"   ]; then COL="${BLUE}"
elif [ "${COL}" = "PURPLE" ]; then COL="${PURPLE}"
fi

# init
k=0
X="$R"
init=0

while true; do
	if [ $k -eq 0 ]; then
		_L=""
		_R="$(printf ' %.0s' $(seq 1 ${spaces}))"
		if [ ! ${init} -eq 0 ]; then
			echo -ne "\r${COL}${_L}${X}${_R}${NC}"
			sleep ${sleeptime}
		fi
		direction="R"
		X=${R}
		let k+=1
	elif [ $k -eq $spaces ]; then
		_R=""
		_L="$(printf ' %.0s' $(seq 1 ${spaces}))"
		echo -ne "\r${COL}${_L}${X}${_R}${NC}"
		sleep ${sleeptime}
		direction="L"
		X=${L}
		let k-=1
	else
		_L="$(printf ' %.0s' $(seq 1 ${k}))"
		let _k=spaces-k
		_R="$(printf ' %.0s' $(seq 1 ${_k}))"
		if [ $direction = "R" ]; then
			let k+=1
		elif [ $direction = "L" ]; then
			let k-=1
		fi
	fi
	let init+=1
	echo -ne "\r${COL}${_L}${X}${_R}${NC}"
	sleep ${sleeptime}
done