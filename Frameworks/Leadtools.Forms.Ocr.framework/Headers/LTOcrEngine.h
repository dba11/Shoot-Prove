//
//  LTOcrEngine.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrEngineType.h"
#import "LTOcrImageSharingMode.h"
#import "LTOcrStatistic.h"
#import "LTOcrPage.h"

#import "LTOcrSettingManager.h"
#import "LTOcrLanguageManager.h"
#import "LTOcrSpellCheckManager.h"
#import "LTOcrZoneManager.h"
#import "LTOcrDocumentManager.h"
#import "LTOcrAutoRecognizeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrEngine : NSObject

@property (nonatomic, assign, readonly)           BOOL isStarted;

@property (nonatomic, assign, readonly)           LTOcrEngineType engineType;

@property (nonatomic, copy, readonly, nullable)   NSString *workDirectory;

@property (nonatomic, strong, readonly, nullable) LTOcrStatistic *lastStatistic;

@property (nonatomic, strong, readonly)           LTRasterCodecs *rasterCodecsInstance;
@property (nonatomic, strong, readonly)           LTDocumentWriter *documentWriterInstance;
@property (nonatomic, strong, readonly)           LTOcrSettingManager *settingManager;
@property (nonatomic, strong, readonly)           LTOcrLanguageManager *languageManager;
@property (nonatomic, strong, readonly)           LTOcrSpellCheckManager *spellCheckManager;
@property (nonatomic, strong, readonly)           LTOcrZoneManager *zoneManager;
@property (nonatomic, strong, readonly)           LTOcrDocumentManager *documentManager;
@property (nonatomic, strong, readonly)           LTOcrAutoRecognizeManager *autoRecognizeManager;

- (instancetype)init __unavailable;

- (BOOL)startup:(nullable LTRasterCodecs *)rasterCodecs documentWriter:(nullable LTDocumentWriter *)documentWriter workDirectory:(nullable NSString *)workDirectory engineDirectory:(nullable NSString *)engineDirectory error:(NSError **)error;
- (BOOL)startup:(nullable LTRasterCodecs *)rasterCodecs workDirectory:(nullable NSString *)workDirectory startupParameters:(nullable NSString *)startupParameters error:(NSError **)error;

- (void)shutdown;

- (nullable LTOcrPage *)createPage:(LTRasterImage *)image sharingMode:(LTOcrImageSharingMode)sharingMode error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END