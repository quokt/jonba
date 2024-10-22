#!/bin/bash

#requires : jshon , spd-say

######## Global Variables ########

game_on=true

content_path="$HOME/jonba/"
content_file_name="content.json"

current_index="start"

null_count=0


######### Functions #########

say() {
	spd-say "$*" -r -100 -l la #-w
}

#get current content description from JSON
get_content() {
	jshon -C -Q -F $content_path$content_file_name -e $current_index
}

#get target index from input
get_target() {
	get_content | jshon -C -Q -e inputs -e "$1" -u |  cat
}

get_actions() {
	get_content | jshon -C -Q -e inputs | jshon -C -Q -k | cat
}

#read and display the json field passed as argument
read_and_display() {
	get_content | jshon -C -Q -e "$1"
	say `get_content | jshon -C -Q -e "$1"`
}

######### Main #########

while $game_on ; do

	read_and_display display_name
	read_and_display text

	echo "########################"
	declare -A actions=`get_actions`
	echo ${actions}
	read -p ">>>>>>>" input _trash
	target=`get_target "$input"`

	case $input in
	"exit" | "quit" | :?q? | :q? | :?q ) game_on=false;;
	"esc" ) cat $content_path/game.bash | spd-say -e -w;;
	#*) echo "test"
	esac

#	if [ "$input" = "exit" ]; then
 #               game_on=false
  #      fi

	if [ "$target" = "null" ]; then
		echo "target is null!"
		#game_on=false
		#null_count= $(($null_count + "1"))
		#echo $null_count
	else
		current_index=$target
	fi
done
