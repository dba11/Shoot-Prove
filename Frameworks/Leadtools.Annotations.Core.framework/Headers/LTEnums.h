//
//  LTEnums.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTAnnHitTestBehavior) {
   LTAnnHitTestBehaviorIntersects   = 0,
   LTAnnHitTestBehaviorContains     = 1,
};

typedef NS_ENUM(NSInteger, LTAnnUserMode) {
   LTAnnUserModeDesign  = 0,
   LTAnnUserModeRun     = 1,
};

typedef NS_ENUM(NSInteger, LTAnnFixedStateOperations) {
   LTAnnFixedStateOperationsNone          = 0,
   LTAnnFixedStateOperationsScrolling     = 1,
   LTAnnFixedStateOperationsZooming       = 2,
   LTAnnFixedStateOperationsFontSize      = 4,
   LTAnnFixedStateOperationsStrokeWidth   = 8,
   LTAnnFixedStateOperationsLengthValue   = 16,
};

typedef NS_ENUM(NSInteger, LTAnnNotifyCollectionChangedAction) {
   LTAnnNotifyCollectionChangedActionAdd     = 0,
   LTAnnNotifyCollectionChangedActionRemove  = 1,
   LTAnnNotifyCollectionChangedActionReplace = 2,
   LTAnnNotifyCollectionChangedActionMove    = 3,
   LTAnnNotifyCollectionChangedActionReset   = 4,
};

typedef NS_ENUM(NSInteger, LTAnnFontWeight) {
   LTAnnFontWeightNormal      = 0,
   LTAnnFontWeightThin        = 1,
   LTAnnFontWeightExtraLight  = 2,
   LTAnnFontWeightLight       = 3,
   LTAnnFontWeightMedium      = 4,
   LTAnnFontWeightSemiBold    = 5,
   LTAnnFontWeightBold        = 6,
   LTAnnFontWeightExtraBold   = 7,
   LTAnnFontWeightBlack       = 8,
   LTAnnFontWeightExtraBlack  = 9,
};

typedef NS_ENUM(NSInteger, LTAnnFontStyle) {
   LTAnnFontStyleNormal    = 0,
   LTAnnFontStyleItalic    = 1,
   LTAnnFontStyleOblique   = 2,
};

typedef NS_ENUM(NSInteger, LTAnnFontStretch) {
   LTAnnFontStretchNormal           = 0,
   LTAnnFontStretchUltraCondensed   = 1,
   LTAnnFontStretchExtraCondensed   = 2,
   LTAnnFontStretchCondensed        = 3,
   LTAnnFontStretchSemiCondensed    = 4,
   LTAnnFontStretchSemiExpanded     = 5,
   LTAnnFontStretchExpanded         = 6,
   LTAnnFontStretchExtraExpanded    = 7,
   LTAnnFontStretchUltraExpanded    = 8,
};

typedef NS_ENUM(NSInteger, LTAnnMouseButtons) {
   LTAnnMouseButtonsNone   = 0,
   LTAnnMouseButtonsLeft   = 1,
   LTAnnMouseButtonsRight  = 2,
   LTAnnMouseButtonsMiddle = 3,
};

typedef NS_ENUM(NSInteger, LTAnnUnit) {
   LTAnnUnitUnit           = 0,
   LTAnnUnitDisplay        = 1,
   LTAnnUnitDocument       = 2,
   LTAnnUnitSmartEnglish   = 3,
   LTAnnUnitSmartMetric    = 4,
   LTAnnUnitInch           = 5,
   LTAnnUnitMillimeter     = 6,
   LTAnnUnitPoint          = 7,
   LTAnnUnitFeet           = 8,
   LTAnnUnitYard           = 9,
   LTAnnUnitMicrometer     = 10,
   LTAnnUnitCentimeter     = 11,
   LTAnnUnitMeter          = 12,
   LTAnnUnitTwip           = 13,
   LTAnnUnitPixel          = 14,
};

typedef NS_ENUM(NSInteger, LTAnnDesignerOperationStatus) {
   LTAnnDesignerOperationStatusIdle      = 0,
   LTAnnDesignerOperationStatusStart     = 1,
   LTAnnDesignerOperationStatusWorking   = 2,
   LTAnnDesignerOperationStatusEnd       = 3,
   LTAnnDesignerOperationStatusCanceled  = 4
};

typedef NS_ENUM(NSInteger, LTAnnEditDesignerOperation) {
   LTAnnEditDesignerOperationNone                     = 0,
   LTAnnEditDesignerOperationMoveThumb                = 1,
   LTAnnEditDesignerOperationMove                     = 2,
   LTAnnEditDesignerOperationMoveName                 = 3,
   LTAnnEditDesignerOperationRotate                   = 4,
   LTAnnEditDesignerOperationMoveRotateCenterThumb    = 5,
   LTAnnEditDesignerOperationMoveRotateGripperThumb   = 6,
};

