//
//  LTLambdaConnectednessCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTLambdaConnectednessCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger lambda;

- (instancetype)initWithLambda:(NSInteger)lambda NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END