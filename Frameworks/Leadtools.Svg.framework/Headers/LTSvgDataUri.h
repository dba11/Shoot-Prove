//
//  LTSvgDataUri.h
//  Leadtools.Svg
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTSvgDataUri : NSObject

@property (nonatomic, assign)         BOOL isDataUri;
@property (nonatomic, assign)         BOOL isBase64;

@property (nonatomic, assign)         NSUInteger mediaOffset;
@property (nonatomic, assign)         NSUInteger mediaLength;
@property (nonatomic, assign)         NSUInteger charSetOffset;
@property (nonatomic, assign)         NSUInteger charSetLength;
@property (nonatomic, assign)         NSUInteger valueOffset;
@property (nonatomic, assign)         NSUInteger valueLength;

@property (nonatomic, assign)         LTRasterImageFormat imageFormat;

@property (nonatomic, copy, nullable) NSString *hRef;
@property (nonatomic, copy, nullable) NSString *extension;

+ (nullable instancetype)parseHRef:(NSString *)hRef error:(NSError **)error;

+ (nullable NSString *)encodeFromData:(NSData *)data error:(NSError **)error;
+ (nullable NSString *)encodeFromFile:(NSString *)file error:(NSError **)error;

- (BOOL)decodeToData:(NSMutableData *)data error:(NSError **)error;
- (BOOL)decodeToFile:(NSString *)file error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END