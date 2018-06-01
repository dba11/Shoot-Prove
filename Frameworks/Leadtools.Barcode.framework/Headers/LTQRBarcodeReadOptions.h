//
//  LTQRBarcodeReadOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTQRBarcodeReadOptions : LTBarcodeReadOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          BOOL enableDoublePass;
@property (nonatomic, assign)          BOOL enableDoublePassIfSuccess;

@end

NS_ASSUME_NONNULL_END