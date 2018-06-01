//
//  LTAnnLayer.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObservableCollection.h"

@class LTAnnLayer;
@class LTAnnLayerCollection;
@class LTAnnObjectCollection;

@interface LTAnnLayerCollection : LTAnnObservableCollection

@property (nonatomic, strong, readonly) LTAnnLayer *parent;

- (void)addLayer:(LTAnnLayer *)layer;

- (LTAnnLayer *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(LTAnnLayer *)object atIndexedSubscript:(NSUInteger)index;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnLayer : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign, getter=isVisible) BOOL visible;
                                        
@property (nonatomic, strong, readonly)         LTAnnLayer *parent;

@property (nonatomic, strong, readonly)         LTAnnObjectCollection *children;
@property (nonatomic, strong, readonly)         LTAnnLayerCollection *layers;

@property (nonatomic, strong, readonly)         NSString *name;
@property (nonatomic, strong, readonly)         NSString *layerId;

+ (instancetype)layerWithName:(NSString *)name;
+ (instancetype)create:(NSString *)name LT_DEPRECATED_USENEW(19_0, "layerWithName:");

@end
