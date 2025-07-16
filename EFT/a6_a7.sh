#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x4C"                            # 76 Bytes
MSG_HEADER="0000"                            # Header "0000" - ASCII
COMMAND_CODE="A6"                            # A6 -  Import a Key Request - ASCII
KEY_TYPE="001"                               # ZPK, Zone PIN Key - ASCII
ZMK="U1BF1879107A29B475E07CB594A8D67A4"      # ZMK - ASCII
KEY_ZMK="XB38BBEBCEE6C5A5484393BBCC4F0D9F8"  # Key ZMK - ASCII
KEY_SCHEME="U"                               # Key Scheme (U for LMK) - ASCII


# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}"\
"${KEY_TYPE}${ZMK}${KEY_ZMK}${KEY_SCHEME}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1