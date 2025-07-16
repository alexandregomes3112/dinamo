#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x42"                           # 66 Bytes
MSG_HEADER="0000"                           # Header "0000" - ASCII
COMMAND_CODE="CY"                           # CW - Generate a Card Verification Code/Value Request
CVK_AB="UEB0F2056EDC79C4BFB52B5B4D3E68D88"  # CVK A / B
CVV="684"                                   # CVV   
PRIMARY_ACCOUNT_NUMBER="1234567890123456"   # Primary Account Number
DELIMITER=";"                               # Delimiter ";" 
EXP_DATE="1510"                             # Expiration Date (YYMM)
SERVICE_CODE="109"                          # Service Code

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}"\
"${CVK_AB}${CVV}${PRIMARY_ACCOUNT_NUMBER}${DELIMITER}${EXP_DATE}${SERVICE_CODE}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1