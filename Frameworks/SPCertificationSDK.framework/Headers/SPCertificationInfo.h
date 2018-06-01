//
//  SPCertificationInfo.h
//  SPCertificationSDK
//
//  Created by Wallerand Réquillart on 02/11/2016.
//  Copyright © 2016 Erynnis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCertificationInfo : NSObject
+ (BOOL)locationServiceEnabled;
+ (CLAuthorizationStatus)locationServiceAuthorizationStatus;
@end
