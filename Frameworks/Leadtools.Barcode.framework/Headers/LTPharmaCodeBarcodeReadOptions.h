//
//  LTPharmaCodeBarcodeReadOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"
#import "LTBarcodeReadEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPharmaCodeBarcodeReadOptions : LTBarcodeReadOptions

@property (nonatomic, copy, readonly) NSString *friendlyName;

@property (nonatomic, assign)         LTBarcodeSearchDirection searchDirection;

@end

NS_ASSUME_NONNULL_END