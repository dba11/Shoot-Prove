//
//  LTBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTBarcodeWriteOptions : LTBarcodeOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, copy)            LTRasterColor *foreColor;
@property (nonatomic, copy)            LTRasterColor *backColor;

@end

NS_ASSUME_NONNULL_END