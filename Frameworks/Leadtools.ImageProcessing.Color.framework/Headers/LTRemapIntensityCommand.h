//
//  LTRemapIntensityCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTRemapIntensityCommandFlags) {
    LTRemapIntensityCommandFlagsMaster        = 0x0000,
    LTRemapIntensityCommandFlagsRed           = 0x0001,
    LTRemapIntensityCommandFlagsGreen         = 0x0002,
    LTRemapIntensityCommandFlagsBlue          = 0x0003,
    LTRemapIntensityCommandFlagsChangeHighBit = 0x0010,
    LTRemapIntensityCommandFlagsNormal        = 0x0100,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTRemapIntensityCommand : LTRasterCommand

@property (nonatomic, assign)           LTRemapIntensityCommandFlags flags;
@property (nonatomic, assign, nullable) const int *lookUpTable;
@property (nonatomic, assign)           NSUInteger lookUpTableLength;

- (instancetype)initWithFlags:(LTRemapIntensityCommandFlags)flags lookUpTable:(const int *)lookUpTable lookUpTableLength:(NSUInteger)lookUpTableLength NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END