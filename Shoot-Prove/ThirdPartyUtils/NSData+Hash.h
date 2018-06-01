//
//  NSData+Hash.h
//  SPCertificationSDK
//
//  Created by Wallerand Réquillart on 28/03/2015.
//  Copyright (c) 2015 Erynnis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSData (Hash)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha256;
@end

@implementation NSData (Hash)

- (NSString *)md5 {
	
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], (CC_LONG)[self length], result);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x",result[i]];
	}
	return output;
	
}

- (NSString *) sha1 {
	
	unsigned char hash[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1([self bytes], (CC_LONG)[self length], hash);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", hash[i]];
	}
	return output;
}

- (NSString *) sha256 {
	
	unsigned char hash[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256([self bytes], (CC_LONG)[self length], hash);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", hash[i]];
	}
	return output;
}
@end