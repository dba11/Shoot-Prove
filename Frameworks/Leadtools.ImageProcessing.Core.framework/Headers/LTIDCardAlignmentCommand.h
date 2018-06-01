//
//  LTIDCardAlignmentCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTIDCardAlignmentCommand : LTRasterCommand

@property (nonatomic, assign, readonly) BOOL isLeftAligned;
@property (nonatomic, assign, readonly) BOOL isTopAligned;
@property (nonatomic, assign, readonly) BOOL isRightAligned;
@property (nonatomic, assign, readonly) BOOL isBottomAligned;

@property (nonatomic, assign)           LeadRect rect;

- (instancetype)initWithRectangle:(LeadRect)rect NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END