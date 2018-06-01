//
//  LTRasterCodecs.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsImageInfo.h"
#import "LTCodecsOptions.h"
#import "LTCodecsLoadImageEventArgs.h"
#import "LTCodecsSaveImageEventArgs.h"
#import "LTCodecsLoadInformationEventArgs.h"
#import "LTCodecsPageEventArgs.h"
#import "LTCodecsEnumTagsEventArgs.h"
#import "LTCodecsEnumGeoKeysEventArgs.h"
#import "LTCompressDataCallback.h"
#import "LTCodecsStartDecompressOptions.h"
#import "LTCodecsRasterPdfInfo.h"
#import "LTCodecsExtension.h"
#import "LTCodecsOverlayData.h"
#import "LTCodecsThumbnailOptions.h"
#import "LTCodecsTransformMarkerCallback.h"
#import "LTCodecsLoadSvgOptions.h"	

@class LTRasterCodecs;

typedef NS_ENUM(NSInteger, LTCodecsFeedGetInformationStatus) {
    LTCodecsFeedGetInformationStatusMore,
    LTCodecsFeedGetInformationStatusFinished,
    LTCodecsFeedGetInformationStatusError
};

NS_ASSUME_NONNULL_BEGIN

@protocol LTRasterCodecsDelegate <NSObject>

@optional
- (void)rasterCodecsLoadInformation:(LTRasterCodecs *)codecs args:(LTCodecsLoadInformationEventArgs *)args;
- (void)rasterCodecsLoadPage:(LTRasterCodecs *)codecs args:(LTCodecsPageEventArgs *)args;
- (void)rasterCodecsLoadImage:(LTRasterCodecs *)codecs args:(LTCodecsLoadImageEventArgs *)args;
- (void)rasterCodecsSavePage:(LTRasterCodecs *)codecs args:(LTCodecsPageEventArgs *)args;
- (void)rasterCodecsSaveImage:(LTRasterCodecs *)codecs args:(LTCodecsSaveImageEventArgs *)args;

@end

@interface LTRasterCodecs : NSObject

@property (nonatomic, assign)         BOOL fastFileInfo;

@property (nonatomic, assign)         NSUInteger uriOperationBufferSize;

@property (nonatomic, weak, nullable) id<LTRasterCodecsDelegate> delegate;

@property (nonatomic, strong)         LTCodecsOptions *options;

@property (nonatomic, strong)         dispatch_queue_t asyncQueue; // Default is serial
@property (nonatomic, strong)         dispatch_group_t asyncGroup;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (ImageInformation)

- (nullable LTCodecsImageInfo *)imageInformationForFile:(NSString *)file totalPages:(BOOL)totalPages error:(NSError **)error;
- (nullable LTCodecsImageInfo *)imageInformationForFile:(NSString *)file totalPages:(BOOL)totalPages pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTCodecsRasterPdfInfo *)rasterPdfInfoForFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTCodecsImageInfo *)imageInformationForStream:(LTLeadStream *)stream totalPages:(BOOL)totalPages error:(NSError **)error;
- (nullable LTCodecsImageInfo *)imageInformationForStream:(LTLeadStream *)stream totalPages:(BOOL)totalPages pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTCodecsRasterPdfInfo *)rasterPdfInfoForStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTCodecsImageInfo *)imageInformationForData:(NSData *)data totalPages:(BOOL)totalPages error:(NSError **)error;
- (nullable LTCodecsImageInfo *)imageInformationForData:(NSData *)data totalPages:(BOOL)totalPages pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTCodecsRasterPdfInfo *)rasterPdfInfoForData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)imageInformationForFileAsync:(NSString *)file totalPages:(BOOL)totalPages completion:(void (^)(LTCodecsImageInfo * __nullable info, NSError * __nullable error))completion;
- (void)imageInformationForFileAsync:(NSString *)file totalPages:(BOOL)totalPages pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsImageInfo * __nullable info, NSError * __nullable error))completion;
- (void)rasterPdfInfoForFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsRasterPdfInfo * __nullable info, NSError * __nullable error))completion;

- (void)imageInformationForStreamAsync:(LTLeadStream *)stream totalPages:(BOOL)totalPages completion:(void (^)(LTCodecsImageInfo * __nullable info, NSError * __nullable error))completion;
- (void)imageInformationForStreamAsync:(LTLeadStream *)stream totalPages:(BOOL)totalPages pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsImageInfo * __nullable info, NSError * __nullable error))completion;
- (void)rasterPdfInfoForStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsRasterPdfInfo * __nullable info, NSError * __nullable error))completion;

- (void)imageInformationForDataAsync:(NSData *)data totalPages:(BOOL)totalPages completion:(void (^)(LTCodecsImageInfo * __nullable info, NSError * __nullable error))completion;
- (void)imageInformationForDataAsync:(NSData *)data totalPages:(BOOL)totalPages pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsImageInfo * __nullable info, NSError * __nullable error))completion;
- (void)rasterPdfInfoForDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsRasterPdfInfo * __nullable info, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (LTRasterImageFormat)formatOfFile:(NSString *)file error:(NSError **)error;
- (LTRasterImageFormat)formatOfStream:(LTLeadStream *)stream error:(NSError **)error;
- (LTRasterImageFormat)formatOfData:(NSData *)data error:(NSError **)error;

