//
//  LTOcrEngineManager.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrEngineManager : NSObject // STATIC CLASS

+ (LTOcrEngine *)createEngine:(LTOcrEngineType)engineType;

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END