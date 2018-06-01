//
//  LTOcrDocumentManager.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrLanguage.h"
#import "LTOcrDocument.h"

@class LTOcrEngine;

typedef NS_ENUM(NSInteger, LTOcrDocumentFontType) {
   LTOcrDocumentFontTypeProportionalSerif = 0,
   LTOcrDocumentFontTypeProportionalSansSerif,
   LTOcrDocumentFontTypeFixedSerif,
   LTOcrDocumentFontTypeFixedSansSerif,
   LTOcrDocumentFontTypeMICR
};

typedef NS_ENUM(NSInteger, LTOcrCreateDocumentOptions) {
   LTOcrCreateDocumentOptionsNone = 0,
   LTOcrCreateDocumentOptionsInMemory,
   LTOcrCreateDocumentOptionsAutoDeleteFile,
   LTOcrCreateDocumentOptionsLoadExisting
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrDocumentManager : NSObject

- (nullable LTOcrDocument *)createDocument:(nullable NSString *)ocrDocumentFilePath options:(LTOcrCreateDocumentOptions)options error:(NSError **)error;

- (nullable NSArray<NSString *> *)fontNamesForLanguage:(LTOcrLanguage)language error:(NSError **)error;
- (BOOL)setFontNames:(NSArray<NSString *> *)fontNames forLanguage:(LTOcrLanguage)language error:(NSError **)error;

- (nullable NSString *)fontNameForLanguage:(LTOcrLanguage)language fontType:(LTOcrDocumentFontType)fontType error:(NSError **)error;
- (void)setFontName:(NSString *)fontName forLanguage:(LTOcrLanguage)language fontType:(LTOcrDocumentFontType)fontType error:(NSError **)error;

@end



@interface LTOcrDocumentManager (Deprecated)

- (nullable LTOcrDocument *)createDocument:(nullable NSString *)ocrDocumentFilePath options:(LTOcrCreateDocumentOptions)options LT_DEPRECATED_USENEW(19_0, "createDocument:options:error:");

- (nullable NSArray*)getFontNames:(LTOcrLanguage)language error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "fontNamesForLanguage:error:");
- (BOOL)setFontNames:(LTOcrLanguage)language fontNames:(NSArray*)fontNames error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "setFontNames:forLanguage:error:");

- (nullable NSString*)getFontName:(LTOcrLanguage)language fontType:(LTOcrDocumentFontType)fontType LT_DEPRECATED_USENEW(19_0, "fontNameForLanguage:fontType:");
- (void)setFontName:(LTOcrLanguage)language fontType:(LTOcrDocumentFontType)fontType fontName:(NSString*)fontName LT_DEPRECATED_USENEW(19_0, "setFontName:forLanguage:fontType:");

@end

NS_ASSUME_NONNULL_END