- (void)formatOfFileAsync:(NSString *)file completion:(void (^)(LTRasterImageFormat format, NSError * __nullable error))completion;
- (void)formatOfStreamAsync:(LTLeadStream *)stream completion:(void (^)(LTRasterImageFormat format, NSError * __nullable error))completion;
- (void)formatOfDataAsync:(NSData *)data completion:(void (^)(LTRasterImageFormat format, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable NSArray<NSValue/*CGSize*/ *> *)loadResolutionsForFile:(NSString *)file error:(NSError **)error;
- (nullable NSArray<NSValue/*CGSize*/ *> *)loadResolutionsForStream:(LTLeadStream *)stream error:(NSError **)error;
- (nullable NSArray<NSValue/*CGSize*/ *> *)loadResolutionsForData:(NSData *)data error:(NSError **)error;

- (nullable NSArray<NSValue/*CGSize*/ *> *)loadResolutionsForFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<NSValue/*CGSize*/ *> *)loadResolutionsForStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<NSValue/*CGSize*/ *> *)loadResolutionsForData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)loadResolutionsForFileAsync:(NSString *)file completion:(void (^)(NSArray<NSValue *> * __nullable resolutions, NSError * __nullable error))completion;
- (void)loadResolutionsForStreamAsync:(LTLeadStream *)stream completion:(void (^)(NSArray<NSValue *> * __nullable resolutions, NSError * __nullable error))completion;
- (void)loadResolutionsForDataAsync:(NSData *)data completion:(void (^)(NSArray<NSValue *> * __nullable resolutions, NSError * __nullable error))completion;

- (void)loadResolutionsForFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<NSValue *> * __nullable resolutions, NSError * __nullable error))completion;
- (void)loadResolutionsForStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<NSValue *> * __nullable resolutions, NSError * __nullable error))completion;
- (void)loadResolutionsForDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<NSValue *> * __nullable resolutions, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable LTCodecsExtensionList *)readExtensionsFromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTCodecsExtensionList *)readExtensionsFromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTCodecsExtensionList *)readExtensionsFromData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)readExtensionsFromFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsExtensionList * __nullable extensions, NSError * __nullable error))completion;
- (void)readExtensionsFromStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsExtensionList * __nullable extensions, NSError * __nullable error))completion;
- (void)readExtensionsFromDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(LTCodecsExtensionList * __nullable extensions, NSError * __nullable error))completion;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (FeedInformation)

@property (nonatomic, assign, readonly) BOOL isFeedGetInformationDone;

- (BOOL)startFeedGetInformation:(BOOL)totalPages pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTCodecsImageInfo *)stopFeedGetInformation:(NSError **)error;
- (void)cancelFeedGetInformation;

- (LTCodecsFeedGetInformationStatus)feedGetInformation:(const unsigned char *)buffer length:(NSUInteger)length error:(NSError **)error;
- (LTCodecsFeedGetInformationStatus)feedGetInformationData:(NSData *)data length:(NSUInteger)length error:(NSError **)error;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Load)

@property (nonatomic, assign, readonly) LTError loadStatus;

- (nullable LTRasterImage *)loadFile:(NSString *)file error:(NSError **)error;
- (nullable LTRasterImage *)loadFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTRasterImage *)loadFile:(NSString *)file bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;
- (nullable LTRasterImage *)loadFile:(NSString *)file tile:(LeadRect)tile bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;
- (nullable LTRasterImage *)loadFile:(NSString *)file width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel flags:(LTRasterSizeFlags)flags order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;

- (nullable LTRasterImage *)loadStream:(LTLeadStream *)stream error:(NSError **)error;
- (nullable LTRasterImage *)loadStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTRasterImage *)loadStream:(LTLeadStream *)stream bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;
- (nullable LTRasterImage *)loadStream:(LTLeadStream *)stream tile:(LeadRect)tile bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;
- (nullable LTRasterImage *)loadStream:(LTLeadStream *)stream width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel flags:(LTRasterSizeFlags)flags order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;

- (nullable LTRasterImage *)loadData:(NSData *)data error:(NSError **)error;
- (nullable LTRasterImage *)loadData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTRasterImage *)loadData:(NSData *)data bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;
- (nullable LTRasterImage *)loadData:(NSData *)data tile:(LeadRect)tile bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;
- (nullable LTRasterImage *)loadData:(NSData *)data width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel flags:(LTRasterSizeFlags)flags order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)loadFileAsync:(NSString *)file completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadFileAsync:(NSString *)file bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadFileAsync:(NSString *)file tile:(LeadRect)tile bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadFileAsync:(NSString *)file width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel flags:(LTRasterSizeFlags)flags order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

- (void)loadStreamAsync:(LTLeadStream *)stream completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadStreamAsync:(LTLeadStream *)stream bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadStreamAsync:(LTLeadStream *)stream tile:(LeadRect)tile bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadStreamAsync:(LTLeadStream *)stream width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel flags:(LTRasterSizeFlags)flags order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

- (void)loadDataAsync:(NSData *)data completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadDataAsync:(NSData *)data bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadDataAsync:(NSData *)data tile:(LeadRect)tile bitsPerPixel:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)loadDataAsync:(NSData *)data width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel flags:(LTRasterSizeFlags)flags order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable LTRasterImage *)readThumbnailFromFile:(NSString *)file options:(LTCodecsThumbnailOptions *)thumbnailOptions pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTRasterImage *)readStampFromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterImage *)readThumbnailFromStream:(LTLeadStream *)stream options:(LTCodecsThumbnailOptions *)thumbnailOptions pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTRasterImage *)readStampFromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterImage *)readThumbnailFromData:(NSData *)data options:(LTCodecsThumbnailOptions *)thumbnailOptions pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable LTRasterImage *)readStampFromData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)readThumbnailFromFileAsync:(NSString *)file options:(LTCodecsThumbnailOptions *)thumbnailOptions pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)readStampFromFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

