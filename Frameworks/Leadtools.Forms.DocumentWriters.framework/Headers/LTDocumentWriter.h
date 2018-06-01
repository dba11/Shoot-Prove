//
//  LTDocumentWriter.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentOptions.h"
#import "LTDocumentPage.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LTDocumentWriterProgressHandler)(NSInteger percentage, BOOL *stop);


@interface LTDocumentWriter : NSObject

+ (NSArray<NSNumber *> *)allSupportedFormats; // LTDocumentFormat

+ (NSString *)fileExtensionForFormat:(LTDocumentFormat)format;
+ (NSString *)friendlyNameForFormat:(LTDocumentFormat)format;

- (LTDocumentOptions *)optionsForFormat:(LTDocumentFormat)format;
- (void)setOptions:(nullable LTDocumentOptions *)options forFormat:(LTDocumentFormat)format;

- (BOOL)beginDocumentWithFileName:(NSString *)fileName format:(LTDocumentFormat)format progress:(nullable LTDocumentWriterProgressHandler)progress error:(NSError **)error;
- (BOOL)endDocument:(nullable LTDocumentWriterProgressHandler)progressHandler error:(NSError **)error;

- (BOOL)convertLtdFile:(NSString *)ltdFileName outputFile:(NSString *)outputFileName format:(LTDocumentFormat)format progress:(nullable LTDocumentWriterProgressHandler)progress error:(NSError **)error;

- (BOOL)addPage:(LTDocumentPage *)page progress:(nullable LTDocumentWriterProgressHandler)progress error:(NSError **)error;
- (BOOL)insertPage:(LTDocumentPage *)page progress:(nullable LTDocumentWriterProgressHandler)progress pageNumber:(NSUInteger)pageNumber error:(NSError **)error;
- (BOOL)appendLtdFile:(NSString *)srcLtdFile destinationLtdFile:(NSString *)dstLtdFile error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END