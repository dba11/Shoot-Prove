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

#import <Foundation/Foundation.h>

@interface RestClientHelper : NSObject
#pragma - user attributes mapping for rest client
+ (RKEntityMapping *)fullUserEntityMapping;
//+ (RKEntityMapping *)simpleUserEntityMapping;
+ (RKObjectMapping *)simpleUserRequestMapping;
#pragma - device attributes mapping for rest client
+ (RKEntityMapping *)deviceEntityMapping;
+ (RKObjectMapping *)deviceRequestMapping;
#pragma - ident attributes mapping for rest client
+ (RKEntityMapping *)identEntityMapping;
#pragma - eula attributes mapping for rest client
+ (RKObjectMapping *)eulaEntityMapping;
#pragma - value transformers
+ (RKValueTransformer*)millisecondsSince1970ToDateValueTransformer;
@end
