//
//  NSString+MD5.h
//  soHunt
//
//  Created by Wallerand Réquillart on 27/08/2014.
//  Copyright (c) 2014 Wallerand Réquillart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString(MD5)
- (NSString *)MD5;
@end

@implementation NSString(MD5)
- (NSString*)MD5 {
	const char *ptr = [self UTF8String];
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
	CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x",md5Buffer[i]];
	return output;
}
@end
