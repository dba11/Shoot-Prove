//
//  LTSvgBounds.h
//  Leadtools.Svg
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTSvgBounds : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL isTrimmed;

@property (nonatomic, assign) LeadSizeD resolution;
@property (nonatomic, assign) LeadRectD bounds;

@end

NS_ASSUME_NONNULL_END