//
//  LTOcrAutoRecognizeJobOperationEventArgs.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrAutoRecognizeJob.h"
#import "LTOcrAutoRecognizeManagerJobError.h"
#import "LTOcrDocument.h"
#import "LTOcrPage.h"

typedef NS_ENUM(NSInteger, LTOcrAutoRecognizeManagerJobStatus) {
    LTOcrAutoRecognizeManagerJobStatusSuccess,
    LTOcrAutoRecognizeManagerJobStatusAbort
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrAutoRecognizeJobOperationEventArgs : NSObject

@property (nonatomic, assign)                     LTOcrAutoRecognizeManagerJobStatus status;
@property (nonatomic, assign, readonly)           LTOcrAutoRecognizeManagerJobOperation operation;
@property (nonatomic, assign, readonly)           LTDocumentFormat format;

@property (nonatomic, assign, readonly)           NSInteger imagePageNumber;

@property (nonatomic, copy, readonly, nullable)   NSString *ltdFileName;
@property (nonatomic, copy, readonly, nullable)   NSString *documentFileName;

@property (nonatomic, strong, readonly)           LTOcrAutoRecognizeJob *job;
@property (nonatomic, strong, readonly, nullable) LTOcrDocument *document;
@property (nonatomic, strong, readonly, nullable) LTOcrPage *page;

@property (nonatomic, strong, nullable)           LTRasterImage *pageImage;

@property (nonatomic, strong, readonly, nullable) LTDocumentWriter *documentWriterInstance;

- (instancetype)initWithJob:(LTOcrAutoRecognizeJob *)job operation:(LTOcrAutoRecognizeManagerJobOperation)operation document:(nullable LTOcrDocument *)document page:(nullable LTOcrPage *)page imagePageNumber:(NSInteger)imagePageNumber ltdFileName:(nullable NSString *)ltdFileName format:(LTDocumentFormat)format documentFileName:(nullable NSString *)documentFileName documentWriter:(nullable LTDocumentWriter *)documentWriterInstance;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END