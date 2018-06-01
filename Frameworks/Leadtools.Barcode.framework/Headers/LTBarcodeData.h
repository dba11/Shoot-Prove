//
//  LTBarcodeData.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTGlobalEnums.h"

NS_ASSUME_NONNULL_BEGIN

__deprecated_msg("Deprecated starting LEADTOOLS 19.0. Use 'copyWithZone' instead.")
@protocol LTBarcodeDataDelegate

@optional
- (instancetype)copy;
- (void)copyTo:(NSObject*)data; // 'data' parameter should be a class of type LTBarcodeData

@end



@interface LTBarcodeData : NSObject <NSCopying>

@property (nonatomic, assign)           LTBarcodeSymbology symbology;

@property (nonatomic, assign)           LeadRect bounds;
@property (nonatomic, assign)           LeadRectD rect;

@property (nonatomic, copy, nullable)   NSString *value;

@property (nonatomic, assign)           NSInteger rotationAngle;

@property (nonatomic, copy)             id tag;

@property (nonatomic, strong, nullable) NSData *data;



- (instancetype)initWithSymbology:(LTBarcodeSymbology)symbology data:(nullable NSData *)data NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSymbology:(LTBarcodeSymbology)symbology value:(nullable NSString *)value;

+ (nullable LTBarcodeData *)createDefaultBarcodeData:(LTBarcodeSymbology)symbology;
+ (Class)barcodeDataTypeForSymbology:(LTBarcodeSymbology)symbology;
+ (nullable NSString *)parseECIData:(NSData *)data error:(NSError **)error;

- (void)updateRect;
- (void)updateValue;

@end



@interface LTBarcodeData (Deprecated)

+ (Class)getBarcodeDataType:(LTBarcodeSymbology)symbology LT_DEPRECATED_USENEW(19_0, "barcodeDataTypeForSymbology:");

- (nullable NSData *)getData LT_DEPRECATED_USENEW(19_0, "data");

@end

NS_ASSUME_NONNULL_END