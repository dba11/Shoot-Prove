//
//  LTAnnPropertyInfo.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@protocol LTIAnnEditor;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPropertyInfo : NSObject

@property (nonatomic, assign, readonly, getter=isReadOnly) BOOL readOnly;
@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, assign, readonly) BOOL hasValues;

@property (nonatomic, strong, readonly) id<LTIAnnEditor> editorType;
@property (nonatomic, strong, nullable) id<NSObject> value;

@property (nonatomic, strong, readonly) NSMutableDictionary *values;

@property (nonatomic, copy)             NSString *category;
@property (nonatomic, copy)             NSString *description;
@property (nonatomic, copy)             NSString *displayName;

@property (nonatomic, assign, nullable) Class type;

- (instancetype)initWithName:(nullable NSString *)propertyName readonly:(BOOL)readOnly value:(nullable id<NSObject>)value category:(NSString *)category description:(NSString *)description displayName:(nullable NSString *)displayName visible:(BOOL)visible editor:(Class)editorType;


@end

NS_ASSUME_NONNULL_END