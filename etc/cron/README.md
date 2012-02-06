# Overview

This folder contains scripts that run on the NAS (ReadyNAS), under cron:

    cron_table: crontab file for the context under which croned scripts will run
    sync_*:     the script to run

The cron_table file is loaded as follows:

    crontab cron_table

Push all the files to the NAS as follows:
    
    rsync -avz -e ssh . root@10.241.46.7:/c/home/cdwmedia/cron/
    # Then load the cron file updates
    ssh root@10.241.46.7 crontab /c/home/cdwmedia/cron/cron_table


