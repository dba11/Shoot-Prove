//
//  LTLTDocumentFormat.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTDocumentFormat) {
    LTDocumentFormatUser    = -1,
    LTDocumentFormatLtd     = 0,
    LTDocumentFormatPdf     = 1,
    LTDocumentFormatDoc     = 2,
    LTDocumentFormatRtf     = 3,
    LTDocumentFormatHtml    = 4,
    LTDocumentFormatText    = 5,
    LTDocumentFormatEmf     = 6,
    LTDocumentFormatXps     = 7,
    LTDocumentFormatDocx    = 8,
    LTDocumentFormatXls     = 9,
    LTDocumentFormatPub     = 10,
    LTDocumentFormatMob     = 11,
    LTDocumentFormatSvg     = 12,
    LTDocumentFormatAltoXml = 13,
};

typedef NS_ENUM(NSInteger, LTDocumentFontEmbedMode) {
    LTDocumentFontEmbedModeNone,
    LTDocumentFontEmbedModeAuto,
    LTDocumentFontEmbedModeForce,
    LTDocumentFontEmbedModeAll
};

typedef NS_ENUM(NSInteger, LTOneBitImageCompressionType) {
    LTOneBitImageCompressionTypeFlate,
    LTOneBitImageCompressionTypeFaxG31D,
    LTOneBitImageCompressionTypeFaxG32D,
    LTOneBitImageCompressionTypeFaxG4,
    LTOneBitImageCompressionTypeLzw,
    LTOneBitImageCompressionTypeJbig2
};

typedef NS_ENUM(NSInteger, LTColoredImageCompressionType) {
    LTColoredImageCompressionTypeFlateJpeg,
    LTColoredImageCompressionTypeLzwJpeg,
    LTColoredImageCompressionTypeFlate,
    LTColoredImageCompressionTypeLzw,
    LTColoredImageCompressionTypeJpeg,
    LTColoredImageCompressionTypeFlateJpx,
    LTColoredImageCompressionTypeLzwJpx,
    LTColoredImageCompressionTypeJpx
};

typedef NS_ENUM(NSInteger, LTDocumentImageOverTextSize) {
    LTDocumentImageOverTextSizeOriginal = 0,
    LTDocumentImageOverTextSizeHalf     = 1,
    LTDocumentImageOverTextSizeQuarter  = 2
};

typedef NS_ENUM(NSInteger, LTDocumentImageOverTextMode) {
    LTDocumentImageOverTextModeNone    = 0,
    LTDocumentImageOverTextModeStrict  = 1,
    LTDocumentImageOverTextModeRelaxed = 2
};

typedef NS_ENUM(NSInteger, LTDocumentTextMode) {
    LTDocumentTextModeAuto,
    LTDocumentTextModeNonFramed,
    LTDocumentTextModeFramed
};

typedef NS_OPTIONS(NSUInteger, LTDocumentWriterFlags) {
    LTDocumentWriterFlagsNone                   = 0x0000,
    LTDocumentWriterFlagsAdvantage              = 0x80000000,
    LTDocumentWriterFlagsOptimizeFonts          = 0x20000000,
    LTDocumentWriterFlagsAdvantageOptimizeFonts = LTDocumentWriterFlagsAdvantage | LTDocumentWriterFlagsOptimizeFonts,
};