//
//  LTRasterRegionXForm.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTLeadtoolsDefines.h"

/**
 Provides data for translating between region coordinates and external representations of those coordinates.
 */
@interface LTRasterRegionXForm : NSObject

/** @brief The view perspective of the external representation */
@property (nonatomic, assign) LTRasterViewPerspective viewPerspective;

/** @brief The numerator for the X scaling factor. */
@property (nonatomic, assign) NSInteger xScalarNumerator;

/** @brief The denominator for the X scaling factor. */
@property (nonatomic, assign) NSInteger xScalarDenominator;

/** @brief The numerator for the Y scaling factor. */
@property (nonatomic, assign) NSInteger yScalarNumerator;

/** @brief The denominator for the Y scaling factor. */
@property (nonatomic, assign) NSInteger yScalarDenominator;

/** @brief The X offset of the external representation. */
@property (nonatomic, assign) NSInteger xOffset;

/** @brief The Y offset of the external representation. */
@property (nonatomic, assign) NSInteger yOffset;

@end
