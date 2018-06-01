//
//  LTAutoCropRectangleCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTAutoCropRectangleCommand : LTRasterCommand

@property (nonatomic, assign)           NSUInteger threshold;
@property (nonatomic, assign, readonly) LeadRect rectangle;

- (id)initWithThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;

@end