- (void)readThumbnailFromStreamAsync:(LTLeadStream *)stream options:(LTCodecsThumbnailOptions *)thumbnailOptions pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)readStampFromStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

- (void)readThumbnailFromDataAsync:(NSData *)data options:(LTCodecsThumbnailOptions *)thumbnailOptions pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
- (void)readStampFromDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (BOOL)canLoadSvgFile:(NSString *)svgFile error:(NSError **)error;
- (BOOL)canLoadSvgData:(NSData *)svgData error:(NSError **)error;
- (BOOL)canLoadSvgStream:(LTLeadStream *)svgStream error:(NSError **)error;

- (BOOL)canLoadSvgFile:(NSString *)svgFile;
- (BOOL)canLoadSvgData:(NSData *)svgData;
- (BOOL)canLoadSvgStream:(LTLeadStream *)svgStream;

- (nullable id<ISvgDocument>)loadSvgFile:(NSString *)file page:(NSInteger)pageNumber options:(nullable LTCodecsLoadSvgOptions *)options error:(NSError **)error;
- (nullable id<ISvgDocument>)loadSvgData:(NSData *)data page:(NSInteger)pageNumber options:(nullable LTCodecsLoadSvgOptions *)options error:(NSError **)error;
- (nullable id<ISvgDocument>)loadSvgStream:(LTLeadStream *)stream page:(NSInteger)pageNumber options:(nullable LTCodecsLoadSvgOptions *)options error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)canLoadSvgFileAsync:(NSString *)svgFile completion:(void (^)(BOOL canLoadSvg, NSError * __nullable error))completion;
- (void)canLoadSvgDataAsync:(NSData *)svgData completion:(void (^)(BOOL canLoadSvg, NSError * __nullable error))completion;
- (void)canLoadSvgStreamAsync:(LTLeadStream *)svgStream completion:(void (^)(BOOL canLoadSvg, NSError * __nullable error))completion;

- (void)loadSvgFileAsync:(NSString *)file page:(NSInteger)pageNumber options:(nullable LTCodecsLoadSvgOptions *)options completion:(void (^)(id<ISvgDocument> __nullable svgDocument, NSError * __nullable error))completion;
- (void)loadSvgDataAsync:(NSData *)data page:(NSInteger)pageNumber options:(nullable LTCodecsLoadSvgOptions *)options completion:(void (^)(id<ISvgDocument> __nullable svgDocument, NSError * __nullable error))completion;
- (void)loadSvgStreamAsync:(LTLeadStream *)stream page:(NSInteger)pageNumber options:(nullable LTCodecsLoadSvgOptions *)options completion:(void (^)(id<ISvgDocument> __nullable svgDocument, NSError * __nullable error))completion;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (FeedLoad)

@property (nonatomic, assign, readonly) BOOL isFeedLoadDone;

- (BOOL)startFeedLoad:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order error:(NSError **)error;
- (BOOL)startFeedLoad:(NSInteger)bitsPerPixel order:(LTCodecsLoadByteOrder)order firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage error:(NSError **)error;
- (nullable LTRasterImage *)stopFeedLoad:(NSError **)error;
- (void)cancelFeedLoad;

- (BOOL)feedLoad:(const unsigned char *)buffer length:(NSUInteger)length error:(NSError **)error;
- (BOOL)feedLoadData:(NSData *)data length:(NSUInteger)length error:(NSError **)error;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Save)

- (BOOL)save:(LTRasterImage *)image file:(NSString *)file format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel error:(NSError **)error;
- (BOOL)save:(LTRasterImage *)image file:(NSString *)file format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;
- (BOOL)saveStamp:(LTRasterImage *)image file:(NSString *)file error:(NSError **)error;
- (BOOL)saveStamp:(LTRasterImage *)image file:(NSString *)file firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;

- (BOOL)save:(LTRasterImage *)image stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel error:(NSError **)error;
- (BOOL)save:(LTRasterImage *)image stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;
- (BOOL)saveStamp:(LTRasterImage *)image stream:(LTLeadStream *)stream error:(NSError **)error;
- (BOOL)saveStamp:(LTRasterImage *)image stream:(LTLeadStream *)stream firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;

- (BOOL)save:(LTRasterImage *)image data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel error:(NSError **)error;
- (BOOL)save:(LTRasterImage *)image data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;
- (BOOL)saveStamp:(LTRasterImage *)image data:(NSMutableData *)data error:(NSError **)error;
- (BOOL)saveStamp:(LTRasterImage *)image data:(NSMutableData *)data firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)saveAsync:(LTRasterImage *)image file:(NSString *)file format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveAsync:(LTRasterImage *)image file:(NSString *)file format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveStampAsync:(LTRasterImage *)image file:(NSString *)file completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveStampAsync:(LTRasterImage *)image file:(NSString *)file firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)saveAsync:(LTRasterImage *)image stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveAsync:(LTRasterImage *)image stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveStampAsync:(LTRasterImage *)image stream:(LTLeadStream *)stream completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveStampAsync:(LTRasterImage *)image stream:(LTLeadStream *)stream firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)saveAsync:(LTRasterImage *)image data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveAsync:(LTRasterImage *)image data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPixel:(NSInteger)bitsPerPixel firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveStampAsync:(LTRasterImage *)image data:(NSMutableData *)data completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)saveStampAsync:(LTRasterImage *)image data:(NSMutableData *)data firstPage:(NSInteger)firstPage lastPage:(NSInteger)lastPage firstSavePageNumber:(NSInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable error))completion;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Pages)

