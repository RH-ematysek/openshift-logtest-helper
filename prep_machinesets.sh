#!/bin/bash

# https://docs.openshift.com/container-platform/4.9/machine_management/manually-scaling-machineset.html

for i in $(oc get machinesets -n openshift-machine-api -o json | jq -r '.items[].metadata.name'); do
#  echo $i
  echo "$i"
#  oc get machineset "$i" -n openshift-machine-api
  instance_type=$(oc get machineset "$i" -o json -n openshift-machine-api | jq -r '.spec.template.spec.providerSpec.value.instanceType')
  echo "$instance_type"
  if [[ $i == *a ]]; then
#    echo "ends in a"
    if [[ $instance_type != "m6i.2xlarge" ]]; then
      echo "*a not m6i.2xlarge"
      oc patch -n openshift-machine-api machineset "$i" --type='merge' -p '{"spec":{"template":{"spec":{"providerSpec":{"value":{"instanceType":"m6i.2xlarge"}}}}}}'
      oc scale -n openshift-machine-api --replicas=0 machineset "$i"
      sleep 15
      oc scale -n openshift-machine-api --replicas=3 machineset "$i"
      sleep 1m
    fi
  elif [[ $i == *c ]]; then
    oc scale -n openshift-machine-api --replicas=0 machineset "$i"
    sleep 30
    oc patch -n openshift-machine-api machineset "$i" --type='merge' -p '{"spec":{"template":{"spec":{"providerSpec":{"value":{"instanceType":"m6i.xlarge"}}}}}}'
    oc scale -n openshift-machine-api --replicas=1 machineset "$i"
  else
#    echo "Not machineset A"
    echo "Patching instancetype and scaling down"
    oc patch -n openshift-machine-api machineset "$i" --type='merge' -p '{"spec":{"template":{"spec":{"providerSpec":{"value":{"instanceType":"m6i.large"}}}}}}'
    oc scale -n openshift-machine-api --replicas=0 machineset "$i"
  fi
done
