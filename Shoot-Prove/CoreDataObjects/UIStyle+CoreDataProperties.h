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

#import "UIStyle.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIStyle (CoreDataProperties)

+ (NSFetchRequest<UIStyle *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *toolbarBackgroundColor;
@property (nullable, nonatomic, copy) NSString *toolbarColor;
@property (nullable, nonatomic, copy) NSString *headerColor;
@property (nullable, nonatomic, copy) NSString *headerBackgroundColor;
@property (nullable, nonatomic, copy) NSString *viewBackgroundColor;
@property (nullable, nonatomic, copy) NSString *thumbnailBackgroundColor;
@property (nullable, nonatomic, copy) NSString *thumbnailColor;
@property (nullable, nonatomic, copy) NSString *promptColor;
@property (nullable, nonatomic, retain) AbstractService *abstractService;

@end

NS_ASSUME_NONNULL_END
