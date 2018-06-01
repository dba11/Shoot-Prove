//
//  LTOcrAutoRecognizeJobData.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrAutoRecognizeJobData : NSObject

@property (nonatomic, copy)             NSString *imageFileName;
@property (nonatomic, copy)             NSString *documentFileName;
@property (nonatomic, copy, nullable)   NSString *zonesFileName;
@property (nonatomic, copy, nullable)   NSString *jobName;

@property (nonatomic, assign)           LTDocumentFormat format;

@property (nonatomic, assign)           NSInteger firstPageNumber;
@property (nonatomic, assign)           NSInteger lastPageNumber;

@property (nonatomic, strong, nullable) NSObject *userData;


- (instancetype)initWithImageFile:(NSString *)fileName format:(LTDocumentFormat)format documentFile:(NSString *)documentFile;
- (instancetype)initWithImageFile:(NSString *)fileName zonesFile:(nullable NSString *)zonesFile format:(LTDocumentFormat)format documentFile:(NSString *)documentFile;
- (instancetype)initWithImageFile:(NSString *)fileName firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage format:(LTDocumentFormat)format documentFile:(NSString *)documentFile;
- (instancetype)initWithImageFile:(NSString *)fileName firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage zonesFile:(nullable NSString *)zonesFile format:(LTDocumentFormat)format documentFile:(NSString *)documentFile NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END