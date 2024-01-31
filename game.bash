#!/bin/bash

######## Global Variables ########

game_on=true

content_path="$HOME/Game/"
content_file_name="content.json"

current_index="start"


######### Functions #########

say() {
	spd-say "$*" -r -100 -l fr -w
}

#get current content description from JSON
get_content() {
	jshon -C -Q -F $content_path$content_file_name -e $current_index
}

#get target index from input
get_target() {
	get_content | jshon -C -Q -e inputs -e "$1" -u |  cat
}

#read and display the json field passed as argument
read_and_display() {
	get_content | jshon -C -Q -e "$1"
	say `get_content | jshon -C -Q -e "$1"`
}

######### Main #########

while $game_on ; do

	#echo $current_index
	#get_content | jshon -C -Q -e display_name
	#say `get_content | jshon -C -Q -e display_name`
	#get_content | jshon -C -Q -e text
	#say `get_content | jshon -C -Q -e text`

	read_and_display display_name
	read_and_display text

	read -p ">>>>>>>" input _trash
	#get_target $input
	target=`get_target "$input"`

	#echo $target

	if [ "$input" = "exit" ]; then
                game_on=false
        fi

	if [ "$target" = "null" ]; then
		echo "target is null!"
		#game_on=false
	else
		current_index=$target
	fi



	#echo $current_index

done
