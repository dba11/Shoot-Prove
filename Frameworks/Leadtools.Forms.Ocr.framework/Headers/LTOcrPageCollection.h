//
//  LTOcrPageCollection.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrAutoPreprocessPageCommand.h"
#import "LTOcrProgressData.h"
#import "LTOcrPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrPageCollection : NSObject <NSFastEnumeration>

@property (nonatomic, assign, readonly) NSUInteger count;

- (instancetype)init __unavailable;

- (LTOcrPage *)pageAtIndex:(NSUInteger)index;

- (NSInteger)indexOfPage:(LTOcrPage *)page;
- (BOOL)containsPage:(LTOcrPage *)page;

- (void)removeLastPage;
- (void)removeAllPages;
- (void)removePage:(LTOcrPage *)page;
- (void)removePageAtIndex:(NSUInteger)index;

- (LTOcrPage *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(LTOcrPage *)page atIndexedSubscript:(NSUInteger)index;

- (void)enumerateObjectsUsingBlock:(void (^)(LTOcrPage *page, NSUInteger idx, BOOL *stop))block;

@end



@interface LTOcrPageCollection (AddPages)

- (BOOL)addPage:(LTOcrPage *)page error:(NSError **)error;
- (BOOL)insertPage:(LTOcrPage *)page atIndex:(NSUInteger)index error:(NSError **)error;

- (nullable LTOcrPage *)addPageWithImage:(LTRasterImage *)image error:(NSError **)error;
- (nullable LTOcrPage *)addPageWithStream:(LTLeadStream *)stream error:(NSError **)error;
- (nullable LTOcrPage *)addPageWithFile:(NSString *)fileName error:(NSError **)error;
- (nullable LTOcrPage *)addPageWithData:(NSData *)data error:(NSError **)error;

- (BOOL)addPagesWithImage:(LTRasterImage *)image inRange:(NSRange)range error:(NSError **)error;
- (BOOL)addPagesWithStream:(LTLeadStream *)stream inRange:(NSRange)range error:(NSError **)error;
- (BOOL)addPagesWithFile:(NSString *)fileName inRange:(NSRange)range error:(NSError **)error;
- (BOOL)addPagesWithData:(NSData *)data inRange:(NSRange)range error:(NSError **)error;

- (nullable LTOcrPage *)insertPageAtIndex:(NSUInteger)pageIndex image:(LTRasterImage *)image error:(NSError **)error;
- (nullable LTOcrPage *)insertPageAtIndex:(NSUInteger)pageIndex stream:(LTLeadStream *)stream error:(NSError **)error;
- (nullable LTOcrPage *)insertPageAtIndex:(NSUInteger)pageIndex file:(NSString *)fileName error:(NSError **)error;
- (nullable LTOcrPage *)insertPageAtIndex:(NSUInteger)pageIndex data:(NSData *)data error:(NSError **)error;

- (BOOL)insertPagesAtIndex:(NSUInteger)pageIndex image:(LTRasterImage *)image inRange:(NSRange)range error:(NSError **)error;
- (BOOL)insertPagesAtIndex:(NSUInteger)pageIndex stream:(LTLeadStream *)stream inRange:(NSRange)range error:(NSError **)error;
- (BOOL)insertPagesAtIndex:(NSUInteger)pageIndex file:(NSString *)fileName inRange:(NSRange)range error:(NSError **)error;
- (BOOL)insertPagesAtIndex:(NSUInteger)pageIndex data:(NSData *)data inRange:(NSRange)range error:(NSError **)error;

- (BOOL)movePage:(LTOcrPage *)page index:(NSInteger)index error:(NSError **)error;

@end



@interface LTOcrPageCollection (ExportPages)

- (nullable LTRasterImage *)exportPageAtIndex:(NSUInteger)pageIndex error:(NSError **)error;
- (nullable LTRasterImage *)exportPagesInRange:(NSRange)range error:(NSError **)error;

- (BOOL)exportPageAtIndex:(NSUInteger)pageIndex stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPixel:(NSUInteger)bitsPerPixel error:(NSError **)error;
- (BOOL)exportPageAtIndex:(NSUInteger)pageIndex file:(NSString *)fileName format:(LTRasterImageFormat)format bitsPerPixel:(NSUInteger)bitsPerPixel error:(NSError **)error;
- (BOOL)exportPageAtIndex:(NSUInteger)pageIndex data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPixel:(NSUInteger)bitsPerPixel error:(NSError **)error;

- (BOOL)exportPagesInRange:(NSRange)range stream:(LTLeadStream *)stream format:(LTRasterImageFormat)format bitsPerPixel:(NSUInteger)bitsPerPixel firstSavePageNumber:(NSUInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;
- (BOOL)exportPagesInRange:(NSRange)range file:(NSString *)fileName format:(LTRasterImageFormat)format bitsPerPixel:(NSUInteger)bitsPerPixel firstSavePageNumber:(NSUInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;
- (BOOL)exportPagesInRange:(NSRange)range data:(NSMutableData *)data format:(LTRasterImageFormat)format bitsPerPixel:(NSUInteger)bitsPerPixel firstSavePageNumber:(NSUInteger)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error;

@end



@interface LTOcrPageCollection (OCRPages)

- (BOOL)autoPreprocessPages:(LTOcrAutoPreprocessPageCommand)command progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (BOOL)autoPreprocessPages:(LTOcrAutoPreprocessPageCommand)command inRange:(NSRange)range progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;

- (BOOL)autoZonePages:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (BOOL)autoZonePagesInRange:(NSRange)range progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;

- (BOOL)recognizePages:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;
- (BOOL)recognizePagesInRange:(NSRange)range progress:(nullable LTOcrProgressHandler)progressHandler error:(NSError **)error;

@end



@interface LTOcrPageCollection (Deprecated)

- (nullable LTOcrPage *)addPageWithImage:(LTRasterImage*)image target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "addPageWithImage:error:");;
- (nullable LTOcrPage *)addPage:(LTLeadStream*)stream target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "addPageWithStream:error:");
- (void)addPageWithPage:(LTOcrPage*)page LT_DEPRECATED_USENEW(19_0, "addPage:error:");

- (BOOL)addPagesWithImage:(LTRasterImage*)image imageFirstPageNumber:(int)imageFirstPageNumber imageLastPageNumber:(int)imageLastPageNumber target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "addPagesWithImage:inRange:error:");
- (BOOL)addPages:(LTLeadStream*)stream imageFirstPageNumber:(int)imageFirstPageNumber imageLastPageNumber:(int)imageLastPageNumber target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "addPagesWithStream:inRange:error:");

