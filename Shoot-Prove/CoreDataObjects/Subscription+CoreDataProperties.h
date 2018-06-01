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

#import "Subscription.h"


NS_ASSUME_NONNULL_BEGIN

@interface Subscription (CoreDataProperties)

+ (NSFetchRequest<Subscription *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *expirationDate;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, retain) User *owner;

@end

NS_ASSUME_NONNULL_END
