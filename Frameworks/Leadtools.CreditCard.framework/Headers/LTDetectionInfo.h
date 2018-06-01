//
//  LTDetectionInfo.h
//  Leadtools.CreditCard
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTDetectionInfo : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign)           BOOL flipped;
@property (nonatomic, assign)           BOOL topEdgeFound;
@property (nonatomic, assign)           BOOL bottomEdgeFound;
@property (nonatomic, assign)           BOOL leftEdgeFound;
@property (nonatomic, assign)           BOOL rightEdgeFound;
@property (nonatomic, assign)           BOOL createCardImage;

@property (nonatomic, assign)           LTScanFrameStatus status;

@property (nonatomic, assign)           NSUInteger yOffset;
@property (nonatomic, assign)           NSUInteger expiryMonth;
@property (nonatomic, assign)           NSUInteger expiryYear;

@property (nonatomic, assign)           float focusScore;

@property (nonatomic, strong, nullable) NSArray<NSNumber *> *xOffsets; //NSUInteger
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *prediction; //NSUInteger

@property (nonatomic, strong, nullable) LTRasterImage *cardImage;

@end

NS_ASSUME_NONNULL_END