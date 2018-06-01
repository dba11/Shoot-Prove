//
//  LTObjectInformationCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTObjectInformationCommand : LTRasterCommand

@property (nonatomic, assign, readonly) LeadPoint centerOfMass;
@property (nonatomic, assign, readonly) NSInteger angle;
@property (nonatomic, assign, readonly) NSUInteger roundness;
@property (nonatomic, assign)           BOOL weighted;

- (instancetype)initWithWeighted:(BOOL)weighted NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END