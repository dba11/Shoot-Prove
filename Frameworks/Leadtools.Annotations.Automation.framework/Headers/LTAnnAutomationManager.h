//
//  LTAnnAutomationManager.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnAutomationCollection.h"
#import "LTIAnnPackage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LTAnnClipboardDataCallback <NSObject>

- (void)annGetClipboardDataCallbackAutomation:(LTAnnAutomation *)automation position:(LeadPointD)postition format:(NSString *)format;
- (void)annSetClipboardDataCallbackAutomation:(LTAnnAutomation *)automation format:(NSString *)format data:(NSString *)data;

- (BOOL)annIsClipboardDataCallbackAutomation:(LTAnnAutomation *)automation format:(NSString *)format;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTPlatformCallbacks : NSObject

@property (nonatomic, weak, nullable) id<LTAnnCheckModifierCallback> checkModifier;
@property (nonatomic, weak, nullable) id<LTAnnClipboardDataCallback> clipboardDataDelegate;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnAutomationManager : NSObject

@property (nonatomic, assign)           NSInteger currentObjectId;

@property (nonatomic, assign)           NSUInteger thumbsHitTestBuffer;
@property (nonatomic, assign)           NSUInteger runHitTestBuffer;
@property (nonatomic, assign)           NSUInteger thumbsGap;

@property (nonatomic, assign)           BOOL editObjectAfterDraw;
@property (nonatomic, assign)           BOOL cancelInactiveDesigners;
@property (nonatomic, assign)           BOOL maintainAspectRatio;
@property (nonatomic, assign)           BOOL showThumbs;

@property (nonatomic, strong, readonly) LTAnnAutomations *automations;
@property (nonatomic, strong, readonly) LTAnnAutomationObjects *objects;

@property (nonatomic, assign)           LTAnnUserMode userMode;
@property (nonatomic, assign)           LTAnnRubberStampType currentRubberStampType;
@property (nonatomic, assign)           LTAnnHitTestBehavior hitTestBehavior;

@property (nonatomic, strong, nullable) LTAnnGroupsRoles *groupsRoles;
@property (nonatomic, strong, nullable) LTAnnRenderingEngine *renderingEngine;

@property (nonatomic, copy, nullable)   NSString *redactionRealizePassword;

- (instancetype)initWithEngine:(LTAnnRenderingEngine *)engine;

+ (LTPlatformCallbacks *)platform;

- (void)createDefaultObjects;

- (nullable LTAnnAutomationObject *)findObjectById:(NSInteger)iD;
- (nullable LTAnnAutomationObject *)findObject:(LTAnnObject *)annObject;

- (void)loadPackage:(id<LTIAnnPackage>)pack groupName:(NSString *)groupName;

@end

NS_ASSUME_NONNULL_END