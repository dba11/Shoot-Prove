//
//  LTRasterColor16.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Describes a color consisting of 16-bit relative intensities of alpha, red, gree, and blue.
 */
@interface LTRasterColor16 : NSObject <NSCopying, NSCoding>

/** The red component of the color */
@property (nonatomic, assign) unsigned short r;

/** The green component of the color */
@property (nonatomic, assign) unsigned short g;

/** The blue component of the color */
@property (nonatomic, assign) unsigned short b;

/** The alpha component of the color */
@property (nonatomic, assign) unsigned short a;

/** For internal use by LEADTOOLS */
@property (nonatomic, assign) unsigned short reserved;

/**
 @brief Creates a LTRasterColor16 instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 @param alpha The alpha color component.
 
 @returns An initialized LTRasterColor16 instance.
 */
+ (instancetype)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

/**
 @brief Creates a LTRasterColor16 instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 
 @returns An initialized LTRasterColor16 instance.
 */
+ (instancetype)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 @brief Creates a LTRasterColor instance representing white.
 
 @returns An initialized LTRasterColor16 instance.
 */
+ (instancetype)white;

/**
 @brief Creates a LTRasterColor instance representing black.
 
 @returns An initialized LTRasterColor16 instance.
 */
+ (instancetype)black;

/**
 @brief Initializes a LTRasterColor16 instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 @param alpha The alpha color component.
 
 @returns An initialized LTRasterColor16 instance.
 */
- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha NS_DESIGNATED_INITIALIZER;

/**
 @brief Initializes a LTRasterColor16 instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 
 @returns An initialized LTRasterColor16 instance.
 */
- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

@end

NS_ASSUME_NONNULL_END
