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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "EnumHelper.h"

@interface SettingsManager : NSObject

#pragma - public instance
+ (instancetype)sharedManager;

#pragma - app build version
@property (nonatomic, strong) NSString *lastBuildVersion;

#pragma - app last ui
@property (nonatomic, strong) NSString *lastViewControllerName;
@property (nonatomic) SPTaskDisplayMode lastDisplayMode;

#pragma - certification options
@property (nonatomic) NSInteger minAccuracy;
@property (nonatomic) BOOL printCertificationInfo;

#pragma - picture settings
@property (nonatomic) SPSize pictureSize;

#pragma - scanner settings
@property (nonatomic) SPFormat scannerFormat;
@property (nonatomic) SPResolution scannerResolution;
@property (nonatomic) SPColorMode scannerColorMode;
@property (nonatomic) BOOL scannerAutoScan;
@property (nonatomic) BOOL deskew;
@property (nonatomic) BOOL despekle;
@property (nonatomic) BOOL smoothing;
@property (nonatomic) BOOL dotRemove;

#pragma - map settings
@property(nonatomic) MKMapType mapType;

#pragma - iTunes sharing settings
@property(nonatomic) BOOL shareFiles;
@property(nonatomic) BOOL shareRenditions;

#pragma - beta/dev Mode
@property (nonatomic) BOOL betaMode;
@property (nonatomic) BOOL devMode;
@property (nonatomic, strong) NSString *devUrl;

#pragma - device info
- (NSString *)mobileLanguage;
- (NSString *)mobileISOCountryCode;

#pragma - public save method
- (void)save;
@end
