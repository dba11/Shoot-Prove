//
//  LTAnnPicture.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPicture : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign)            BOOL isLoaded;
@property (nonatomic, assign)            BOOL isDirty;

@property (nonatomic, assign)            double width;
@property (nonatomic, assign)            double height;

@property (nonatomic, strong, readwrite) UIImage *internalData;
@property (nonatomic, copy, nullable)    NSString *pictureData;
@property (nonatomic, strong, nullable)  NSString *source;

+ (instancetype)emptyPicture;

- (instancetype)initWithSource:(NSString *)source;
- (instancetype)initWithData:(NSData *)pictureData;

@end

NS_ASSUME_NONNULL_END