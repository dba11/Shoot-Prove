//
//  LTAnnContainerCollection.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnContainer.h"
#import "LTAnnObservableCollection.h"
#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnContainerCollection : LTAnnObservableCollection

- (void)addContainerObject:(LTAnnContainer *)container;

- (LTAnnContainer *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(LTAnnContainer *)object atIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END