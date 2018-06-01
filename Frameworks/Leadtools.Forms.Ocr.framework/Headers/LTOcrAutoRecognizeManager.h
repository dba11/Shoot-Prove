//
//  LTOcrAutoRecognizeManager.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrAutoRecognizeJobOperationEventArgs.h"
#import "LTOcrAutoRecognizeJob.h"
#import "LTOcrProgressData.h"

typedef NS_ENUM(NSInteger, LTOcrAutoRecognizeManagerJobErrorMode) {
    LTOcrAutoRecognizeManagerJobErrorModeAbort,
    LTOcrAutoRecognizeManagerJobErrorModeContinue
};

NS_ASSUME_NONNULL_BEGIN

@class LTOcrAutoRecognizeManager;
@protocol LTOcrAutoRecognizeManagerDelegate <NSObject>

@optional
- (void)autoRecognizeManager:(LTOcrAutoRecognizeManager *)manager progress:(LTOcrProgressData *)progressData;
- (void)autoRecognizeManager:(LTOcrAutoRecognizeManager *)manager didStartWithStatus:(LTOcrAutoRecognizeManagerJobStatus *)status;
- (void)autoRecognizeManager:(LTOcrAutoRecognizeManager *)manager didCompleteWithStatus:(LTOcrAutoRecognizeManagerJobStatus *)status;
- (void)autoRecognizeManager:(LTOcrAutoRecognizeManager *)manager willRunOperation:(LTOcrAutoRecognizeJobOperationEventArgs *)operation;
- (void)autoRecognizeManager:(LTOcrAutoRecognizeManager *)manager didRunOperation:(LTOcrAutoRecognizeJobOperationEventArgs *)operation;

@end



@interface LTOcrAutoRecognizeManager : NSObject

@property (nonatomic, weak, nullable)   id<LTOcrAutoRecognizeManagerDelegate> delegate;

@property (nonatomic, assign)           NSInteger maximumPagesBeforeLtd;
@property (nonatomic, assign)           NSInteger maximumThreadsPerJob;

@property (nonatomic, assign)           BOOL enableTrace;
@property (nonatomic, assign, readonly) BOOL isMultiThreadedSupported;

@property (nonatomic, assign)           LTOcrAutoRecognizeManagerJobErrorMode jobErrorMode;

@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *preprocessPageCommands; // LTOcrAutoPreprocessPageCommand

- (instancetype)init __unavailable;

- (BOOL)run:(NSString *)imageFileName documentFileName:(NSString *)documentFileName zonesFileName:(nullable NSString *)zonesFileName format:(LTDocumentFormat)format error:(NSError **)error;

- (nullable LTOcrAutoRecognizeJob *)createJob:(LTOcrAutoRecognizeJobData *)jobData error:(NSError **)error;

- (LTOcrAutoRecognizeManagerJobStatus)runJob:(LTOcrAutoRecognizeJob *)job error:(NSError **)error;
- (BOOL)runJobAsync:(LTOcrAutoRecognizeJob *)job error:(NSError **)error;
- (void)abortAllJobs;

@end

NS_ASSUME_NONNULL_END