//
//  LTRasterMetadata.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

/**
 @typedef LTRasterMetadataRational
 
 @brief Encapsulates a rational value, for use with classes derived from LTRasterMetadata.
 */
typedef struct LTRasterMetadataRational {
    NSInteger numerator;
    NSInteger denominator;
} LTRasterMetadataRational;

/**
 @typedef LTRasterMetadataURational
 
 @brief Encapsulates an unsigned rational value, for use with classes derived from LTRasterMetadata.
 */
typedef struct LTRasterMetadataURational {
    NSUInteger numerator;
    NSUInteger denominator;
} LTRasterMetadataURational;

/**
 @brief Provides base functionality for dealing with metadata stored in various image file formats.
 */
@interface LTRasterMetadata : NSObject <NSCopying, NSCoding>

@end
