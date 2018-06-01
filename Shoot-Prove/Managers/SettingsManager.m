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

#import "SettingsManager.h"

#import "FreeCaptureViewController.h"

//GVEEY39B6C.

#define kSettingsLastBuildVersion @"last_build_version"

#define kSettingsLastViewController @"last_view_controller"
#define kSettingsLastDisplayMode @"last_display_mode"

#define kSettingsMinAccuracy @"accuracy"
#define kSettingsPrintCertificationInfo @"print_certification_info"

#define kSettingsSize @"picture_size"

#define kSettingsFormat @"scan_format"
#define kSettingsResolution @"scan_resolution"
#define kSettingsColor @"scan_color"
#define kSettingsAuto @"scan_auto"
#define kSettingsDeskew @"deskew"
#define kSettingsDespekle @"despekle"
#define kSettingsSmoothing @"smoothing"
#define kSettingsDotRemove @"dot_remove"

#define kSettingsMapType @"map_type"

#define kSettingsShareFiles @"share_files"
#define kSettingsShareRenditions @"share_renditions"

#define kSettingsBetaMode @"beta_mode"
#define kSettingsDevMode @"dev_mode"
#define kSettingsDevUrl @"dev_url"

@interface SettingsManager ()
-(id)objectForKey:(NSString *) key defaultValue:(id) defaultValue;
-(void)setObject:(id) obj forKey:(NSString *) key;
@end

@implementation SettingsManager

@synthesize lastBuildVersion = _lastBuildVersion;

@synthesize lastViewControllerName = _lastViewControllerName;
@synthesize lastDisplayMode = _lastDisplayMode;

@synthesize minAccuracy = _minAccuracy;
@synthesize printCertificationInfo = _printCertificationInfo;

@synthesize pictureSize = _pictureSize;

@synthesize scannerFormat = _scannerFormat;
@synthesize scannerResolution = _scannerResolution;
@synthesize scannerColorMode = _scannerColorMode;
@synthesize scannerAutoScan = _scannerAutoScan;
@synthesize deskew = _deskew;
@synthesize despekle = _despekle;
@synthesize smoothing = _smoothing;
@synthesize dotRemove = _dotRemove;

@synthesize mapType = _mapType;

@synthesize shareFiles = _shareFiles;
@synthesize shareRenditions = _shareRenditions;

@synthesize betaMode = _betaMode;
@synthesize devMode = _devMode;
@synthesize devUrl = _devUrl;

+ (instancetype)sharedManager {
	static id sharedSettingsManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedSettingsManager = [[SettingsManager alloc] init];
	});
	return sharedSettingsManager;
}

- (id)objectForKey:(NSString *)key defaultValue:(id)defaultValue {
	id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if(obj)
		return obj;
	return defaultValue;
}

