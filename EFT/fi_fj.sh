#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x28"                        # 40 Bytes
MSG_HEADER="0000"                        # Header "0000" - ASCII
COMMAND_CODE="FI"                        # FI - Generate a ZEK or ZAK Request
FLAG="0"                                 # Flag (0 for ZEK 1 for ZAK)
ZMK="UBB839220AE2F70A754F05D356107D6E3"  # ZMK encrypted under LMK pair 04-05.

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${FLAG}${ZMK}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1