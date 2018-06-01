//
//  LTPharmaCodeBarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"

@interface LTPharmaCodeBarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly) NSString *friendlyName;

@property (nonatomic, assign)         BOOL useXModule;
@property (nonatomic, assign)         NSInteger xModule;

@end