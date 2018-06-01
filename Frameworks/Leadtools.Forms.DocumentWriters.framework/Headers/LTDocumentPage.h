//
//  LTDocumentPage.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTDocumentPageType) {
    LTDocumentPageTypeEmf,
    LTDocumentPageTypeSvg,
    LTDocumentPageTypeRaster,
    LTDocumentPageTypeEmpty
};

NS_ASSUME_NONNULL_BEGIN

@interface LTDocumentPage : NSObject <NSCopying> // ABSTRACT

@property (nonatomic, assign, readonly) LTDocumentPageType type;

@end

NS_ASSUME_NONNULL_END