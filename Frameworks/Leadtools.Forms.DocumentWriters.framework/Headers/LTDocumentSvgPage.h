//
//  LTDocumentSvgPage.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentPage.h"

@interface LTDocumentSvgPage : LTDocumentPage <NSCopying>

@property (nonatomic, strong) id<ISvgDocument> svgDocument;

@property (nonatomic, strong) LTRasterImage *image;

@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;

@end