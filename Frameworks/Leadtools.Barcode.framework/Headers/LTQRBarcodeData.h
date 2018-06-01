//
//  LTQRBarcodeData.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeData.h"
#import "LTQRBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTQRBarcodeData : LTBarcodeData <NSCopying>

@property (nonatomic, assign) LTBarcodeSymbology symbology;

@property (nonatomic, assign) LTQRBarcodeSymbolModel symbolModel;

@end

NS_ASSUME_NONNULL_END