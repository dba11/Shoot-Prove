//
//  LTOcrSettingDescriptor.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTOcrSettingValueType) {
   LTOcrSettingValueTypeBeginCategory = 0,
   LTOcrSettingValueTypeEndCategory,
   LTOcrSettingValueTypeInteger,
   LTOcrSettingValueTypeEnum,
   LTOcrSettingValueTypeDouble,
   LTOcrSettingValueTypeBoolean,
   LTOcrSettingValueTypeString,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrSettingDescriptor : NSObject

@property (nonatomic, copy, readonly, nullable) NSString *name;
@property (nonatomic, copy, readonly, nullable) NSString *friendlyName;
@property (nonatomic, copy, readonly, nullable) NSString *units;

@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *enumMemberFriendlyNames;
@property (nonatomic, copy, readonly, nullable) NSArray<NSNumber *> *enumMemberValues;

@property (nonatomic, assign, readonly)         LTOcrSettingValueType valueType;

@property (nonatomic, assign, readonly)         NSInteger integerMinimumValue;
@property (nonatomic, assign, readonly)         NSInteger integerMaximumValue;
@property (nonatomic, assign, readonly)         NSInteger stringMaximumLength;

@property (nonatomic, assign, readonly)         BOOL enumIsFlags;
@property (nonatomic, assign, readonly)         BOOL stringNullAllowed;

@property (nonatomic, assign, readonly)         double doubleMinimumValue;
@property (nonatomic, assign, readonly)         double doubleMaximumValue;

@end

NS_ASSUME_NONNULL_END