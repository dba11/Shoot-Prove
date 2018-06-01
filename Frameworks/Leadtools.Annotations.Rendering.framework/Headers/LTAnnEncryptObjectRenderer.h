//
//  LTAnnEncryptObjectRenderer.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnEncryptObjectRenderer.h"
#import "LTAnnRectangleObjectRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnEncryptObjectRenderer : LTAnnRectangleObjectRenderer

@property (nonatomic, assign, readonly) BOOL showAtRunMode;

- (void)renderMapper:(LTAnnContainerMapper *)mapper object:(LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END