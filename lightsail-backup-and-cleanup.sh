#!/bin/bash

log_file="./snapshot.log"
instance_name=$1
backup_name="autosnap-${instance_name}-$(date +%Y-%m-%d_%H.%M)"
instance_region=$2
snapshots_to_keep=$3

fn_log_item() {
  logString=${*}
  echo "$(date +"%Y-%m-%d-%H%M%S") ${logString}" 2>&1 | tee -a ${log_file}
}

fn_terminate_script() {
	fn_log_item "SIGINT caught."
	exit 1
}

fn_abort() {
  errString=${*}
  fn_log_item "$errString"
  exit 1
}

trap 'fn_terminate_script' SIGINT

fn_log_item "Starting Snapshot script"

# Check inputs
if [[ ${#} -ne 3 ]]
then
	echo "Usage: $0 instanceName instance_region snapshots_to_keep"
	fn_abort "arguments provided not equal to 3. Exiting."
fi

if [[ -n ${3//[0-9]/} ]]; then
    echo "Please ensure you enter a number for the 3rd argument, to specify how many snapshots to keep."
		fn_abort "3rd argument is not an integer. Exiting."
fi

# Create backup
aws lightsail create-instance-snapshot --instance-snapshot-name ${backup_name} --instance-name $instance_name --region $instance_region

fn_log_item "Backup created: ${backup_name}"


sleep 30
# Cleanup old backups
# get the names of all snapshots sorted from old to new
snapshot_names=$(aws lightsail get-instance-snapshots | jq '.instanceSnapshots | map(select(.name|startswith("'autosnap-${instance_name}'"))) | .[].name')

# Filter snapshots, so we only look at ones created by the script
number_of_snapshots=$(echo "$snapshot_names" | wc -l)
fn_log_item "Snapshots to keep  : ${snapshots_to_keep}"
fn_log_item "Current # snapshots: ${number_of_snapshots}"

# loop through all snapshots
while IFS= read -r line
do
let "i++"

	# delete old snapshots condition
	if (($i <= $number_of_snapshots-$snapshots_to_keep))
	then
		snapshot_to_delete=$(echo "$line" | tr -d '"')

		# delete snapshot command
		aws lightsail delete-instance-snapshot --instance-snapshot-name $snapshot_to_delete
		fn_log_item "Backup deleted: ${snapshot_to_delete}"
	fi

done <<< "$snapshot_names"

fn_log_item "Snapshot script completed"

exit 0
