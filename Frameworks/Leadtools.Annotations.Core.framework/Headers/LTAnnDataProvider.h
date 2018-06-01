//
//  LTAnnDataProvider.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnDataProvider : NSObject // ABSTRACT CLASS

- (void)fillContainer:(LTAnnContainer *)container bounds:(LeadRectD)bounds color:(NSString *)color;
- (void)encryptContainer:(LTAnnContainer *)container bounds:(LeadRectD)bounds key:(int)key;
- (void)decryptContainer:(LTAnnContainer *)container bounds:(LeadRectD)bounds key:(int)key;

- (NSData *)imageDataContainer:(LTAnnContainer *)container bounds:(LeadRectD)bounds;
- (void)setImageDataContainer:(LTAnnContainer *)container bounds:(LeadRectD)bounds data:(NSData *)data;



- (NSData *)getImageDataContainer:(LTAnnContainer *)container bounds:(LeadRectD)bounds LT_DEPRECATED_USENEW(19_0, "-imageDataContainer:bounds:");

@end

NS_ASSUME_NONNULL_END