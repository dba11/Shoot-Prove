//
//  LTAnnTextObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleObject.h"
#import "LTAnnThickness.h"
#import "LTAnnBrush.h"
#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTextObject : LTAnnRectangleObject <NSCoding, NSCopying>

@property (nonatomic, copy, nullable) NSString *text;

@property (nonatomic, assign)         LTAnnTextRotate textRotate;
@property (nonatomic, assign)         LTAnnHorizontalAlignment horizontalAlignment;
@property (nonatomic, assign)         LTAnnVerticalAlignment verticalAlignment;

@property (nonatomic, strong)         LTAnnBrush *textBackground;
@property (nonatomic, strong)         LTAnnBrush *textForeground;
@property (nonatomic, strong)         LTAnnThickness *padding;

@property (nonatomic, assign)         BOOL wordWrap;

@end

NS_ASSUME_NONNULL_END