typedef NS_ENUM(NSInteger, LTAnnAngularUnit) {
   LTAnnAngularUnitRadian = 0,
   LTAnnAngularUnitDegree = 1
};

typedef NS_ENUM(NSInteger, LTAnnFillRule) {
   LTAnnFillRuleEvenOdd = 0,
   LTAnnFillRuleNonzero = 1,
};

typedef NS_ENUM(NSInteger, LTAnnTextRotate) {
   LTAnnTextRotateRotate0     = 0,
   LTAnnTextRotateRotate90    = 1,
   LTAnnTextRotateRotate180   = 2,
   LTAnnTextRotateRotate270   = 3,
};

typedef NS_ENUM(NSInteger, LTAnnHorizontalAlignment) {
   LTAnnHorizontalAlignmentLeft     = 0,
   LTAnnHorizontalAlignmentCenter   = 1,
   LTAnnHorizontalAlignmentRight    = 2,
};

typedef NS_ENUM(NSInteger, LTAnnVerticalAlignment) {
   LTAnnVerticalAlignmentTop     = 0,
   LTAnnVerticalAlignmentCenter  = 1,
   LTAnnVerticalAlignmentBottom  = 2,
};

typedef NS_ENUM(NSInteger, LTAnnStrokeLineCap) {
   LTAnnStrokeLineCapFlat     = 0,
   LTAnnStrokeLineCapSquare   = 1,
   LTAnnStrokeLineCapRound    = 2,
   LTAnnStrokeLineCapTriangle = 3,
};

typedef NS_ENUM(NSInteger, LTAnnStrokeLineJoin) {
   LTAnnStrokeLineJoinMiter         = 0,
   LTAnnStrokeLineJoinBevel         = 1,
   LTAnnStrokeLineJoinRound         = 2,
   LTAnnStrokeLineJoinMiterClipped  = 3,
};

typedef NS_ENUM(NSInteger, LTAnnTransparentMode) {
   LTAnnTransparentModeNone         = 0,
   LTAnnTransparentModeUseColor     = 1,
   LTAnnTransparentModeTopLeftPixel = 2,
};

typedef NS_ENUM(NSInteger, LTAnnRubberStampType) {
   LTAnnRubberStampTypeStampApproved   = 0,
   LTAnnRubberStampTypeStampAssigned   = 1,
   LTAnnRubberStampTypeStampChecked    = 2,
   LTAnnRubberStampTypeStampClient     = 3,
   LTAnnRubberStampTypeStampCopy       = 4,
   LTAnnRubberStampTypeStampDraft      = 5,
   LTAnnRubberStampTypeStampExtended   = 6,
   LTAnnRubberStampTypeStampFax        = 7,
   LTAnnRubberStampTypeStampFaxed      = 8,
   LTAnnRubberStampTypeStampImportant  = 9,
   LTAnnRubberStampTypeStampInvoice    = 10,
   LTAnnRubberStampTypeStampNotice     = 11,
   LTAnnRubberStampTypeStampOfficial   = 12,
   LTAnnRubberStampTypeStampOnFile     = 13,
   LTAnnRubberStampTypeStampPaid       = 14,
   LTAnnRubberStampTypeStampPassed     = 15,
   LTAnnRubberStampTypeStampPending    = 16,
   LTAnnRubberStampTypeStampProcessed  = 17,
   LTAnnRubberStampTypeStampReceived   = 18,
   LTAnnRubberStampTypeStampRejected   = 19,
   LTAnnRubberStampTypeStampRelease    = 20,
   LTAnnRubberStampTypeStampSent       = 21,
   LTAnnRubberStampTypeStampShipped    = 22,
   LTAnnRubberStampTypeStampTopSecret  = 23,
   LTAnnRubberStampTypeStampUrgent     = 24,
   LTAnnRubberStampTypeStampVoid       = 25,
};

typedef NS_ENUM(NSInteger, LTAnnPointerPosition) {
   LTAnnPointerPositionStart  = 0,
   LTAnnPointerPositionEnd    = 1,
};

typedef NS_ENUM(NSInteger, LTAnnKeys) {
   LTAnnKeyNone      = 0,
   LTAnnKeyEnter     = 13,
   LTAnnKeyEscape    = 53,
   LTAnnKeySpace     = 32,
   LTAnnKeyAlt       = 0x40000,
   LTAnnKeyShift     = 0x10000,
};

typedef NS_ENUM(NSInteger, LTAnnTextDecorations) {
   LTAnnTextDecorationsNone            = 0,
   LTAnnTextDecorationsBaseLine        = 1,
   LTAnnTextDecorationsOverLine        = 2,
   LTAnnTextDecorationsStrikethrough   = 4,
   LTAnnTextDecorationsunderline       = 8,
};