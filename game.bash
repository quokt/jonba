#!/bin/bash

######## Global Variables ########

game_on=true

content_path="$HOME/Game/"
content_file_name="content.json"

current_index="start"


######### Functions #########

say() {
	spd-say $1
}

#get current content description from JSON
get_content() { 
	jshon -F $content_path$content_file_name -e $current_index
}

#get target index from input
get_target() {
	get_content | jshon -e inputs -e $1 -u |  cat
}


######### Main #########

while $game_on ; do

	#echo $current_index
	get_content | jshon -e display_name
	spd-say `get_content | jshon -e display_name`
	get_content | jshon -e text

	read -p ">>>>>>>" input _trash
	#get_target $input
	target=`get_target $input`
	#echo $target

	current_index=$target


	#echo $current_index
	
done