//
//  LTAnnMedia.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnMedia : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *source1;
@property (nonatomic, copy) NSString *type1;

@property (nonatomic, copy) NSString *source2;
@property (nonatomic, copy) NSString *type2;

@property (nonatomic, copy) NSString *source3;
@property (nonatomic, copy) NSString *type3;

@end

NS_ASSUME_NONNULL_END