- (void)setObject:(id)obj forKey:(NSString *)key {
	if(obj)
		[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
	else
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (void)save {
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLastBuildVersion:(NSString *)lastBuildVersion {
	_lastBuildVersion = lastBuildVersion;
	[self setObject:[NSString stringWithFormat:@"%@", lastBuildVersion] forKey:kSettingsLastBuildVersion];
}

- (NSString *)lastBuildVersion {
	if(!_lastBuildVersion) {
		_lastBuildVersion = [self objectForKey:kSettingsLastBuildVersion defaultValue:@""];
	}
	return _lastBuildVersion;
}

- (void)setLastViewControllerName:(NSString *)lastViewControllerName {
	_lastViewControllerName = lastViewControllerName;
	[self setObject:[NSString stringWithFormat:@"%@", lastViewControllerName] forKey:kSettingsLastViewController];
}

- (NSString *)lastViewControllerName {
	if(!_lastViewControllerName) {
        _lastViewControllerName = [self objectForKey:kSettingsLastViewController defaultValue:NSStringFromClass([FreeCaptureViewController class])];
	}
	return _lastViewControllerName;
}

- (void)setLastDisplayMode:(SPTaskDisplayMode)lastDisplayMode {
	_lastDisplayMode = lastDisplayMode;
	[self setObject:[NSString stringWithFormat:@"%d", lastDisplayMode] forKey:kSettingsLastDisplayMode];
}

- (SPTaskDisplayMode)lastDisplayMode {
	if(!_lastDisplayMode) {
		_lastDisplayMode = [[self objectForKey:kSettingsLastDisplayMode defaultValue:[NSString stringWithFormat:@"%d", SPTaskDisplayModeInbox]] intValue];
	}
	return _lastDisplayMode;
}

- (void)setMinAccuracy:(NSInteger)minAccuracy {
	_minAccuracy = minAccuracy;
	[self setObject:[NSString stringWithFormat:@"%d", (int)minAccuracy] forKey:kSettingsMinAccuracy];
}

- (NSInteger)minAccuracy {
	if(!_minAccuracy) {
		_minAccuracy = [[self objectForKey:kSettingsMinAccuracy defaultValue:@"300"] integerValue];
	}
	return _minAccuracy;
}

- (void)setPrintCertificationInfo:(BOOL)printCertificationInfo {
	_printCertificationInfo = printCertificationInfo;
	[self setObject:[NSString stringWithFormat:@"%d", (printCertificationInfo == YES ? 1:0)] forKey:kSettingsPrintCertificationInfo];
}

- (BOOL)printCertificationInfo {
	if(!_printCertificationInfo) {
		_printCertificationInfo = [[self objectForKey:kSettingsPrintCertificationInfo defaultValue:@"1"] boolValue];
	}
	return  _printCertificationInfo;
}

- (void)setPictureSize:(SPSize)size {
	_pictureSize = size;
	[self setObject:[NSString stringWithFormat:@"%d", size] forKey:kSettingsSize];
}

- (SPSize)pictureSize {
	if(!_pictureSize) {
		_pictureSize = [[self objectForKey:kSettingsSize defaultValue:@"0"] intValue];
	}
	return _pictureSize;
}

- (void)setScannerFormat:(SPFormat)scannerFormat {
	_scannerFormat = scannerFormat;
	[self setObject:[NSString stringWithFormat:@"%d", (int)scannerFormat] forKey:kSettingsFormat];
}

- (SPFormat)scannerFormat {
	if(!_scannerFormat) {
		_scannerFormat = [[self objectForKey:kSettingsFormat defaultValue:@"0"] intValue];
	}
	return _scannerFormat;
}

- (void)setScannerResolution:(SPResolution)scannerResolution {
	_scannerResolution = scannerResolution;
	[self setObject:[NSString stringWithFormat:@"%d", (int)scannerResolution] forKey:kSettingsResolution];
}

- (SPResolution)scannerResolution {
	if(!_scannerResolution) {
		_scannerResolution = [[self objectForKey:kSettingsResolution defaultValue:[NSString stringWithFormat:@"%d", SPResolution200]] intValue];
	}
	return _scannerResolution;
}

- (void)setScannerColorMode:(SPColorMode)scannerColorMode {
	_scannerColorMode = scannerColorMode;
	[self setObject:[NSString stringWithFormat:@"%d", (int)scannerColorMode] forKey:kSettingsColor];
}

- (SPColorMode)scannerColorMode {
	if(!_scannerColorMode) {
		_scannerColorMode = [[self objectForKey:kSettingsColor defaultValue:@"0"] intValue];
	}
	return _scannerColorMode;
}

- (void)setScannerAutoScan:(BOOL)scannerAutoScan {
	_scannerAutoScan = scannerAutoScan;
	[self setObject:[NSString stringWithFormat:@"%d", (scannerAutoScan == YES ? 1:0)] forKey:kSettingsAuto];
}

- (BOOL)scannerAutoScan {
	if(!_scannerAutoScan) {
		_scannerAutoScan = [[self objectForKey:kSettingsAuto defaultValue:@"1"] boolValue];
	}
	return _scannerAutoScan;
}

- (void)setDeskew:(BOOL)deskew {
    _deskew = deskew;
    [self setObject:[NSString stringWithFormat:@"%d", (deskew == YES ? 1:0)] forKey:kSettingsDeskew];
}

- (BOOL)deskew {
    if(!_deskew) {
        _deskew = [[self objectForKey:kSettingsDeskew defaultValue:@"1"] boolValue];
    }
    return _deskew;
}

- (void)setDespekle:(BOOL)despekle {
    _despekle = despekle;
    [self setObject:[NSString stringWithFormat:@"%d", (despekle == YES ? 1:0)] forKey:kSettingsDespekle];
}

- (BOOL)despekle {
    if(!_despekle) {
        _despekle = [[self objectForKey:kSettingsDespekle defaultValue:@"0"] boolValue];
    }
    return _despekle;
}

- (void)setSmoothing:(BOOL)smoothing {
    _smoothing = smoothing;
    [self setObject:[NSString stringWithFormat:@"%d", (smoothing == YES ? 1:0)] forKey:kSettingsSmoothing];
}

- (BOOL)smoothing {
    if(!_smoothing) {
        _smoothing = [[self objectForKey:kSettingsSmoothing defaultValue:@"0"] boolValue];
    }
    return _smoothing;
}

- (void)setDotRemove:(BOOL)dotRemove {
    _dotRemove = dotRemove;
    [self setObject:[NSString stringWithFormat:@"%d", (dotRemove == YES ? 1:0)] forKey:kSettingsDotRemove];
}

- (BOOL)dotRemove {
    if(!_dotRemove) {
        _dotRemove = [[self objectForKey:kSettingsDotRemove defaultValue:@"0"] boolValue];
    }
    return _dotRemove;
}

- (MKMapType)mapType {
	if(!_mapType) {
		NSString *type = [self objectForKey:kSettingsMapType defaultValue:@"0"];
		if([type isEqualToString:@"0"]) {
			_mapType = MKMapTypeStandard;
		} else if([type isEqualToString:@"1"]) {
			_mapType = MKMapTypeSatellite;
		} else if([type isEqualToString:@"2"]) {
			_mapType = MKMapTypeHybrid;
		}
	}
	return _mapType;
}

- (void)setShareFiles:(BOOL)shareFiles {
	_shareFiles = shareFiles;
	[self setObject:[NSString stringWithFormat:@"%d", (shareFiles == YES ? 1:0)] forKey:kSettingsShareFiles];
}

- (BOOL)shareFiles {
	if(!_shareFiles) {
		_shareFiles = [[self objectForKey:kSettingsShareFiles defaultValue:@"0"] boolValue];
	}
	return _shareFiles;
}

- (void)setShareRenditions:(BOOL)shareRenditions {
	_shareRenditions = shareRenditions;
	[self setObject:[NSString stringWithFormat:@"%d", (shareRenditions == YES ? 1:0)] forKey:kSettingsShareRenditions];
}

- (BOOL)shareRenditions {
	if(!_shareRenditions) {
		_shareRenditions = [[self objectForKey:kSettingsShareRenditions defaultValue:@"0"] boolValue];
	}
	return _shareRenditions;
}

- (void)setBetaMode:(BOOL)betaMode {
	_betaMode = betaMode;
	[self setObject:[NSString stringWithFormat:@"%d", (_betaMode == YES ? 1:0)] forKey:kSettingsBetaMode];
}

- (BOOL)betaMode {
	if(!_betaMode) {
		_betaMode = [[self objectForKey:kSettingsBetaMode defaultValue:@"0"] boolValue];
	}
	return _betaMode;
}

- (void)setDevMode:(BOOL)devMode {
	_devMode = devMode;
	[self setObject:[NSString stringWithFormat:@"%d", (_devMode == YES ? 1:0)] forKey:kSettingsDevMode];
}

- (BOOL)devMode {
	if(!_devMode) {
		_devMode = [[self objectForKey:kSettingsDevMode defaultValue:@"0"] boolValue];
	}
	return _devMode;
}

- (void)setDevUrl:(NSString *)devUrl {
	_devUrl = devUrl;
	[self setObject:[NSString stringWithFormat:@"%@", _devUrl] forKey:kSettingsDevUrl];
}

- (NSString *)devUrl {
	if(!_devUrl) {
		_devUrl = [self objectForKey:kSettingsDevUrl defaultValue:@"https://dev.shootandprove.com"];
	}
	return _devUrl;
}

- (void)setMapType:(MKMapType)mapType {
	_mapType = mapType;
	if(mapType == MKMapTypeStandard) {
		[self setObject:@"0" forKey:kSettingsMapType];
	} else if(mapType == MKMapTypeSatellite) {
		[self setObject:@"1" forKey:kSettingsMapType];
	} else if(mapType == MKMapTypeHybrid) {
		[self setObject:@"2" forKey:kSettingsMapType];
	}
}

- (NSString *)mobileLanguage {
	NSString * prefLanguage = [[[NSLocale preferredLanguages] objectAtIndex:0] lowercaseString];
	NSLog(@"Apple language: %@", prefLanguage);
	
	NSString *language;
	if([prefLanguage containsString:@"-"]) {
		NSArray *prefLanguageParts = [prefLanguage componentsSeparatedByString:@"-"];
		language = [prefLanguageParts firstObject];
	} else {
		language = prefLanguage;
	}
	return language;
}

- (NSString *)mobileISOCountryCode {
	return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}


@end
