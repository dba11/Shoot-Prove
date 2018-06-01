//
//  LTWatershedCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTWatershedCommand : LTRasterCommand

@property (nonatomic, strong) NSArray<NSArray<NSValue *> *> *pointsArray; //LeadPoint

- (instancetype)initWithPointsArray:(NSArray<NSArray<NSValue *> *> *)pointsArray /*LeadPoint*/ NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END