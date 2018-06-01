//
//  LTBitmapHandleConverter.h
//  Leadtools.Converters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#include "LTConvertersDefines.h"

typedef struct {
    L_UINT structSize;
    L_UINT maximumWidth;
    L_UINT maximumHeight;
    L_UINT sizeMode;
    L_BOOL resample;
    
    LTConvertToImageOptions options;
} L_ConvertToImageData;

typedef struct
{
    L_UINT structSize;
    
    LTConvertFromImageOptions options;
} L_ConvertFromImageData;

extern L_ConvertToImageData _defaultConvertToImageData;
extern L_ConvertFromImageData _defaultConvertFromImageData;

EXTERN_C L_INT L_ConvertToCGImage(BITMAPHANDLE *bitmapHandle, CGImageRef *image, const L_ConvertToImageData *data);
EXTERN_C L_INT L_ConvertFromCGImage(CGImageRef image, BITMAPHANDLE *bitmapHandle, const L_ConvertFromImageData *data);