//
//  LTSvgElementInfo.h
//  Leadtools.Svg
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTSvgTextData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSvgElementInfo : NSObject

@property (nonatomic, assign)           LTSvgElementType elementType;

@property (nonatomic, assign)           LeadRectD bounds;

@property (nonatomic, strong, nullable) LTSvgTextData *textData;

@end

NS_ASSUME_NONNULL_END