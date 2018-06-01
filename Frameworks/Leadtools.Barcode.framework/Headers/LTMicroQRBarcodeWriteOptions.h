//
//  LTMicroQRBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTMicroQRBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTMicroQRBarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          NSInteger xModule;

@property (nonatomic, assign)          LTMicroQRBarcodeSymbolModel symbolModel;

@end

NS_ASSUME_NONNULL_END