- (nullable LTOcrPage *)insertPage:(int)pageIndex image:(LTRasterImage*)image target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "insertPageAtIndex:image:error:");
- (nullable LTOcrPage *)insertPage:(int)pageIndex stream:(LTLeadStream*)stream target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "insertPageAtIndex:stream:error:");

- (BOOL)insertPages:(int)pageIndex image:(LTRasterImage*)image imageFirstPageNumber:(int)imageFirstPageNumber imageLastPageNumber:(int)imageLastPageNumber target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "insertPagesAtIndex:image:inRange:error:");
- (BOOL)insertPages:(int)pageIndex stream:(LTLeadStream*)stream imageFirstPageNumber:(int)imageFirstPageNumber imageLastPageNumber:(int)imageLastPageNumber target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "insertPagesAtIndex:stream:inRange:error:");

- (nullable LTRasterImage *)exportPage:(int)pageIndex error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "exportPageAtIndex:error:");
- (nullable LTRasterImage *)exportPages:(int)firstPageIndex lastPageIndex:(int)lastPageIndex error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "exportPagesInRange:error:");

- (BOOL)exportPage:(int)pageIndex stream:(LTLeadStream*)stream format:(LTRasterImageFormat)format bitsPerPixel:(int)bitsPerPixel error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "exportPageAtIndex:stream:format:bitsPerPixel:error:");
- (BOOL)exportPages:(int)firstPageIndex lastPageIndex:(int)lastPageIndex stream:(LTLeadStream*)stream format:(LTRasterImageFormat)format bitsPerPixel:(int)bitsPerPixel firstSavePageNumber:(int)firstSavePageNumber pageMode:(LTCodecsSavePageMode)pageMode error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "exportPagesInRange:stream:format:bitsPerPixel:firstSavePageNumber:pageMode:error:");

- (BOOL)autoPreprocess:(LTOcrAutoPreprocessPageCommand)command target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "autoPreprocessPages:progress:error:");
- (BOOL)autoPreprocess:(LTOcrAutoPreprocessPageCommand)command firstPageIndex:(int)firstPageIndex lastPageIndex:(int)lastPageIndex target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "autoPreprocessPages:inRange:progress:error:");

- (BOOL)autoZone:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "autoZonePages:error:");
- (BOOL)autoZone:(int)firstPageIndex lastPageIndex:(int)lastPageIndex target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "autoZonePagesInRange:progress:error:");

- (BOOL)recognize:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "recognizePages:error:");
- (BOOL)recognize:(int)firstPageIndex lastPageIndex:(int)lastPageIndex target:(id)target selector:(SEL)selector error:(NSError **)error LT_DEPRECATED_USENEW(19_0, "recognizePagesInRange:progress:error:");

@end

NS_ASSUME_NONNULL_END