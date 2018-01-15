#!/bin/bash

# <bitbar.title>Kraken Litecoin Ticker</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Soowa</bitbar.author>
# <bitbar.author.github>soowa</bitbar.author.github>
# <bitbar.desc>Displays Litecoin to Euro rate</bitbar.desc>
# <bitbar.dependencies>bash</bitbar.dependencies>

LABEL="LTC"
ICON="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAAAsTAAALEwEAmpwYAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAACBElEQVQ4EX1STWsaYRB+dXUXP7aoKEYrGEE8lUoQ9NKDNz+OJZ68CJbmJ+TqwT+Rn+At59CDkHopSAjkYEyIIpUqQj1EEq3rbp953V3cKBkY3plnvmdexvbJtg+xQxh3E944k6NGWKFQSMuyXJxMJr+hvoDtYG7De5DMKn6//zwUCmmRSORPLpeLkXcmk3EeiqKsBvEE1Wr1A4Cz2WzGBEF4KpVKf8kB3bxbneXzeQc5lsvlVDgcHkPUksnkJWE7ZHZpYLsdcGy5XB4tFosoKXa7/ZHeWq12VK/XAxD3ujCXOBwOacaN1+v9ggRfY7HYIB6PXweDweJgMLhQFOUKL3VGMWYi3jYAam0FZj6fbyGK4s/1ei32er3mdDoVNE3ruFyue7KDzOCtuj0PyRJm/46KN1jYq9vtfkbQj0AgcIpdSLrz3g4I510kEolvaF+LRqPzdDp9nc1mW5VK5aMeSA+1TmzZGykKmOHu/5CkiS5a8/n803g8PgH8Sjb9QhuIxCphFjI+SaPRECVJeoBRwwI7mN1SbSfIHMVYIre12+3PGCO8Wq0Ygo9BLRhUh8Mh4ApUXU6lUr/6/X6DB2D5PEG32+UZEZSw2WwyGUejEf2FU+hss6HYLSGRpaih8D2g0i3czsCqx+NZI1BRVZXPDVnFeZ3A7/RcVNRyUnMu3eG9x/T9D4/zo1UHXOd+AAAAAElFTkSuQmCC"

# Include
source "${BASH_SOURCE%/*}/inc/kraken.sh"
source "${BASH_SOURCE%/*}/inc/bmp.sh"

# Will exit if no connection is available
check_connection

# Read previous Ask, Low and High value
read PA PL PH <<< $(read_history $LABEL)

DATA=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=XLTCZEUR")

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
