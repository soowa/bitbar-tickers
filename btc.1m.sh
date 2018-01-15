#!/bin/bash

# <bitbar.title>Kraken Bitcoin Ticker</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Soowa</bitbar.author>
# <bitbar.author.github>soowa</bitbar.author.github>
# <bitbar.desc>Displays Bitcoin to Euro rate</bitbar.desc>
# <bitbar.dependencies>bash</bitbar.dependencies>

LABEL="BTC"
ICON="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAActpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx4bXA6Q3JlYXRvclRvb2w+d3d3Lmlua3NjYXBlLm9yZzwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KGMtVWAAAAg5JREFUOBF9k7+LE1EQx/dHTLJC0KsSEhBFjiBBiInnEdMEG8HagNiIhfpXaKeVjdVVXi9BC1E4u3QHF5JLIalkVZAYzkbInSxJ9q2feexbslfcwGS+b95859fbWNbZYq9dr+PE7SYoBt1u1/U871apVLowm83+NJvN7UqlsjGdTo8IcdBonSMOIxr3er0QxyfXdV/EF++VUi9jrLCpTnQHUnUymahGo3GnXC7vELSJXqHybdu2b4I9/EGxWPxGVwHnpBNd1fd9bQmu5nK5uwRIpe9RFFXRr+BL2Wx2x3GcHlgk6UQTC4WCnosEJ2EoE1j+cDi8gVbR65yfiJ/7Tr1evywBdK25+kccIszqECTQabVaXqfTycgBOU91sT67kWVa7EoXTSUgyCWJ3G8uFovf8/n8iFc4yWQyb5bL5THjPKKjf3FiHWgqCEkkijs4Bn9BFedotVpdwzY5P2+32w/6/f4cLMVVKgHVFdXwW7+o9FCAETrZy+fz94IgeIbvNV04JFKpEaSaIZy23P2U8bDyxImkOmBGk3CDb+IxOwkhhZC2YDyVBMjnhA1IJYBgx89YYtu7EojV8ZB/sMhXo9HoIw6b9ldyYT5LsRFvfJEkV6m4z/kAfB+iT2eHENtCOC2mZZndGY/Hfwkcgt+i7waDwQzyLgk/CLFWq2XFniW2/C9MAJs/ZzDWFFtzWdZ/VW7KdFciWMMAAAAASUVORK5CYII="

# Include
source "${BASH_SOURCE%/*}/inc/kraken.sh"
source "${BASH_SOURCE%/*}/inc/bmp.sh"

# Will exit if no connection is available
check_connection

# Read previous Ask, Low and High value
read PA PL PH <<< $(read_history $LABEL)

DATA=$(curl -s "https://api.kraken.com/0/public/Ticker?pair=XBTCZEUR")

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
