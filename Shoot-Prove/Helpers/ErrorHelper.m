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

#import "ErrorHelper.h"

@implementation ErrorHelper
+ (NSError *)errorFromException:(NSException *)exception module:(NSString *)module action:(NSString *)action {
	NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
	[errorDict setObject:[NSString stringWithFormat:@"Error %@: %@", action, exception.reason] forKey:NSLocalizedDescriptionKey];
	[errorDict setObject:exception.reason forKey:NSLocalizedFailureReasonErrorKey];
	return [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"%@.%@", @"com.shootandprove", module] code:-1 userInfo:errorDict];
}

+ (NSString *)errorMessageFromStatusCode:(NSInteger)statusCode error:(NSError *)error {
    NSString *keyword = [NSString stringWithFormat:@"ERROR_%ld", (long)statusCode];
    NSString *message = NSLocalizedString(keyword, nil);
    if(!message)
        message = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ERROR_GENERIC", nil), error ? [NSString stringWithFormat:@": %@", error.localizedDescription] : @"."];
    return message;
}

+ (void)popDialogWithTitle:(NSString *)title message:(NSString *)message type:(DialogType)type {
    [[[Dialog alloc] initWithType:type title:title message:message confirmButtonTitle:nil confirmTag:nil cancelButtonTitle:NSLocalizedString(@"BUTTON_OK", nil) target:nil] show];
}

+ (void)popToastWithMessage:(NSString *)message style:(CSToastStyle *)style {
    UIImage *image;
    if([style.titleColor isEqual:ToastHelper.styleError.titleColor])
        image = ToastHelper.imageError;
    else if([style.titleColor isEqual:ToastHelper.styleWarning.titleColor])
        image = ToastHelper.imageWarning;
    else
        image = ToastHelper.imageInfo;
    UIView * view = UIApplication.sharedApplication.keyWindow.subviews.lastObject;
    [view makeToast:message duration:toastDuration position:CSToastPositionBottom title:nil image:image style:style completion:^(BOOL didTap) {}];
}

+ (void)popDialogForStatusCode:(NSInteger)statusCode error:(NSError *)error type:(DialogType)type {
    NSString *message = [self errorMessageFromStatusCode:statusCode error:error];
    NSString *title;
    if(type == DialogTypeError)
        title = NSLocalizedString(@"TITLE_ERROR", nil);
    else if(type == DialogTypeWarning)
        title = NSLocalizedString(@"TITLE_WARNING", nil);
    else
        title = NSLocalizedString(@"TITLE_INFO", nil);
    [self popDialogWithTitle:title message:message type:type];
}

+ (void)popToastForStatusCode:(NSInteger)statusCode error:(NSError *)error style:(CSToastStyle *)style {
    NSString *message = [self errorMessageFromStatusCode:statusCode error:error];
    [self popToastWithMessage:message style:style];
}
@end
