//
//  LTBarcodeWriter.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTBarcodeData.h"

NS_ASSUME_NONNULL_BEGIN

@class LTBarcodeEngine;

@interface LTBarcodeWriter : NSObject

@property (nonatomic, strong, readonly) LTBarcodeEngine *engine;

@property (nonatomic, strong, readonly) NSArray<__kindof LTBarcodeWriteOptions *> *allDefaultOptions;

@property (nonatomic, strong, readonly) NSArray<NSNumber *> *availableSymbologies;

- (instancetype)init __unavailable;

+ (Class)barcodeWriteOptionsTypeForSymbology:(LTBarcodeSymbology)symbology;

- (LTBarcodeWriteOptions *)defaultOptionsForSymbology:(LTBarcodeSymbology)symbology;

// Write one barcode of a certain type with options, if options is null, uses default
- (BOOL)calculateBarcodeDataBounds:(LeadRect)writeBounds xResolution:(NSInteger)xResolution yResolution:(NSInteger)yResolution data:(LTBarcodeData *)data options:(nullable LTBarcodeWriteOptions *)options error:(NSError **)error;

- (BOOL)writeBarcode:(LTRasterImage *)image data:(LTBarcodeData *)data options:(nullable LTBarcodeWriteOptions *)options error:(NSError **)error;

@end

@interface LTBarcodeWriter (Deprecated)

+ (Class)getBarcodeWriteOptionsType:(LTBarcodeSymbology)symbology LT_DEPRECATED_USENEW(19_0, "barcodeWriteOptionsTypeForSymbology:");

- (nullable NSArray *)getAllDefaultOptions LT_DEPRECATED_USENEW(19_0, "allDefaultOptions");
- (LTBarcodeWriteOptions*)getDefaultOptions:(LTBarcodeSymbology)symbology LT_DEPRECATED_USENEW(19_0, "defaultOptionsForSymbology:");

- (void)getAvailableSymbologies:(LTBarcodeSymbology * _Nullable * _Nonnull)availableSymbologies availableSymbologiesCount:(NSUInteger *)availableSymbologiesCount LT_DEPRECATED_USENEW(19_0, "availableSymbologies");
- (void)freeAvailableSymbologies:(LTBarcodeSymbology *)availableSymbologies LT_DEPRECATED(19_0, "");

@end

NS_ASSUME_NONNULL_END