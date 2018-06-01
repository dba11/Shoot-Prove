//
//  LTCodecsPngOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsPngLoadOptions : NSObject

@property (nonatomic, strong, nullable) NSData *trnsChunk;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsPngSaveOptions : NSObject

@property (nonatomic, assign) NSInteger qualityFactor;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsPngOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsPngLoadOptions *load;
@property (nonatomic, strong, readonly) LTCodecsPngSaveOptions *save;

@end

NS_ASSUME_NONNULL_END