- (NSInteger)totalPagesInFile:(NSString *)file error:(NSError **)error;
- (NSInteger)totalPagesInStream:(LTLeadStream *)stream error:(NSError **)error;
- (NSInteger)totalPagesInData:(NSData *)data error:(NSError **)error;

- (void)totalPagesInFileAsync:(NSString *)file completion:(void (^)(NSInteger totalPages, NSError * __nullable error))completion;
- (void)totalPagesInStreamAsync:(LTLeadStream *)stream completion:(void (^)(NSInteger totalPages, NSError * __nullable error))completion;
- (void)totalPagesInDataAsync:(NSData *)data completion:(void (^)(NSInteger totalPages, NSError * __nullable error))completion;

- (BOOL)deletePageInFile:(NSString *)file page:(NSInteger)page error:(NSError **)error;
- (BOOL)deletePageInStream:(LTLeadStream *)stream page:(NSInteger)page error:(NSError **)error;
- (BOOL)deletePageInData:(NSData *)data page:(NSInteger)page error:(NSError **)error;

- (void)deletePageInFileAsync:(NSString *)file page:(NSInteger)page completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)deletePageInStreamAsync:(LTLeadStream *)stream page:(NSInteger)page completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)deletePageInDataAsync:(NSData *)data page:(NSInteger)page completion:(nullable void (^)(NSError * __nullable error))completion;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Convert)

- (BOOL)convertFile:(NSString *)srcFile destinationFile:(NSString *)dstFile format:(LTRasterImageFormat)format width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel error:(NSError **)error;

- (BOOL)convertStream:(LTLeadStream *)srcStream destinationStream:(LTLeadStream *)dstStream format:(LTRasterImageFormat)format width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel error:(NSError **)error;

- (BOOL)convertData:(NSData *)srcData destinationData:(NSMutableData *)dstData format:(LTRasterImageFormat)format width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)convertFileAsync:(NSString *)srcFile destinationFile:(NSString *)dstFile format:(LTRasterImageFormat)format width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)convertStreamAsync:(LTLeadStream *)srcStream destinationStream:(LTLeadStream *)dstStream format:(LTRasterImageFormat)format width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)convertDataAsync:(NSData *)srcData destinationData:(NSMutableData *)dstData format:(LTRasterImageFormat)format width:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel completion:(nullable void (^)(NSError * __nullable error))completion;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Compact)

- (BOOL)compactFile:(NSString *)sourceFile destinationFile:(NSString *)destinationFile pages:(NSUInteger)pages error:(NSError **)error;
- (BOOL)compactFile:(NSString *)sourceFile destinationFile:(NSString *)destinationFile pages:(NSUInteger)pages sourceStartPage:(NSInteger)sourceStartPage destinationStartPage:(NSInteger)destinationStartPage useSourceIFD:(BOOL)useSourceIFD sourceIFD:(NSInteger)sourceIFD useDestinationIFD:(BOOL)useDestinationIFD destinationIFD:(NSInteger)destinationIFD pageMode:(LTCodecsSavePageMode)pageMode noSubFileType:(BOOL)noSubFileType motorolaOrder:(BOOL)motorolaOrder bigTiff:(BOOL)bigTiff error:(NSError **)error;

- (BOOL)compactStream:(LTLeadStream *)sourceStream destinationStream:(LTLeadStream *)destinationStream pages:(NSUInteger)pages error:(NSError **)error;
- (BOOL)compactStream:(LTLeadStream *)sourceStream destinationStream:(LTLeadStream *)destinationStream pages:(NSUInteger)pages sourceStartPage:(NSInteger)sourceStartPage destinationStartPage:(NSInteger)destinationStartPage useSourceIFD:(BOOL)useSourceIFD sourceIFD:(NSInteger)sourceIFD useDestinationIFD:(BOOL)useDestinationIFD destinationIFD:(NSInteger)destinationIFD pageMode:(LTCodecsSavePageMode)pageMode noSubFileType:(BOOL)noSubFileType motorolaOrder:(BOOL)motorolaOrder bigTiff:(BOOL)bigTiff error:(NSError **)error;

- (BOOL)compactData:(NSData *)sourceData destinationData:(NSMutableData *)destinationData pages:(NSUInteger)pages error:(NSError **)error;
- (BOOL)compactData:(NSData *)sourceData destinationData:(NSMutableData *)destinationData pages:(NSUInteger)pages sourceStartPage:(NSInteger)sourceStartPage destinationStartPage:(NSInteger)destinationStartPage useSourceIFD:(BOOL)useSourceIFD sourceIFD:(NSInteger)sourceIFD useDestinationIFD:(BOOL)useDestinationIFD destinationIFD:(NSInteger)destinationIFD pageMode:(LTCodecsSavePageMode)pageMode noSubFileType:(BOOL)noSubFileType motorolaOrder:(BOOL)motorolaOrder bigTiff:(BOOL)bigTiff error:(NSError **)error;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Overlay)

