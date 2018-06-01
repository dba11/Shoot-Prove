//
//  LTOneDBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTBarcodeWriteEnums.h"
#import "LTOneDBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOneDBarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeOutputTextPosition textPosition;

@property (nonatomic, assign)          LTCode128BarcodeTableEncoding code128TableEncoding;

@property (nonatomic, assign)          LTCode11BarcodeCheckDigitType code11CheckDigitType;

@property (nonatomic, assign)          LTMSIBarcodeModuloType msiModuloType;

@property (nonatomic, assign)          BOOL useXModule;
@property (nonatomic, assign)          BOOL enableErrorCheck;
@property (nonatomic, assign)          BOOL setGS1DatabarLinkageBit;
@property (nonatomic, assign)          BOOL writeTruncatedGS1Databar;

@property (nonatomic, assign)          NSInteger xModule;

@end

NS_ASSUME_NONNULL_END