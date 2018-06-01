//
//  LTMinMaxBitsCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTMinMaxBitsCommand : LTRasterCommand

@property (nonatomic, assign, readonly) NSInteger minimumBit;
@property (nonatomic, assign, readonly) NSInteger maximumBit;

@end
