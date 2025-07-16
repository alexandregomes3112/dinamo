#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x49"                        # 73 Bytes
MSG_HEADER="0000"                        # Header "0000" - ASCII
COMMAND_CODE="FK"                        # FK - Translate a ZEK/ZAK from ZMK to LMK encryption Request
FLAG="0"                                 # Flag (0 for ZEK 1 for ZAK)
ZMK="U80190C8703DD06D17ACAC79D9D92842D"  # ZMK encrypted under LMK pair 04-05.
ZEK="U0DB7AFD60BAA1458EA5B7C75EC90141D"  # ZPK em ASCII

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${FLAG}${ZMK}${ZEK}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1