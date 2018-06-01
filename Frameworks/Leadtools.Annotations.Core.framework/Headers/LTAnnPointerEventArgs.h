//
//  LTAnnPointerEventArgs.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPointerEventArgs : NSObject

@property (nonatomic, assign) LTAnnMouseButtons button;
@property (nonatomic, assign) LeadPointD location;

- (instancetype)initWithButton:(LTAnnMouseButtons)button location:(LeadPointD)location NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END