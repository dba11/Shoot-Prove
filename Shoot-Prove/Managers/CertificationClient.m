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

#import "CertificationClient.h"
#import "StoreManager.h"
#import "SettingsManager.h"
#import "ImageHelper.h"
#import "ErrorHelper.h"
#import "FileHash.h"
#import "User.h"
#import "CaptureImage.h"
#import "FreeCaptureImage.h"
#import "Task.h"
#import "AbstractSubTask.h"
#import "AbstractSubTaskCapture.h"
#import "SubTaskScan.h"
#import "SubTaskPicture.h"
#import "FreeCaptureImageCertificationError.h"

@interface CertificationClient()
{
    UIBackgroundTaskIdentifier _backgroundTaskIdentifier;
	SPCertificationQueue *_certification_queue;
    int _itemInQueue;
}
@end

@implementation CertificationClient
@synthesize delegate;

+ (instancetype)sharedManager {
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[CertificationClient alloc] init];
	});
	return manager;
}

- (id)init {
	self = [super init];
	if(self) {
		_certification_queue = [[SPCertificationQueue alloc] init];
        _itemInQueue = 0;
		[self checkLocationServiceAvailability];
	}
	return self;
}

- (void)checkLocationServiceAvailability {
	NSString *tag;
	BOOL available = YES;
	if(![SPCertificationInfo locationServiceEnabled]) {
		//tag = openLocationServiceTag;
		//available = NO;
	} else if([SPCertificationInfo locationServiceAuthorizationStatus] == kCLAuthorizationStatusDenied) {
		tag = openSettingsTag;
		available = NO;
	}
	if(!available) {
		[[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"DEVICE_LOCATION_DISABLED", nil), NSLocalizedString(@"DEVICE_OPEN_SETTINGS", nil)] confirmButtonTitle:NSLocalizedString(@"BUTTON_SETTINGS", nil) confirmTag:tag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
	}
}

- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
	if([tag isEqualToString:openLocationServiceTag]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
	} else if([tag isEqualToString:openSettingsTag]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
}

- (void)queueCaptureImageObject:(id)imageObject indexPath:(NSIndexPath *)indexPath {
    User *user = [StoreManager.sharedManager fetchUser];
    SPCertificationItem *item = [SPCertificationItem new];
    if([imageObject isKindOfClass:[CaptureImage class]]) {
        CaptureImage *captureImage = (CaptureImage *)imageObject;
        item.identifier = [NSString stringWithFormat:@"%@_%ld_%ld", captureImage.uuid, (long)indexPath.section, (long)indexPath.row];
        item.data = captureImage.data;
        item.isPicture = (captureImage.format == SPFormatPicture);
    } else if([imageObject isKindOfClass:[FreeCaptureImage class]]) {
        FreeCaptureImage *freeCaptureImage = (FreeCaptureImage *)imageObject;
        item.identifier = [NSString stringWithFormat:@"%@_%ld_%ld", freeCaptureImage.uuid,  (long)indexPath.section, (long)indexPath.row];
        item.data = [NSData dataWithContentsOfFile:freeCaptureImage.path];
        item.isPicture = (freeCaptureImage.format == SPFormatPicture);
    } else {
        NSLog(@"CertificationClient.queueCaptureImageObject: invalid object class.");
        return;
    }
    item.printRequested = [SettingsManager.sharedManager printCertificationInfo];
    item.callerIdentifier = user.uuid;
    item.minAccuracy = [SettingsManager.sharedManager minAccuracy];
    item.delayInSec = 10;
    if(item.printRequested) {
        NSMutableString *userInfo = [[NSMutableString alloc] initWithString:@"Author:"];
        NSString *displayName = [user.displayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [userInfo appendString:[NSString stringWithFormat:@" %@", displayName.length > 0 ? [NSString stringWithFormat:@"%@\nIdentifier: %@", displayName, user.uuid]:user.uuid]];
        item.printFirstLine = userInfo;
    } else {
        item.printFirstLine = nil;
    }
    item.object = imageObject;
    if(!_backgroundTaskIdentifier) {
        _backgroundTaskIdentifier = [UIApplication.sharedApplication beginBackgroundTaskWithName:@"sp_certification" expirationHandler:^{
            [UIApplication.sharedApplication endBackgroundTask:_backgroundTaskIdentifier];
            _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            _itemInQueue = 0;
            NSLog(@"CertificationClient.backgroundTask.expired");
        }];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"CertificationClient.backgroundTask.started");
        _itemInQueue++;
        item.delegate = self;
        [_certification_queue queue:item];
    });
}

