//
//  LTDatamatrixBarcodeData.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeData.h"
#import "LTDatamatrixBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTDatamatrixBarcodeData : LTBarcodeData <NSCopying>

@property (nonatomic, assign) LTBarcodeSymbology symbology;

@property (nonatomic, assign) LTDatamatrixBarcodeSymbolSize symbolSize;

@end

NS_ASSUME_NONNULL_END