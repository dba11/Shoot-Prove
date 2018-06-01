//
//  LTAnnLabel.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnBrush.h"
#import "LTAnnFont.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnLabel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign)         BOOL isVisible;
@property (nonatomic, assign)         BOOL isRestricted;

@property (nonatomic, assign)         LeadPointD originalPosition;
@property (nonatomic, assign)         LeadPointD offset;

@property (nonatomic, strong)         LTAnnFont *font;
@property (nonatomic, strong)         LTAnnBrush *textBackground;
@property (nonatomic, strong)         LTAnnBrush *textForeground;

@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, copy)           NSString *stateId;

@end

NS_ASSUME_NONNULL_END