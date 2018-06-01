//
//  LTRemapHueCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTRemapHueCommand : LTRasterCommand

@property (nonatomic, assign, nullable) const unsigned int *mask;
@property (nonatomic, assign, nullable) const unsigned int *hueTable;
@property (nonatomic, assign, nullable) const unsigned int *saturationTable;
@property (nonatomic, assign, nullable) const unsigned int *valueTable;
@property (nonatomic, assign) NSUInteger lookUpTableLength;

- (instancetype)initWithMask:(nullable const unsigned int *)mask hueTable:(nullable const unsigned int *)hueTable saturationTable:(nullable const unsigned int *)saturationTable valueTable:(nullable const unsigned int *)valueTable lookUpTableLength:(NSUInteger)lookUpTableLength NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END