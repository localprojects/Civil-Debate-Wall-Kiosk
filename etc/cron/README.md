# Overview

This folder contains scripts that run on the NAS (ReadyNAS), under cron:

    cron_table: crontab file for the context under which croned scripts will run
    sync_*:     the script to run

The cron_table file is loaded as follows:

```
    crontab cron_table
```



