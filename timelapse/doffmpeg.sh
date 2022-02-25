#!/usr/bin/bash
###################################################
# This script takes three arguments and will ignore the "&" parameter that is passed
# because nohup is used to avoid the 60 second limitation placed on
# shell scripts run in home assistant, and can be called in 3 different scenarios 
# shown below. The date format should be YYYYMMDD
#
# doffmpeg <start date> <end date> <cam name> - this will generate all the videos from 
# <start date> to <end date> and all dates in between
#
# doffmpeg <start date> <number 1 or above> <cam name>- this will generate all the videos
# from <start date> to <start date + number> i.e. if the date is 20210301 and the 
# second argument is 3, it would process 20210301, 20210302, 20210303, 20210304  
#
# NOTE: the script will not process across months, so the two above would not work
# if the <end date> was another month than <start date>, or if the second argument 
# is more than the difference between <start date> and the last day of the month.
# For instance, a start date of 20210329 and the second argument of 3
#
#doffmpeg <start date> 0 <cam name> - this will generate only the date passed as the start
# date, and would be likely used by an automation to generate the video every day
# at the end of the day. example: 20210329 0 "esp32cam"

callFFMpeg(){
    ffmpeg -pattern_type glob -i "/media/$2/$1/*.jpg" \
    -c:v libx264 -vf fps=25,format=yuv420p \
    "/media/$2/$1_out.mp4"
}

if [[ ${#3} > 0 ]] && [[ "${3}&" != "&" ]]
then
    if [[ ${#1} == 8 ]] && [[ ${#2} == 8 ]]
    then
        for (( MY_DATE=$1; MY_DATE<=$2; MY_DATE++ ))
        do
            callFFMpeg ${MY_DATE} ${3}
        done
    else
        if [[ ${#2} == 1 ]] && [[ ${2} > 0 ]]
        then
            for (( MY_DATE=$1; MY_DATE<=$1+$2; MY_DATE++ ))
            do 
                callFFMpeg ${MY_DATE} ${3}
            done
        else
            MY_DATE=$1
            callFFMpeg ${MY_DATE} ${3}
        fi
    fi
fi