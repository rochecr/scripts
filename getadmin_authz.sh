#!/bin/bash

AFILE=$1
REPO=$2

if [ ! ${AFILE} ] || [ ! -f ${AFILE} ]
then
	echo "ERROR: no authz file for this repo : ${REPO}"
	exit 1
fi

while read LINE
do
        if [[ ${LINE} == *"groups"* ]]
        then
                BEGIN="inicio"
        elif [[ ${LINE} == *"["* ]] && [[ ${BEGIN} == "inicio" ]]
        then
                END="fin"
                exit 0
        else
                END=""
        fi
        if [[ $(echo ${LINE} |awk -F\= '{print $1}') ]]
        then
                GROUP=$(echo ${LINE} | awk -F\= '{print $1}')
                MEMBERS=$(echo ${LINE} | awk -F\= '{print $2}')
		$(echo "${MEMBERS}" | tr "," "\n")
		if [ ${GROUP} == "svnadmin" ]
		then
			echo "svnadim,$REPO,$MEMBERS"
		fi
					
        fi
done < ${AFILE}
