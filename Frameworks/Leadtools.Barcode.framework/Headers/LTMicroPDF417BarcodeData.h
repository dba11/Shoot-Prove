//
//  LTMicroPDF417BarcodeData.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTMicroPDF417BarcodeData : LTBarcodeData <NSCopying>

@property (nonatomic, assign)             LTBarcodeSymbology symbology;

@property (nonatomic, assign, readonly)   BOOL isLinked;

@property (nonatomic, assign)             NSUInteger dataCode;

@end

NS_ASSUME_NONNULL_END