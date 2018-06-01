//
//  LTAnnResources.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnResources : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *images;
@property (nonatomic, strong, readonly) NSMutableDictionary *rubberStamps;

@end

NS_ASSUME_NONNULL_END