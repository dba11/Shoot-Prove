//
//  LTDicomLookupTableDescriptor.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTDicomLookupTableDescriptor : NSObject

- (instancetype)initWithFirstStoredPixelValueMapped:(NSInteger)firstStoredPixelValueMapped entryBits:(NSUInteger)entryBits NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign) NSInteger firstStoredPixelValueMapped;
@property (nonatomic, assign) NSUInteger entryBits;

@end

NS_ASSUME_NONNULL_END