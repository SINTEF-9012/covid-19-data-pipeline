#!/bin/bash
# Configures the template to load only data from yesterday; 
# Note: comment this line if you would like to enable all data to be processed
echo "*$(date -d 'yesterday 13:00' +'%Y-%m-%d')*.csv"

# Note: Uncomment the following line to enable all data to be processed
#echo "*.csv"