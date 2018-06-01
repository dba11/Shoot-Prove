//
//  LTAnnObjectCollection.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"
#import "LTAnnObservableCollection.h"
#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnObjectCollection : LTAnnObservableCollection

- (void)addAnnObject:(LTAnnObject *)obj;

- (LTAnnObject *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(LTAnnObject *)object atIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END