# Lightsail Backup and Clean Up Shell Script

## This fork does not delete manually created snapshots

This script was forked from here: https://github.com/JozefJarosciak/Lightsail-Backup-and-Clean-Up-Shell-Script  

The script now prepends 'autosnap' to backup names, and will only delete backups that start with 'autosnap'. (Use at your own risk, I did not throughly test this script after modifying it...)

## Dependencies
jq: https://stedolan.github.io/jq/download/

## Instructions
Shell script to automatically backup a Lightsail snapshot and then remove old AWS Lightsail snapshots (by retaining only a specific number of snapshot backups).

This script will take in three arguments. 
1. The instance you want to backup
2. The AWS region where the lightsail instrance is located.
3. The number of backups that you would like to keep.

To execute the script:

`$lightsail-backup.sh [instance] [region] [# backups to keep]`

## Scheduling Backups

Use the `run-aws-snapshot.sh` script to schedule snapshots with cron. Follow the instructions in the comments of the script.

## Special Thanks

- Shell script to automatically remove old AWS Lightsail snapshots (and retain a specific number of backups that inspired my fork:
https://www.joe0.com/2017/07/31/shell-script-to-automatically-remove-old-aws-lightsail-snapshots-and-retain-only-a-specific-desired-number-of-snapshots/
- How to schedule nightly backups of Amazon Lightsail Instance by leveraging AWS Command Line Interface (CLI)
https://www.joe0.com/2017/07/29/how-to-schedule-nightly-backups-of-amazon-lightsail-instance-by-leveraging-aws-command-line-interface-cli/
