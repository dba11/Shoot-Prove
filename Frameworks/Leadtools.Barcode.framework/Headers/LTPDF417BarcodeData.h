//
//  LTPDF417BarcodeData.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPDF417BarcodeData : LTBarcodeData <NSCopying>

@property (nonatomic, assign) LTBarcodeSymbology symbology;

@property (nonatomic, assign) NSInteger group;

@end

NS_ASSUME_NONNULL_END