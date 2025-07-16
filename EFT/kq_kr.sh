#!/bin/bash

# HSM IP and port (replace as necessary)
HSM_IP="187.33.9.132"
HSM_PORT="1500"

# Defining Command Message
HEADER="\x00\x8C"                               # 140 Bytes
MSG_HEADER="0000"                               # Header "0000" - ASCII
COMMAND_CODE="KQ"                               # KQ ARQC Validation and/or ARPC Generation (EMV 3.1.1) Request
MODE_FLAG="1"                                   # FLAG 1 Perform ARQC Verification and ARPC Generation
SCHEME="0"                                      # Scheme EMV Option 'A' Key Derivation
MK_AC="U87E7B360B5E6DF7101F481B145E1A809"       # The Issuer Master Key for generating and verifying Application Cryptograms.
PAN="\x04\x23\x01\x02\x03\x04\x05\x00"          # Pre-formatted PAN/PAN Sequence No. in HEX
ATC="\x00\x05"                                  # Application Transaction Counter. Present for all modes. A two byte value must be supplied.
UN="\x00\x00\x00\x00"                           # Unpredictable Number. Present for all modes. A four byte value must be supplied, though it is not used if Scheme ID is '0'.
TRANSACTION_DATA_LENGTH="48"                    # Length of next field. Can be any length from 1 to 255 bytes. Only present if Mode is '0', '1', '3' or '4'.
TRANSACTION_DATA="\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x76\x60\x80"\
"\x00\x00\x00\x09\x86\x10\x05\x14\x00\xAF\xFB\x4A\x7A\x59\x00\x00"\
"\x05\x0F\xA5\x01\xA2\x08\x00\x58\x00\x00\x00\x00\x00\x00\x00\x00"\
"\x00\x0F\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"\
"\x00\x80\x00\x00\x00\x00\x00\x00"              # Variable length data. Only present if Mode is '0', '1', '3' or '4'.
DELIMITER=";"                                   # Delimiter, to indicate end of Transaction Data, value ';'. Only present if Mode is '0', '1', '3' or '4'.
ARQC_TC_AAC="\x5E\x59\xAE\x10\x7E\x67\xEE\xC7"  # ARQC/TC/AAC to be validated and/or used for ARPC generation.
ARC="\x00\x00"                                  # Authorisation Response Code to be used for ARPC Generation. 

# Building Command Message
HEX_PAYLOAD="${HEADER}${MSG_HEADER}${COMMAND_CODE}${MODE_FLAG}"\
"${SCHEME}${MK_AC}${PAN}${ATC}${UN}${TRANSACTION_DATA_LENGTH}"\
"${TRANSACTION_DATA}${DELIMITER}${ARQC_TC_AAC}${ARC}"

# Sending to HSM
echo -ne "$HEX_PAYLOAD" | nc -N "$HSM_IP" "$HSM_PORT" | xxd -u -g 1