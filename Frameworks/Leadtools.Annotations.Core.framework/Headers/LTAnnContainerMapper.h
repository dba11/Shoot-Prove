//
//  LTAnnContainerMapper.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"
#import "LTLeadPointCollection.h"
#import "LTAnnFont.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnContainerMapper : NSObject <NSCopying>

@property (nonatomic, assign, readonly) double calibrationScale;
@property (nonatomic, assign, readonly) double sourceDpiX;
@property (nonatomic, assign, readonly) double sourceDpiY;
@property (nonatomic, assign, readonly) double targetDpiX;
@property (nonatomic, assign, readonly) double targetDpiY;

@property (nonatomic, assign)           LeadMatrix transform;

@property (nonatomic, assign)           double deviceDpiX;
@property (nonatomic, assign)           double deviceDpiY;

@property (nonatomic, assign)           BOOL burnFontDpi;
@property (nonatomic, assign)           BOOL fontRelativeToDevice;

@property (nonatomic, assign)           LeadPointD offset;

+ (instancetype)createDefault;

- (double)normalizeRectangleWithRect:(LeadRectD *)rect operation:(LTAnnFixedStateOperations)operation;
- (double)lengthFromContainerCoordinates:(LeadLengthD)length operation:(LTAnnFixedStateOperations)operation;
- (double)getHitTestBuffer:(double)hitTestBuffer;

- (LeadSizeD)sizeToContainerCoordinates:(LeadSizeD)size;
- (LeadSizeD)sizeFromContainerCoordinates:(LeadSizeD)size;
- (LeadLengthD)lengthToContainerCoordinates:(double)length;
- (LeadPointD)pointToContainerCoordinates:(LeadPointD)point;
- (LeadPointD)pointFromContainerCoordinates:(LeadPointD)point operation:(LTAnnFixedStateOperations)operation;
- (LeadRectD)rectFromContainerCoordinates:(LeadRectD)rect operation:(LTAnnFixedStateOperations)operation;
- (LeadRectD)rectToContainerCoordinates:(LeadRectD)rect transform:(nullable LeadMatrix *)transform;

- (void)calibrateSourceLength:(double)srcLen sourceUnit:(LTAnnUnit)srcUnit destinationLength:(double)dstLen destinationUnit:(LTAnnUnit)dstUnit;
- (void)updateTransForm:(LeadMatrix)transform;
- (void)mapResolutionsSourceDpiX:(double)xSourceDpi sourceDpiY:(double)ySourceDpi targetDpiX:(double)xTargetDpi targetDpiY:(double)yTargetDpi;
- (void)updateDestinationRectangle:(LeadRectD)dstRect sourceSize:(LeadSizeD)srcSize;

- (LTLeadPointCollection *)pointsFromContainerCoordinates:(LTLeadPointCollection *)points operation:(LTAnnFixedStateOperations)operation;

- (LTAnnFont *)fontToContainerCoordinates:(LTAnnFont *)annFont;
- (LTAnnFont *)fontFromContainerCoordinates:(LTAnnFont *)annFont operation:(LTAnnFixedStateOperations)operation;

- (LTAnnStroke *)strokeFromContainerCoordinates:(LTAnnStroke *)stroke operation:(LTAnnFixedStateOperations)operation;

- (instancetype)initWithSourceDpiX:(double)xSourceDpi sourceDpiY:(double)ySourceDpi targetDpiX:(double)xTargetDpi targetDpiY:(double)yTargetDpi;

@end

NS_ASSUME_NONNULL_END