#!/bin/bash
# arg1: input file spec              
# arg2: process_job              
# arg3: code directory
# arg4: input directory
# arg5: work directory
# arg6: output directory
# arg7 ... : application params

input_file_spec=${1}
process_job=${2}
code_directory=${3}
input_directory=${4}
work_directory=${5}
output_directory=${6}

# Remove two first arguments to make it easy to pass the remaining params
shift 2

echo "input_file_spec: ${input_file_spec}"
echo "process_job: ${process_job}"
echo "code_directory: ${code_directory}"
echo "input_directory: ${input_directory}"
echo "work_directory: ${work_directory}"
echo "output_directory: ${output_directory}"
echo '***'

echo '#'
echo '#   Starting: fetch_one_and_process'
echo '#'

lock_file="${input_directory}/dir_rw.lock"

new_file_to_process="no"

# Aquire lock
echo "// Aquire lock ${lock_file}"
exec 9>$lock_file
if flock 9; then   # Blocking wait
    
    # Check if there are files to process
    nfiles="$(find "${input_directory}" -name "${input_file_spec}" | wc -l)"
    if [ "${nfiles}" -gt "0" ]; then
        # Extract File Name in random pos
        file_num=`shuf -i1-${nfiles} -n1`
        input_path="$(find "${input_directory}" -name "${input_file_spec}" | head "-${file_num}" | tail -1)"
        echo "// Found ${nfiles} Files"
        echo "// Picking file_num ${file_num}"
        echo "// File to process ${input_path}"

        # Construct Paths
        file_name=${input_path##*/}
        file_name_no_ext=${file_name%.*}
        input_path_renamed=${input_path}.inmove
        work_path=${work_directory}/${file_name}

        # Execute test if present
	check_ok=1  # Assume of if no check present
        check_script="${code_directory}/check_input_file.sh"
        if [ -f "$check_script" ]; then
           # Call script to check if file is complete - exit 0 if complete
           ${check_script} ${input_path}
           retn_code=$?

           if [ ${retn_code} -eq 0 ]; then
              check_ok=1
           else
              check_ok=0
           fi
        fi
    
        if [ ${check_ok} -eq 1 ]; then
            # File is ok ... use file

            # Check if file already there
            #ls -l ${input_directory}
            #ls -l ${work_directory}
            found_existing="$(find "${work_directory}" -name "${file_name}" | wc -l)"
            #echo $found_existing
            if [ "${found_existing}" -eq "0" ]; then

                # Move to Workspace
                echo "   Renaming file ${input_path} ${input_path_renamed}"
                mv ${input_path} ${input_path_renamed}
                new_file_to_process="yes"

            else
                echo "// File ${file_name} already exists in working dir ... skipping operation"
            fi
        else
            echo "// File ${file_name} failed check ... skipping operation"
        fi
    else
        echo '// No file found ... skipping operation'
    fi
else
    echo '// Lock failed ... skipping operation'
fi

# Release the lock
exec 9>&-

if [ $new_file_to_process == "yes" ]; then
    # Move renamed file to Workspace
    echo "   Moving to Workspace ${input_path_renamed} ${work_path}"
    mv ${input_path_renamed} ${work_path}

    # File are now in the work dir ... ready to be processed

    # Run the job 
    if [ "${LOG_JOBS}" -eq "1" ]; then
        log_directory=${work_directory}/logs
        mkdir -p $log_directory
        log_file=${log_directory}/${file_name_no_ext}.log

	start_process=$(date)
        ${process_job} "${work_path}" "$@" 2>&1 | tee ${log_file}
	end_process=$(date)

	# Append to common log file
	${code_directory}/append_to_log_common.sh "${log_directory}" "${start_process}" "${end_process}" ${log_file} 
        
    else
        ${process_job} "${work_path}" "$@"
    fi
    exit 0
else
    exit 1
fi


