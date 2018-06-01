//
//  LTApplyLinearVoiLookupTableCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTApplyLinearVoiLookupTableCommand : LTRasterCommand

@property (nonatomic, assign) double center;
@property (nonatomic, assign) double width;
@property (nonatomic, assign) LTVoiLookupTableCommandFlags flags;

- (instancetype)initWithCenter:(double)center width:(double)width flags:(LTVoiLookupTableCommandFlags)flags;

@end

NS_ASSUME_NONNULL_END