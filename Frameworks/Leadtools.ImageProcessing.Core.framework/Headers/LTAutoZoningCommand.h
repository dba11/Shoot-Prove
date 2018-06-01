//
//  LTAutoZoningCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTLeadZoneType) {
    LTLeadZoneTypeText    = 0,
    LTLeadZoneTypeGraphic = 1,
    LTLeadZoneTypeTable   = 2,
};

typedef NS_ENUM(NSInteger, LTDitheringType) {
    LTDitheringTypeUndithered  = 0,
    LTDitheringTypeTextDither  = 1,
    LTDitheringTypeWhiteDither = 2
};

typedef NS_ENUM(NSInteger, LTDotMatrixType) {
    LTDotMatrixTypeDotMatrix = 0,
    LTDotMatrixTypeNone = 1,
};

typedef NS_OPTIONS(NSUInteger, LTAutoZoningOptions) {
    LTAutoZoningOptionsNone                          = 0,
    LTAutoZoningOptionsDetectText                    = 0x00001,
    LTAutoZoningOptionsDetectGraphics                = 0x00002,
    LTAutoZoningOptionsDetectTable                   = 0x00004,
    LTAutoZoningOptionsDetectAll                     = 0x00007,
    LTAutoZoningOptionsAllowOverlap                  = 0x00010,
    LTAutoZoningOptionsDontAllowOverlap              = 0x00000,
    LTAutoZoningOptionsDetectAccurateZones           = 0x00000,
    LTAutoZoningOptionsDetectGeneralZones            = 0x00100,
    LTAutoZoningOptionsDontRecognizeOneCellTable     = 0x00000,
    LTAutoZoningOptionsRecognizeOneCellTable         = 0x01000,
    LTAutoZoningOptionsUseMultiThreading             = 0x00000000,
    LTAutoZoningOptionsDontUseMultiThreading         = 0x80000000,
    LTAutoZoningOptionsUseNormalTableDetection       = 0x00000,
    LTAutoZoningOptionsUseAdvancedTableDetection     = 0x02000,
    LTAutoZoningOptionsUseTextDetectionVersion       = 0x08000,
    LTAutoZoningOptionsUseLinesReconstruction        = 0x04000,
    LTAutoZoningOptionsAsianAutoZone                 = 0x00200,
    LTAutoZoningOptionsDetectCheckbox                = 0x10000,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTLeadZoneTableData : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *cellTypes;
@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *cells; //LeadRect
@property (nonatomic, strong, readonly) NSMutableArray<NSArray<NSValue *> *> *insideCells; //LeadRect
@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *boundsToDraw; //LeadRect
@property (nonatomic, assign)           NSUInteger columns;
@property (nonatomic, assign)           NSUInteger rows;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTLeadZoneTextData : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *textLines; //LeadRect

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTLeadZone : NSObject

@property (nonatomic, assign) LTLeadZoneType type;
@property (nonatomic, assign) LeadRect bounds;
@property (nonatomic, strong) LTLeadZoneTableData *tableData;
@property (nonatomic, strong) LTLeadZoneTextData *textData;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAutoZoningCommand : LTRasterCommand

@property (nonatomic, assign, readonly)           LTDitheringType ditherType;
@property (nonatomic, assign, readonly)           LTDotMatrixType dotMatrix;
@property (nonatomic, strong, readonly)           NSMutableArray<LTLeadZone *> *zones;
@property (nonatomic, assign)                     LTAutoZoningOptions options;
@property (nonatomic, strong, readonly, nullable) LTRasterImage *tableImage;

@property (nonatomic, assign, readonly, nullable) LeadRect *underlines;
@property (nonatomic, assign, readonly, nullable) LeadRect *checkboxes;
@property (nonatomic, assign, readonly, nullable) LeadRect *strikelines;

@property (nonatomic, assign, readonly)           NSUInteger underlinesCount;
@property (nonatomic, assign, readonly)           NSUInteger checkboxesCount;
@property (nonatomic, assign, readonly)           NSUInteger strikelinesCount;

- (instancetype)initWithOptions:(LTAutoZoningOptions)options NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END