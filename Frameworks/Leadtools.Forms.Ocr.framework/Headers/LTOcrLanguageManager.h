//
//  LTOcrLanguageManager.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrLanguage.h"
#import "LTOcrPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrLanguageManager : NSObject

@property (nonatomic, strong, readonly) NSArray<NSNumber *> *supportedLanguages;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *additionalLanguages;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *enabledLanguages;

+ (NSString *)nameForLanguage:(LTOcrLanguage)language;
+ (LTOcrLanguage)languageForName:(NSString *)name;

- (BOOL)isLanguageSupported:(LTOcrLanguage)language;

- (BOOL)enableLanguages:(NSArray<NSNumber *> *)languages error:(NSError **)error;

- (NSUInteger)detectLanguage:(LTOcrPage *)page languages:(NSArray<NSNumber *> *)languages confidences:(NSArray<NSNumber *> * _Nullable * _Nullable)confidences minimumConfidence:(NSUInteger)minimumConfidence error:(NSError **)error;

@end



@interface LTOcrLanguageManager (Deprecated)

+ (nullable NSString *)getLanguageName:(LTOcrLanguage)language LT_DEPRECATED_USENEW(19_0, "nameForLanguage:");
+ (LTOcrLanguage)getLanguageValue:(NSString *)name LT_DEPRECATED_USENEW(19_0, "languageForName:");

- (nullable NSArray *)getSupportedLanguages LT_DEPRECATED_USENEW(19_0, "supportedLanguages");
- (nullable NSArray *)getAdditionalLanguages LT_DEPRECATED_USENEW(19_0, "additionalLanguages");
- (nullable NSArray *)getEnabledLanguages LT_DEPRECATED_USENEW(19_0, "enabledLanguages");

- (int)detectLanguage:(LTOcrPage *)page languages:(const LTOcrLanguage *)languages count:(unsigned int)count confidences:(int *)confidences minimumConfidence:(unsigned int)minimumConfidence error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "detectLanguage:languages:confidences:minimumConfidence:error:");

@end

NS_ASSUME_NONNULL_END