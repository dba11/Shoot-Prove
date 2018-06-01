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

#import "StyleHelper.h"
#import "UIStyle.h"
#import "UIColor+HexString.h"

@implementation StyleHelper
+ (void)setDefaultStyleOnViewController:(UIViewController *)controller {
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setOpaque:YES];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:colorWhite andAlpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:boldFontName size:largeFontSize], NSFontAttributeName, nil]];
    [[UIToolbar appearance] setBarStyle:UIBarStyleDefault];
    [[UIToolbar appearance] setTintColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
    [[UIToolbar appearance] setBarTintColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
    [[UIToolbar appearance] setTranslucent:NO];
    [[UIToolbar appearance] setOpaque:YES];
    if(controller) {
        controller.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        controller.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
        controller.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f];
        controller.navigationController.navigationBar.translucent = NO;
        controller.navigationController.navigationBar.opaque = YES;
        [controller.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:colorWhite andAlpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:boldFontName size:largeFontSize], NSFontAttributeName, nil]];
        controller.navigationController.toolbar.barStyle = UIBarStyleDefault;
        controller.navigationController.toolbar.tintColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
        controller.navigationController.toolbar.barTintColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f];
        controller.navigationController.toolbar.translucent = NO;
        controller.navigationController.toolbar.opaque = YES;
    }
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class], [UINavigationBar class]]] setBackgroundColor:[UIColor clearColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class], [UINavigationBar class]]] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:colorWhite andAlpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:boldFontName size:normalFontSize], NSFontAttributeName, [UIColor clearColor], NSBackgroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UILabel appearance] setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [[UILabel appearance] setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [[UITextField appearance] setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
    [[UITextField appearance] setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [[UITextField appearance] setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [[UIActivityIndicatorView appearance] setColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
    [[UIActivityIndicatorView appearance] setHidesWhenStopped:YES];
}

+ (void)setStyle:(UIStyle *)style viewController:(UIViewController *)controller {
    controller.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    controller.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f];
    controller.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f];
    controller.navigationController.navigationBar.translucent = NO;
    controller.navigationController.navigationBar.opaque = YES;
    [controller.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:boldFontName size:largeFontSize], NSFontAttributeName, nil]];
    controller.navigationController.toolbar.barStyle = UIBarStyleDefault;
    controller.navigationController.toolbar.tintColor = [UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f];
    controller.navigationController.toolbar.barTintColor = [UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f];
    controller.navigationController.toolbar.translucent = NO;
    controller.navigationController.toolbar.opaque = YES;
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class], [UINavigationBar class]]] setBackgroundColor:[UIColor clearColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setTextColor:[UIColor colorWithHexString:style.promptColor andAlpha:1.0f]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class], [UINavigationBar class]]] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f], NSForegroundColorAttributeName, [UIFont fontWithName:boldFontName size:normalFontSize], NSFontAttributeName, [UIColor clearColor], NSBackgroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UILabel appearance] setTextColor:[UIColor colorWithHexString:style.promptColor andAlpha:1.0f]];
    [[UILabel appearance] setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [[UITextField appearance] setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
    [[UITextField appearance] setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [[UITextField appearance] setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [[UIActivityIndicatorView appearance] setColor:[UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f]];
    [[UIActivityIndicatorView appearance] setHidesWhenStopped:YES];
}
@end
