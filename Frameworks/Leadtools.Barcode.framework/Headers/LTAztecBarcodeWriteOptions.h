//
//  LTAztecBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTBarcodeWriteEnums.h"
#import "LTAztecBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAztecBarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTAztecBarcodeSymbolModel symbolModel;

@property (nonatomic, assign)          NSInteger xModule;
@property (nonatomic, assign)          NSInteger quietZone;
@property (nonatomic, assign)          NSInteger errorCorrectionRate;
@property (nonatomic, assign)          NSInteger aztecRuneValue;

@property (nonatomic, assign)          BOOL aztecRune;

@end

NS_ASSUME_NONNULL_END