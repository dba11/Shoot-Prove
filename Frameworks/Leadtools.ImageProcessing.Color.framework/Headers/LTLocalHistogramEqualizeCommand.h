//
//  LTLocalHistogramEqualizeCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTLocalHistogramEqualizeCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger widthExtension;
@property (nonatomic, assign) NSInteger heightExtension;
@property (nonatomic, assign) NSUInteger smooth;
@property (nonatomic, assign) LTHistogramEqualizeType type;

- (instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height widthExtension:(NSInteger)widthExtension heightExtension:(NSInteger)heightExtension smooth:(NSUInteger)smooth type:(LTHistogramEqualizeType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END