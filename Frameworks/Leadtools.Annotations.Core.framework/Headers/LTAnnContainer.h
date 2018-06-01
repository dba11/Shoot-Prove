//
//  LTAnnContainer.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnSelectionObject.h"
#import "LTAnnContainerMapper.h"
#import "LTAnnResources.h"
#import "LTAnnLayer.h"
#import "LTAnnGroupsRoles.h"
#import "LTEnums.h"

typedef NS_ENUM(NSInteger, LTAnnResizeMode) {
   LTAnnResizeModeFit       = 0,
   LTAnnResizeModeFitAlways = 1,
   LTAnnResizeModeFitWidth  = 2,
   LTAnnResizeModeFitHeight = 3,
   LTAnnResizeModeStretch   = 4,
};

typedef NS_ENUM(NSUInteger, LTAnnResizeContainerFlags) {
   LTAnnResizeContainerFlagsNone          = 0, // Resize container only
   LTAnnResizeContainerFlagsResizeObjects = 1, // Resize container and scaleObjets
   LTAnnResizeContainerFlagsAutoCalibrate = 2, // Calibrate rulers by setting the calibration in mapper
};

NS_ASSUME_NONNULL_BEGIN

extern NSString *const  LTAnnContainerAddObjectNotification;
extern NSString *const  LTAnnContainerRemoveObjectNotification;

extern NSString *const  LTAnnContainerObjectsKey;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnContainer : NSObject <NSCopying>

@property (nonatomic, assign)           BOOL isVisible;
@property (nonatomic, assign)           BOOL isEnabled;

@property (nonatomic, assign)           NSUInteger pageNumber;

@property (nonatomic, assign)           double hitTestBuffer;

@property (nonatomic, assign)           LeadSizeD size;
@property (nonatomic, assign)           LeadPointD offset;

@property (nonatomic, assign)           LTAnnUserMode userMode;
@property (nonatomic, assign)           LTAnnHitTestBehavior hitTestBehavior;

@property (nonatomic, strong)           LTAnnResources *resources;
@property (nonatomic, strong, nullable) LTAnnBrush *fill;
@property (nonatomic, strong, nullable) LTAnnStroke *stroke;
@property (nonatomic, strong, nullable) LTAnnLayer *activeLayer;

@property (nonatomic, copy)             NSString *userData;
@property (nonatomic, copy, nullable)   NSString *stateId;

@property (nonatomic, strong, readonly) LTAnnObjectCollection *children;
@property (nonatomic, strong)           LTAnnLayerCollection *layers;
@property (nonatomic, strong, nullable) LTAnnSelectionObject *selectionObject; //(getter == nullable, setter == nonnull)
@property (nonatomic, strong, nullable) LTAnnGroupsRoles *groupsRoles;
@property (nonatomic, strong)           LTAnnContainerMapper *mapper; 

- (instancetype)init;
- (instancetype)initWithOffset:(LeadPointD)offset size:(LeadSizeD)size mapper:(LTAnnContainerMapper *)mapper;

- (nullable LTAnnObjectCollection *)hitTestPoint:(LeadPointD)point;
- (nullable LTAnnObjectCollection *)hitTestRect:(LeadRectD)rect;

- (BOOL)selectObject:(LTAnnObject *)annObject;
- (BOOL)unselectObject:(LTAnnObject *)annObject;

- (void)resize:(LeadSizeD)newSize flags:(LTAnnResizeContainerFlags)flags mode:(LTAnnResizeMode)mode;

@end



@interface LTAnnContainer (Deprecated)

- (instancetype)initOffset:(LeadPointD)offset size:(LeadSizeD)size mapper:(nullable LTAnnContainerMapper *)mapper LT_DEPRECATED_USENEW(19_0, "-initWithOffset:size:mapper");

@end

NS_ASSUME_NONNULL_END