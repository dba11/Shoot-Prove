//
//  LTOcrCharacter.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrLanguage.h"

typedef NS_OPTIONS(NSUInteger, LTOcrCharacterFontStyle) {
    LTOcrCharacterFontStyleRegular      = 0,
    LTOcrCharacterFontStyleBold         = 1 << 0,
    LTOcrCharacterFontStyleItalic       = 1 << 1,
    LTOcrCharacterFontStyleUnderline    = 1 << 2,
    LTOcrCharacterFontStyleSansSerif    = 1 << 3,
    LTOcrCharacterFontStyleSerif        = 1 << 4,
    LTOcrCharacterFontStyleProportional = 1 << 5,
    LTOcrCharacterFontStyleSuperscript  = 1 << 6,
    LTOcrCharacterFontStyleSubscript    = 1 << 7,
    LTOcrCharacterFontStyleStrikeout    = 1 << 8,
};

typedef NS_OPTIONS(NSUInteger, LTOcrCharacterPosition) {
    LTOcrCharacterPositionNone           = 0,
    LTOcrCharacterPositionEndOfLine      = 1 << 0,
    LTOcrCharacterPositionEndOfParagraph = 1 << 1,
    LTOcrCharacterPositionEndOfWord      = 1 << 2,
    LTOcrCharacterPositionEndOfZone      = 1 << 3,
    LTOcrCharacterPositionEndOfPage      = 1 << 4,
    LTOcrCharacterPositionEndOfCell      = 1 << 5,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrCharacter : NSObject <NSCopying>

@property (nonatomic, assign)                LTOcrLanguage language;
@property (nonatomic, assign)                LTOcrCharacterFontStyle fontStyle;
@property (nonatomic, assign)                LTOcrCharacterPosition position;

@property (nonatomic, assign)                LeadRect bounds;

@property (nonatomic, assign)                BOOL wordIsCertain;

@property (nonatomic, assign)                CGFloat fontSize;
@property (nonatomic, copy, null_resettable) LTRasterColor *color;

@property (nonatomic, assign)                NSUInteger confidence;
@property (nonatomic, assign)                NSUInteger base;
@property (nonatomic, assign)                NSUInteger cellIndex;
@property (nonatomic, assign)                NSUInteger leadingSpaces;
@property (nonatomic, assign)                NSUInteger leadingSpacesConfidence;
@property (nonatomic, assign)                NSUInteger rotationAngle;

@property (nonatomic, assign)                wchar_t code;
@property (nonatomic, assign)                wchar_t guessCode1;
@property (nonatomic, assign)                wchar_t guessCode2;

@end

NS_ASSUME_NONNULL_END