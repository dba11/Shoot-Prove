//
//  LTCodecsTiffImageInfo.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsTiffImageInfo : NSObject

@property (nonatomic, assign, readonly) BOOL isBigTiff;
@property (nonatomic, assign, readonly) BOOL hasNoPalette;
@property (nonatomic, assign, readonly) BOOL isImageFileDirectoryOffsetValid;

@property (nonatomic, assign, readonly) unsigned long imageFileDirectoryOffset;

@end

NS_ASSUME_NONNULL_END