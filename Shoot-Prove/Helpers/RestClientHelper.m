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

#import "RestClientHelper.h"
#import "StoreManager.h"
#import "Device.h"
#import "Ident.h"
#import "User.h"
#import "Eula.h"
#import "CaptureImage.h"
#import "CertificationError.h"
#import "Rendition.h"
#import "RemoteService.h"
#import "RemoteTask.h"
#import "Subscription.h"
#import "Receipt.h"

@implementation RestClientHelper
#pragma - user mapping
+ (NSArray *)receiptAttributes {
    return @[@"uuid",
             @"buy_date",
             @"product_id",
             @"quantity",
             @"store"];
}

+ (RKEntityMapping *)receiptEntityMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Receipt class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
    mapping.identificationAttributes = @[@"uuid"];
    [mapping addAttributeMappingsFromArray:[self receiptAttributes]];
    return mapping;
}

+ (NSArray *)userAttributes {
	return @[@"avatar",
			 @"eulaAcceptDate",
			 @"eulaAcceptVersion",
			 @"firstName",
			 @"lastName",
			 @"displayName",
			 @"uuid",
             @"locale"];
}

+ (RKEntityMapping *)fullUserEntityMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([User class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
	mapping.identificationAttributes = @[@"uuid"];
	[mapping addAttributeMappingsFromArray:[self userAttributes]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"_credits": @"credits",
                                                  @"_betaUser": @"betaUser",
                                                  @"_devUser": @"devUser"
                                                  }];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"devices" toKeyPath:@"devices" withMapping:[self deviceEntityMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"idents" toKeyPath:@"idents" withMapping:[self identEntityMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"tasks" toKeyPath:@"remoteTasks" withMapping:[self remoteTaskEntityMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"templates" toKeyPath:@"remoteServices" withMapping:[self remoteServiceEntityMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"_activeSubscription" toKeyPath:@"activeSubscription" withMapping:[self subscriptionEntityMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"receipts" toKeyPath:@"receipts" withMapping:[self receiptEntityMapping]]];
	return mapping;
}
/*
+ (RKEntityMapping *)simpleUserEntityMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([User class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
	mapping.identificationAttributes = @[@"uuid"];
	[mapping addAttributeMappingsFromArray:[self userAttributes]];
    [mapping addAttributeMappingsFromDictionary:@{@"_credits": @"credits"}];
	return mapping;
}
*/
+ (RKObjectMapping *)simpleUserRequestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	[mapping addAttributeMappingsFromArray:[self userAttributes]];
	return mapping;
}

#pragma - device mapping
+ (NSArray *)deviceAttributes {
	return @[@"uuid",
			 @"uid",
			 @"name",
			 @"type",
			 @"token",
			 @"nsToken",
			 @"buildNumber",
			 @"lastSeen"];
}

+ (RKEntityMapping *)deviceEntityMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Device class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
	mapping.identificationAttributes = @[@"uuid"];
	[mapping addAttributeMappingsFromArray:[self deviceAttributes]];
	return mapping;
}

+ (RKObjectMapping *)deviceRequestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	[mapping addAttributeMappingsFromArray:[self deviceAttributes]];
	return mapping;
}

#pragma - ident mapping
+ (NSArray *)identAttributes {
	return @[@"uuid",
			 @"uid",
			 @"type",
			 @"email",
			 @"icon_url"];
}

+ (RKEntityMapping *)identEntityMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Ident class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
	mapping.identificationAttributes = @[@"uuid"];
	[mapping addAttributeMappingsFromArray:[self identAttributes]];
	return mapping;
}

#pragma - remote service mapping
+ (NSArray *)remoteServiceAttributes {
	return @[@"uuid",
			 @"lastUpdate"];
}

+ (RKEntityMapping *)remoteServiceEntityMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([RemoteService class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
	mapping.identificationAttributes = @[@"uuid"];
	[mapping addAttributeMappingsFromArray:[self remoteServiceAttributes]];
	return mapping;
}

+ (RKObjectMapping *)remoteServiceRequestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	[mapping addAttributeMappingsFromArray:[self remoteServiceAttributes]];
	return mapping;
}

#pragma - remote task mapping
+ (NSArray *)remoteTaskAttributes {
	return @[@"uuid",
			 @"lastUpdate"];
}

+ (RKEntityMapping *)remoteTaskEntityMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([RemoteTask class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
	mapping.identificationAttributes = @[@"uuid"];
	[mapping addAttributeMappingsFromArray:[self remoteTaskAttributes]];
	return mapping;
}

+ (RKObjectMapping *)remoteTaskRequestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	[mapping addAttributeMappingsFromArray:[self remoteTaskAttributes]];
	return mapping;
}

#pragma - subscription mapping
+ (NSArray *)subscriptionAttributes {
	return @[@"uuid",
             @"type",
			 @"expirationDate"];
}

+ (RKEntityMapping *)subscriptionEntityMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Subscription class]) inManagedObjectStore:[[StoreManager sharedManager] objectStore]];
	mapping.identificationAttributes = @[@"uuid"];
	[mapping addAttributeMappingsFromArray:[self subscriptionAttributes]];
	return mapping;
}

+ (RKObjectMapping *)subscriptionRequestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	[mapping addAttributeMappingsFromArray:[self subscriptionAttributes]];
	return mapping;
}

#pragma - eula mapping
+ (NSArray *)eulaAttributes {
	return @[@"version",
			 @"url",
             @"urls"
			 ];
}

+ (RKObjectMapping *)eulaEntityMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Eula class]];
	[mapping addAttributeMappingsFromArray:[self eulaAttributes]];
	return mapping;
}

+ (RKValueTransformer*)millisecondsSince1970ToDateValueTransformer {
    return [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class sourceClass, __unsafe_unretained Class destinationClass) {
        return [sourceClass isSubclassOfClass:[NSNumber class]] && [destinationClass isSubclassOfClass:[NSDate class]];
    } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputValueClass, NSError *__autoreleasing *error) {
        RKValueTransformerTestInputValueIsKindOfClass(inputValue, (@[ [NSNumber class] ]), error);
        RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, (@[ [NSDate class] ]), error);
        *outputValue = [NSDate dateWithTimeIntervalSince1970:[inputValue unsignedLongValue] / 1000];
        return YES;
    }];
}
@end
