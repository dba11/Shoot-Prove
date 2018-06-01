//
//  LTAnnBrush.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnBrush : NSObject <NSCoding, NSCopying>

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnSolidColorBrush : LTAnnBrush

@property (nonatomic, copy) NSString *color;

+ (instancetype)brushWithColor:(NSString *)color;
- (instancetype)initWithColor:(NSString *)color;

@end

NS_ASSUME_NONNULL_END