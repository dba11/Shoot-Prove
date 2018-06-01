//
//  LTCodecsJpegImageInfo.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsJpegImageInfo : NSObject

@property (nonatomic, assign, readonly) BOOL hasStamp;
@property (nonatomic, assign, readonly) BOOL isProgressive;
@property (nonatomic, assign, readonly) BOOL isLossless;

@end

NS_ASSUME_NONNULL_END