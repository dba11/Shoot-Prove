//
//  LTCodecsGifOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsGifLoadOptions : NSObject

@property (nonatomic, assign) NSUInteger animationLoop;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsGifSaveOptions : NSObject

@property (nonatomic, assign, getter=usesAnimationPalette)    BOOL useAnimationPalette;
@property (nonatomic, assign, getter=usesAnimationLoop)       BOOL useAnimationLoop;
@property (nonatomic, assign, getter=usesAnimationBackground) BOOL useAnimationBackground;

@property (nonatomic, strong, nullable) NSArray<LTRasterColor *> *animationPalette;

@property (nonatomic, assign)           BOOL interlaced;

@property (nonatomic, assign)           NSUInteger animationLoop;
@property (nonatomic, assign)           NSInteger animationWidth;

@property (nonatomic, assign)           NSInteger animationHeight;

@property (nonatomic, copy)             LTRasterColor *animationBackground;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsGifOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsGifLoadOptions *load;
@property (nonatomic, strong, readonly) LTCodecsGifSaveOptions *save;

@end

NS_ASSUME_NONNULL_END