//
//  LTCodecsRawOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsRawSaveOptions : NSObject

@property (nonatomic, assign) BOOL reverseBits;
@property (nonatomic, assign) BOOL pad4;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsRawOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsRawSaveOptions *save;

@end

NS_ASSUME_NONNULL_END