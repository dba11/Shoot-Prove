//
//  LTBarcodeOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTGlobalEnums.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LTBarcodeOptionsDelegate

@required
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *supportedSymbologies;

@optional
- (instancetype)copy LT_DEPRECATED_USENEW(19_0, "copyWithZone:");
- (void)copyTo:(NSObject*)options LT_DEPRECATED_USENEW(19_0, "copyWithZone:"); // 'options' parameter should be a class of type LTBarcodeOptions

@end


@interface LTBarcodeOptions : NSObject <LTBarcodeOptionsDelegate, NSCopying>

- (BOOL)isSupportedSymbology:(LTBarcodeSymbology)symbology;

@end

NS_ASSUME_NONNULL_END