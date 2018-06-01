//
//  LTDatamatrixBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTBarcodeWriteEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTDatamatrixBarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeAlignment horizontalAlignment;

@property (nonatomic, assign)          LTBarcodeAlignment verticalAlignment;

@property (nonatomic, assign)          BOOL disableCompression;

@property (nonatomic, assign)          NSInteger groupNumber;
@property (nonatomic, assign)          NSInteger groupTotal;

@property (nonatomic, assign)          unsigned char fileIdNumberLowByte;
@property (nonatomic, assign)          unsigned char fileIdNumberHighByte;

@property (nonatomic, assign)          NSInteger xModule;

@end

NS_ASSUME_NONNULL_END