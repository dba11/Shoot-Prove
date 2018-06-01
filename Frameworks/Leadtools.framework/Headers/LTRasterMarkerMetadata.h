//
//  LTRasterMarketMetadata.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTRasterMetadata.h"

/** @brief A constant which represents the SOS marker */
extern const NSInteger LTRasterMarkerMetadataSos;

/** @brief A constant which represents the APP0 marker */
extern const NSInteger LTRasterMarkerMetadataApp0;

/** @brief A constant which represents the APP1 marker */
extern const NSInteger LTRasterMarkerMetadataApp1;

/** @brief A constant which represents the APP2 marker */
extern const NSInteger LTRasterMarkerMetadataApp2;

/** @brief A constant which represents the COM marker */
extern const NSInteger LTRasterMarkerMetadataCom;

/** @brief A constant which represents the RST0 marker */
extern const NSInteger LTRasterMarkerMetadataRst0;

/** @brief A constant which represents the RST7 marker */
extern const NSInteger LTRasterMarkerMetadataRst7;

/** @brief A constant which represents the SOI marker */
extern const NSInteger LTRasterMarkerMetadataSoi;

/** @brief A constant which represents the EOI marker */
extern const NSInteger LTRasterMarkerMetadataEoi;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Extends the LTRasterMetadata class to provide functionality for dealing with marker metadata stored within various image file formats.
 */
@interface LTRasterMarkerMetadata : LTRasterMetadata

/** @brief The marker id. */
@property (nonatomic, assign) NSInteger markerId;

/** @brief The marker data. */
@property (nonatomic, strong) NSData *data;


/**
 @brief Initializes a new LTRasterMarkerMetadata object with the specified values.
 
 @param markerId The marker id.
 @param data The data for the marker.
 
 @returns A LTRasterMarkerMetadata object initialized with the specified values.
 */
- (instancetype)initWithId:(NSInteger)markerId data:(NSData *)data NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END