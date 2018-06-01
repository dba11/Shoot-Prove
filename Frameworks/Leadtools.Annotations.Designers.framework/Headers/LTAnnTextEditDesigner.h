//
//  LTAnnTextEditDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnEditDesigner.h"
#import "LTAnnRectangleEditDesigner.h"

@class LTAnnEditTextEventArgs, LTAnnTextEditDesigner;

NS_ASSUME_NONNULL_BEGIN

@protocol LTAnnTextEditDesignerDelegate<NSObject>

@optional
- (void)textEditDesigner:(LTAnnTextEditDesigner *)designer editWithArgs:(LTAnnEditTextEventArgs *)args;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnTextEditDesigner : LTAnnRectangleEditDesigner

@property (nonatomic, weak, nullable) id<LTAnnTextEditDesignerDelegate> editTextDelegate;

@property (nonatomic, assign)         BOOL acceptsReturn;
@property (nonatomic, assign)         BOOL autoSizeAfterEdit;

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnTextObject *)annObject;

@end

NS_ASSUME_NONNULL_END