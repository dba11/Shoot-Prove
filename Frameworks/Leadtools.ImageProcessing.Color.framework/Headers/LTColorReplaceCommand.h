//
//  LTColorReplaceCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTColorReplaceCommandColor : NSObject

@property (nonatomic, copy) LTRasterColor *color;
@property (nonatomic, assign) NSUInteger fuzziness;

- (instancetype)initWithColor:(LTRasterColor *)color fuzziness:(NSUInteger)fuzziness NS_DESIGNATED_INITIALIZER;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTColorReplaceCommand : LTRasterCommand

- (instancetype)initWithColors:(NSArray<LTColorReplaceCommandColor *> *)colors hue:(NSInteger)hue saturation:(NSInteger)saturation brightness:(NSInteger)brightness NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSMutableArray<LTColorReplaceCommandColor *> *colors;

@property (nonatomic, assign) NSInteger hue;
@property (nonatomic, assign) NSInteger saturation;
@property (nonatomic, assign) NSInteger brightness;

@end

NS_ASSUME_NONNULL_END