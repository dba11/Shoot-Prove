//
//  LTGetBackgroundColorCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTGetBackgroundColorCommand : LTRasterCommand

@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *rectangles; //LeadRect
@property (nonatomic, strong, readonly) NSMutableArray<LTRasterColor *> *backgroundColors;

@end

NS_ASSUME_NONNULL_END