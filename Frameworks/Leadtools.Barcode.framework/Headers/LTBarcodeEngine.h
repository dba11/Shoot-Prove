//
//  LTBarcodeEngine.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTGlobalEnums.h"
#import "LTBarcodeReader.h"
#import "LTBarcodeWriter.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTBarcodeEngine : NSObject

@property (nonatomic, strong, readonly) LTBarcodeReader *reader;
@property (nonatomic, strong, readonly) LTBarcodeWriter *writer;

+ (NSArray<NSNumber *> *)supportedSymbologies;

+ (NSString *)friendlyNameForSymbology:(LTBarcodeSymbology)symbology;

@end

@interface LTBarcodeEngine (Deprecated)

+ (void)getSupportedSymbologies:(LTBarcodeSymbology * _Nullable * _Nonnull)supportedSymbologies supportedSymbologiesCount:(NSUInteger *)supportedSymbologiesCount LT_DEPRECATED_USENEW(19_0, "+[LTBarcodeEngine supportedSymboligies]");;
+ (void)freeSupportedSymbologies:(LTBarcodeSymbology *)supportedSymbologies LT_DEPRECATED(19_0, "");

+ (NSString *)getSymbologyFriendlyName:(LTBarcodeSymbology)symbology LT_DEPRECATED_USENEW(19_0, "friendlyNameForSymbology:");

@end

NS_ASSUME_NONNULL_END