- (BOOL)startOverlay:(nullable LTCodecsOverlayCallback)callback mode:(LTCodecsOverlayCallbackMode)mode error:(NSError **)error;
- (void)stopOverlay;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Metadata)

- (BOOL)enumerateTagsInFile:(NSString *)file pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumTagsEventArgs *tagInfo))handler error:(NSError **)error;
- (BOOL)enumerateGeoKeysInFile:(NSString *)file pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumGeoKeysEventArgs *geoKeyInfo))handler error:(NSError **)error;

- (BOOL)enumerateTagsInStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumTagsEventArgs *tagInfo))handler error:(NSError **)error;
- (BOOL)enumerateGeoKeysInStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumGeoKeysEventArgs *geoKeyInfo))handler error:(NSError **)error;

- (BOOL)enumerateTagsInData:(NSData *)data pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumTagsEventArgs *tagInfo))handler error:(NSError **)error;
- (BOOL)enumerateGeoKeysInData:(NSData *)data pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumGeoKeysEventArgs *geoKeyInfo))handler error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)enumerateTagsInFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumTagsEventArgs *tagInfo))handler completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)enumerateGeoKeysInFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumGeoKeysEventArgs *geoKeyInfo))handler completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)enumerateTagsInStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumTagsEventArgs *tagInfo))handler completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)enumerateGeoKeysInStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumGeoKeysEventArgs *geoKeyInfo))handler completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)enumerateTagsInDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumTagsEventArgs *tagInfo))handler completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)enumerateGeoKeysInDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber callback:(void (^)(LTCodecsEnumGeoKeysEventArgs *geoKeyInfo))handler completion:(nullable void (^)(NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable LTRasterTagMetadata *)readTag:(NSUInteger)tagId fromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readTagsFromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readTagsFromFile:(NSString *)file pageNumber:(NSInteger)pageNumber offsets:(NSMutableArray<NSNumber *> *)offsets error:(NSError **)error;
- (BOOL)writeTag:(nullable LTRasterTagMetadata *)tag toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeTags:(nullable NSArray<LTRasterTagMetadata *> *)tags toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)deleteTag:(NSUInteger)tagId fromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterTagMetadata *)readTag:(NSUInteger)tagId fromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readTagsFromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readTagsFromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber offsets:(NSMutableArray<NSNumber *> *)offsets error:(NSError **)error;
- (BOOL)writeTag:(nullable LTRasterTagMetadata *)tag toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeTags:(nullable NSArray<LTRasterTagMetadata *> *)tags toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)deleteTag:(NSUInteger)tagId fromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterTagMetadata *)readTag:(NSUInteger)tagId fromData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readTagsFromData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readTagsFromData:(NSData *)data pageNumber:(NSInteger)pageNumber offsets:(NSMutableArray<NSNumber *> *)offsets error:(NSError **)error;
- (BOOL)writeTag:(nullable LTRasterTagMetadata *)tag toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeTags:(nullable NSArray<LTRasterTagMetadata *> *)tags toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)deleteTag:(NSUInteger)tagId fromData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)readTagAsync:(NSUInteger)tagId fromFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterTagMetadata * __nullable tag, NSError * __nullable error))completion;
- (void)readTagsFromFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable tag, NSError * __nullable error))completion;
- (void)readTagsFromFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber offsets:(NSMutableArray<NSNumber *> *)offsets completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable tag, NSError * __nullable error))completion;
- (void)writeTagAsync:(nullable LTRasterTagMetadata *)tag toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeTagsAsync:(nullable NSArray<LTRasterTagMetadata *> *)tags toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)deleteTagAsync:(NSUInteger)tagId fromFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readTagAsync:(NSUInteger)tagId fromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterTagMetadata * __nullable tag, NSError * __nullable error))completion;
- (void)readTagsFromStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable tag, NSError * __nullable error))completion;
- (void)readTagsFromStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber offsets:(NSMutableArray<NSNumber *> *)offsets completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable tag, NSError * __nullable error))completion;
- (void)writeTagAsync:(nullable LTRasterTagMetadata *)tag toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeTagsAsync:(nullable NSArray<LTRasterTagMetadata *> *)tags toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)deleteTagAsync:(NSUInteger)tagId fromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readTagAsync:(NSUInteger)tagId fromData:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterTagMetadata * __nullable tag, NSError * __nullable error))completion;
- (void)readTagsFromDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable tag, NSError * __nullable error))completion;
- (void)readTagsFromDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber offsets:(NSMutableArray<NSNumber *> *)offsets completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable tag, NSError * __nullable error))completion;
- (void)writeTagAsync:(nullable LTRasterTagMetadata *)tag toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeTagsAsync:(nullable NSArray<LTRasterTagMetadata *> *)tags toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)deleteTagAsync:(NSUInteger)tagId fromData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable LTRasterTagMetadata *)readGeoKey:(NSUInteger)tagId fromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readGeoKeysFromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeGeoKey:(nullable LTRasterTagMetadata *)geoKey toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeGeoKeys:(nullable NSArray<LTRasterTagMetadata *> *)geoKeys toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterTagMetadata *)readGeoKey:(NSUInteger)tagId fromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readGeoKeysFromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeGeoKey:(nullable LTRasterTagMetadata *)geoKey toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeGeoKeys:(nullable NSArray<LTRasterTagMetadata *> *)geoKeys toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterTagMetadata *)readGeoKey:(NSUInteger)tagId fromData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (nullable NSArray<LTRasterTagMetadata *> *)readGeoKeysFromData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeGeoKey:(nullable LTRasterTagMetadata *)geoKey toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeGeoKeys:(nullable NSArray<LTRasterTagMetadata *> *)geoKeys toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)readGeoKeyAsync:(NSUInteger)tagId fromFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterTagMetadata * __nullable geoKey, NSError * __nullable error))completion;
- (void)readGeoKeysFromFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable geoKeys, NSError * __nullable error))completion;
- (void)writeGeoKeyAsync:(nullable LTRasterTagMetadata *)geoKey toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeGeoKeysAsync:(nullable NSArray<LTRasterTagMetadata *> *)geoKeys toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readGeoKeyAsync:(NSUInteger)tagId fromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterTagMetadata * __nullable geoKey, NSError * __nullable error))completion;
- (void)readGeoKeysFromStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable geoKeys, NSError * __nullable error))completion;
- (void)writeGeoKeyAsync:(nullable LTRasterTagMetadata *)geoKey toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeGeoKeysAsync:(nullable NSArray<LTRasterTagMetadata *> *)geoKeys toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readGeoKeyAsync:(NSUInteger)tagId fromData:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterTagMetadata * __nullable geoKey, NSError * __nullable error))completion;
- (void)readGeoKeysFromDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterTagMetadata *> * __nullable geoKeys, NSError * __nullable error))completion;
- (void)writeGeoKeyAsync:(nullable LTRasterTagMetadata *)geoKey toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeGeoKeysAsync:(nullable NSArray<LTRasterTagMetadata *> *)geoKeys toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable LTRasterCommentMetadata *)readCommentFromFile:(NSString *)file pageNumber:(NSInteger)pageNumber type:(LTRasterCommentMetadataType)type error:(NSError **)error;
- (nullable NSArray<LTRasterCommentMetadata *> *)readCommentsFromFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeComment:(nullable LTRasterCommentMetadata *)comment toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeComments:(nullable NSArray<LTRasterCommentMetadata *> *)comments toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterCommentMetadata *)readCommentFromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber type:(LTRasterCommentMetadataType)type error:(NSError **)error;
- (nullable NSArray<LTRasterCommentMetadata *> *)readCommentsFromStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeComment:(nullable LTRasterCommentMetadata *)comment toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeComments:(nullable NSArray<LTRasterCommentMetadata *> *)comments toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable LTRasterCommentMetadata *)readCommentFromData:(NSData *)data pageNumber:(NSInteger)pageNumber type:(LTRasterCommentMetadataType)type error:(NSError **)error;
- (nullable NSArray<LTRasterCommentMetadata *> *)readCommentsFromData:(NSData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeComment:(nullable LTRasterCommentMetadata *)comment toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeComments:(nullable NSArray<LTRasterCommentMetadata *> *)comments toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)readCommentFromFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber type:(LTRasterCommentMetadataType)type completion:(void (^)(LTRasterCommentMetadata * __nullable comment, NSError * __nullable error))completion;
- (void)readCommentsFromFileAsync:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterCommentMetadata *> * __nullable comments, NSError * __nullable error))completion;
- (void)writeCommentAsync:(nullable LTRasterCommentMetadata *)comment toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeCommentsAsync:(nullable NSArray<LTRasterCommentMetadata *> *)comments toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readCommentFromStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber type:(LTRasterCommentMetadataType)type completion:(void (^)(LTRasterCommentMetadata * __nullable comment, NSError * __nullable error))completion;
- (void)readCommentsFromStreamAsync:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterCommentMetadata *> * __nullable comments, NSError * __nullable error))completion;
- (void)writeCommentAsync:(nullable LTRasterCommentMetadata *)comment toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeCommentsAsync:(nullable NSArray<LTRasterCommentMetadata *> *)comments toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readCommentFromDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber type:(LTRasterCommentMetadataType)type completion:(void (^)(LTRasterCommentMetadata * __nullable comment, NSError * __nullable error))completion;
- (void)readCommentsFromDataAsync:(NSData *)data pageNumber:(NSInteger)pageNumber completion:(void (^)(NSArray<LTRasterCommentMetadata *> * __nullable comments, NSError * __nullable error))completion;
- (void)writeCommentAsync:(nullable LTRasterCommentMetadata *)comment toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeCommentsAsync:(nullable NSArray<LTRasterCommentMetadata *> *)comments toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable NSArray<LTRasterMarkerMetadata *> *)readMarkersFromFile:(NSString *)file error:(NSError **)error;
- (BOOL)writeMarker:(nullable LTRasterMarkerMetadata *)marker toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeMarkers:(nullable NSArray<LTRasterMarkerMetadata *> *)markers toFile:(NSString *)file pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable NSArray<LTRasterMarkerMetadata *> *)readMarkersFromStream:(LTLeadStream *)stream error:(NSError **)error;
- (BOOL)writeMarker:(nullable LTRasterMarkerMetadata *)marker toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeMarkers:(nullable NSArray<LTRasterMarkerMetadata *> *)markers toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber error:(NSError **)error;

