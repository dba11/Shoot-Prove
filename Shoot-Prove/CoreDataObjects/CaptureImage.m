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

#import "CaptureImage.h"
#import "CertificationError.h"
#import "Task.h"
#import "StoreManager.h"
#import "NSData+Hash.h"
#import "DateTimeHelper.h"
#import "AbstractSubTaskCapture.h"
#import "SubTaskScan.h"

@interface CaptureImage()
{
    AbstractSubTaskCapture *_abstractSubTaskCapture;
}
@end

@implementation CaptureImage
- (NSString *)name {
	return [NSString stringWithFormat:@"image_%@_%@.%@", self.uuid, self.order, [[StoreManager sharedManager] extentionFromMime:self.mimetype]];
}

- (NSString *)privatePath {
	return [[[StoreManager sharedManager] privatePath] stringByAppendingPathComponent:[self name]];
}

- (NSString *)publicPath {
	return [[[StoreManager sharedManager] publicPath] stringByAppendingPathComponent:[self name]];
}

- (UIImage *)image {
	if([[NSFileManager defaultManager] fileExistsAtPath:[self privatePath]]) {
		return [UIImage imageWithContentsOfFile:[self privatePath]];
	}
	return nil;
}

- (NSData *)data {
	if([[NSFileManager defaultManager] fileExistsAtPath:[self privatePath]]) {
		return [NSData dataWithContentsOfFile:[self privatePath]];
	}
	return nil;
}

- (NSNumber *)size {
	return [NSNumber numberWithUnsignedInteger:[[self data] length]];
}

- (NSString *)challenge {
	NSMutableData *data = [[NSMutableData alloc] initWithData:[@"WEBDA" dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[self data]];
	return [data md5];
}

- (NSDictionary *)dictionary {
	NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
	if([self data]) {
		[imageDic setObject:[[self data] md5] forKey:@"hash"];
		[imageDic setObject:[self challenge] forKey:@"challenge"];
		[imageDic setObject:[self size] forKey:@"size"];
	}
	[imageDic setObject:[self name] forKey:@"originalname"];
	[imageDic setObject:self.mimetype forKey:@"mimetype"];
	NSMutableDictionary *metadatas = [[NSMutableDictionary alloc] init];
	[metadatas setObject:self.uuid forKey:@"uuid"];
	[metadatas setObject:self.order forKey:@"order"];
	[metadatas setObject:self.certified forKey:@"certified"];
	[metadatas setObject:[DateTimeHelper jsonFromDate:self.creationDate] forKey:@"creationDate"];
	if(self.latitude)
		[metadatas setObject:self.latitude forKey:@"latitude"];
	if(self.longitude)
		[metadatas setObject:self.longitude forKey:@"longitude"];
	if(self.accuracy)
		[metadatas setObject:self.accuracy forKey:@"accuracy"];
	if(self.sha1)
		[metadatas setObject:self.sha1 forKey:@"sha1"];
	if(self.timestamp)
		[metadatas setObject:[DateTimeHelper jsonFromDate:self.timestamp] forKey:@"timestamp"];
	[metadatas setObject:self.errorLevel forKey:@"errorLevel"];
	NSMutableArray *errors = [[NSMutableArray alloc] init];
	for(CertificationError *certificationError in self.errors) {
		NSMutableDictionary *errorDic = [[NSMutableDictionary alloc] init];
		[errorDic setObject:certificationError.code forKey:@"code"];
		[errorDic setObject:certificationError.desc forKey:@"description"];
		[errorDic setObject:certificationError.domain forKey:@"domain"];
		[errors addObject:errorDic];
	}
	[metadatas setObject:errors forKey:@"errors"];
	[imageDic setObject:metadatas forKey:@"metadatas"];
	return imageDic;
}

- (BOOL)isSync {
	return [self.data.md5 isEqualToString:self.md5];
}

- (BOOL)isNew {
	return [self.md5 length] == 0;
}

- (AbstractSubTaskCapture *)abstractSubTaskCapture {
    if(!_abstractSubTaskCapture) {
        Task *task = self.task;
        for(AbstractSubTask *abstractSubTask in task.subTasks) {
            if([abstractSubTask isKindOfClass:([AbstractSubTaskCapture class])]) {
                AbstractSubTaskCapture *subTaskCapture = (AbstractSubTaskCapture *)abstractSubTask;
                if([subTaskCapture.uuid isEqualToString:self.uuid]) {
                    _abstractSubTaskCapture = subTaskCapture;
                    break;
                }
            }
        }
        
    }
    return _abstractSubTaskCapture;
}

- (SPFormat)format {
    AbstractSubTaskCapture *subTaskCapture = [self abstractSubTaskCapture];
    if([subTaskCapture isKindOfClass:[SubTaskScan class]]) {
        SubTaskScan *subTaskScan = (SubTaskScan *) subTaskCapture;
        return [EnumHelper formatFromDescription:subTaskScan.format];
    } else {
        return SPFormatPicture;
    }
}

- (SPResolution)resolution {
    AbstractSubTaskCapture *subTaskCapture = [self abstractSubTaskCapture];
    if([subTaskCapture isKindOfClass:[SubTaskScan class]]) {
        SubTaskScan *subTaskScan = (SubTaskScan *) subTaskCapture;
        return [EnumHelper resolutionFromValue:[subTaskScan.dpi intValue]];
    } else {
        return SPResolution200;
    }
}

- (SPColorMode)colorMode {
    AbstractSubTaskCapture *subTaskCapture = [self abstractSubTaskCapture];
    if([subTaskCapture isKindOfClass:[SubTaskScan class]]) {
        SubTaskScan *subTaskScan = (SubTaskScan *) subTaskCapture;
        return [EnumHelper colorModeFromDescription:subTaskScan.mode];
    } else {
        return SPColorModeColor;
    }
}
@end
