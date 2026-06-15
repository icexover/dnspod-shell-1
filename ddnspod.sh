#!/bin/sh

cd "$(dirname "$0")"

# Import ardnspod functions
. ./ardnspod

################################################################### configuration ##

# Token: read from environment variable DNSPOD_TOKEN, or set it below.
# Environment variable takes precedence over the hardcoded value.
# To set via env: export DNSPOD_TOKEN="12345,7676f344eaeaea9074c123451234512d"

if [ -n "$DNSPOD_TOKEN" ]; then
    arToken="$DNSPOD_TOKEN"
else
    # Fallback: set your token here (not recommended for production)
    arToken="${arToken:-12345,7676f344eaeaea9074c123451234512d}"
fi

# Web endpoint to be used for querying the public IPv6 address
# Set this to override the default url provided by ardnspod
#   ipv4 backup api https://ipv4.ddnsip.cn
#   ipv6 backup api https://ipv6.ddnsip.cn

arIp4QueryUrl="${arIp4QueryUrl:-http://ipv4.rehi.org/ip}"
arIp6QueryUrl="${arIp6QueryUrl:-http://ipv6.ddnsip.cn/ip}"

# The temp file to store the last record ip

arLastRecordFile="${arLastRecordFile:-/tmp/ardnspod_last_record}"

# Return code when the last record IP is same as current host IP
# Set this to a value other than 0 to distinguish with a successful ddns update

arErrCodeUnchanged="${arErrCodeUnchanged:-0}"

# indicates whether a new domain record should be created
# if the record does not already exist. It is set to 1 (true) if a new record should be created
# when the domain record is missing, and 0 (false) otherwise.

arIsCreateRecord="${arIsCreateRecord:-0}"

# Retry configuration (can also be set via environment variables)
# arRetryCount: number of retry attempts after the initial call fails
# arRetryDelay: seconds to wait between retries

arRetryCount="${DNSPOD_RETRY_COUNT:-${arRetryCount:-3}}"
arRetryDelay="${DNSPOD_RETRY_DELAY:-${arRetryDelay:-5}}"

# Log file path. Set to enable file logging.
# Can also be set via environment variable DNSPOD_LOG_FILE.

arLogFile="${DNSPOD_LOG_FILE:-${arLogFile:-}}"

# Webhook URL for failure notifications (e.g., DingTalk robot webhook).
# Can also be set via environment variable DNSPOD_WEBHOOK_URL.

arWebhookUrl="${DNSPOD_WEBHOOK_URL:-${arWebhookUrl:-}}"

# Dry-run mode. Can be enabled via --dry-run flag or DNSPOD_DRY_RUN=1 env var.
# When enabled, no actual API calls are made. Only prints what would be done.

if [ "$DNSPOD_DRY_RUN" = "1" ]; then
    arDryRun=1
fi

################################################################### cli args ##

# Parse command-line arguments

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            arDryRun=1
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run       Run without making actual API calls (debug mode)"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Environment variables:"
            echo "  DNSPOD_TOKEN          API token (recommended over hardcoded value)"
            echo "  DNSPOD_LOG_FILE       Path to log file"
            echo "  DNSPOD_WEBHOOK_URL    Webhook URL for failure notifications"
            echo "  DNSPOD_DRY_RUN        Set to 1 to enable dry-run mode"
            echo "  DNSPOD_RETRY_COUNT    Number of API retry attempts (default: 3)"
            echo "  DNSPOD_RETRY_DELAY    Seconds between retries (default: 5)"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg (use --help for usage)" >&2
            exit 1
            ;;
    esac
done

################################################################### startup ##

# Initialize log file directory if needed
if [ -n "$arLogFile" ]; then
    logDir=$(dirname "$arLogFile")
    if [ ! -d "$logDir" ]; then
        mkdir -p "$logDir" 2>/dev/null
    fi
fi

arLog "========================================"
arLog " ardnspod DDNS Update"
arLog " $(date '+%Y-%m-%d %H:%M:%S')"
if [ "$arDryRun" = "1" ]; then
    arLog " *** DRY-RUN MODE - no changes will be made ***"
fi
arLog "========================================"

# Reset status tracking before running checks
arStatusReset

################################################################### ddns checks ##

# Place each domain you want to check as follows
# you can have multiple arDdnsCheck blocks

# IPv4:
arDdnsCheck "test.org" "subdomain"

# IPv6:
arDdnsCheck "test.org" "subdomain6" 6

################################################################### summary ##

# Print summary of all DDNS check results
arStatusSummary
exit $?
