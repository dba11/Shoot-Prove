//
//  LTRasterColor.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/** 
 @brief Describes a color consisting of 8-bit relative intensities of alpha, red, gree, and blue.
 */
@interface LTRasterColor : NSObject <NSCopying, NSCoding>

/** The red component of the color */
@property (nonatomic, assign) unsigned char r;

/** The green component of the color */
@property (nonatomic, assign) unsigned char g;

/** The blue component of the color */
@property (nonatomic, assign) unsigned char b;

/** The alpha component of the color */
@property (nonatomic, assign) unsigned char a;

/** For internal use by LEADTOOLS */
@property (nonatomic, assign) unsigned char reserved;

/** 
 @brief Creates a LTRasterColor instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 @param alpha The alpha color component.
 
 @returns An initialized LTRasterColor instance.
 */
+ (instancetype)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

/**
 @brief Creates a LTRasterColor instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 
 @returns An initialized LTRasterColor instance.
 */
+ (instancetype)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 @brief Creates a LTRasterColor instance representing white.
 
 @returns An initialized LTRasterColor instance.
 */
+ (instancetype)white;

/**
 @brief Creates a LTRasterColor instance representing black.
 
 @returns An initialized LTRasterColor instance.
 */
+ (instancetype)black;

/**
 @brief Initializes a LTRasterColor instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 @param alpha The alpha color component.
 
 @returns An initialized LTRasterColor instance.
 */
- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha NS_DESIGNATED_INITIALIZER;

/**
 @brief Initializes a LTRasterColor instance with explicit color components.
 
 @param red The red color component.
 @param green The green color component.
 @param blue The blue color component.
 
 @returns An initialized LTRasterColor instance.
 */
- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

@end



@interface LTRasterColor (LTRasterColorConversions)

/** Creates an UIColor instance using the current values for this instance */
@property (nonatomic, copy, readonly)   UIColor *UIColor;

/** Returns the associated CGColorRef for the UIColor property */
@property (nonatomic, assign, readonly) CGColorRef CGColor;

@end



@interface UIColor (UIColorConversions)

/** Creates a LTRasterColor instance using the current values for this instance */
@property (nonatomic, copy, readonly) LTRasterColor *LTRasterColor;

@end

NS_ASSUME_NONNULL_END
