//
//  LTAnnAutomationObject.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@class LTIAnnObjectRenderer, LTAnnObject;
@protocol LTIAnnObjectRenderer;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnAutomationObject : NSObject

@property (nonatomic, assign)           NSInteger iD;

@property (nonatomic, assign)           NSUInteger nextNumber;

@property (nonatomic, assign)           BOOL useRotateThumbs;

@property (nonatomic, assign)           Class drawDesignerType;
@property (nonatomic, assign)           Class editDesignerType;
@property (nonatomic, assign, nullable) Class runDesignerType;

@property (nonatomic, strong)           LTAnnObject *objectTemplate; 

@property (nonatomic, strong, nullable) id<LTIAnnObjectRenderer> renderer;

@property (nonatomic, copy)             NSString *name;
@property (nonatomic, copy, nullable)   NSString *groupName;
@property (nonatomic, copy, nullable)   NSString *labelTemplate;
@property (nonatomic, copy, nullable)   NSString *toolBarTipText;

@property (nonatomic, strong, nullable) NSObject *drawCursor;
@property (nonatomic, strong, nullable) NSObject *contextMenu;
@property (nonatomic, strong, nullable) NSObject *toolBarImage;
@property (nonatomic, strong, nullable) NSObject *userData;


- (instancetype)initWithId:(NSInteger)iD name:(NSString *)name drawDesigner:(Class)drawDesigner editDesigner:(Class)editDesigner template:(LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END