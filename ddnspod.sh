#!/bin/sh

cd "$(dirname "$0")"

# Import ardnspod functions
. ./ardnspod

# Initialise with explicit parameters (preferred over global variables).
# Args: token [ip4QueryUrl] [ip6QueryUrl] [lastRecordFile] [errCodeUnchanged] [isCreateRecord]
#
# Legacy global variables (arToken, arIp4QueryUrl, etc.) are still
# supported for backward compatibility, but arInit is recommended.

arInit "12345,7676f344eaeaea9074c123451234512d" \
       "http://ipv4.rehi.org/ip" \
       "http://ipv6.rehi.org/ip" \
       "/tmp/ardnspod_last_record" \
       0 0

# Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks

# IPv4:
arDdnsCheck "test.org" "subdomain"

# IPv6:
arDdnsCheck "test.org" "subdomain6" 6
