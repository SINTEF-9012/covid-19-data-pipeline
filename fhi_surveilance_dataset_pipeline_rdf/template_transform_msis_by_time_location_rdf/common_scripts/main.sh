#!/bin/bash

function gracefulshutdown {
    echo "Main - Received signal to shut down"
    echo "Main - Deleting run-file"
    rm $run_file_name
}

# arg1: retry_max_count
# arg2: code directory
# arg3: input directory
# arg4: work directory
# arg5: output directory
# arg6... : application params

retry_max_count=${1}
code_directory=${2}
input_directory=${3}
work_directory=${4}
output_directory=${5}

echo "Arguments"
for i in $*; do 
   echo $i 
done
echo "***" 

echo "********* Listing of ${code_directory}"
ls -l ${code_directory}
echo "********* Listing of ${input_directory}"
ls -l ${input_directory}
echo "********* Listing of ${work_directory}"
ls -l ${work_directory}
echo "********* Listing of ${output_directory}"
ls -l ${output_directory}

# Worker script to run
cmd_to_run="${code_directory}/main_worker.sh"

echo "Main - Starting"

# Make tmp file ... run until file is deleted
mkdir -p $work_directory/run
run_file_name=`mktemp -t -p ${work_directory}/run`

trap gracefulshutdown SIGINT SIGTERM

# Execute init if present
init_script="${code_directory}/init.sh"
if [ -f "$init_script" ]; then
   $init_script
fi

# Execute single_shot if present, else 
single_shot_script="${code_directory}/single_shot.sh"
if [ -f "$single_shot_script" ]; then
    echo "Main - Starting single shot $run_file_name"

    if [ "${LOG_JOBS}" -eq "1" ]; then
        log_directory=${work_directory}/logs
        mkdir -p $log_directory
        log_file=${log_directory}/single_shot.log

	start_process=$(date)
        $single_shot_script $run_file_name "$@" 2>&1 | tee ${log_file} &
	pid=$!

	end_process=$(date)

	# Append to common log file
	${code_directory}/append_to_log_common.sh "${log_directory}" "${start_process}" "${end_process}" ${log_file} 
        
    else
        $single_shot_script $run_file_name "$@" &
        pid=$!
    fi
else
    echo "Main - Starting worker $run_file_name"
    $cmd_to_run $run_file_name "$@" &
    pid=$!
fi

# This will wait until the cmd ends or we receive SIGINT
wait $pid

echo "Main - Wait for worker to end ..."
wait $pid

# Cleanup
rm -f $run_file_name

echo "Main - End"

