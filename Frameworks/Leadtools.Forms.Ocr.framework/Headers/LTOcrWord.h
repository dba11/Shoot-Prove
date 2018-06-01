//
//  LTOcrWord.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrWord : NSObject <NSCopying>

@property (nonatomic, copy, nullable) NSString *value;

@property (nonatomic, assign)         LeadRect bounds;

@property (nonatomic, assign)         NSUInteger firstCharacterIndex;
@property (nonatomic, assign)         NSUInteger lastCharacterIndex;

@end

NS_ASSUME_NONNULL_END