#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x48"                        # 72 Bytes
MSG_HEADER="0000"                        # Header "0000" - ASCII
COMMAND_CODE="FA"                        # FA - Translate a ZPK from ZMK to LMK encryption Request
ZMK="U76E0E694E9B32D6D8D2DA02214FA453D"  # ZMK
ZPK="U49EC8839025AD967AD723220E9002A0D"  # ZPK

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${ZMK}${ZPK}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1