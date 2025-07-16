#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\xD6"                            # 214 Bytes
MSG_HEADER="0000"                            # Header "0000" - ASCII
COMMAND_CODE="M4"                            # M4 - Translate Data Block Request
SRC_MODE_FLAG="01"                           # Mode Flag (01 for CBC)
DEST_MODE_FLAG="01"                          # Mode Flag (01 for CBC)
IN_FORMAT_FLAG="1"                           # Describes the format of the input message: '1': Hex-Encoded Binary.
OUT_FORMAT_FLAG="1"                          # Describes the format of the output message: '1': Hex-Encoded Binary.
SRC_KEY_TYPE="009"                           # '009': BDK-1 (encrypted under LMK pair 28-29)
SRC_KEY="U490B5A62E949F90240D9EEAE0009E0DF"  # The Source (decryption) Key, used in conjunction with the IV, if appropriate, to decrypt the supplied Message.
KSN_DESCRIPTOR="609"                         # The descriptor for the KSN (in the next field).
SRC_KEY_SN="1FFF0000000026E00263"            # The KSN supplied by the PIN pad. For further information on DUKPT,
DEST_KEY_TYPE="009"                          # Destination Key Type BDK-1 (encrypted under LMK pair 28-29)
DEST_KEY="U490B5A62E949F90240D9EEAE0009E0DF" # The Destination (encryption) Key, used in conjunction with the IV, if appropriate, to re-encrypt the decrypted Message.
KSN_DESC="609"                               # The descriptor for the KSN (in the next field).
DEST_KEY_SN="1FFF0000000026E00263"           # Key Serial Number in ASCII
SRC_IV="0000000000000000"                    # The source IV, to be used in conjunction with Source Key.
DEST_IV="0000000000000000"                   # The input IV, to be used in conjunction with Destination Key.
MSG_LENGHT="0030"                            # The length of the following field, in bytes. Maximum: X'7D00 (32000) bytes.
MSG_BLOCK="5217301101010202D2020201"\
"121212121FFFFFFFFFFFFFFF"                   # Message Block

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${SRC_MODE_FLAG}"\
"${DEST_MODE_FLAG}${IN_FORMAT_FLAG}${OUT_FORMAT_FLAG}${SRC_KEY_TYPE}"\
"${SRC_KEY}${KSN_DESCRIPTOR}${SRC_KEY_SN}${DEST_KEY_TYPE}${DEST_KEY}"\
"${KSN_DESC}${DEST_KEY_SN}${SRC_IV}${DEST_IV}${MSG_LENGHT}${MSG_BLOCK}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1