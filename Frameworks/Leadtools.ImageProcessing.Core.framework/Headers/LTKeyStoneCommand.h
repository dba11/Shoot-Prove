//
//  LTKeyStoneCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTKeyStoneCommand : LTRasterCommand

@property (nonatomic, strong, nullable) LTRasterImage *transformedImage;
@property (nonatomic, strong, nullable) NSArray<NSValue *> *polygonPoints; //LeadPoint

- (instancetype)initWithPolygonPoints:(NSArray<NSValue *> *)polygonPoints /*LeadPoint*/ NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END