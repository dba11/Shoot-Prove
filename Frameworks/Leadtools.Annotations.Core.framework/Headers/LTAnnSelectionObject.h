//
//  LTAnnSelectionObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleObject.h"
#import "LTAnnObjectCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnSelectionObject : LTAnnRectangleObject <NSCoding, NSCopying>

@property (nonatomic, strong, readonly) LTAnnObjectCollection *selectedObjects;
@property (nonatomic, strong)           LTAnnStroke *selectionStroke;

- (void)adjustBounds;

- (void)group:(NSString *)groupName;
- (void)ungroup:(NSString *)groupName;

- (void)applyProperties;

@end

NS_ASSUME_NONNULL_END