- (nullable NSArray<LTRasterMarkerMetadata *> *)readMarkersFromData:(NSData *)data error:(NSError **)error;
- (BOOL)writeMarker:(nullable LTRasterMarkerMetadata *)marker toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)writeMarkers:(nullable NSArray<LTRasterMarkerMetadata *> *)markers toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)readMarkersFromFileAsync:(NSString *)file completion:(void (^)(NSArray<LTRasterMarkerMetadata *> * __nullable, NSError * __nullable error))completion;
- (void)writeMarkerAsync:(nullable LTRasterMarkerMetadata *)marker toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeMarkersAsync:(nullable NSArray<LTRasterMarkerMetadata *> *)markers toFile:(NSString *)file pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readMarkersFromStreamAsync:(LTLeadStream *)stream completion:(void (^)(NSArray<LTRasterMarkerMetadata *> * __nullable, NSError * __nullable error))completion;
- (void)writeMarkerAsync:(nullable LTRasterMarkerMetadata *)marker toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeMarkersAsync:(nullable NSArray<LTRasterMarkerMetadata *> *)markers toStream:(LTLeadStream *)stream pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

- (void)readMarkersFromDataAsync:(NSData *)data completion:(void (^)(NSArray<LTRasterMarkerMetadata *> * __nullable, NSError * __nullable error))completion;
- (void)writeMarkerAsync:(nullable LTRasterMarkerMetadata *)marker toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;
- (void)writeMarkersAsync:(nullable NSArray<LTRasterMarkerMetadata *> *)markers toData:(NSMutableData *)data pageNumber:(NSInteger)pageNumber completion:(nullable void (^)(NSError * __nullable error))completion;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Compression)

