//
//  LTAnnEncryptObject.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"
#import "LTAnnRectangleObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnEncryptObject : LTAnnRectangleObject <NSCoding, NSCopying>

@property (nonatomic, assign)           BOOL resetKeyIfApplied;
@property (nonatomic, assign)           BOOL serializeKeyIfEncrypted;
@property (nonatomic, assign)           BOOL encryptor;
@property (nonatomic, assign, readonly) BOOL isEncrypted;
@property (nonatomic, assign, readonly) BOOL canEncrypt;
@property (nonatomic, assign, readonly) BOOL canDecrypt;

@property (nonatomic, assign)           unsigned int key;

@property (nonatomic, strong, nullable) LTAnnPicture *primaryPicture;
@property (nonatomic, strong, nullable) LTAnnPicture *secondaryPicture;

@property (nonatomic, assign)           NSInteger defaultPrimaryPicture;
@property (nonatomic, assign)           NSInteger defaultSecondaryPicture;

- (void)apply:(LTRasterImage *)image mapper:(LTAnnContainerMapper *)mapper;

@end

NS_ASSUME_NONNULL_END