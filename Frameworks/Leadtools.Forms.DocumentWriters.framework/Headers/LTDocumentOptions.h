//
//  LTDocumentOptions.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentFormat.h"

typedef NS_ENUM(NSInteger, LTDocumentPageRestriction) {
    LTDocumentPageRestrictionDefault,
    LTDocumentPageRestrictionRelaxed
};

NS_ASSUME_NONNULL_BEGIN

@interface LTDocumentOptions : NSObject <NSCopying, NSCoding> // ABSTRACT

@property (nonatomic, assign, readonly) LTDocumentFormat format;

@property (nonatomic, assign)           LTDocumentPageRestriction pageRestriction;

@property (nonatomic, assign)           double emptyPageWidth;
@property (nonatomic, assign)           double emptyPageHeight;

@property (nonatomic, assign)           NSInteger emptyPageResolution;
@property (nonatomic, assign)           NSInteger documentResolution;

@property (nonatomic, assign)           BOOL maintainAspectRatio;

@end

NS_ASSUME_NONNULL_END