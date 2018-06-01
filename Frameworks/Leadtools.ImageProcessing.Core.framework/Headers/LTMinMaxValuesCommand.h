//
//  LTMinMaxValuesCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTMinMaxValuesCommand : LTRasterCommand

@property (nonatomic, assign, readonly) NSInteger minimumValue;
@property (nonatomic, assign, readonly) NSInteger maximumValue;

@end
