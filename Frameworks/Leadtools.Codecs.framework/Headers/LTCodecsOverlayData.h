//
//  LTCodecsOverlayData.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsOverlayData : NSObject

@property (nonatomic, assign, readonly) BOOL info;

@property (nonatomic, assign)           NSUInteger infoWidth;
@property (nonatomic, assign)           NSUInteger infoHeight;
@property (nonatomic, assign)           NSUInteger infoXResolution;
@property (nonatomic, assign)           NSUInteger infoYResolution;
@property (nonatomic, assign, readonly) NSUInteger pageNumber;

@property (nonatomic, strong, readonly) NSString *fileName;

@property (nonatomic, strong, nullable) LTRasterImage *image;

@end

typedef void (^LTCodecsOverlayCallback)(LTCodecsOverlayData *data);

NS_ASSUME_NONNULL_END