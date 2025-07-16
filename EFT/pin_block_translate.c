#include <string.h>
#include <stdlib.h>
#include <stdio.h>
 
#include <dinamo.h> /* DINAMO Header */
 
#define HOST_ADDR       "187.33.9.132"
#define USER_ID         "demoale"
#define USER_PWD        "12345678"
 
#define KEY_TYPE   ALG_3DES_112
#define SRC_KEY_VALUE                                      \
    {                                                      \
        0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF,    \
        0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10     \
    }
 
/*
 * Dummy PIN block, generated from src_key and block with data
 * ABABABABABABABAB
 */
#define FAKE_PINBLOCK                                  \
    {                                                  \
        0xD9, 0x3B, 0x9C, 0xC2, 0x8B, 0x8F, 0x11, 0xF9 \
    }
 
int main()
{
    int nRet = 0;
    struct AUTH_PWD authPwd;
    HSESSIONCTX hSession = NULL;
    HKEYCTX hSrcKey = NULL;
    HKEYCTX hDstKey = NULL;
    BYTE pbKeyData[] = SRC_KEY_VALUE;
    BYTE pbPinBlock[] = FAKE_PINBLOCK;
    BYTE pbOutPinBlock[DES_BLOCK] = {};
    char szSrcKey[] = "src_key";
    char szDstKey[] = "dst_key";
 
    //Initialize DINAMO libraries
    nRet = DInitialize(0);
    if (nRet){
        printf("Function Failed: DInitialize \nError Code: %d\n", nRet);
        goto clean;
    }
 
    printf("Initialized libraries.\n");
 
    //Initializes the structure for connection to the HSM
    strncpy(authPwd.szAddr, HOST_ADDR, sizeof(authPwd.szAddr));
    authPwd.nPort = DEFAULT_PORT;
    strncpy(authPwd.szUserId, USER_ID, sizeof(authPwd.szUserId));
    strncpy(authPwd.szPassword, USER_PWD, sizeof(authPwd.szPassword));
 
    nRet = DOpenSession(&hSession, SS_USER_PWD, (BYTE *)&authPwd, 
                        sizeof(authPwd), ENCRYPTED_CONN);
 
    if (nRet){
        printf("Function failure: DOpenSession \nError Code: %d\n", nRet);
        goto clean;
    }
    printf("DINAMO Session established.\n");
 
    // Import source key
    nRet = DImportKey(hSession, szSrcKey, NULL, PLAINTEXTKEY_BLOB, KEY_TYPE,
                      TEMPORARY_KEY, pbKeyData, sizeof(pbKeyData), &hSrcKey);
    if(nRet){
        printf("Function Failure: DImportKey\nError Code: %d\n", nRet);
        goto clean;
    }
    printf("Source key imported successfully!\n");
 
    /*
    * The key context can now be released. We will only need the
    * key name from here on.
    */
    DDestroyKey(&hSrcKey, 0);
 
    // Generate target key
    nRet = DGenerateKey(hSession, szDstKey, KEY_TYPE, TEMPORARY_KEY, &hDstKey);
    if(nRet){
        printf("Function Failure: DGenerateKey\nError Code: %d\n", nRet);
        goto clean;
    }
    printf("Target key generated successfully!\n");
 
    /*
     * The key context can now be released. We will only need the
     * key name from here on.
     */
    DDestroyKey(&hDstKey, 0);
 
    /*
    * Translates the PIN block according to the source and destination key
    * In this case, it uses automatic/opaque translation (TP_TRANSLATE_TYPE_AUTO)
    * without needing to enter the PAN.
    */
    nRet = DPINBlockTranslate(hSession, szSrcKey, szDstKey, TP_TRANSLATE_TYPE_AUTO, 
                              NULL, pbPinBlock, pbOutPinBlock, 0);
    if(nRet){
        printf("Falha na funcao: DPINBlockTranslate\nCodigo de erro: %d\n", nRet);
        goto clean;
    }
 
    printf("PIN block traduzido com sucesso!\n");
 
    clean:
 
    if (hSession) {
        DCloseSession(&hSession, 0);
        printf("Sessao encerrada.\n");
    }
 
    DFinalize();
    printf("Bibliotecas finalizada.\n");
 
    return nRet;
    }