//
//  LTLevelsetCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTLevelsetCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger lambdaIn;
@property (nonatomic, assign) NSInteger lambdaOut;

- (instancetype)initWithLambdaIn:(NSInteger)lambdaIn lambdaOut:(NSInteger)lambdaOut NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END