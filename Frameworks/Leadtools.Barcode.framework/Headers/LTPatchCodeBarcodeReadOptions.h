//
//  LTPatchCodeBarcodeReadOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"
#import "LTBarcodeReadEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPatchCodeBarcodeReadOptions : LTBarcodeReadOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeSearchDirection searchDirection;

@property (nonatomic, assign)          NSInteger granularity;

@end

NS_ASSUME_NONNULL_END