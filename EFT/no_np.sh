#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x08"   # 26 bytes 
MSG_HEADER="0000"   # Header "0000" - ASCII -> 30303030
COMMAND_CODE="NO"   # NO - HSM State Request
MODE_FLAG="00"      # Mode Flag - '00': Return status information

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${MODE_FLAG}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1