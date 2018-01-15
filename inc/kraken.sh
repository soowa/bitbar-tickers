#!/bin/bash

# If file is not sourced we exit
[[ $0 == "$BASH_SOURCE" ]] && exit

function check_connection()
{
  if curl --silent --head https://www.kraken.com/ | egrep "20[0-9] OK|30[0-9] Found" > /dev/null
  then
      echo ""
  else
    echo "- | image=$ICON dropdown=false"
    exit
  fi
}

function read_history()
{
  if [ ! -f "/tmp/$1.dat" ] ; then
    echo "0 0 0"
  else
    HIST=$(cat /tmp/$1.dat)
    IFS=':' read -a H <<< "$HIST"
    echo "${H[0]} ${H[1]} ${H[2]}"
  fi
}

function parse_present()
{
  # Ask
  A=$(echo $1 | egrep -o '"a":\["[0-9]+(\.)?([0-9]{3})?' | sed 's/"a":\["//')
  # Bid
  B=$(echo $1 | egrep -o '"b":\["[0-9]+(\.)?([0-9]{3})?' | sed 's/"b":\["//')
  # Low
  L=$(echo $1 | egrep -o '"l":\["[0-9]+(\.)?([0-9]{3})?' | sed 's/"l":\["//')
  # High
  H=$(echo $1 | egrep -o '"h":\["[0-9]+(\.)?([0-9]{3})?' | sed 's/"h":\["//')
  # Opening
  O=$(echo $1 | egrep -o '"o":\"[0-9]+(\.)?([0-9]{3})?' | sed 's/"o":"//')
  # Trades
  T=$(echo $1 | egrep -o '"t":\[[0-9]+(\,)?([0-9]+(\]))?' | sed 's/"t":\[//' | sed 's/]//')
  
  # Store some info in file
  echo "$A:$L:$H" > /tmp/$2.dat
  
  echo "$A $B $L $H $O $T"
}

function notify_on_new_high_or_low()
{
  if [[ $(bc <<< "$2 > $4") -eq 1 ]] ; then
    name=$(echo $5 | awk '{print tolower($0)}')
    dir=$(dirname "${BASH_SOURCE%/*}")
    open $dir/$name-notification.app/ --args "New high is $2\n$5 reached a new High\nSubmarine" &> /dev/null
  elif [[ $(bc <<< "$1 < $3") -eq 1 ]] ; then
    name=$(echo $5 | awk '{print tolower($0)}')
    dir=$(dirname "${BASH_SOURCE%/*}")
    open $dir/$name-notification.app/ --args "New low is $1\n$5 reached a new Low\nSubmarine" &> /dev/null
  fi
}

function output_primary_info()
{
  DIFF=$(bc <<< "$1 - $2")
  [[ $(bc <<< "$DIFF > 0") -eq 1 ]] && DIFF="+$DIFF" || DIFF="$DIFF"

  if [[ $(bc <<< "$1 > $2") -eq 1 ]] ; then
    echo "$(printf '%s%7s\n' "▲" "$1") | image=$3 color=green dropdown=false font=Courier"
    echo "$(printf '%s%7s\n' "▲" "$DIFF") | image=$3 color=green dropdown=false font=Courier"
  elif [[ $(bc <<< "$1 < $2") -eq 1 ]] ; then
    echo "$(printf '%s%7s\n' "▼" "$1") | image=$3 color=red dropdown=false font=Courier"
    echo "$(printf '%s%7s\n' "▼" "$DIFF") | image=$3 color=red dropdown=false font=Courier"
  else
    echo "$1 | image=$3 dropdown=false font=Courier"
  fi
}

function output_secondary_info()
{
  echo "---"
  printf '%-10s%30s\n' "Ask" "$1 | font=Courier"
  printf '%-10s%30s\n' "Bid" "$2 | font=Courier"
  printf '%-10s%30s\n' "Low" "$3 | font=Courier"
  printf '%-10s%30s\n' "High" "$4 | font=Courier"
  printf '%-10s%30s\n' "Opening" "$5 | font=Courier"
  printf '%-10s%30s\n' "Trades" "$6 | font=Courier"
}
