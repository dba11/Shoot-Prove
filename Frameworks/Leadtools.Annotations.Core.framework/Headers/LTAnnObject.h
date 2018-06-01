//
//  LTAnnObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnFont.h"
#import "LTAnnStroke.h"
#import "LTAnnLabel.h"
#import "LTAnnCodecs.h"
#import "LTLeadPointCollection.h"

NS_ASSUME_NONNULL_BEGIN

@class LTAnnContainerMapper;
@protocol LTIAnnObjectRenderer;

@interface LTAnnObject : NSObject <NSCoding, NSCopying> // ABSTRACT

@property (nonatomic, assign, readonly) BOOL supportsFill;
@property (nonatomic, assign, readonly) BOOL supportsStroke;
@property (nonatomic, assign, readonly) BOOL supportsFont;
@property (nonatomic, assign, readonly) BOOL isLocked;
@property (nonatomic, assign, readonly) BOOL canRotate;
@property (nonatomic, assign, readonly) BOOL hitTestInterior;
@property (nonatomic, assign)           BOOL isSelected;
@property (nonatomic, assign)           BOOL isVisible;

@property (nonatomic, assign, readonly) LeadRectD bounds;
@property (nonatomic, assign)           LeadPointD rotateCenter;
@property (nonatomic, assign)           LeadLengthD rotateGripper;

@property (nonatomic, assign)           double opacity;

@property (nonatomic, assign)           NSInteger iD;
@property (nonatomic, assign)           NSInteger lockedPicture;

@property (nonatomic, strong, nullable) LTAnnFont *font;
@property (nonatomic, strong, nullable) LTAnnStroke *stroke;
@property (nonatomic, strong, nullable) LTAnnBrush *fill;
@property (nonatomic, strong, nullable) LTAnnLayer *layer;

@property (nonatomic, copy, readonly)   NSString *friendlyName;
@property (nonatomic, copy, nullable)   NSString *groupName;
@property (nonatomic, copy, nullable)   NSString *password;
@property (nonatomic, copy, nullable)   NSString *hyperlink;
@property (nonatomic, copy, nullable)   NSString *userId;
@property (nonatomic, copy, nullable)   NSString *stateId;

@property (nonatomic, assign)           LTAnnFixedStateOperations fixedStateOperation;

@property (nonatomic, strong, readonly) LTLeadPointCollection *points;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, LTAnnLabel *> *labels;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> *metadata;

@property (nonatomic, strong, nullable) NSObject *tag;

- (void)lock:(nullable NSString *)password;
- (void)unlock:(nullable NSString *)password;

- (void)scaleX:(double)scaleX y:(double)scaleY atPoint:(LeadPointD)origin;
- (void)translateOffsetX:(double)offsetX offsetY:(double)offsetY;
- (void)rotateWithAngle:(double)angle atPoint:(LeadPointD)origin;
- (void)normalize;

- (BOOL)hitTest:(LeadPointD)point buffer:(double)buffer;

- (void)serializeOptions:(LTAnnSerializeOptions *)options toNode:(DDXMLElement *)parentNode document:(nullable DDXMLDocument *)document;
- (void)deserializeOptions:(LTAnnDeserializeOptions *)options fromNode:(DDXMLElement *)element document:(nullable DDXMLDocument *)document;

- (void)scaleVectorScaleX:(double)scaleX scaleY:(double)scaleY unitVectorX:(LeadPointD)unitVectorX unitVectorY:(LeadPointD)unitVectorY centerPoint:(LeadPointD)centerPoint;

- (LeadRectD)getInvalidateRectMapper:(LTAnnContainerMapper *)mapper renderer:(id<LTIAnnObjectRenderer>)renderer;
 
@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnObject(ObjectIDs)

+ (NSInteger)none;
+ (NSInteger)groupObjectId;
+ (NSInteger)selectObjectId;
+ (NSInteger)lineObjectId;
+ (NSInteger)rectangleObjectId;
+ (NSInteger)ellipseObjectId;
+ (NSInteger)polylineObjectId;
+ (NSInteger)polygonObjectId;
+ (NSInteger)curveObjectId;
+ (NSInteger)closedCurveObjectId;
+ (NSInteger)pointerObjectId;
+ (NSInteger)freehandObjectId;
+ (NSInteger)hiliteObjectId;
+ (NSInteger)textObjectId;
+ (NSInteger)textRollupObjectId;
+ (NSInteger)textPointerObjectId;
+ (NSInteger)noteObjectId;
+ (NSInteger)stampObjectId;
+ (NSInteger)rubberStampObjectId;
+ (NSInteger)hotspotObjectId;
+ (NSInteger)freehandHotspotObjectId;
+ (NSInteger)buttonObjectId;
+ (NSInteger)pointObjectId;
+ (NSInteger)redactionObjectId;
+ (NSInteger)rulerObjectId;
+ (NSInteger)polyRulerObjectId;
+ (NSInteger)protractorObjectId;
+ (NSInteger)crossProductObjectId;
+ (NSInteger)encryptObjectId;
+ (NSInteger)audioObjectId;
+ (NSInteger)richTextObjectId;
+ (NSInteger)mediaObjectId;
+ (NSInteger)imageObjectId;
+ (NSInteger)userObjectId;

@end

NS_ASSUME_NONNULL_END