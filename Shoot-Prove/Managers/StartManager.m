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

#import "StartManager.h"
#import "StoreManager.h"
#import "RestClientManager.h"
#import "SettingsManager.h"
#import "NotificationManager.h"
#import "InAppPurchaseManager.h"

#import "FreeCaptureViewController.h"

#import "ErrorHelper.h"
#import "CleanAndRepairHelper.h"

#import "User.h"
#import "Ident.h"
#import "Device.h"
#import "Eula.h"

@interface StartManager()
{
    User *_user;
    BOOL _didRegister;
    BOOL _serverOnline;
}
@end

@implementation StartManager
@synthesize delegate, navigationController = _navigationController;

#pragma - public instance
+ (instancetype)sharedManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[StartManager alloc] init];
    });
    return manager;
}

#pragma - helper to set the max progress value in delegate
- (void)setMaxProgressValue:(NSInteger)value {
    if([self.delegate respondsToSelector:@selector(didStartManagerSetMaxSteps:)]) {
        [self.delegate didStartManagerSetMaxSteps:value];
    }
}

#pragma - helper set a progress value in delegate
- (void)setProgressValue:(NSInteger)value async:(BOOL)async {
    if([self.delegate respondsToSelector:@selector(didStartManagerSetStep:async:)]) {
        [self.delegate didStartManagerSetStep:value async:async];
    }
}

#pragma - start manager step 1
- (void)start {
    _user = [StoreManager.sharedManager fetchUser];
    _didRegister = NO;
    [self setMaxProgressValue:6];
    [self setProgressValue:1 async:NO];
    if(_user) {
        [self authenticateDevice];
    } else {
        [self startRegistration];
    }
}

- (void)reset {
    [self setProgressValue:0 async:NO];
    [self setMaxProgressValue:0];
    [self deleteLocalUser];
    _user = nil;
    [StoreManager.sharedManager cleanSharedDirectoy];
    [SettingsManager.sharedManager setLastViewControllerName:NSStringFromClass([FreeCaptureViewController class])];
    [SettingsManager.sharedManager setDevMode:NO];
    [SettingsManager.sharedManager setBetaMode:NO];
    [SettingsManager.sharedManager save];
    [RestClientManager.sharedManager useProductionServer];
    if([self.delegate respondsToSelector:@selector(didStartManagerRequestReset)]) {
        [self.delegate didStartManagerRequestReset];
    }
}

#pragma - Reset helper to delete the user
- (void)deleteLocalUser {
    [StoreManager.sharedManager deleteUser:_user];
    NSError *error;
    [StoreManager.sharedManager saveContext:&error];
    if(error) {
        [ErrorHelper popToastWithMessage:error.localizedDescription style:ToastHelper.styleError];
    } else {
        _user = nil;
    }
}

#pragma - Main authentication method - start process step 2
- (void)authenticateDevice {
    
    [self setProgressValue:2 async:NO];
    Device *device = [DeviceHelper getCurrentDevice];
    
    if(device) {
        
        BOOL userHadSubscription = (_user.activeSubscription != nil);
        
        [[RestClientManager sharedManager] authDevice:device andReturnUser:^(User *user, NSInteger statusCode, NSError *error) {
            
            if(statusCode == 200) {
                
                _user = user;
                //reset dev and beta mode in case the user is not dev or beta anymore
                if([user.devUser isEqualToNumber:@0]) {
                    [SettingsManager.sharedManager setDevMode:NO];
                }
                if([user.betaUser isEqualToNumber:@0]) {
                    [SettingsManager.sharedManager setBetaMode:NO];
                    [RestClientManager.sharedManager useProductionServer];
                }
                //if the user now has a subscription (which the App did not know)
                //migrate the user account
                if(!userHadSubscription && user.activeSubscription) {
                    [CleanAndRepairHelper migrateFreeToSubscriptionUser:user];
                }
                [self getAllUserDevices];
                
            } else {
                
                if(statusCode == 403) {
                    [ErrorHelper popToastWithMessage:NSLocalizedString(@"REGISTER_DEVICE_DELETED", nil) style:ToastHelper.styleWarning];
                    [self reset];
                } else {
                    [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleWarning];
                    [self prepareApplication];
                }
            }
        }];
    } else {
        [self getMe];
    }
}

#pragma - registration process step 1
- (void)startRegistration {
    [self setProgressValue:1 async:NO];
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initForRegistration:YES delegate:self];
    [_navigationController pushViewController:registerViewController animated:YES];
}

#pragma - RegisterViewController delegate methods
- (void)didRegisterViewControllerRequestOAuthAtURL:(NSURL *)url title:(NSString *)title fakeBrowser:(BOOL)fakeBrowser {
    RegisterOAuthViewController *oauthVc = [[RegisterOAuthViewController alloc] initWithURL:url behaveAsBrowser:fakeBrowser title:title delegate:self];
    [_navigationController pushViewController:oauthVc animated:YES];
}

- (void)didRegisterViewControllerReturnEmailRegistrationSuccess {
    [self getMe];
}

#pragma - register oauth delegate
- (void)didRegisterOAuthViewControllerRequestCancel {
    [_navigationController popViewControllerAnimated:YES];
}

- (void)didRegisterOAuthViewControllerReturnSuccess {
    [self getMe];
}

#pragma - registration process step 2
- (void)getMe {
    [self setProgressValue:2 async:NO];
    [RestClientManager.sharedManager getMe:^(User *user, NSInteger statusCode, NSError *error) {
        if(statusCode == 200) {
            _user = user;
            [self checkPhoneNumberIdentity];
        } else {
            [ErrorHelper popDialogForStatusCode:statusCode error:error type:DialogTypeError];
            [self reset];
        }
    }];
}

