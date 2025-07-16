#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x27"                                # 39 Bytes
MSG_HEADER="0000"                                # Header "0000" - ASCII
COMMAND_CODE="HC"                                # HC - Generate a TMK, TPK or PVK Request
TMK_TPK_PVK="UFB16FE0006A86F423E7A9935FFBB103F"  # The current TMK, TPK or PVK encrypted under LMK pair 14-15.

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${TMK_TPK_PVK}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1