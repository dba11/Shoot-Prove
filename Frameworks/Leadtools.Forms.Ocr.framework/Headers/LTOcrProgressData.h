//
//  LTOcrProgressData.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTOcrProgressOperation) {
   LTOcrProgressOperationLoadImage = 0,
   LTOcrProgressOperationSaveImage,
   LTOcrProgressOperationPreprocessImage,
   LTOcrProgressOperationAutoZone,
   LTOcrProgressOperationRecognize,
   LTOcrProgressOperationSaveDocumentPrepare,
   LTOcrProgressOperationSaveDocument,
   LTOcrProgressOperationSaveDocumentConvertImage,
   LTOcrProgressOperationFormatting,
   LTOcrProgressOperationRecognizeOMR,
   LTOcrProgressOperationLast = LTOcrProgressOperationRecognizeOMR
};

typedef NS_ENUM(NSInteger, LTOcrProgressStatus) {
   LTOcrProgressStatusContinue = 0,
   LTOcrProgressStatusAbort
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrProgressData : NSObject

@property (nonatomic, assign, readonly) NSInteger firstPageIndex;
@property (nonatomic, assign, readonly) NSInteger lastPageIndex;
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
@property (nonatomic, assign, readonly) NSInteger percentage;

@property (nonatomic, assign, readonly) LTOcrProgressOperation operation;

@property (nonatomic, assign)           LTOcrProgressStatus status;

@end


typedef void (^LTOcrProgressHandler)(LTOcrProgressData *progressData);

NS_ASSUME_NONNULL_END