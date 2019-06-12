#!/bin/bash

# running the command
function run(){
    local command=$1
    eval "$command"
}

# copy table from one dataset to another
function copy_table(){
	cmd="bq cp $1 $2"
	run "$cmd"
}

# Execute a BQ sql query
function execute_query(){
	cmd="bq query --use_legacy_sql=false '$1'"
	run "$cmd"
}

# Replace a string key with value 
function replace_string(){
    local str=$1
    local param_name=$2
    local param_value=$3
    echo "${str//$param_name/$param_value}"
}

# Read file using file path
function readfile(){
	local file_path=$1
	local data
	data=$(cat "$file_path")
	echo "$data"
}