- (BOOL)startCompress:(NSInteger)width height:(NSInteger)height bitsPerPixel:(NSInteger)bitsPerPixel order:(LTRasterByteOrder)order viewPerspective:(LTRasterViewPerspective)viewPerspective inputDataLength:(NSUInteger)inputDataLength outputData:(unsigned char *)outputData outputDataLength:(NSUInteger)outputDataLength compression:(LTCodecsCompression)compression callback:(nullable LTCodecsCompressDataCallback)callback error:(NSError **)error;
- (BOOL)compress:(unsigned char *)data error:(NSError **)error;
- (void)stopCompress;

- (nullable NSObject *)startDecompress:(LTCodecsStartDecompressOptions *)decompressOptions error:(NSError **)error;
- (BOOL)decompress:(NSObject *)decompressContext data:(const unsigned char *)data
       dataOffset:(NSUInteger)dataOffset dataLength:(size_t)dataLength width:(NSInteger)width height:(NSInteger)height row:(NSInteger)row column:(NSInteger)column flags:(LTCodecsDecompressDataFlags)flags error:(NSError **)error;
- (nullable LTRasterImage *)stopDecompress:(NSObject *)decompressContext error:(NSError **)error;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (CMYK)

- (nullable LTRasterImage *)loadCmykPlanesFromFile:(NSString *)file bitsPerPixel:(NSInteger)bitsPerPixel pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)saveCmykPlanes:(LTRasterImage *)image file:(NSString *)file format:(LTRasterImageFormat)format bitsPerPlane:(NSInteger)bitsPerPlane pageNumber:(NSInteger)pageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;

- (nullable LTRasterImage *)loadCmykPlanesFromStream:(LTLeadStream *)stream bitsPerPixel:(NSInteger)bitsPerPixel pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)saveCmykPlanes:(LTRasterImage *)image stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPlane:(NSInteger)bitsPerPlane pageNumber:(NSInteger)pageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;

- (nullable LTRasterImage *)loadCmykPlanesFromData:(NSData *)data bitsPerPixel:(NSInteger)bitsPerPixel pageNumber:(NSInteger)pageNumber error:(NSError **)error;
- (BOOL)saveCmykPlanes:(LTRasterImage *)image data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPlane:(NSInteger)bitsPerPlane pageNumber:(NSInteger)pageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (void)loadCmykPlanesFromFileAsync:(NSString *)file bitsPerPixel:(NSInteger)bitsPerPixel pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable, NSError * __nullable))completion;
- (void)saveCmykPlanesAsync:(LTRasterImage *)image file:(NSString *)file format:(LTRasterImageFormat)format bitsPerPlane:(NSInteger)bitsPerPlane pageNumber:(NSInteger)pageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable))completion;

- (void)loadCmykPlanesFromStreamAsync:(LTLeadStream *)stream bitsPerPixel:(NSInteger)bitsPerPixel pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable, NSError * __nullable))completion;
- (void)saveCmykPlanesAsync:(LTRasterImage *)image stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPlane:(NSInteger)bitsPerPlane pageNumber:(NSInteger)pageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable))completion;

- (void)loadCmykPlanesFromDataAsync:(NSData *)data bitsPerPixel:(NSInteger)bitsPerPixel pageNumber:(NSInteger)pageNumber completion:(void (^)(LTRasterImage * __nullable, NSError * __nullable))completion;
- (void)saveCmykPlanesAsync:(LTRasterImage *)image data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPlane:(NSInteger)bitsPerPlane pageNumber:(NSInteger)pageNumber pageMode:(LTCodecsSavePageMode)pageMode completion:(nullable void (^)(NSError * __nullable))completion;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Support)

