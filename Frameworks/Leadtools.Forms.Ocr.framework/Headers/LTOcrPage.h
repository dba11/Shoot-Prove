//
//  LTOcrPage.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrAutoPreprocessPageCommand.h"
#import "LTOcrImageSharingMode.h"
#import "LTOcrWriteXmlOptions.h"
#import "LTOcrZoneCollection.h"
#import "LTOcrPageCharacters.h"
#import "LTOcrZoneCollection.h"
#import "LTOcrProgressData.h"

@class LTOcrDocument;

typedef NS_ENUM(NSInteger, LTOcrPageType) {
   LTOcrPageTypeCurrent = 0,
   LTOcrPageTypeProcessing,
   LTOcrPageTypeOriginal
};

@interface LTOcrPageAutoPreprocessValues : NSObject

@property (nonatomic, assign) BOOL isInverted;

@property (nonatomic, assign) NSUInteger rotationAngle;  // 100 of a degree
@property (nonatomic, assign) NSUInteger deskewAngle;    // 100 of a degree

@end


NS_ASSUME_NONNULL_BEGIN

@interface LTOcrPage : NSObject

@property (nonatomic, assign, readonly)           BOOL isRecognized;

@property (nonatomic, assign, readonly)           NSUInteger width;
@property (nonatomic, assign, readonly)           NSUInteger height;
@property (nonatomic, assign, readonly)           NSUInteger bitsPerPixel;
@property (nonatomic, assign, readonly)           NSUInteger bytesPerLine;
@property (nonatomic, assign, readonly)           NSUInteger dpiX;
@property (nonatomic, assign, readonly)           NSUInteger dpiY;

@property (nonatomic, assign, readonly)           LTRasterImageFormat originalFormat;

@property (nonatomic, weak, readonly, nullable)   LTOcrDocument *document;
@property (nonatomic, strong, readonly)           LTOcrZoneCollection *zones;

@property (nonatomic, strong, readonly, nullable) NSArray<LTRasterColor *> *palette;


- (instancetype)init __unavailable;

- (nullable LTRasterImage *)rasterImageForPageType:(LTOcrPageType)pageType error:(NSError **)error;
- (BOOL)setRasterImage:(LTRasterImage *)image error:(NSError **)error;

- (nullable LTRasterImage *)createThumbnailWithWidth:(NSUInteger)thumbnailWidth height:(NSUInteger)thumbnailHeight error:(NSError **)error;

- (NSInteger)deskewAngle:(NSError **)error;
- (NSInteger)rotateAngle:(NSError **)error;
- (BOOL)isInverted:(NSError **)error;

- (LeadRect)zoneBoundsAtIndex:(NSUInteger)index;
- (NSUInteger)hitTestZone:(LeadPoint)point;

- (BOOL)autoPreprocess:(LTOcrAutoPreprocessPageCommand)command progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (BOOL)autoZone:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (BOOL)recognize:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (void)unrecognize;
- (nullable NSString *)textForZoneAtIndex:(NSInteger)index error:(NSError **)error;

- (nullable LTOcrPageCharacters *)recognizedCharacters:(NSError **)error;
- (BOOL)setRecognizedCharacters:(LTOcrPageCharacters *)pageCharacters error:(NSError **)error;

- (NSArray<NSNumber *> *)detectLanguages:(NSArray<NSNumber *> *)languages error:(NSError **)error;
- (LTOcrPageAutoPreprocessValues *)preprocessValues:(NSError **)error;
- (nullable LTRasterImage *)overlayImage:(NSError **)error;
- (void)setOverlayImage:(LTRasterImage *)image error:(NSError **)error;

- (void)loadZonesFromStream:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error;
- (void)saveZonesToStream:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error;
- (void)saveXmlToStream:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error;

- (void)loadZonesFromFile:(NSString *)fileName pageNumber:(NSUInteger)pageNumber error:(NSError **)error;
- (void)saveZonesToFile:(NSString *)fileName pageNumber:(NSUInteger)pageNumber xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error;
- (void)saveXmlToFile:(NSString *)fileName pageNumber:(NSUInteger)pageNumber xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error;

- (void)loadZonesFromData:(NSData *)data pageNumber:(NSUInteger)pageNumber error:(NSError **)error;
- (void)saveZonesToData:(NSMutableData *)data pageNumber:(NSUInteger)pageNumber xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error;
- (void)saveXmlToData:(NSMutableData *)data pageNumber:(NSUInteger)pageNumber xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error;

@end



@interface LTOcrPage (Deprecated)

- (nullable LTRasterImage *)getRasterImage:(LTOcrPageType)pageType error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "rasterImageForPageType:error:");
- (nullable LTRasterImage *)createThumbnail:(unsigned int)thumbnailWidth thumbnailHeight:(unsigned int)thumbnailHeight error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "createThumbnailWithWidth:height:error:");
- (nullable NSData *)getPalette LT_DEPRECATED_USENEW(19_0, "palette");

- (BOOL)autoPreprocess:(LTOcrAutoPreprocessPageCommand)command target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "autoPreprocess:progress:error:");

- (BOOL)getDeskewAngle:(int*)value error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "deskewAngle:");
- (BOOL)getRotateAngle:(int*)value error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "rotateAngle:");
- (BOOL)isInverted:(BOOL *)value error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "isInverted:");

- (LeadRect)getZoneBoundsInPixels:(unsigned int)zoneIndex LT_DEPRECATED_USENEW(19_0, "zoneBoundsAtIndex:");

- (BOOL)autoZone:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "autoZone:error:");
- (BOOL)recognize:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "recognize:error:");
- (nullable NSString *)getText:(int)zoneIndex error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "textForZoneAtIndex:error:");

- (nullable LTOcrPageCharacters *)getRecognizedCharacters:(NSError **)error LT_DEPRECATED_USENEW(19_0, "recognizedCharacters:");

- (void)loadZones:(LTLeadStream *)stream pageNumber:(unsigned int)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "loadZonesFromStream:pageNumber:error:");
- (void)saveZones:(LTLeadStream *)stream pageNumber:(unsigned int)pageNumber xmlWriteOptions:(LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "saveZonesToStream:pageNumber:xmlWriteOptions:error");
- (void)saveXml:(LTLeadStream *)stream pageNumber:(unsigned int)pageNumber xmlWriteOptions:(LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "saveXmlToStream:pageNumber:xmlWriteOptions:outputOptions:error:");

@end

NS_ASSUME_NONNULL_END