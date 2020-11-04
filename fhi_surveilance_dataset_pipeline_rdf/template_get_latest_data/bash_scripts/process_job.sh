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

echo "work_path: ${work_path}"
echo "code_directory: ${code_directory}"
echo "input_directory: ${input_directory}"
echo "work_directory: ${work_directory}"
echo "output_directory: ${output_directory}"

echo '***'
echo '#'
echo '#  Starting Process: Transform'
echo '#'


file_name=${work_path##*/}
file_name_no_ext=${file_name%.*}
file_name_new="${file_name_no_ext}-new.csv"
work_path_new=${work_directory}/${file_name_new}
date=$(echo ${file_name} | grep -oP '\d+-\d+-\d+(?=\.)')

#add a column named "date_published" (with header) that contains the date part of the file name
awk -v d=",${date}" -F"," '
	BEGIN {
		FS=OFS = ","
		} 
	{
		printf("%s%s",$0,FNR>1?d RS:",date_published" RS)
	}
	' ${work_path} > ${work_path_new}

# Move the files to output
${code_directory}/move_to_output.sh ${output_directory} ${work_path_new}
rm -f ${work_path}

echo '   Done'


