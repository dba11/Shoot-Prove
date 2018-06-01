//
//  LTScrambleCommand.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterCommand.h"

typedef NS_OPTIONS(NSUInteger, LTScrambleCommandFlags) {
    LTScrambleCommandFlagsNone        = 0,
    LTScrambleCommandFlagsEncrypt     = 0x0001,
    LTScrambleCommandFlagsDecrypt     = 0x0002,
    LTScrambleCommandFlagsIntersect   = 0x0004,
    LTScrambleCommandFlagsReserved3   = 0x0008,
    LTScrambleCommandFlagsReserved4   = 0x0010,
    LTScrambleCommandFlagsReserved5   = 0x0020,
    LTScrambleCommandFlagsReserved6   = 0x0040,
    LTScrambleCommandFlagsReserved7   = 0x0080,
    LTScrambleCommandFlagsReserved8   = 0x0100,
    LTScrambleCommandFlagsReserved9   = 0x0200
};

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Scrambles all or a portion of an image.
 */
@interface LTScrambleCommand : LTRasterCommand

/** @brief The rectangle which describes the area to scramble. */
@property (nonatomic, assign) LeadRect rectangle;

/** @brief The key that determines the scramble. */
@property (nonatomic, assign) unsigned int key;

/** @brief The flags that determine whether to encrypt or decrypt the area. */
@property (nonatomic, assign) LTScrambleCommandFlags flags;


/**
 @brief Initializes a new LTScrambleCommand with explicit parameters.
 
 @param rect The rectangle which describes the area to scramble.
 @param key The key that determines the scramble.
 @param flags The flags that determine whether to encrypt or decrypt the area.
 
 @returns A LTScrambleCommand object initialized with specific values.
 */
- (instancetype)initWithRectangle:(LeadRect)rect key:(unsigned int)key flags:(LTScrambleCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END