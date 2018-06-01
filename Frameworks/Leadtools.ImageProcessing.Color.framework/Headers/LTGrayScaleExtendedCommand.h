//
//  LTGrayScaleExtendedCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTGrayScaleExtendedCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger redFactor;
@property (nonatomic, assign) NSInteger greenFactor;
@property (nonatomic, assign) NSInteger blueFactor;

- (instancetype)initWithRedFactor:(NSInteger)redFactor greenFactor:(NSInteger)greenFactor blueFactor:(NSInteger)blueFactor NS_DESIGNATED_INITIALIZER;

@end
