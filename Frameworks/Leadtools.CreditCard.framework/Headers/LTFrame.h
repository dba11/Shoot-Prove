//
//  LTFrame.h
//  Leadtools.CreditCard
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTFrame : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign)           NSInteger width;
@property (nonatomic, assign)           NSInteger height;

@property (nonatomic, assign)           LTFrameOrientation orientation;
@property (nonatomic, assign)           LTImageFormat imageFormat;

@property (nonatomic, assign, nullable) void *imageData;

@end

NS_ASSUME_NONNULL_END