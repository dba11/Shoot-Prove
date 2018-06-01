//
//  LTRtfDocumentOptions.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTRtfDocumentOptions : LTDocumentOptions <NSCopying, NSCoding>

@property (nonatomic, assign) LTDocumentTextMode textMode;

@end

NS_ASSUME_NONNULL_END