#!/bin/sh

set -e

gcloud auth activate-service-account --key-file=/keyFile

echo "checking for existing subnet"

if eval "gcloud compute networks subnets describe $name" >/dev/null 2>&1
then
  echo "found exiting subnet"
  exit
else
  echo "existing subnet not found"
fi

echo "creating subnet..."
subnetCreateCmd="gcloud compute networks subnets create $name"
subnetCreateCmd=$(printf "%s --network %s" "$subnetCreateCmd" "$network")
subnetCreateCmd=$(printf "%s --range %s" "$subnetCreateCmd" "$range")

# handle opts
if [ "$enableFlowLogs" = "true" ]; then
  clusterCreateCmd=$(printf "%s --enable-flow-logs" "$enableFlowLogs")
fi
if [ "$enablePrivateIpGoogleAccess" = "true" ]; then
  clusterCreateCmd=$(printf "%s --enable-private-ip-google-access" "$enablePrivateIpGoogleAccess")
fi
if [ "$description" != " " ]; then
  subnetCreateCmd=$(printf "%s --description %s" "$subnetCreateCmd" "$description")
fi
if [ "$secondaryRange" != " " ]; then
  subnetCreateCmd=$(printf "%s --secondary-range %s" "$subnetCreateCmd" "$secondaryRange")
fi

eval "$subnetCreateCmd"