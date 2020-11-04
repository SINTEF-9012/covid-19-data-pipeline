#!/bin/bash
# arg1: log directory
# arg2: start_process_date
# arg3: end_process_date
# arg4...: files to append


log_directory=${1}
start_process_date=${2}
end_process_date=${3}

# Remove the three first arguments to make it easy to loop through files
shift 3

echo "log_directory: ${log_directory}"
echo "start_process_date: ${start_process_date}"
echo "end_process_date: ${end_process_date}"
#echo $@
echo '***'

echo '#'
echo '#   Starting: append_to_log_common'
echo '#'


common_log_file=${log_directory}/common.log
output_lock_file="${log_directory}/dir_rw.lock"

# Aquire lock
exec 9>$output_lock_file
echo "// Aquire lock ${output_lock_file}"
if flock 9; then   # Blocking wait

    # Append start date
    echo "#######################################" >> ${common_log_file}
    echo "#### Start time: ${start_process_date}" >> ${common_log_file}
    
    # Loop through all files in argument list
    while [ "$1" ] 
    do
        log_file_path=${1}
        shift
        
        echo "#### Log file: ${log_file_path}" >> ${common_log_file}
        cat ${log_file_path} >> ${common_log_file}
        echo "-" >> ${common_log_file}

    done
    
    # Append end date
    echo "#### End time: ${end_process_date}" >> ${common_log_file}
    echo "#######################################" >> ${common_log_file}
fi
# Release the lock
exec 9>&-

