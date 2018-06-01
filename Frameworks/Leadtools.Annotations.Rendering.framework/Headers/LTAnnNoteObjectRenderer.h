//
//  LTAnnNoteObjectRenderer.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnTextObjectRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnNoteObjectRenderer : LTAnnTextObjectRenderer

- (void)renderMapper:(LTAnnContainerMapper *)mapper object:(LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END