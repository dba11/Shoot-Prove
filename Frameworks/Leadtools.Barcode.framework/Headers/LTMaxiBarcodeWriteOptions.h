//
//  LTMaxiBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTMaxiBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTMaxiBarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;
@property (nonatomic, copy)            NSString *postalCodeChar;

@property (nonatomic, assign)          LTMaxiBarcodeSymbolModel symbolModel;

@property (nonatomic, assign)          NSInteger resolution;
@property (nonatomic, assign)          NSInteger countryCode;
@property (nonatomic, assign)          NSInteger serviceClass;
@property (nonatomic, assign)          NSInteger postalCodeNum;
@property (nonatomic, assign)          NSInteger year;

@property (nonatomic, assign)          BOOL openSystemStandard;

@end

NS_ASSUME_NONNULL_END