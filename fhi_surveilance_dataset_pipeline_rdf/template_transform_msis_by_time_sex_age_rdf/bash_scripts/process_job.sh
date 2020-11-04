#!/bin/bash
# arg1: work_path
# arg2: code directory
# arg3: input directory
# arg4: work directory
# arg5: output directory
# arg6: transformation_full_path

work_path=${1}
code_directory=${2}
input_directory=${3}
work_directory=${4}
output_directory=${5}
transformation_full_path=${6}

echo "work_path: ${work_path}"
echo "code_directory: ${code_directory}"
echo "input_directory: ${input_directory}"
echo "work_directory: ${work_directory}"
echo "output_directory: ${output_directory}"
echo "transformation_full_path: ${transformation_full_path}"

echo '***'
echo '#'
echo '#  Starting Process: Transform'
echo '#'


# Construct Paths
file_name=${work_path##*/}
file_name_no_ext=${file_name%.*}
file_name_transformed="${file_name_no_ext}-tr.nt"
work_path_transformed=${work_directory}/${file_name_transformed}

# Debug: Show Paths
echo "!! work_path_transformed", ${work_path_transformed}

# Files are now in the work dir ... ready to be processed

# Transforming
echo "   Transforming"
java -Xmx4g -jar ${transformation_full_path} \
    ${work_path} \
    ${work_path_transformed}


# Move the files to output
${code_directory}/move_to_output.sh ${output_directory} ${work_path_transformed}

echo '   Done'


