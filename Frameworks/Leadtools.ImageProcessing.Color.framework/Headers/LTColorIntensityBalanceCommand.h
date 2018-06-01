//
//  LTColorIntensityBalanceCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTColorIntensityBalanceCommandData : NSObject

@property (nonatomic, assign) NSInteger red;
@property (nonatomic, assign) NSInteger green;
@property (nonatomic, assign) NSInteger blue;

- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue NS_DESIGNATED_INITIALIZER;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTColorIntensityBalanceCommand : LTRasterCommand

- (instancetype)initWithShadows:(LTColorIntensityBalanceCommandData *)shadows midTone:(LTColorIntensityBalanceCommandData *)midTone highLight:(LTColorIntensityBalanceCommandData *)highlight luminance:(BOOL)luminance NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign) BOOL luminance;
@property (nonatomic, strong) LTColorIntensityBalanceCommandData *shadows;
@property (nonatomic, strong) LTColorIntensityBalanceCommandData *midTone;
@property (nonatomic, strong) LTColorIntensityBalanceCommandData *highlight;

@end

NS_ASSUME_NONNULL_END