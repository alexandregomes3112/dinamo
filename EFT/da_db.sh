#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x92"                        # 146 Bytes
MSG_HEADER="0000"                        # Header "0000" - ASCII
COMMAND_CODE="DA"                        # DA - Verify a Terminal PIN Using the IBM Method Request
TPK="UE24F4BD5EF6E98BA24E18EE874606B2E"  # TPK 
PVK="U34319B1E6E631C121F0D97BFA232E181"  # PVK 
MAX_PIN_LENGTH="12"                      # Maximum PIN Length 
PIN_BLOCK="3D470E8524DF31D0"             # The PIN block encrypted under the TPK
PIN_BLOCK_FORMAT_CODE="01"               # One of the valid PIN block format codes.
CHECK_LENGTH="04"                        # The minimum PIN length.
PAN="990000000123"                       # The Primary Account Number, used to form the PIN Block.
DECIMALISATION_TABLE="FD64FC3FAD504BB3"  # Decimalization Table
PIN_VALIDATION_DATA="5799900000N0"       # PIN validation Data
OFFSET="0463FFFFFFFF"                    # Offset in ASCIIIBM offset value, left-justified and padded with 'F's


# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${TPK}${PVK}"\
"${MAX_PIN_LENGTH}${PIN_BLOCK}${PIN_BLOCK_FORMAT_CODE}${CHECK_LENGTH}"\
"${PAN}${DECIMALISATION_TABLE}${PIN_VALIDATION_DATA}${OFFSET}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1
