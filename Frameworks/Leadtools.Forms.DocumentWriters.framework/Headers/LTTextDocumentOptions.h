//
//  LTTextDocumentOptions.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentOptions.h"

typedef NS_ENUM(NSInteger, LTTextDocumentType) {
    LTTextDocumentTypeAnsi,
    LTTextDocumentTypeUnicode,
    LTTextDocumentTypeUnicodeBigEndian,
    LTTextDocumentTypeUTF8
};

NS_ASSUME_NONNULL_BEGIN

@interface LTTextDocumentOptions : LTDocumentOptions <NSCopying, NSCoding>

@property (nonatomic, assign) LTTextDocumentType documentType;

@property (nonatomic, assign) BOOL addPageNumber;
@property (nonatomic, assign) BOOL addPageBreak;
@property (nonatomic, assign) BOOL formatted;

@end

NS_ASSUME_NONNULL_END