//
//  LTCodecsGifImageInfo.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsGifImageInfo : NSObject

@property (nonatomic, assign, readonly)           BOOL hasAnimationLoop;
@property (nonatomic, assign, readonly)           BOOL hasAnimationPalette;
@property (nonatomic, assign, readonly)           BOOL hasAnimationBackground;
@property (nonatomic, assign, readonly)           BOOL isInterlaced;

@property (nonatomic, assign, readonly)           NSInteger animationWidth;
@property (nonatomic, assign, readonly)           NSInteger animationHeight;

@property (nonatomic, assign, readonly)           NSUInteger animationLoop;

@property (nonatomic, copy, readonly)             LTRasterColor *animationBackground;
@property (nonatomic, strong, readonly, nullable) NSArray<LTRasterColor *> *animationPalette;

@end

NS_ASSUME_NONNULL_END