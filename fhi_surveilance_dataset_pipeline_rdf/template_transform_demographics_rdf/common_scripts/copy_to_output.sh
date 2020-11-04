#!/bin/bash
# arg1: output directory
# arg2 ... : files to move

output_directory=${1}

# Remove the first argument to make it easy to loop through files
shift

echo "output_directory: ${output_directory}"
#echo $@
echo '***'

echo '#'
echo '#   Starting: copy_to_output'
echo '#'


output_lock_file="${output_directory}/dir_rw.lock"

# Loop through all files in argument list
while [ "$1" ]
do
    from_file_path=${1}
    file_name=${from_file_path##*/}
    to_file_path=${output_directory}/${file_name}
    to_file_path_renamed=${to_file_path}.outmove
    shift
    
    echo "   Copy file ${from_file_path} to ${to_file_path_renamed}"
    cp ${from_file_path} ${to_file_path_renamed}
    
    # Aquire lock
    exec 9>$output_lock_file
    echo "// Aquire lock ${output_lock_file}"
    if flock 9; then   # Blocking wait
          
        # Rename file in output dir to assure complete operation before starting to consume
        echo "   Rename file in output dir ${to_file_path_renamed} ${to_file_path}"
        mv ${to_file_path_renamed} ${to_file_path}

    fi
    # Release the lock
    exec 9>&-

done


