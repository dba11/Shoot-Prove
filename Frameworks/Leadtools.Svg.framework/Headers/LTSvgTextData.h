//
//  LTSvgTextData.h
//  Leadtools.Svg
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSvgTextData : NSObject

@property (nonatomic, copy, nullable)           NSString *text;

@property (nonatomic, strong, null_unspecified) NSArray<NSValue *> *bounds; //LeadRectD

@property (nonatomic, strong, null_unspecified) NSArray<NSNumber *> *characterFlags; //LTSvgTextCharacterFlags
@property (nonatomic, strong, null_unspecified) NSArray<NSNumber *> *directions; //LTSvgCharacterDirection

@end

NS_ASSUME_NONNULL_END