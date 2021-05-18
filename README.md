# About this fork

The original mongo-backup hasn't been touched in years, and all the
dependencies are out of date. It built and ran, but didn't connect to a
newer version of mongo.

This is all experimental, but maybe will work. My planned changes:

1. update dependencies and Dockerfile to newer versions
2. add env variable to specify collections to back up

Update: this doesn't work yet. It may not be worth more effort.

```
[2021/05/18 12:54:43][error] CLI::Error
[2021/05/18 12:54:43][error] --- Wrapped Exception ---
[2021/05/18 12:54:43][error] Config::Error: Invalid Configuration File
[2021/05/18 12:54:43][error]   The configuration file at '/app/Backup/config.rb'
[2021/05/18 12:54:43][error]   does not appear to be a Backup v5.x configuration file.
[2021/05/18 12:54:43][error]   If you have upgraded to v5.x from a previous version,
[2021/05/18 12:54:43][error]   you need to upgrade your configuration file.
[2021/05/18 12:54:43][error]   Please see the instructions for upgrading in the Backup documentation.
```

A different strategy may be to use this tool instead: https://github.com/stefanprodan/mgob

# mongo-backup
>Automated backups for MongoDB containers

This Docker image runs mongodump to backup data to folder `/backup`. The image uses [backup](http://backup.github.io/backup/v4/) Ruby gem to create backups and [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) gem for scheduling.

## Backup interval
Backup interval can be set by `INTERVAL` environment variable. Value can be:
* number of seconds: `30`
* minutes: `1m`
* hours: `1h`
* days: `1d`
* cron format: `0 22 * * *`

## Storages

You can store your backup:

* Amazon S3
* Dropbox
* RSync
* SFTP

## Notifiers
Notifiers are used to send notifications upon successful and/or failed completion of your backup

Supported notification services include:

* Slack
* Flowdock
* Email
* DataDog
* Pagerduty

## Example: Backup to S3 every day

```
export MONGO_BUCKET=<Your S3 bucket name>
export SLACK_WEBHOOK_URL=<Your Slack webhook url>
export MONGO_CONTAINER=<Your MongoDB container name>
docker run --name mongo-backup \
  --link $MONGO_CONTAINER:mongo \
  -e MONGODB_HOST=mongo \
  -e INTERVAL=1d \
  -e S3_ACCESS_KEY_ID=<YOUR AWS ACCESS KEY> \
  -e S3_SECRET_ACCESS_KEY=<YOUR AWS ACCESS KEY> \
  -e S3_REGION=eu-west-1 \
  -e S3_BUCKET=$MONGO_BUCKET \
  -e S3_PATH=backups \
  -e SLACK_WEBHOOK_URL=$SLACK_WEBHOOK_URL \
  -e SLACK_NOTIFY_ON_FAILURE=true \
  -e SLACK_NOTIFY_ON_WARNING=true \
  --restart=always \
  -d kontena/mongo-backup
```
