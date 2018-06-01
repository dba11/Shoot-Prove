//
//  LTAnnTextRollupObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnNoteObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTextRollupObject : LTAnnNoteObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL expanded;

@end

NS_ASSUME_NONNULL_END