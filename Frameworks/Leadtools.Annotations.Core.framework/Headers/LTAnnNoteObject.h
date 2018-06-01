//
//  LTAnnNoteObject.h
//  Leadtools.Annotations.Core
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnTextObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnNoteObject : LTAnnTextObject <NSCoding, NSCopying>

@property (nonatomic, assign) LeadLengthD shadowBorderWidth;

@end

NS_ASSUME_NONNULL_END