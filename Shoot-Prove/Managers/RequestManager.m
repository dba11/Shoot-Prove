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

#import "RequestManager.h"

#import "StoreManager.h"
#import "RestClientManager.h"

#import "ErrorHelper.h"
#import "TaskHelper.h"

#import "User.h"
#import "Task.h"

@interface RequestManager() {
    User *_user;
    NSDictionary *_requestDictionary;
}
@end

@implementation RequestManager
@synthesize delegate;

+ (instancetype)sharedManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if(self) {
        _user = [[StoreManager sharedManager] fetchUser];
        _requestDictionary = nil;
    }
    return self;
}

- (BOOL)hasPendingRequest {
    return (_requestDictionary != nil);
}

- (void)registerRequest:(NSString *)base64request {
    NSData *requestData = [[NSData alloc] initWithBase64EncodedString:base64request options:0];
    NSError *error = nil;
    _requestDictionary = [NSJSONSerialization JSONObjectWithData:requestData options:0 error:&error];
    if(error) {
        [ErrorHelper popToastWithMessage:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"REQUEST_PARSE_ERROR",nil), error.localizedDescription] style:ToastHelper.styleError];
        _requestDictionary = nil;
        return;
    }
}

- (void)processPendingRequest {
    if(!_requestDictionary)
        return;
    [RestClientManager.sharedManager postQRCode:_requestDictionary block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
        if(statusCode == 200) {
            NSString *action = [_requestDictionary objectForKey:@"a"];
            if([action isEqualToString:@"start"]) {
                NSError *createTaskError;
                Task *task = [TaskHelper createTaskFromDictionary:dictionary visible:YES error:&createTaskError];
                if(!createTaskError) {
                    if([self.delegate respondsToSelector:@selector(didRequestManagerRequestStartTask:)]) {
                        [self.delegate didRequestManagerRequestStartTask:task];
                    }
                } else {
                    [ErrorHelper popToastWithMessage:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"REQUEST_POST_ERROR",nil), createTaskError.localizedDescription] style:ToastHelper.styleError];
                }
            }
        } else {
            [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
        }
        _requestDictionary = nil;
    }];
}
@end
