#!/bin/bash

# Run this file from cron with the following arguments to schedule snapshots
# 0 0 * * 0 bash -lc /home/bitnami/Lightsail-Backup-and-Clean-Up-Shell-Script/run-aws-snapshot.sh

# (The 'bash -lc' command loads your environment variables from .profile)
# adjust the timing to suit your needs (https://crontab.guru/ if you need it.)

# adjust the command below to suit your setup.
/path/to/script/lightsail-backup-and-cleanup.sh instance_name instance_region number_of_snapshots
