//
//  LTAnnThickness.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnThickness : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign) double left;
@property (nonatomic, assign) double top;
@property (nonatomic, assign) double right;
@property (nonatomic, assign) double bottom;

- (instancetype)initWithLeft:(double)left top:(double)top right:(double)right bottom:(double)bottom NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END