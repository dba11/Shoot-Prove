/*************************************************************
   LtBarcodeDispatch.h - barcode interfaces module header file
   Copyright (c) 1991-2016 LEAD Technologies, Inc.
   All Rights Reserved.
*************************************************************/

#if !defined(INC_LTBARCODEDISPATCH)
#define INC_LTBARCODEDISPATCH

#if defined(FOR_IOS) || defined(FOR_OSX)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma GCC diagnostic ignored "-Wignored-attributes"
#endif // #if defined(FOR_IOS) || defined(FOR_OSX)

/* Read functions */
typedef int (__stdcall* pLTBARCODE_READ_GETVERSION)(void);
typedef int (__stdcall* pLTBARCODE_READ_INIT)(void* pBar, int nSize, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_READ_READ)(void* pImage, void* pBar, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_READ_READBITMAP)(void* pImage, void* pBar, void* hBitmap, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_READ_READDIB)(void* pImage, void* pBar, void* pbmi, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_READ_READFILE)(void* pBar, const char* pFileName, int Subfile, int* pLTParam);
typedef void (__stdcall* pLTBARCODE_READ_READPASSWORD)(const char* pPassword);
typedef void (__stdcall* pLTBARCODE_READ_FREEMEMORY)(void* hMem, void* pMem);
typedef unsigned int (__stdcall* pLTBARCODE_READ_GETSTARTPOSITION)(void* pBar);
typedef void* (__stdcall* pLTBARCODE_READ_GETNEXTSYMBOL)(unsigned int* pos);

/* Write function */
typedef int (__stdcall* pLTBARCODE_WRITE_GETVERSION)(void);
typedef int (__stdcall* pLTBARCODE_WRITE_INIT)(void* pBar, int nSize, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_WRITE_WRITE)(void* pImage, void* pBar, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_WRITE_WRITEBITMAP)(void* pImage, void* pBar, void* hBitmap, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_WRITE_WRITEDIB)(void* pImage, void* pBar, void* pbmi, int* pLTParam);
typedef int (__stdcall* pLTBARCODE_WRITE_GETSIZE)(void* pImage, void* pBar, int* pLTParam);
typedef void (__stdcall* pLTBARCODE_WRITE_WRITEPASSWORD)(const char* pPassword);

#pragma pack(1)
typedef struct _LTBARCODE_READ_DISPATCH
{
   pLTBARCODE_READ_GETVERSION ltbarr_GetVersion;
   pLTBARCODE_READ_INIT ltbarr_Init;
   pLTBARCODE_READ_READ ltbarr_Read;
   pLTBARCODE_READ_READBITMAP ltbarr_ReadBitmap;
   pLTBARCODE_READ_READDIB ltbarr_ReadDib;
   pLTBARCODE_READ_READFILE ltbarr_ReadFile;
   pLTBARCODE_READ_READPASSWORD ltbarr_ReadPassword;
   pLTBARCODE_READ_FREEMEMORY ltbarr_FreeMemory;
   pLTBARCODE_READ_GETSTARTPOSITION ltbarr_GetStartPosition;
   pLTBARCODE_READ_GETNEXTSYMBOL ltbarr_GetNextSymbol;
}
LTBARCODE_READ_DISPATCH, *pLTBARCODE_READ_DISPATCH;
#pragma pack()

#pragma pack(1)
typedef struct _LTBARCODE_WRITE_DISPATCH
{
   pLTBARCODE_WRITE_GETVERSION ltbarw_GetVersion;
   pLTBARCODE_WRITE_INIT ltbarw_Init;
   pLTBARCODE_WRITE_WRITE ltbarw_Write;
   pLTBARCODE_WRITE_WRITEBITMAP ltbarw_WriteBitmap;
   pLTBARCODE_WRITE_WRITEDIB ltbarw_WriteDib;
   pLTBARCODE_WRITE_GETSIZE ltbarw_GetSize;
   pLTBARCODE_WRITE_WRITEPASSWORD ltbarw_WritePassword;
}
LTBARCODE_WRITE_DISPATCH, *pLTBARCODE_WRITE_DISPATCH;
#pragma pack()

enum LTBarcodeUse
{
   LTBarcodeUseOneD,
   LTBarcodeUsePDF417,
   LTBarcodeUseDatamatrix,
   LTBarcodeUseQR,
   LTBarcodeUseLead2D,
   LTBarcodeUseLast
};

#if defined(FOR_LIB) || defined(FOR_IOS) || defined(FOR_OSX) || defined(__APPLE_CC__) || defined(FOR_ANDROID) || defined(FOR_LINUX) || defined(FOR_JNI)
#  if !defined(LT_EXTERN_C)
#     if defined(__cplusplus)
#        define LT_EXTERN_C extern "C"
#     else
#        define LT_EXTERN_C extern
#     endif
#  endif

   LT_EXTERN_C LTBARCODE_READ_DISPATCH BarcodeReadLoaders[];
   LT_EXTERN_C LTBARCODE_WRITE_DISPATCH BarcodeWriteLoaders[];

   LT_EXTERN_C void LTBarcodeRead_FillDispatch_OneD(pLTBARCODE_READ_DISPATCH);
   LT_EXTERN_C void LTBarcodeWrite_FillDispatch_OneD(pLTBARCODE_WRITE_DISPATCH);
   LT_EXTERN_C void LTBarcodeRead_FillDispatch_PDF417(pLTBARCODE_READ_DISPATCH);
   LT_EXTERN_C void LTBarcodeWrite_FillDispatch_PDF417(pLTBARCODE_WRITE_DISPATCH);
   LT_EXTERN_C void LTBarcodeRead_FillDispatch_Datamatrix(pLTBARCODE_READ_DISPATCH);
   LT_EXTERN_C void LTBarcodeWrite_FillDispatch_Datamatrix(pLTBARCODE_WRITE_DISPATCH);
   LT_EXTERN_C void LTBarcodeRead_FillDispatch_QR(pLTBARCODE_READ_DISPATCH);
   LT_EXTERN_C void LTBarcodeWrite_FillDispatch_QR(pLTBARCODE_WRITE_DISPATCH);
   LT_EXTERN_C void LTBarcodeRead_FillDispatch_Lead2D(pLTBARCODE_READ_DISPATCH);
   LT_EXTERN_C void LTBarcodeWrite_FillDispatch_Lead2D(pLTBARCODE_WRITE_DISPATCH);

#  define LTBARCODE_USE_READ(name)  \
   LTBarcodeRead_FillDispatch_##name(&BarcodeReadLoaders[(int)LTBarcodeUse##name])
#  define LTBARCODE_USE_WRITE(name)  \
   LTBarcodeWrite_FillDispatch_##name(&BarcodeWriteLoaders[(int)LTBarcodeUse##name])
#endif // #if defined(FOR_LIB) || defined(FOR_IOS) || defined(FOR_OSX) || defined(__APPLE_CC__) || defined(FOR_ANDROID) || defined(FOR_JNI)

#if defined(FOR_IOS) || defined(FOR_OSX)
#pragma GCC diagnostic pop
#endif // #if defined(FOR_IOS) || defined(FOR_OSX)

#endif
