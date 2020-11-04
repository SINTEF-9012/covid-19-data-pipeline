#!/bin/bash
# arg1: run_file_name              
# arg2: retry_max_count
# arg3: code directory
# arg4: input directory
# arg5: work directory
# arg6: output directory
# arg7 ... : application params

run_file_name=${1}
retry_max_count=${2}
code_directory=${3}
input_directory=${4}
work_directory=${5}
output_directory=${6}

# Remove the two first arguments to make it easy to pass the remaining params
shift 2

echo "run_file_name: ${run_file_name}"
echo "retry_max_count: ${retry_max_count}"
echo "code_directory: ${code_directory}"
echo "input_directory: ${input_directory}"
echo "work_directory: ${work_directory}"
echo "output_directory: ${output_directory}"
echo '***'

echo '#'
echo '#   Starting: main_worker'
echo '#'


lock_file="${input_directory}/dir_rw.lock"

wait_count=0

# What files to look for ?
echo "Fetching file pattern from: ${code_directory}/get_input_file_spec.sh"
input_file_spec=$(${code_directory}/get_input_file_spec.sh)
echo "Got filepattern: ${input_file_spec}"

while [ -f $run_file_name ]; do

    # Call script to find a file and process it 
    "${code_directory}/fetch_one_and_process.sh" "${input_file_spec}" "${code_directory}/process_job.sh" "$@"
    
    retn_code=$?

    if [ ${retn_code} -eq 0 ]; then
        # File processed ... try next  
        wait_count=0
    else
        # No file processed ... wait
        if [[ $retry_max_count -eq 0 ]];  then
            echo "// Sleeping 60 Seconds"
            sleep 60
        else
            wait_count=$((wait_count+1))
            echo "// Sleeping 60 Seconds $wait_count of max $retry_max_count"
            if [[ $wait_count -gt $retry_max_count ]];  then
                echo "Terminating idle script"
                exit 0
            fi
            sleep 60
        fi
    fi

done

