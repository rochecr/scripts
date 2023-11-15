#!/bin/bash
# rocastro

for cluster in $(kubectl config get-contexts | awk 'NR>1 {print $1}'| grep -v '*' | xargs );
do
        kubectl config use-context $cluster
        for master in $(kubectl get pods -n cje | awk 'NR>1 {print $1}' | xargs)
        do
                echo "master: $master"
                mkdir -pv ./activity-support/$cluster-$master
                kubectl cp $master:/var/jenkins_home/user-activity-reports/ ./activity-support/$cluster-$master -n cje
        done
done
