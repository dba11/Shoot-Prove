//
//  LTAnnObjectChangedEventArgs.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@class LTAnnDesigner;

typedef NS_ENUM(NSInteger, LTAnnObjectChangedType) {
   LTAnnObjectChangedTypeNone              = 0,
   LTAnnObjectChangedTypeBringToFront      = 1,
   LTAnnObjectChangedTypeSendToBack        = 2,
   LTAnnObjectChangedTypeDeleted           = 3,
   LTAnnObjectChangedTypeLock              = 4,
   LTAnnObjectChangedTypeUnlock            = 5,
   LTAnnObjectChangedTypePaste             = 6,
   LTAnnObjectChangedTypeFlip              = 7,
   LTAnnObjectChangedTypeRealizeRedaction  = 8,
   LTAnnObjectChangedTypeRestoreRedaction  = 9,
   LTAnnObjectChangedTypeApplyEncryptor    = 10,
   LTAnnObjectChangedTypeApplyDecryptor    = 11,
   LTAnnObjectChangedTypeName              = 12,
   LTAnnObjectChangedTypeHyperlink         = 13,
   LTAnnObjectChangedTypeText              = 14,
   LTAnnObjectChangedTypePicture           = 15,
   LTAnnObjectChangedTypePictures          = 16,
   LTAnnObjectChangedTypeRuler             = 17,
   LTAnnObjectChangedTypeStroke            = 18,
   LTAnnObjectChangedTypeFill              = 19,
   LTAnnObjectChangedTypeFont              = 20,
   LTAnnObjectChangedTypeEncrypt           = 21,
   LTAnnObjectChangedTypePolygon           = 22,
   LTAnnObjectChangedTypeCurve             = 23,
   LTAnnObjectChangedTypeProtractor        = 24,
   LTAnnObjectChangedTypeRubberStamp       = 25,
   LTAnnObjectChangedTypePoint             = 26,
   LTAnnObjectChangedTypeAudio             = 27,
   LTAnnObjectChangedTypeControlPoints     = 28,
   LTAnnObjectChangedTypeHilite            = 29,
   LTAnnObjectChangedTypeDesignerDraw      = 30,
   LTAnnObjectChangedTypeDesignerEdit      = 31,
   LTAnnObjectChangedTypeResetRotatePoints = 32,
   LTAnnObjectChangedTypeFixed             = 33,
   LTAnnObjectChangedTypeAdded             = 34,
   LTAnnObjectChangedTypeModified          = 35,
};

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnBeforeObjectChangedEventArgs : NSObject

@property (nonatomic, strong, readonly)           LTAnnObjectCollection *objects;
@property (nonatomic, strong, readonly, nullable) LTAnnDesigner *designer;

@property (nonatomic, assign, readonly)           LTAnnObjectChangedType changeType;

@property (nonatomic, assign)                     BOOL cancel;

- (instancetype)initWithObjects:(LTAnnObjectCollection *)objects changeType:(LTAnnObjectChangedType)changeType designer:(nullable LTAnnDesigner *)designer;
@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnAfterObjectChangedEventArgs : NSObject

@property (nonatomic, strong, readonly)           LTAnnObjectCollection *objects;
@property (nonatomic, strong, readonly, nullable) LTAnnDesigner *designer;

@property (nonatomic, assign, readonly)           LTAnnObjectChangedType changeType;

@property (nonatomic, assign)                     BOOL cancel;

- (instancetype)initWithObjects:(LTAnnObjectCollection *)objects changeType:(LTAnnObjectChangedType)changeType designer:(nullable LTAnnDesigner *)designer;
@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnObjectModifiedEventArgs : NSObject

@property (nonatomic, strong, readonly) LTAnnObjectCollection *objects;

@property (nonatomic, assign, readonly) LTAnnObjectChangedType changeType;

- (instancetype)initWithObjects:(LTAnnObjectCollection *)objects changeType:(LTAnnObjectChangedType)changeType;
@end

NS_ASSUME_NONNULL_END