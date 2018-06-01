//
//  LTSvgNodeHandle.h
//  Leadtools.Svg
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSvgNodeHandle : NSObject

@property (nonatomic, assign)                           LTSvgElementType elementType;

@property (nonatomic, assign, readonly)                 LeadRectD bounds;

- (instancetype)init; //This should not be called directly

- (nullable NSString *)elementName:(NSError **)error;

- (nullable NSString *)elementValue:(NSError **)error;
- (BOOL)setElementValue:(NSString *)value;

- (nullable NSString *)valueOfAttribute:(NSString *)attribute error:(NSError **)error;
- (BOOL)setValue:(NSString *)value forAttribute:(NSString *)attribute error:(NSError **)error;
- (BOOL)removeElementAttribute:(NSString *)attribute error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END