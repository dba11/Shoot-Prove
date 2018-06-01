//
//  LTOcrZoneCell.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrZoneType.h"

typedef NS_ENUM(NSInteger, LTOcrCellBorderLineStyle) {
    LTOcrCellBorderLineStyleNone,
    LTOcrCellBorderLineStyleSolid,
    LTOcrCellBorderLineStyleDouble,
    LTOcrCellBorderLineStyleDashed,
    LTOcrCellBorderLineStyleDotted
};

typedef NS_ENUM(NSInteger, LTOcrBackgroundFillStyle) {
    LTOcrBackgroundFillStyleNone,
    LTOcrBackgroundFillStyleSolid,
    LTOcrBackgroundFillStyleHatch
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrZoneCell : NSObject <NSCopying>

@property (nonatomic, assign)                LeadRect bounds;

@property (nonatomic, assign)                LTOcrZoneType cellType;

@property (nonatomic, copy, null_resettable) LTRasterColor *backgroundColor;
@property (nonatomic, copy, null_resettable) LTRasterColor *leftBorderColor;
@property (nonatomic, copy, null_resettable) LTRasterColor *topBorderColor;
@property (nonatomic, copy, null_resettable) LTRasterColor *rightBorderColor;
@property (nonatomic, copy, null_resettable) LTRasterColor *bottomBorderColor;

@property (nonatomic, assign)                LTOcrCellBorderLineStyle leftBorderStyle;
@property (nonatomic, assign)                LTOcrCellBorderLineStyle topBorderStyle;
@property (nonatomic, assign)                LTOcrCellBorderLineStyle rightBorderStyle;
@property (nonatomic, assign)                LTOcrCellBorderLineStyle bottomBorderStyle;

@property (nonatomic, assign)                LTOcrBackgroundFillStyle backgroundFillStyle;

@property (nonatomic, assign)                CGFloat leftBorderWidth;
@property (nonatomic, assign)                CGFloat topBorderWidth;
@property (nonatomic, assign)                CGFloat rightBorderWidth;
@property (nonatomic, assign)                CGFloat bottomBorderWidth;

@end

NS_ASSUME_NONNULL_END