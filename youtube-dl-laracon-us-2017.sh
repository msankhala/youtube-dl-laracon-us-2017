#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage:
#/ Description:
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

cleanup() {
    # Remove temporary files
    rm -f *.mp4.*
    echo 'cleanup';
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT
    # Script goes here
    # Set desired format value.
    desiredFormat='960x540';
    # List of urls form where to download vidoes.
    urls=(
      'https://streamacon.com/video/laracon-us-2017/day-1-taylor-otwell'
      # 'https://streamacon.com/video/laracon-us-2017/day-1-blackfireio'
      # 'https://streamacon.com/video/laracon-us-2017/day-1-nexmo'
      # 'https://streamacon.com/video/laracon-us-2017/day-1-vehikl'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-matt-stauffer'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-sean-larkinn'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-algolia'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-heroku'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-sentry'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-mathias-and-michele-hansen'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-eric-barnes'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-jeffrey-way'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-jack-mcdade'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-justin-jackson'
      # 'https://streamacon.com/video/laracon-us-2017/day-2-laura-elizabeth'
    );
    # Loop through urls and run `youtub-dl -F <url>` command on each url to
    # fetch available format of that video and save that output text in `output`
    # variable.
    for url in "${urls[@]}"; do
      echo "URL: $url";
      output=$(youtube-dl -F $url);

      # Run `awk on the output text and match the desired output and store video
      # format name in `formatName`.
      read formatName <<< $(awk '{
        if (($3 ~ /'$desiredFormat'/) && ($NF !~ /only/)) {
          print $1; exit;
        }
      }' <<< "$output")

      # Now run `youtube-dl -f <formatName> <url>` command to download video.
      echo "DOWNLOADING $formatName"
      youtube-dl -f $formatName $url;
    done

fi
