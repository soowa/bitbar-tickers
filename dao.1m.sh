#!/bin/bash

# <bitbar.title>Kraken DAO Ticker</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Soowa</bitbar.author>
# <bitbar.author.github>soowa</bitbar.author.github>
# <bitbar.desc>Displays DAO to Euro rate</bitbar.desc>
# <bitbar.dependencies>bash</bitbar.dependencies>

LABEL="DAO"
ICON="iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAAAsTAAALEwEAmpwYAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAABEklEQVQoFT3SoUsDYRjH8TvnRBEtA2cZBoNgMDjY2opoWrAZhAUFcWDwrzCOZe2CGAWbCAsWg6aFVcGoYYoDN/X73fnsB59797zvve97e+/SJEuFpo0ivjGFEd5xh3O8IJ3mYhawgQfcYxEpSjjFNhroYZwtrh84zMrJ1Z32MMAl8rHDL4WZzZrE/p9/V7SbOELZFcwnnPRlQXx+J8xYkA7sK7vSDk7g6vtYRwG3uIbpw8WWYwc7I/F4Udt6AJqMVSlc5QDGQZPPmmSX9g3HscM8hTfNweTgmO/E1OB/eowJsaLHZ4bwBvs91iZu8BzHyu9xHFyCL87nXUEdTzjDKCb40rpYwypc2WP002jhAq9I/wC1ezVv76uvQwAAAABJRU5ErkJggg=="

# Include
source "${BASH_SOURCE%/*}/inc/kraken.sh"
source "${BASH_SOURCE%/*}/inc/bmp.sh"

# Will exit if no connection is available
check_connection

# Read previous Ask, Low and High value
read PA PL PH <<< $(read_history $LABEL)

DATA=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=XDAOZEUR")

# Parse the kraken API data
read A B L H O T <<< $(parse_present $DATA $LABEL)

# Alert if Ask is more/less than High/Low
notify_on_new_high_or_low $L $H $PL $PH $LABEL

# Display current Ask and diff to prev. Ask
output_primary_info $A $PA $ICON

# Display Ask, Bid, Low, High, Opening, Trades
output_secondary_info $A $B $L $H $O $T

echo "---"
candle "$H" "$L" "$O" "$A"
echo -n "| image="
output_bmp | base64
