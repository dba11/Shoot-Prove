//
//  LTChangeHueSaturationIntensityCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTChangeHueSaturationIntensityCommandData : NSObject

@property (nonatomic, assign) NSInteger hue;
@property (nonatomic, assign) NSInteger saturation;
@property (nonatomic, assign) NSInteger intensity;
@property (nonatomic, assign) NSInteger outerLow;
@property (nonatomic, assign) NSInteger outerHigh;
@property (nonatomic, assign) NSInteger innerLow;
@property (nonatomic, assign) NSInteger innerHigh;

- (instancetype)initWithHue:(NSInteger)hue saturation:(NSInteger)saturation intensity:(NSInteger)intensity outerLow:(NSInteger)outerLow outerHigh:(NSInteger)outerHigh innerLow:(NSInteger)innerLow innerHigh:(NSInteger)innerHigh NS_DESIGNATED_INITIALIZER;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTChangeHueSaturationIntensityCommand : LTRasterCommand

- (instancetype)initWithHue:(NSInteger)hue saturation:(NSInteger)saturation intensity:(NSInteger)intensity data:(NSArray<LTChangeHueSaturationIntensityCommandData *> *)data NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign) NSInteger hue;
@property (nonatomic, assign) NSInteger saturation;
@property (nonatomic, assign) NSInteger intensity;

@property (nonatomic, strong) NSMutableArray<LTChangeHueSaturationIntensityCommandData *> *data;

@end

NS_ASSUME_NONNULL_END