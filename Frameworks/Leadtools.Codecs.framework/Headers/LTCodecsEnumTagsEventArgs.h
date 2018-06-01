//
//  LTCodecsEnumTagsEventArgs.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsEnumTagsEventArgs : NSObject

@property (nonatomic, assign)           BOOL cancel;

@property (nonatomic, assign, readonly) NSInteger tagId;

@property (nonatomic, assign, readonly) NSUInteger count;

@property (nonatomic, assign, readonly) LTRasterTagMetadataDataType metadataType;

@end

NS_ASSUME_NONNULL_END