//
//  LTAnnCodecs.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"
#import "LTAnnObject.h"
#import "LTAnnLayer.h"
#import "DDXML.h"

@class LTAnnCodecsInfo, LTAnnObject, LTAnnContainer;
@protocol LTAnnSerializeObjectDelegate, LTAnnDeserializeObjectDelegate;

typedef NS_ENUM(NSInteger, LTAnnFormat){
   LTAnnFormatUnknown,
   LTAnnFormatAnnotations,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnSerializeOptions : NSObject

@property (nonatomic, assign)         BOOL saveLockPassword;

@property (nonatomic, weak, nullable) id<LTAnnSerializeObjectDelegate> delegate;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnDeserializeOptions : NSObject

@property (nonatomic, weak, nullable) id<LTAnnDeserializeObjectDelegate> delegate;

@end

 /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
@interface LTAnnCodecs : NSObject

@property (nonatomic, strong) LTAnnSerializeOptions *serializeOptions;
@property (nonatomic, strong) LTAnnDeserializeOptions *deserializeOptions;

- (nullable LTAnnContainer *)loadFromXmlDocument:(DDXMLDocument *)document pageNumber:(NSUInteger)pageNumber;
- (nullable LTAnnContainer *)loadXmlData:(NSString *)xmlData pageNumber:(NSUInteger)pageNumber;

- (LTAnnCodecsInfo *)getInfoFromXmlDocument:(DDXMLDocument *)document;
- (LTAnnCodecsInfo *)getInfo:(NSString *)xmlData;

- (NSString *)saveContainer:(LTAnnContainer *)container format:(LTAnnFormat)format data:(nullable NSString *)xmlData savePageNumber:(NSUInteger)savePageNumber;

- (void)saveInStream:(NSOutputStream *)stream layer:(LTAnnLayer *)layer format:(LTAnnFormat)format savePageNumber:(NSUInteger)savePageNumber;
- (void)saveInFile:(NSString *)fileName layer:(LTAnnLayer *)layer format:(LTAnnFormat)format savePageNumber:(NSUInteger)savePageNumber;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnCodecsInfo : NSObject

@property (nonatomic, assign) LTAnnFormat format;

@property (nonatomic, assign) double version;

@property (nonatomic, strong) NSArray<NSNumber *> *pages;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnSerializeObjectEventArgs : NSObject

@property (nonatomic, strong, readonly)           NSString *typeName;
@property (nonatomic, strong, readonly, nullable) NSError *error;

@property (nonatomic, strong, nullable)           LTAnnObject *annObject;

@property (nonatomic, assign)                     BOOL skipObject;

- (instancetype)initWithTypeName:(NSString *)name annObject:(nullable LTAnnObject *)obj error:(nullable NSError *)error;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@protocol LTAnnSerializeObjectDelegate<NSObject>

- (void)serializeObject:(LTAnnSerializeOptions *)options args:(LTAnnSerializeObjectEventArgs *)args;

@end

@protocol LTAnnDeserializeObjectDelegate<NSObject>

- (void)deserializeObject:(LTAnnDeserializeOptions *)options args:(LTAnnSerializeObjectEventArgs *)args;
- (void)deserializeObjectError:(LTAnnDeserializeOptions *)options args:(LTAnnSerializeObjectEventArgs *)args;
                         
@end

NS_ASSUME_NONNULL_END