//
//  LTRasterRegion.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTLeadtoolsDefines.h"
#import "LTRasterRegionXForm.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Describes a region of interest in a LTRasterImage object.
 */
@interface LTRasterRegion : NSObject

/** @brief Checks if this LTRasterRegion has an empty interior. */
@property (nonatomic, assign, readonly, getter=isEmpty) BOOL empty;

/** @brief A LeadRect structure representing a rectangle that bounds this LTRasterRegion in pixels. */
@property (nonatomic, assign, readonly)                 LeadRect bounds;

/**
 @brief Overrides this LTRasterRegion to the specified LeadRect.
 
 @param rect The LeadRect describing the new bounds for this LTRasterRegion.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if the LeadRect overwrote this LTRasterRegion, otherwise NO.
 */
- (BOOL)setRect:(LeadRect)rect error:(NSError **)error;

/**
 @brief Initializes this LTRasterRegion to an empty interior.
 */
- (void)makeEmpty;

/**
 @brief Updates this LTRasterRegion to a combination of itself and the specified LeadRect.
 
 @param rect The LeadRect structure to combine with this LTRasterRegion.
 @param combineMode One of the LTRasterRegionCombineMode enumeration members that describes the combine method to use. This cannot be LTRasterRegionCombineModeAndNotImage or LTRasterRegionCombineModeAndNotRegion. Using any of these combine method will result in an exception.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if the LeadRect and LTRasterRegion combined successfully, otherwise NO.
 */
- (BOOL)combineWithRect:(LeadRect)rect combineMode:(LTRasterRegionCombineMode)combineMode error:(NSError **)error;

/**
 @brief Updates this LTRasterRegion to a combination of itself and the specified LTRasterRegion.
 
 @param region The LTRasterRegion to combine with this LTRasterRegion.
 @param combineMode One of the LTRasterRegionCombineMode enumeration members that describes the combine method to use. This cannot be LTRasterRegionCombineModeAndNotImage or LTRasterRegionCombineModeAndNotRegion. Using any of these combine method will result in an exception.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if the regions combined successfully, otherwise NO.
 */
- (BOOL)combineWithRegion:(LTRasterRegion *)region combineMode:(LTRasterRegionCombineMode)combineMode error:(NSError **)error;

/**
 @brief Tests whether the specified LeadPoint structure is contained within this LTRasterRegion.
 
 @param point The LeadPoint structure to test.
 
 @returns YES is the point is contained within this LTRasterRegion, otherwise NO.
 */
- (BOOL)isVisible:(LeadPoint)point;

/**
 @brief Trims this LTRasterRegion to fit inside a specified LeadRect.
 
 @param rect A LeadRect that defines the clipping boundaries.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if this LTRasterRegion was clipped successfully, otherwise NO.
 */
- (BOOL)clip:(LeadRect)rect error:(NSError **)error;

/**
 @brief Transforms this LTRasterRegion by the specified LTRasterRegionXForm.
 
 @param xform The LTRasterRegionXForm by which to transform this region.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if this LTRasterRegion was transformed successfully, otherwise NO.
 */
- (BOOL)transform:(LTRasterRegionXForm *)xform error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END