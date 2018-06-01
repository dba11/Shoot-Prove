//
//  LTAnnRenderingEngine.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnContainer.h"
#import "LTAnnResources.h"
#import "LTAnnPicture.h"

@class LTAnnRenderingEngine;
@protocol LTIAnnLabelRenderer;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnLoadPictureEventArgs : NSObject

@property (nonatomic, strong, readonly, nullable) LTAnnPicture *picture;
@property (nonatomic, strong, readonly, nullable) LTAnnObject *annObject;
@property (nonatomic, strong, readonly, nullable) LTAnnContainer *container;
@property (nonatomic, strong, readonly, nullable) NSError *error;

- (instancetype)initWithPicture:(nullable LTAnnPicture *)picture object:(nullable LTAnnObject *)annObject container:(nullable LTAnnContainer *)container error:(nullable NSError *)error NS_DESIGNATED_INITIALIZER;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@protocol LTAnnRenderingEngineDelegate <NSObject>
@optional
- (void)renderingEngine:(LTAnnRenderingEngine *)engine didLoadPicture:(LTAnnLoadPictureEventArgs *)args;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnRenderingEngine : NSObject

@property (nonatomic, weak, nullable)                       id<LTAnnRenderingEngineDelegate> delegate;

@property (nonatomic, assign, readonly, getter=isStateless) BOOL stateless;

@property (nonatomic, assign, readonly)                     LeadRectD clipRectangle;

@property (nonatomic, strong, readonly, nullable)           LTAnnContainer *container;
@property (nonatomic, strong, readonly, nullable)           LTAnnResources *resources;

@property (nonatomic, strong)                               LTAnnStroke *loadingPictureStroke;
@property (nonatomic, strong)                               LTAnnBrush *loadingPictureFill;

@property (nonatomic, strong)                               NSMutableDictionary<NSNumber *, id<LTIAnnObjectRenderer>> *renderers;

- (void)render:(LeadRectD)rect clear:(BOOL)clear;
- (void)renderContainer:(LTAnnContainer *)container rect:(LeadRectD)rect burn:(BOOL)doBurn;
- (void)renderLayer:(LTAnnLayer *)layer clientRect:(LeadRectD)clientRect rect:(LeadRectD)rect container:(LTAnnContainer *)container burn:(BOOL)doBurn;
- (void)renderLayers:(LTAnnLayerCollection *)layers clientRect:(LeadRectD)clientRect rect:(LeadRectD)rect container:(LTAnnContainer *)container burn:(BOOL)doBurn;

- (void)burn;
- (void)burnToRect:(LeadRectD)destinationRect;
- (void)burnToRectWithDpi:(LeadRectD)destinationRect sourceDpiX:(double)sourceDpiX sourceDpiY:(double)sourceDpiY targetDpiX:(double)targetDpiX targetDpiY:(double)targetDpiY;

- (void)attachContainer:(LTAnnContainer *)container;
- (void)detach;

+ (id<LTIAnnLabelRenderer>)containerLabelRenderer;
+ (void)setContainerLabelRenderer:(id<LTIAnnLabelRenderer>)labelRenderer;

- (LeadSizeD)measureString:(NSString *)text font:(LTAnnFont *)font; // ABSTRACT METHOD

- (void)onLoadPicture:(LTAnnLoadPictureEventArgs *)args;

@end

NS_ASSUME_NONNULL_END

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */