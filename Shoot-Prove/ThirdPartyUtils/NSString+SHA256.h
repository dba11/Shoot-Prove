//
//  NSString+SHA256.h
//  ShootProve
//
//  Created by Wallerand Réquillart on 06/12/2015.
//  Copyright © 2015 Erynnis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString(SHA256)
- (NSString *)SHA256;
@end

@implementation NSString(SHA256)
- (NSString*)SHA256 {
	const char *s=[self cStringUsingEncoding:NSASCIIStringEncoding];
	NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
	uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
	CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
	NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
	NSString *hash=[out description];
	hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
	return hash;
}
@end
