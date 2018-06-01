//
//  LTOcrAutoRecognizeManagerJobError.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTOcrAutoRecognizeManagerJobOperation) {
    LTOcrAutoRecognizeManagerJobOperationOther,
    LTOcrAutoRecognizeManagerJobOperationCreateDocument,
    LTOcrAutoRecognizeManagerJobOperationPrepareDocument,
    LTOcrAutoRecognizeManagerJobOperationLoadPage,
    LTOcrAutoRecognizeManagerJobOperationPreprocessPage,
    LTOcrAutoRecognizeManagerJobOperationZonePage,
    LTOcrAutoRecognizeManagerJobOperationRecognizePage,
    LTOcrAutoRecognizeManagerJobOperationSavePage,
    LTOcrAutoRecognizeManagerJobOperationAppendLtd,
    LTOcrAutoRecognizeManagerJobOperationSaveDocument,
    LTOcrAutoRecognizeManagerJobOperationConvertDocument
};

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrAutoRecognizeManagerJobError : NSObject

@property (nonatomic, assign) NSInteger imagePageNumber;
@property (nonatomic, assign) LTOcrAutoRecognizeManagerJobOperation operation;
@property (nonatomic, strong) NSError *error;

- (instancetype)initWithPageNumber:(NSInteger)imagePageNumber operation:(LTOcrAutoRecognizeManagerJobOperation)operation error:(NSError *)error;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END