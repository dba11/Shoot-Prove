//
//  LTMaxiBarcodeData.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeData.h"
#import "LTMaxiBarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTMaxiBarcodeData : LTBarcodeData <NSCopying>

@property (nonatomic, assign) LTBarcodeSymbology symbology;

@end

NS_ASSUME_NONNULL_END