+ (NSString *)mimeTypeForFormat:(LTRasterImageFormat)format;
+ (NSString *)extensionForFormat:(LTRasterImageFormat)format;
+ (NSString *)mimeTypeForExtension:(NSString *)extension;
+ (NSString *)extensionForMimeType:(NSString *)mimeType;

+ (BOOL)formatSupportsMultipageSave:(LTRasterImageFormat)format;

+ (BOOL)tagsSupported:(LTRasterImageFormat)format;
+ (BOOL)geoKeysSupported:(LTRasterImageFormat)format;
+ (BOOL)commentsSupported:(LTRasterImageFormat)format;
+ (BOOL)markersSupported:(LTRasterImageFormat)format;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTRasterCodecs (Deprecated)

- (nullable LTCodecsImageInfo *)getInformation:(LTLeadStream *)stream totalPages:(BOOL)totalPages error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "imageInformationForStream:totalPages:error:");
- (nullable LTCodecsImageInfo *)getInformation:(LTLeadStream *)stream totalPages:(BOOL)totalPages pageNumber:(NSInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "imageInformationForStream:totalPages:pageNumber:error:");
- (nullable LTCodecsRasterPdfInfo *)getRasterPdfInfo:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "rasterPdfInfoForStream:pageNumber:error:");

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable NSArray *)readLoadResolutions:(LTLeadStream *)stream error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "loadResolutionsForStream:error:");

- (nullable LTRasterImage *)readThumbnail:(LTLeadStream *)stream options:(LTCodecsThumbnailOptions *)thumbnailOptions pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readThumbnailFromStream:options:pageNumber:error:");
- (nullable LTRasterImage *)readStamp:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readStampFromStream:pageNumber:error:");

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (BOOL)convert:(LTLeadStream *)srcStream destStream:(LTLeadStream *)dstStream format:(LTRasterImageFormat)format width:(NSUInteger)width height:(NSUInteger)height bitsPerPixel:(NSUInteger)bitsPerPixel info:(nullable LTCodecsImageInfo *)info error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "convert:destinationStream:format:width:height:bitsPerPixel:error:");

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (BOOL)deletePage:(LTLeadStream *)stream page:(NSUInteger)page error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "deletePageInStream:page:error:");

- (NSUInteger)getTotalPages:(LTLeadStream *)stream error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "totalPagesInStream:error:");

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable NSArray *)readMarkers:(LTLeadStream*)stream error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readMarkersFromStream:error:");

- (BOOL)enumTags:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "enumerateTagsInStream:pageNumber:callback:error:");
- (BOOL)EnumGeoKeys:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "enumerateGeoKeysInStream:pageNumber:callback:error:");

- (BOOL)deleteTag:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber tagId:(int)tagId error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "deleteTag:fromStream:pageNumber:error:");
- (nullable LTRasterTagMetadata *)readTag:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber tagId:(int)tagId error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readTag:fromStream:pageNumber:error:");
- (nullable NSArray *)readTags:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readTags:fromStream:pageNumber:error:");
- (nullable NSArray *)readTagsWithOffsets:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber offsets:(NSMutableArray *)offsets error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readTags:fromStream:pageNumber:offsets:error:");

- (nullable LTRasterTagMetadata *)readGeoKey:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber tagId:(int)tagId error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readGeoKey:fromStream:pageNumber:error:");
- (nullable NSArray *)readGeoKeys:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readGeoKeysFromStream:pageNumber:error:");

- (BOOL)writeTag:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber tag:(nullable LTRasterTagMetadata *)tag error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeTag:toStream:pageNumber:error:");
- (BOOL)writeTags:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber tags:(nullable NSArray *)tags error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeTags:toStream:pageNumber:error:");

- (BOOL)writeGeoKey:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber geoKey:(nullable LTRasterTagMetadata *)geoKey error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeGeoKey:toStream:pageNumber:error:");
- (BOOL)writeGeoKeys:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber geoKeys:(nullable NSArray *)geoKeys error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeGeoKeys:toStream:pageNumber:error:");

- (nullable LTRasterCommentMetadata *)readComment:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber type:(LTRasterCommentMetadataType)type error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readComment:fromStream:pageNumber:error:");
- (nullable NSArray *)readComments:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readComments:fromStream:pageNumber:error:");

- (BOOL)writeComment:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber comment:(nullable LTRasterCommentMetadata *)comment error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeComment:toStream:pageNumber:error:");
- (BOOL)writeComments:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber comments:(nullable NSArray *)comments error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeComments:toStream:pageNumber:error:");

- (BOOL)writeMarker:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber marker:(nullable LTRasterMarkerMetadata *)marker error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeMarker:toStream:pageNumber:error:");
- (BOOL)writeMarkers:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber markers:(nullable NSArray *)markers error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "writeMarkers:toStream:pageNumber:error:");

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable LTRasterImage *)loadCmykPlanes:(LTLeadStream *)stream bitsPerPixel:(NSUInteger)bitsPerPixel pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "loadCmykPlanesFromStream:bitsPerPixel:pageNumber:error:");

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (nullable LTCodecsExtensionList *)readExtensions:(LTLeadStream *)stream pageNumber:(NSUInteger)pageNumber error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "readExtensionsFromStream:pageNumber:error:");

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

+ (NSString *)getMimeType:(LTRasterImageFormat)format LT_DEPRECATED_USENEW(19_0, "mimeTypeForFormat:");

@end

NS_ASSUME_NONNULL_END