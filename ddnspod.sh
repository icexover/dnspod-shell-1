#!/bin/sh

cd "$(dirname "$0")"

# Import ardnspod functions
. ./ardnspod

# Combine your token ID and token together as follows
# You can also provide the token via the ARDNSPOD_TOKEN environment variable
# (e.g. `export ARDNSPOD_TOKEN="12345,7676f344..."`), which takes precedence
# over the arToken set below and keeps the secret out of this file

arToken="12345,7676f344eaeaea9074c123451234512d"

# Web endpoint to be used for querying the public IPv6 address
# Set this to override the default url provided by ardnspod
#   ipv4 backup api https://ipv4.ddnsip.cn
#   ipv6 backup api https://ipv6.ddnsip.cn

arIp4QueryUrl="http://ipv4.rehi.org/ip"
arIp6QueryUrl="http://ipv6.rehi.org/ip"

# The temp file to store the last record ip

arLastRecordFile=/tmp/ardnspod_last_record

# Return code when the last record IP is same as current host IP
# Set this to a value other than 0 to distinguish with a successful ddns update

arErrCodeUnchanged=0

# indicates whether a new domain record should be created
# if the record does not already exist. It is set to 1 (true) if a new record should be created
# when the domain record is missing, and 0 (false) otherwise.

arIsCreateRecord=0

# Number of retries after the first attempt for failed requests, and the
# interval in seconds between retries. Set arRetryCount=0 to disable retrying
# arRetryCount=3
# arRetryInterval=3

# Append logs to a file in addition to stderr; empty means stderr only
# arLogFile=/var/log/ardnspod.log

# Webhook url for failure notifications (DingTalk-style robot). When set, a single
# consolidated message is sent at the end of the run if any domain failed
# arWebhookUrl=https://oapi.dingtalk.com/robot/send?access_token=xxxx

# Dry-run: detect the ip and print what would happen without calling the DNSPod API
# arDryRun=1

# Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks

# IPv4:
arDdnsCheck "test.org" "subdomain"

# IPv6:
arDdnsCheck "test.org" "subdomain6" 6

# Print a run summary (which domains succeeded/failed) and, if arWebhookUrl is
# set, send a single consolidated failure notification
arDdnsSummary
