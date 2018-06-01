//
//  SPCertificationItem.h
//  SPCertificationSDK
//
//  Created by Wallerand Réquillart on 28/03/2015.
//  Copyright (c) 2015 Erynnis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class SPCertificationItem;

@protocol SPCertificationDelegate <NSObject>
@optional
- (void)certificationWillBeginWithItem:(SPCertificationItem *)item;
- (void)certificationDidFinishedWithItem:(SPCertificationItem *)item withErrors:(NSArray *) errors;
@end

@interface SPCertificationItem : NSObject
@property(nonatomic, strong) NSString *identifier; //unique identifier of the item to certify
@property(nonatomic, strong) NSData *data; //data of the item
@property(nonatomic, strong) NSString *callerIdentifier; //identifier of the caller
@property(nonatomic) BOOL printRequested; //is the certification print requested ?
@property(nonatomic, strong) NSString *printFirstLine; //a custom print string that will be the first line of the print.
@property(nonatomic) NSUInteger minAccuracy; //location minimum accuracy required by the certification
@property(nonatomic) NSUInteger delayInSec; //delay allowed to reach the minimum accuracy and current time
@property(nonatomic) BOOL isPicture; //is the item a picture ? it not it is considered as a scan
@property(nonatomic, strong) id object; //the object linked to the item to certify

@property(nonatomic, readonly, copy) CLLocation *location; //location returned to the caller
@property(nonatomic, readonly, copy) NSDate *timestamp; //timestamp returned to the caller
@property(nonatomic, readonly, copy) NSString *sha1;//SHA1 hash of the certified file, returned to the caller
@property(weak) id<SPCertificationDelegate> delegate; //delegate that will receive calls during item certification process
@end
