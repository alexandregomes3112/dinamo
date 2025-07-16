#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x2A"                       # 42 Bytes
MSG_HEADER="0000"                       # Header "0000" - ASCII
COMMAND_CODE="BU"                       # BU - Generate a Key Check Value Request
KEY_TYPE="00"                           # LMK pair 04-05
KEY_LENGHT_FLAG="0"                     # for double length key
KEY="U294E6024662EB037097C4C8D5CEEA6ED" # Key


# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}"\
"${KEY_TYPE}${KEY_LENGHT_FLAG}${KEY}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1