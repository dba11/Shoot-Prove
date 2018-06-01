//
//  NSString+Phone.h
//  ShootProve
//
//  Created by Wallerand Réquillart on 15/10/2015.
//  Copyright © 2015 Erynnis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Phone)
- (BOOL)isValidPhoneNumber;
@end

@implementation NSString(Phone)
- (BOOL)isValidPhoneNumber {
	NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
	return (BOOL) [phoneTest evaluateWithObject:self];
}
@end