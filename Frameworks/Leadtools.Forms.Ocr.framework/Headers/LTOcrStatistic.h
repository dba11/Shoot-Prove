//
//  LTOcrStatistic.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrStatistic : NSObject

@property (nonatomic, assign) NSUInteger recognizedCharacters;
@property (nonatomic, assign) NSUInteger recognizedWords;
@property (nonatomic, assign) NSUInteger rejectedCharacters;
@property (nonatomic, assign) NSUInteger correctedWords;

@property (nonatomic, assign) UInt64 recognitionTime;
@property (nonatomic, assign) UInt64 readingTime;
@property (nonatomic, assign) UInt64 imagePreprocessingTime;
@property (nonatomic, assign) UInt64 decompositionTime;

@end

NS_ASSUME_NONNULL_END