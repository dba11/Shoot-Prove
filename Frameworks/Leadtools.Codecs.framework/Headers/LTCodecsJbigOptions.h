//
//  LTCodecsJbigOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsJbigLoadOptions : NSObject

@property (nonatomic, assign) LeadSize resolution;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsJbigOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsJbigLoadOptions *load;

@end

NS_ASSUME_NONNULL_END