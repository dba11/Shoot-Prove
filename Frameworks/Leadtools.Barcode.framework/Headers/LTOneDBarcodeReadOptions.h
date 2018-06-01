//
//  LTOneDBarcodeReadOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"
#import "LTBarcodeReadEnums.h"
#import "LTOneDBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOneDBarcodeReadOptions : LTBarcodeReadOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeSearchDirection searchDirection;

@property (nonatomic, assign)          LTBarcodeReturnCheckDigit returnCheckDigit;

@property (nonatomic, assign)          LTCode11BarcodeCheckDigitType code11CheckDigitType;

@property (nonatomic, assign)          LTMSIBarcodeModuloType msiModuloType;

@property (nonatomic, assign)          NSInteger granularity;
@property (nonatomic, assign)          NSInteger minimumStringLength;
@property (nonatomic, assign)          NSInteger maximumStringLength;
@property (nonatomic, assign)          NSInteger whiteLinesNumber;

@property (nonatomic, assign)          BOOL enableFastMode;
@property (nonatomic, assign)          BOOL enableErrorCheck;
@property (nonatomic, assign)          BOOL avoidCorruptedBlocks;
@property (nonatomic, assign)          BOOL allowPartialRead;
@property (nonatomic, assign)          BOOL code39Extended;
@property (nonatomic, assign)          BOOL resizeSmall1D;

@end

NS_ASSUME_NONNULL_END