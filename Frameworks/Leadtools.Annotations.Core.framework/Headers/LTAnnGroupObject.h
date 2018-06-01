//
//  LTAnnGroupObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleObject.h"
#import "LTAnnObjectCollection.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const  LTAnnGroupObjectAddObjectNotification;
extern NSString *const  LTAnnGroupObjectRemoveObjectNotification;

extern NSString *const  LTAnnGroupObjectObjectsKey;



@interface LTAnnGroupObject : LTAnnRectangleObject <NSCoding, NSCopying>

@property (nonatomic, strong, readonly) LTAnnObjectCollection *children;

@end

NS_ASSUME_NONNULL_END