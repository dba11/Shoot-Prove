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

#import "RegisterTermsViewController.h"
#import "RestClientManager.h"
#import "ErrorHelper.h"
#import "DeviceHelper.h"
#import "Eula.h"

@interface RegisterTermsViewController ()
{
	BOOL _isNewVersion;
	BOOL _enableCancel;
	Eula *_eula;
	UIBarButtonItem *_btnAccept;
	UIBarButtonItem *_btnBack;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<RegisterTermsViewControllerDelegate> delegate;
@end

@implementation RegisterTermsViewController
#pragma view life cycle
- (id)initWithEula:(Eula *)eula newVersion:(BOOL)isNewVersion enableCancel:(BOOL)enableCancel delegate:(id<RegisterTermsViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		_eula = eula;
		_isNewVersion = isNewVersion;
		_enableCancel = enableCancel;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self buildButtons];
	self.title = NSLocalizedString(@"TITLE_TERMS", nil);
	[self.webView setScalesPageToFit:YES];
	[self openURL];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if(_enableCancel && [self.delegate respondsToSelector:@selector(didRegisterTermsViewControllerRequestCancel)]) {
		[self.navigationItem setLeftBarButtonItems:@[_btnBack]];
		[self.navigationItem setRightBarButtonItems:nil];
	} else {
		[self.navigationItem setHidesBackButton:YES];
		[self.navigationItem setLeftBarButtonItems:nil];
		[self.navigationItem setRightBarButtonItems:@[_btnAccept]];
	}
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)buildButtons {
	_btnBack = [[UIBarButtonItem alloc] init];
	[_btnBack setImage:[UIImage imageNamed:@"back"]];
	[_btnBack setTarget:self];
	[_btnBack setAction:@selector(back)];
	
	_btnAccept = [[UIBarButtonItem alloc] init];
	[_btnAccept setTitle:NSLocalizedString(@"BUTTON_ACCEPT", nil)];
	[_btnAccept setTarget:self];
	[_btnAccept setAction:@selector(accept)];
}

- (void)openURL {
	_btnAccept.enabled = NO;
	[self.activityIndicator startAnimating];
    DeviceProperties *props = [DeviceHelper getDeviceProperties];
    NSArray *languageAndCountry = [props.preferredLanguage componentsSeparatedByString:@"-"];
    NSString *language = [languageAndCountry objectAtIndex:0];
    NSString *url = [_eula.urls objectForKey:language];
    if(!url)
        url = _eula.url;
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self.webView setDelegate:self];
	[self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	if(_isNewVersion) {
        [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_TERMS", nil) message:NSLocalizedString(@"REGISTER_TERMS_HAVE_CHANGED", nil) type:DialogTypeInfo];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.activityIndicator stopAnimating];
	_btnAccept.enabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self.activityIndicator stopAnimating];
	[[[Dialog alloc] initWithType:DialogTypeError title:NSLocalizedString(@"TITLE_ERROR", nil) message:[error localizedDescription] confirmButtonTitle:NSLocalizedString(@"BUTTON_RETRY", nil) confirmTag:retryTag cancelButtonTitle:NSLocalizedString(@"BUTTON_CANCEL", nil) target:self] show];
}

#pragma - accept button event (if exists by init)
- (void)accept {
	[[[Dialog alloc] initWithType:DialogTypeInfo title:NSLocalizedString(@"TITLE_CONFIRM", nil) message:NSLocalizedString(@"REGISTER_TERMS_CONFIRM_MESSAGE", nil) confirmButtonTitle:NSLocalizedString(@"BUTTON_CONFIRM", nil)  confirmTag:acceptTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
}

#pragma - back button event (if allowed by init)
- (void)back {
	if([self.delegate respondsToSelector:@selector(didRegisterTermsViewControllerRequestCancel)]) {
		[self.delegate didRegisterTermsViewControllerRequestCancel];
	}
}

#pragma DialogUtils delegate
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
	if([tag isEqualToString:retryTag]) {
		[self openURL];
	} else if([tag isEqualToString:acceptTag]) {
		[self confirm];
	}
}

- (void)confirm {
	[self.activityIndicator startAnimating];
	if([self.delegate respondsToSelector:@selector(didRegisterTermsViewControllerReturnEula:)]) {
		[self.delegate didRegisterTermsViewControllerReturnEula:_eula];
	}
}
@end
