//
//  LTDocumentRasterPage.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentPage.h"

@interface LTDocumentRasterPage : LTDocumentPage <NSCopying>

@property (nonatomic, strong) LTRasterImage *image;

@end