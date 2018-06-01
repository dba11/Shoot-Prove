//
//  LTOcrAutoRecognizeJob.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrAutoRecognizeJobData.h"
#import "LTOcrAutoRecognizeManagerJobError.h"

NS_ASSUME_NONNULL_BEGIN

@class LTOcrAutoRecognizeManager;

@interface LTOcrAutoRecognizeJob : NSObject

@property (nonatomic, strong, readonly)           LTOcrAutoRecognizeManager *autoRecognizeManager;
@property (nonatomic, strong, readonly)           LTOcrAutoRecognizeJobData *jobData;
@property (nonatomic, strong, readonly, nullable) NSArray<LTOcrAutoRecognizeManagerJobError *> *errors;

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END