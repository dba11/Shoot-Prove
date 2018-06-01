//
//  LTAnnAutomation.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnAutomationEventArgs.h"
#import "LTAnnObjectChangedEventArgs.h"
#import "LTAnnDragDropEventArgs.h"
#import "LTAnnAutomationUndoRedoObject.h"

@class LTAnnAutomation, LTAnnAutomationManager;
@protocol LTAnnAutomationControlDelegate, LTAnnEditDesignerDelegate, LTAnnDrawDesignerDelegate, LTAnnRunDesignerDelegate, LTAnnTextEditDesignerDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol LTAnnAutomationDelegate<NSObject>

@optional
- (void)automation:(LTAnnAutomation *)automation objectModified:(LTAnnObjectModifiedEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation beforeObjectChanged:(LTAnnBeforeObjectChangedEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation afterObjectChanged:(LTAnnAfterObjectChangedEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation lockWithArgs:(LTAnnLockObjectEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation unlockWithArgs:(LTAnnLockObjectEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation editWithArgs:(LTAnnEditDesignerEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation drawWithArgs:(LTAnnDrawDesignerEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation runWithArgs:(LTAnnRunDesignerEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation editTextWithArgs:(LTAnnEditTextEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation showContextMenu:(nullable LTAnnAutomationEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation showObjectProperties:(LTAnnAutomationEventArgs *)args;
- (void)automation:(LTAnnAutomation *)automation deserializeObjectError:(LTAnnSerializeObjectEventArgs *)args;
- (void)automationSelectedObjectChanged:(LTAnnAutomation *)automation;
- (void)automationUndoRedoChanged:(LTAnnAutomation *)automation;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnAutomation : NSObject <LTAnnAutomationControlDelegate, LTAnnEditDesignerDelegate, LTAnnDrawDesignerDelegate, LTAnnRunDesignerDelegate, LTAnnTextEditDesignerDelegate>

@property (nonatomic, weak, nullable)             id<LTAnnAutomationDelegate> delegate;
@property (nonatomic, strong, readonly)           NSObject<LTIAnnAutomationControl> *automationControl;

@property (nonatomic, strong, readonly)           LTAnnAutomationManager *manager;
@property (nonatomic, strong, readonly)           LTAnnContainer *container;

@property (nonatomic, strong, readonly, nullable) LTAnnDesigner *currentDesigner;
@property (nonatomic, strong, readonly, nullable) LTAnnObject *currentEditObject;

@property (nonatomic, strong, readonly)           LTAnnContainerCollection *containers;

@property (nonatomic, strong, readonly, nullable) LTAnnAutomationUndoRedoObject *undoRedoObject;

@property (nonatomic, assign)                     NSUInteger undoCapacity;

@property (nonatomic, assign, getter=isActive)    BOOL active;

@property (nonatomic, assign)                     BOOL enableDragDrop;

@property (nonatomic, assign, readonly)           BOOL canDeleteObjects;
@property (nonatomic, assign, readonly)           BOOL canUndo;
@property (nonatomic, assign, readonly)           BOOL canRedo;
@property (nonatomic, assign, readonly)           BOOL canLock;
@property (nonatomic, assign, readonly)           BOOL canUnlock;
@property (nonatomic, assign, readonly)           BOOL canSelectObjects;
@property (nonatomic, assign, readonly)           BOOL canShowProperties;
@property (nonatomic, assign, readonly)           BOOL canGroup;
@property (nonatomic, assign, readonly)           BOOL canUngroup;
@property (nonatomic, assign, readonly)           BOOL canCopy;
@property (nonatomic, assign, readonly)           BOOL canPaste;
@property (nonatomic, assign, readonly)           BOOL canBringToFront;
@property (nonatomic, assign, readonly)           BOOL canBringToFirst;
@property (nonatomic, assign, readonly)           BOOL canSendToBack;
@property (nonatomic, assign, readonly)           BOOL canSendToLast;
@property (nonatomic, assign, readonly)           BOOL canFlip;
@property (nonatomic, assign, readonly)           BOOL canResetRotatePoints;
@property (nonatomic, assign, readonly)           BOOL canShowObjectProperties;
@property (nonatomic, assign, readonly)           BOOL canShowObjectContextMenu;
@property (nonatomic, assign, readonly)           BOOL canSelectNone;

@property (nonatomic, assign, readonly)           BOOL canApplyDecryptor;
@property (nonatomic, assign, readonly)           BOOL canApplyEncryptor;
@property (nonatomic, assign, readonly)           BOOL canApplyAllDecryptors;
@property (nonatomic, assign, readonly)           BOOL canApplyAllEncryptors;

@property (nonatomic, assign, readonly)           BOOL canRealizeRedaction;
@property (nonatomic, assign, readonly)           BOOL canRestoreRedaction;
@property (nonatomic, assign, readonly)           BOOL canRealizeAllRedactions;
@property (nonatomic, assign, readonly)           BOOL canRestoreAllRedactions;

@property (nonatomic, assign, readonly)           BOOL canBringLayerToFront;
@property (nonatomic, assign, readonly)           BOOL canBringLayerToFirst;
@property (nonatomic, assign, readonly)           BOOL canSendLayerToBack;
@property (nonatomic, assign, readonly)           BOOL canSendLayerToLast;

- (instancetype)initWithManager:(LTAnnAutomationManager *)automationManager automationControl:(NSObject<LTIAnnAutomationControl> *)automationControl;
- (instancetype)init __unavailable;

- (void)attach:(NSObject<LTIAnnAutomationControl> *)automationControl;
- (void)detach;
- (void)cancel;

- (void)deleteSelectedObjects;

- (void)beginUndo;
- (void)endUndo;
- (void)cancelUndo;

- (void)undo;
- (void)redo;
- (void)lock;
- (void)unlock;

- (void)invalidate:(LeadRectD)rect;

- (void)selectObject:(nullable LTAnnObject *)annObject;
- (void)selectObjects:(nullable LTAnnObjectCollection *)objects;

- (void)setActiveContainer:(LTAnnContainer *)container;

- (void)applyEncryptor;
- (void)applyDecryptor;

- (void)copyObject;
- (void)pasteObject;
- (void)pasteObjectAtPoint:(LeadPointD)position;
- (void)pasteObject:(NSString *)objectData atPoint:(LeadPointD)position;

- (void)bringToFront:(BOOL)first;
- (void)sendToBack:(BOOL)last;

- (void)flip:(BOOL)horizontal;
- (void)resetRotatePoints;

- (void)applyAllEncryptors;
- (void)applyAllDecryptors;

- (void)showContextMenu;
- (void)showObjectContextMenu;
- (void)showObjectProperties;

- (void)realizeAllRedactions;
- (void)restoreAllRedactions;
- (void)realizeRedaction;
- (void)restoreRedaction;

- (void)addLayer:(LTAnnLayer *)parentLayer layer:(LTAnnLayer *)layer;
- (void)deleteLayer:(LTAnnLayer *)layer deleteChildren:(BOOL)deleteChildren;

- (nullable LTAnnLayer *)selectLayer:(nullable LTAnnLayer *)activeLayer;

- (void)sendLayerToBack:(BOOL)last;
- (void)bringLayerToFront:(BOOL)first;

- (LTAnnLayerCollection *)parentLayersForChild:(LTAnnLayer *)child;
- (LTAnnLayer *)layerFromSelectedObjects:(NSString *)layerName;

- (LeadRectD)invalidateRectForObject:(LTAnnObject *)annObject;
- (void)invalidateObject:(LTAnnObject *)annObject;

- (void)attachContainer:(nullable LTAnnContainer *)container undoRedo:(nullable LTAnnAutomationUndoRedoObject *)undoRedoObject;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnAutomation (Deprecated)

- (void)objectCopy LT_DEPRECATED_USENEW(19_0, "copyObject");
- (void)objectPaste LT_DEPRECATED_USENEW(19_0, "pasteObject");
- (void)objectPasteAt:(LeadPointD)position LT_DEPRECATED_USENEW(19_0, "pasteObjectAtPoint:");
- (void)objectPasteStringAt:(NSString *)data at:(LeadPointD)position LT_DEPRECATED_USENEW(19_0, "pasteObject:atPoint:");

- (LTAnnLayerCollection *)getParentLayers:(LTAnnLayer *)child LT_DEPRECATED_USENEW(19_0, "parentLayersForChild:");

- (LeadRectD)getObjectInvalidateRect:(LTAnnObject *)annObject LT_DEPRECATED_USENEW(19_0, "invalidateRectForObject:");

- (nullable LTAnnAutomationUndoRedoObject *)getUndoRedoObject LT_DEPRECATED_USENEW(19_0, "undoRedoObject");

@end

NS_ASSUME_NONNULL_END