- (void)certificationDidFinishedWithItem:(SPCertificationItem *)item withErrors:(NSArray *)errors {
    NSArray *identifiers = [item.identifier componentsSeparatedByString:@"_"];
    NSInteger section = [[identifiers objectAtIndex:1] integerValue];
    NSInteger row = [[identifiers objectAtIndex:2] integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSError *error;
    LTRasterImage *rasterImage = [ImageHelper rasterImageFromData:item.data error:&error];
    if(!error) {
        SPFormat format = SPFormatPicture;
        SPResolution resolution = SPResolution200;
        SPColorMode colorMode = SPColorModeColor;
        NSString *filePath;
        if([item.object isKindOfClass:[CaptureImage class]]) {
            CaptureImage *captureImage = (CaptureImage *)item.object;
            filePath = captureImage.privatePath;
            format = captureImage.format;
            resolution = captureImage.resolution;
            colorMode = captureImage.colorMode;
        } else if([item.object isKindOfClass:[FreeCaptureImage class]]) {
            FreeCaptureImage *captureImage = (FreeCaptureImage *)item.object;
            filePath = captureImage.path;
            format = captureImage.format;
            resolution = captureImage.resolution;
            colorMode = captureImage.colorMode;
        } else {
            NSLog(@"certificationDidFinishedWithItem: invalid item.object class.");
            return;
        }
        [ImageHelper saveRasterImage:rasterImage path:filePath format:format resolution:resolution colorMode:colorMode error:&error];
        if(error) {
            [ErrorHelper popToastWithMessage:error.localizedDescription style:ToastHelper.styleError];
        }
        if([item.object isKindOfClass:[CaptureImage class]]) {
            CaptureImage *captureImage = (CaptureImage *)item.object;
            captureImage.sha1 = [FileHash sha1HashOfFileAtPath:captureImage.privatePath];
            CLLocation *location = (CLLocation *) item.location;
            captureImage.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
            captureImage.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
            captureImage.accuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
            captureImage.timestamp = item.timestamp;
            captureImage.certified = @1;
            if(errors.count>0) {
                BOOL isCritical = NO;
                for(NSError *err in errors) {
                    isCritical = isCritical || [err.domain isEqualToString:SPCertificationErrorDomain];
                    [StoreManager.sharedManager createCertificationErrorForImage:captureImage code:err.code description:err.description domain:err.domain];
                }
                captureImage.errorLevel = [NSNumber numberWithInt:isCritical ? SPErrorLevelError:SPErrorLevelWarning];
            }
        } else if([item.object isKindOfClass:[FreeCaptureImage class]]) {
            FreeCaptureImage *captureImage = (FreeCaptureImage *)item.object;
            captureImage.sha1 = [FileHash sha1HashOfFileAtPath:captureImage.path];
            CLLocation *location = (CLLocation *) item.location;
            captureImage.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
            captureImage.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
            captureImage.accuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
            captureImage.timestamp = item.timestamp;
            captureImage.certified = YES;
            if(errors.count > 0) {
                BOOL isCritical = NO;
                for(NSError *err in errors) {
                    isCritical = isCritical || [err.domain isEqualToString:SPCertificationErrorDomain];
                    FreeCaptureImageCertificationError *captureError = [FreeCaptureImageCertificationError new];
                    captureError.code = err.code;
                    captureError.desc = err.description;
                    captureError.domain = err.domain;
                    [captureImage.errors addObject:captureError];
                }
                captureImage.errorLevel = [NSNumber numberWithInt:isCritical ? SPErrorLevelError:SPErrorLevelWarning];
            }
        }
    } else {
        [ErrorHelper popToastWithMessage:error.localizedDescription style:ToastHelper.styleError];
    }
    if([self.delegate respondsToSelector:@selector(didCertificationClientFinishWithCaptureImageObject:indexPath:)]) {
        [self.delegate didCertificationClientFinishWithCaptureImageObject:item.object indexPath:indexPath];
    }
    _itemInQueue--;
    if(_itemInQueue == 0) {
        [UIApplication.sharedApplication endBackgroundTask:_backgroundTaskIdentifier];
        _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        NSLog(@"CertificationClient.backgroundTask.done");
    }
}

@end