- (void)checkPhoneNumberIdentity {
     BOOL hasPhoneIdent = NO;
     for(Ident *ident in _user.idents) {
         if([ident.type isEqualToString:@"phone"]) {
             hasPhoneIdent = YES;
             break;
         }
     }
     if(hasPhoneIdent) {
         [self getAllUserDevices];
     } else {
         RegisterPhoneViewController *phoneVc = [[RegisterPhoneViewController alloc] initForRegistration:YES delegate:self];
         [_navigationController pushViewController:phoneVc animated:YES];
     }
}

#pragma - register phone delegate
- (void)didRegisterPhoneViewControllerReturnUser:(User *)user {
    _user = user;
    [self getAllUserDevices];
}

- (void)didRegisterPhoneViewControllesSkip {
    [self getAllUserDevices];
}

#pragma - registration/start process step 3
- (void)getAllUserDevices {
    
    [self setProgressValue:3 async:NO];
    __block int numberOfDevices = (int)_user.devices.count;
    __block int deviceNum = 0;
    
    if(numberOfDevices > 0) {
        for(Device *device in _user.devices) {
            [RestClientManager.sharedManager getDevice:device.uuid block:^(Device *device, NSInteger statusCode, NSError *error) {
                deviceNum++;
                if(deviceNum == numberOfDevices) {
                    [self registerCurrentDevice];
                }
            }];
        }
    } else {
        [self registerCurrentDevice];
    }
    
}

#pragma - registration/start process step 4
- (void)registerCurrentDevice {
    
    [self setProgressValue:4 async:NO];
    Device *device = [DeviceHelper getCurrentDevice];
    
    if(!device) {
        
        DeviceProperties *deviceProperties = [DeviceHelper getDeviceProperties];
        device = [StoreManager.sharedManager createDeviceForUser:_user withProperties:deviceProperties];
        
        [RestClientManager.sharedManager postDevice:device block:^(Device *device, NSInteger statusCode, NSError *error) {
            if(statusCode <= 204) {
                [self checkUserEula];
            } else {
                [ErrorHelper popDialogForStatusCode:statusCode error:error type:DialogTypeError];
                [self reset];
            }
        }];
        
    } else {
        [self checkUserEula];
    }
    
}

#pragma - registration/start process step 5
- (void)checkUserEula {
    
    [self setProgressValue:5 async:NO];
    [RestClientManager.sharedManager getEula:^(Eula *eula, NSInteger statusCode, NSError *error) {
        if(statusCode <= 204) {
            if(!eula || [_user.eulaAcceptVersion isEqualToNumber:eula.version]) {
                [self prepareApplication];
            } else {
                [self startEulaValidationWithEula:eula];
            }
        } else {
            if(![_user.eulaAcceptVersion isEqualToNumber:@0]) {
                [self prepareApplication];
            } else {
                [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_ERROR", nil) message:error.localizedDescription type:DialogTypeError];
                [self reset];
            }
        }
    }];
}

- (void)startEulaValidationWithEula:(Eula *)eula {
    RegisterTermsViewController *termsViewController = [[RegisterTermsViewController alloc] initWithEula:eula newVersion:![_user.eulaAcceptVersion isEqualToNumber:@0] enableCancel:NO delegate:self];
    [_navigationController pushViewController:termsViewController animated:YES];
}

#pragma terms view controller delegate
- (void)didRegisterTermsViewControllerReturnEula:(Eula *)eula {
    
    _user.eulaAcceptDate = [NSDate date];
    _user.eulaAcceptVersion = eula.version;
    DeviceProperties *props = [DeviceHelper getDeviceProperties];
    _user.locale = props.preferredLanguage;
    
    [RestClientManager.sharedManager putUser:_user block:^(NSInteger statusCode, NSError *error) {
        
        if(statusCode >= 400) {
            [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleWarning];
        }
        [self prepareApplication];
        
    }];
    
}

#pragma - registration/start process step 6
- (void)prepareApplication {
    
    [self setProgressValue:6 async:NO];
    
    [NotificationManager.sharedManager registerAPNS];
    
    NSError *error;
    [CleanAndRepairHelper cleanAndRepair:&error];
    if(error) {
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
        error = nil;
    }
    
    error = [ImageHelper activateLeadToolsLicense];
    if(error) {
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
        error = nil;
    }
    
    if(![InAppPurchaseManager.sharedManager canMakePurchases]) {
        [ErrorHelper popToastWithMessage:NSLocalizedString(@"IAP_DISABLED", nil) style:ToastHelper.styleWarning];
    }
    
    //Init the certification client manager to start the location service now
    [CertificationClient sharedManager];
    
    if([self.delegate respondsToSelector:@selector(didStartManagerRequestDisplayInterfaceWithUser:serverOnline:)]) {
        [self.delegate didStartManagerRequestDisplayInterfaceWithUser:_user serverOnline:_serverOnline];
    }
    
    [self updateDeviceBuildNumber];
    
}

- (void)updateDeviceBuildNumber {
    
    Device *device = [DeviceHelper getCurrentDevice];
    DeviceProperties *deviceProperties = [DeviceHelper getDeviceProperties];
    
    if(![deviceProperties.buildNumber isEqualToString:device.buildNumber]) {
        
        device.buildNumber = deviceProperties.buildNumber;
        [RestClientManager.sharedManager putDevice:device block:^(Device *device, NSInteger statusCode, NSError *error) {
            if(statusCode >= 400) {
                [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleWarning];
            }
        }];
        
    }
    
}

@end
