//
//  LTAnnFont.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnFont : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy)             NSString *fontFamilyName;

@property (nonatomic, assign)           CGFloat fontSize;
@property (nonatomic, assign, readonly) CGFloat fontHeight;

@property (nonatomic, assign)           LTAnnFontStretch fontStretch;
@property (nonatomic, assign)           LTAnnFontStyle fontStyle;
@property (nonatomic, assign)           LTAnnFontWeight fontWeight;
@property (nonatomic, assign)           LTAnnTextDecorations textDecoration;

- (instancetype)initWithFamilyName:(NSString *)name fontSize:(CGFloat)size NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END