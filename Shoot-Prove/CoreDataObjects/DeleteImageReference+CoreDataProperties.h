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

#import "DeleteImageReference.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeleteImageReference (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *index;
@property (nullable, nonatomic, retain) NSString *md5;
@property (nullable, nonatomic, retain) Task *task;

@end

NS_ASSUME_NONNULL_END
