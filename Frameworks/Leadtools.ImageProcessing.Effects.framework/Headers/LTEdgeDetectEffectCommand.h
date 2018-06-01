//
//  LTEdgeDetectEffectCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTEdgeDetectEffectCommandType) {
    LTEdgeDetectEffectCommandTypeSolid  = 1,
    LTEdgeDetectEffectCommandTypeSmooth = 0
};

NS_ASSUME_NONNULL_BEGIN

@interface LTEdgeDetectEffectCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) NSInteger threshold;
@property (nonatomic, assign) LTEdgeDetectEffectCommandType type;

- (instancetype)initWithLevel:(NSUInteger)level threshold:(NSInteger)threshold type:(LTEdgeDetectEffectCommandType)type NS_DESIGNATED_INITIALIZER;


@end

NS_ASSUME_NONNULL_END