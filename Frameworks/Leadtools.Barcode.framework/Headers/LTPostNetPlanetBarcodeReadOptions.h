//
//  LTPostNetPlanetBarcodeReadOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"
#import "LTBarcodeReadEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPostNetPlanetBarcodeReadOptions : LTBarcodeReadOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeSearchDirection searchDirection;

@property (nonatomic, assign)          LTBarcodeReturnCheckDigit returnCheckDigit;

@property (nonatomic, assign)          NSInteger granularity;
@property (nonatomic, assign)          NSInteger whiteLinesNumber;

@end

NS_ASSUME_NONNULL_END