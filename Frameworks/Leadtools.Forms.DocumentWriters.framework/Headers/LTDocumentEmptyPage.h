//
//  LTDocumentEmptyPage.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentPage.h"

@interface LTDocumentEmptyPage : LTDocumentPage <NSCopying>

@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;

@end