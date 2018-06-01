//
//  LTDatamatrixBarcodeReadOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTDatamatrixBarcodeReadOptions : LTBarcodeReadOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          BOOL enableDoublePass;
@property (nonatomic, assign)          BOOL enableDoublePassIfSuccess;
@property (nonatomic, assign)          BOOL enableInvertedSymbols;
@property (nonatomic, assign)          BOOL enableFastMode;
@property (nonatomic, assign)          BOOL readSquareSymbolsOnly;
@property (nonatomic, assign)          BOOL enableSmallSymbols;

@end

NS_ASSUME_NONNULL_END