//
//  LTAnnObjectEditor.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPropertyInfo.h"

@class LTAnnObject;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const LTAnnEditorChangeNotification;

extern NSString * const LTAnnEditorNewValueKey;
extern NSString * const LTAnnEditorOldValueKey;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@protocol LTIAnnEditor <NSObject>

@property (nonatomic, copy, readonly)             NSString *category;

@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, LTAnnPropertyInfo *> *properties;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnColorEditor : NSObject <LTIAnnEditor>

@property (nonatomic, copy, nullable) NSString *value;

- (instancetype)initWithColor:(nullable NSString *)color category:(NSString *)category;
@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnBooleanEditor : NSObject <LTIAnnEditor>

@property (nonatomic, assign) BOOL value;

- (instancetype)initWithBool:(BOOL)value category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnIntegerEditor : NSObject <LTIAnnEditor>

@property (nonatomic, assign) NSInteger value;

- (instancetype)initWithInteger:(NSInteger)value category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnPictureEditor : NSObject <LTIAnnEditor>

@property (nonatomic, strong, nullable) LTAnnPicture *value;

- (instancetype)initWithPicture:(nullable LTAnnPicture *)value category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnLengthEditor : NSObject <LTIAnnEditor>

- (instancetype)initWithLength:(LeadLengthD)annLength category:(NSString *)category propertyName:(nullable NSString *)propertyName displayName:(nullable NSString *)displayName;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnMediaEditor : NSObject <LTIAnnEditor>

@property (nonatomic, strong, nullable) LTAnnMedia *value;

- (instancetype)initWithMedia:(nullable LTAnnMedia *)media category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnSolidColorBrushEditor : NSObject <LTIAnnEditor>

- (instancetype)initWithBrush:(nullable LTAnnSolidColorBrush *)brush category:(NSString *)category propertyName:(nullable NSString *)propertyName displayName:(nullable NSString *)displayName;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnDoubleEditor : NSObject <LTIAnnEditor>

@property (nonatomic, assign) double value;

- (instancetype)initWithDouble:(double)value category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnStringEditor : NSObject <LTIAnnEditor>

@property (nonatomic, copy, nullable) NSString *value;

- (instancetype)initWithString:(nullable NSString *)value category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnStrokeEditor : NSObject <LTIAnnEditor>

- (instancetype)initWithStroke:(nullable LTAnnStroke *)value category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnFontEditor : NSObject <LTIAnnEditor>

- (instancetype)initWithFont:(nullable LTAnnFont *)value category:(NSString *)category;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnObjectEditor : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, LTAnnPropertyInfo *> *properties;

- (instancetype)initWithObject:(LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END