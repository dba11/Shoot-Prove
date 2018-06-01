//
//  LTCodecsExtension.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LTCodecsExtensionListFlags) {
    LTCodecsExtensionListFlagsNone  = 0,
    LTCodecsExtensionListFlagsStamp = 0x0001,
    LTCodecsExtensionListFlagsAudio = 0x0002
};



@interface LTCodecsExtension : NSObject

@property (nonatomic, copy, readonly, nullable)   NSString *name;
@property (nonatomic, assign, readonly)           NSData *data;
@property (nonatomic, assign, readonly, nullable) NSUUID *clsid;
@property (nonatomic, assign, readonly)           unsigned char ucDefault;

@end



@interface LTCodecsExtensionList : NSObject

@property (nonatomic, assign, readonly)           LTCodecsExtensionListFlags flags;
@property (nonatomic, strong, readonly, nullable) NSArray<LTCodecsExtension *> *extensions;

- (nullable LTRasterImage *)createStamp:(NSError **)error;
- (nullable NSData *)getAudioData:(NSInteger)stream error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END