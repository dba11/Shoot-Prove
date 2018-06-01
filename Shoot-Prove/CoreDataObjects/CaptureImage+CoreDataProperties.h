/*************************************************************************
 *
 * SHOOT&PROVE CONFIDENTIAL
 * __________________
 *
 *  [2016]-[2018] Shoot&Prove SA/NV
 *  www.shootandprove.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property
 * of Shoot&Prove SA/NV. The intellectual and technical concepts contained
 * herein are proprietary to Shoot&Prove SA/NV.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Shoot&Prove SA/NV.
 */

#import "CaptureImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaptureImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *mimetype;
@property (nullable, nonatomic, retain) NSString *md5;
@property (nullable, nonatomic, retain) NSNumber *accuracy;
@property (nullable, nonatomic, retain) NSNumber *certified;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSNumber *errorLevel;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSString *sha1;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) Task *task;
@property (nullable, nonatomic, retain) NSOrderedSet<CertificationError *> *errors;

@end

@interface CaptureImage (CoreDataGeneratedAccessors)

- (void)insertObject:(CertificationError *)value inErrorsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromErrorsAtIndex:(NSUInteger)idx;
- (void)insertErrors:(NSArray<CertificationError *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeErrorsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInErrorsAtIndex:(NSUInteger)idx withObject:(CertificationError *)value;
- (void)replaceErrorsAtIndexes:(NSIndexSet *)indexes withErrors:(NSArray<CertificationError *> *)values;
- (void)addErrorsObject:(CertificationError *)value;
- (void)removeErrorsObject:(CertificationError *)value;
- (void)addErrors:(NSOrderedSet<CertificationError *> *)values;
- (void)removeErrors:(NSOrderedSet<CertificationError *> *)values;

@end

NS_ASSUME_NONNULL_END
