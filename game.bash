#!/bin/bash

#requires : jshon , spd-say

######## Global Variables ########

source ./game.conf

game_on=true

current_index="start"

null_count=0


######### Functions #########

say() {
	spd-say "$*" -r ${read_speed} -l ${language} -w
}

#get current content description from JSON
get_content() {
	jq .${current_index} ${content_path}${content_file_name}
}

#get target index from input
get_target() {
	get_content | jq .inputs."${1}" | cat
}

get_and_display_actions() {
	actions=$(get_content | jq '.inputs | keys[]')
   	echo "${actions}" | while read -r action; do
        echo "- ${action}"
    done
}

#read and display the json field passed as argument
read_and_display() {
	get_content | jq ."${1}" | fold -s -w ${max_char_per_text_line}
	say `get_content | jq ."${1}"`
}

######### Main #########

clear

jq --version >/dev/null 2>&1 || (echo "Please install jq" && exit 1)
spd-say " " >/dev/null 2>&1 || (echo "Please install speech-dispatcher" && exit 1)

while ${game_on} ; do

	read_and_display display_name
	read_and_display text

	echo "########################"
	get_and_display_actions
 	echo "########################"
	read -r -p ">>>>>>> " input

	case ${input} in
	"exit" | "quit" | ":?q?" | ":q" | ":?q" ) game_on=false;;
	"esc" ) cat ${content_path}/game.bash | spd-say -e -w;;
	#*) echo "test"
	esac

	if [ ${game_on} = "false" ]; then
		exit 0
	fi

        target=$(get_target "${input}")

	if [ "${target}" = "null" ]; then
		echo "target is null!"
		#game_on=false
		#null_count= $((${null_count} + "1"))
		#echo ${null_count}
	else
		current_index=${target}
	fi
done
