//
//  LTGetLinearVoiLookupTableCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTGetLinearVoiLookupTableCommandFlags) {
    LTGetLinearVoiLookupTableCommandFlagsNone   = 0x0000,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTGetLinearVoiLookupTableCommand : LTRasterCommand

@property (nonatomic, assign, readonly) double center;
@property (nonatomic, assign, readonly) double width;
@property (nonatomic, assign)           LTGetLinearVoiLookupTableCommandFlags flags;

- (instancetype)initWithFlags:(LTGetLinearVoiLookupTableCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END