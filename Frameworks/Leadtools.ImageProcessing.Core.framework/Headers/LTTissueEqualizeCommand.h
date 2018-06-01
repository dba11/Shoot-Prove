//
//  LTTissueEqualizeCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTTissueEqualizeCommandFlags) {
    LTTissueEqualizeCommandFlagsUseSimplifyOption  = 0x00000001,
    LTTissueEqualizeCommandFlagsUseIntensifyOption = 0x00000002,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTTissueEqualizeCommand : LTRasterCommand

@property (nonatomic, assign) LTTissueEqualizeCommandFlags flags;

- (instancetype)initWithFlags:(LTTissueEqualizeCommandFlags)flags;

@end

NS_ASSUME_NONNULL_END