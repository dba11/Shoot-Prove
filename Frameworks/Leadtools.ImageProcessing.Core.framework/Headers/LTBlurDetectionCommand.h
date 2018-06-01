//
//  LTBlurDetectionCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTBlurDetectionCommand : LTRasterCommand

@property (nonatomic, assign, readonly) BOOL blurred;
@property (nonatomic, assign, readonly) double blurExtent;

@end
