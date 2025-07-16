#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x89"                       # 137 Bytes
MSG_HEADER="0000"                       # Header "0000" - ASCII
COMMAND_CODE="M0"                       # M0 - Encrypt Data Block Request
MODE_FLAG="01"                          # CBC (requires an IV)
IN_FORMAT_FLAG="1"                      # Describes the format of the input message: '1': Hex-Encoded Binary.
OUT_FORMAT_FLAG="1"                     # Describes the format of the output message: '1': Hex-Encoded Binary.
KEY_TYPE="009"                          # BDK-1 (encrypted under LMK pair 28-29)
KEY="U490B5A62E949F90240D9EEAE0009E0DF" # Key
KSN_DESCRIPTOR="609"                    # KSN Descriptor (609 for Primary Key)
KEY_SN="1FFF0000000026E00263"           # The KSN supplied by the PIN pad, including the transaction counter
IV="0000000000000000"                   # The input IV, used in conjunction with the encryption Key
MSG_LENGHT="0030"                       # Message Length
MSG_BLOCK="5217301101010202D2020201"\
"121212121FFFFFFFFFFFFFFF"              # Message Block

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${MODE_FLAG}"\
"${IN_FORMAT_FLAG}${OUT_FORMAT_FLAG}${KEY_TYPE}${KEY}"\
"${KSN_DESCRIPTOR}${KEY_SN}${IV}${MSG_LENGHT}${MSG_BLOCK}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1