#!/bin/bash

# <bitbar.title>Kraken Ethereum Ticker</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Soowa</bitbar.author>
# <bitbar.author.github>soowa</bitbar.author.github>
# <bitbar.desc>Displays Ether to Euro rate</bitbar.desc>
# <bitbar.dependencies>bash</bitbar.dependencies>

LABEL="ETH"
ICON="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAAAsTAAALEwEAmpwYAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAABQ0lEQVQ4EY3SSytFURTA8esVmckrpeSGhIyNlMGdKFP5ECIDcwNfwlSGPoIRAwMyM1IyVWJAIs///96zj3V0Tt1Vv7u3tffar6NWq46OMBT7IV3d7cyGJminsn7KFapKk2HGKv3d7O/vkM+7ZQuYc/IshrGENRjdrebv9/8C3tXiXizjC+/YRD8+UajpIhHDwR+soA6LJ+FbGOewJr9OXM2+A4OYh2E7ihdswAf1FPnG6fPYurPtFrz3UGac9g09OMU6jGZNPIFJ7+nDzcGdX+E1RuCuzxhAHvlRsswH7QOu0YcZjOEER7jEFfKIC6TrOLiIM9ziAnfwqxziEZ7cKxc+iQkH7mGRBU+oYxsHuIH/Cz52ZaSTNJixD4v2YMQTtzIlv2kBh3ZwDN/D8IRtRZo4zeyFrKKt3ePq8SRpwTje7P8CsLUwKqXqYlcAAAAASUVORK5CYII="

# Include
source "${BASH_SOURCE%/*}/inc/kraken.sh"
source "${BASH_SOURCE%/*}/inc/bmp.sh"

# Will exit if no connection is available
check_connection

# Read previous Ask, Low and High value
read PA PL PH <<< $(read_history $LABEL)

DATA=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=XETHZEUR")

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
output_bmp > /tmp/$LABEL.bmp
echo -n "| image="
output_bmp | base64
