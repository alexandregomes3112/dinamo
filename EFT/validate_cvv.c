#include <string.h>
#include <stdlib.h>
#include <stdio.h>
 
#include <dinamo.h> /* DINAMO Header */
 
#define HOST_ADDR       "187.33.9.132"
#define USER_ID         "demoale"
#define USER_PWD        "12345678"
 
#define PAN             "4123456789012345"
#define EXPIRATION_DATE "8701"
#define SERVICE_CODE    "101"
 
#define CVV_RESULT      "561"
 
#define KEY_ID          "KEY_CVV"
#define KEY_VALUE       { 0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF, 0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10 }
#define KEY_TYPE        ALG_3DES_112
 
int main()
{
    int nRet = 0;
    char szCVV[MIN_CVV_LEN];
    struct AUTH_PWD authPwd;
    HSESSIONCTX hSession = NULL;
    HKEYCTX hKey = NULL;
    BYTE  pbKeyData[] = KEY_VALUE;
 
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
 
    nRet = DOpenSession(&hSession, SS_USER_PWD, (BYTE *)&authPwd, sizeof(authPwd), ENCRYPTED_CONN);
 
    if (nRet){
        printf("Function failure: DOpenSession \nError Code: %d\n", nRet);
        goto clean;
    }
    printf("DINAMO Session established.\n");
 
    // Import temporary key
    nRet = DImportKey( hSession, KEY_ID, NULL, PLAINTEXTKEY_BLOB, KEY_TYPE, TEMPORARY_KEY, pbKeyData, sizeof(pbKeyData), &hKey );
 
    if(nRet){
        printf("Function Failure: DImportKey\nError Code: %d\n", nRet);
        goto clean;
    }
 
    // Generates CVV based on the temporary key and other parameters
    nRet = DGenerateCVV( hSession, KEY_ID, PAN, EXPIRATION_DATE, SERVICE_CODE, szCVV, 0);
 
    if(nRet){
        printf("Function Failure: DGenerateCVV\nError Code: %d\n", nRet);
        goto clean;
    }
 
    // Algorithm validation - compare the resulting CVV with the expected CVV
    // (with the same key and other parameters, the result is always the same)
    if( strcmp( szCVV, CVV_RESULT ) ) {
        printf("Comparison between generated CVV failed (%s) and expected (%s).", szCVV, CVV_RESULT);
    }
 
    // Check if the CVV generator is actually valid in the HSM (using the same key and parameters)
    nRet = DVerifyCVV( hSession, KEY_ID, PAN, EXPIRATION_DATE, SERVICE_CODE, szCVV, 0);
 
    if(nRet){
        printf("Functoin failure: DVerifyCVV\nError Code: %d\n", nRet);
        goto clean;
    }
 
    printf("CVV verified successfully!\n");
 
    clean:
 
    if (hKey) {
        DDestroyKey(&hKey, 0);
        printf("Key context released.\n");
    }
 
    if (hSession) {
        DCloseSession(&hSession, 0);
        printf("Session closed.\n");
    }
 
    DFinalize();
    printf("Libraries closed.\n");
 
    return nRet;
}
