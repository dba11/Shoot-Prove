//
//  NSString+Email.h
//  soHunt
//
//  Created by Wallerand Réquillart on 27/08/2014.
//  Copyright (c) 2014 Wallerand Réquillart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Email)
- (BOOL)isValidEmail;
@end

@implementation NSString(Email)
- (BOOL)isValidEmail {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return (BOOL) [emailTest evaluateWithObject:self];
}
@end