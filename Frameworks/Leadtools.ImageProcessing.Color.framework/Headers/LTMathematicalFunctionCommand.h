//
//  LTMathematicalFunctionCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTMathematicalFunctionCommandType) {
    LTMathematicalFunctionCommandTypeSquare     = 0x0000,
    LTMathematicalFunctionCommandTypeLogarithm  = 0x0001,
    LTMathematicalFunctionCommandTypeSquareRoot = 0x0002,
    LTMathematicalFunctionCommandTypeSine       = 0x0003,
    LTMathematicalFunctionCommandTypeCosine     = 0x0004
};

@interface LTMathematicalFunctionCommand : LTRasterCommand

@property (nonatomic, assign) LTMathematicalFunctionCommandType type;
@property (nonatomic, assign) NSUInteger factor;

- (instancetype)initWithType:(LTMathematicalFunctionCommandType)type factor:(NSUInteger)factor NS_DESIGNATED_INITIALIZER;

@end
