//
//  LTAnnTextObjectRenderer.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleObjectRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTextObjectRenderer : LTAnnRectangleObjectRenderer

@property (nonatomic, assign) BOOL flipReverseText;

- (CGSize)getTextSize:(NSString *)text font:(LTAnnFont *)annFont rect:(LeadRectD)rect;

- (void)renderMapper:(LTAnnContainerMapper *)mapper object : (LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END