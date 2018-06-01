//
//  LTOcrDocument.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrPageCollection.h"
#import "LTOcrWriteXmlOptions.h"

@class LTOcrEngine;

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrDocument : NSObject

@property (nonatomic, assign, readonly)           BOOL isInMemory;
@property (nonatomic, assign)                     BOOL useEngineInstanceOptions;

@property (nonatomic, strong, readonly)           LTRasterCodecs *rasterCodecsInstance;
@property (nonatomic, strong, readonly)           LTDocumentWriter *documentWriterInstance;
@property (nonatomic, strong, readonly)           LTOcrEngine *engine;
@property (nonatomic, strong, readonly)           LTOcrPageCollection *pages;

@property (nonatomic, strong, readonly, nullable) NSString *fileName;

- (BOOL)saveToStream:(LTLeadStream *)stream format:(LTDocumentFormat)format progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (BOOL)saveToFile:(NSString *)fileName format:(LTDocumentFormat)format progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (BOOL)saveToData:(NSMutableData *)data format:(LTDocumentFormat)format progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;

- (void)saveZonesToStream:(LTLeadStream *)stream xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error;
- (void)saveZonesToFile:(NSString *)fileName xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error;
- (void)saveZonesToData:(NSMutableData *)data xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error;

- (void)loadZonesFromStream:(LTLeadStream *)stream error:(NSError **)error;
- (void)loadZonesFromFile:(NSString *)fileName error:(NSError **)error;
- (void)loadZonesFromData:(NSMutableData *)data error:(NSError **)error;

- (void)saveXmlToStream:(LTLeadStream *)stream xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error;
- (void)saveXmlToFileName:(NSString *)fileName xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error;
- (void)saveXmlToData:(NSMutableData *)data xmlWriteOptions:(nullable LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error;

@end



@interface LTOcrDocument (Deprecated)

- (BOOL)save:(LTLeadStream *)stream target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "saveToStream:error:");

- (void)saveZones:(LTLeadStream *)stream xmlWriteOptions:(LTOcrWriteXmlOptions *)xmlWriteOptions error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "saveZonesToStream:xmlWriteOptions:error:");
- (void)loadZones:(LTLeadStream *)stream error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "loadZonesFromStream:error:");

- (void)saveXml:(LTLeadStream *)stream xmlWriteOptions:(LTOcrWriteXmlOptions *)xmlWriteOptions outputOptions:(LTOcrXmlOutputOptions)outputOptions error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "saveXmlToStream:xmlWriteOptions:outputOptions:error:");

@end

NS_ASSUME_NONNULL_END