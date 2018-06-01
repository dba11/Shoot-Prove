//
//  LTAnnDragDropEventArgs.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnDragDropEventArgs : NSObject

@property (nonatomic, strong) LTAnnObject *target;

@property (nonatomic, strong) LTAnnContainer *container;
@property (nonatomic, strong) LTAnnContainer *oldContainer;

@property (nonatomic, assign) BOOL cancel;

- (instancetype)initWithTarget:(LTAnnObject *)target oldContainer:(LTAnnContainer *)oldContainer newContainer:(LTAnnContainer *)newContainer;

@end

NS_ASSUME_NONNULL_END