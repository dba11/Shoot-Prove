//
//  LTFourStateBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTBarcodeWriteEnums.h"
#import "LTFourStateBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTFourStateBarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeOutputTextPosition textPosition;

@property (nonatomic, assign)          NSInteger xModule;

@property (nonatomic, assign)          LTAustralianPost4StateBarcodeCIFEncoding australianPostCIFEncoding;

@end

NS_ASSUME_NONNULL_END