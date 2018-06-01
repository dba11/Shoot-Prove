//
//  LTAnnRunDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDesigner.h"

@class LTAnnRunDesigner, LTAnnRunDesignerEventArgs;

NS_ASSUME_NONNULL_BEGIN

@protocol LTAnnRunDesignerDelegate<NSObject>

@optional
- (void)runDesigner:(LTAnnRunDesigner *)designer runWithArgs:(LTAnnRunDesignerEventArgs *)args;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnRunDesigner : LTAnnDesigner

@property (nonatomic, weak, nullable) id<LTAnnRunDesignerDelegate> delegate;

@property (nonatomic, assign)         NSUInteger hitTestBuffer;

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END