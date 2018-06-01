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

#import "RegisterOAuthViewController.h"
#import "RestClientManager.h"
#import "StoreManager.h"
#import "User.h"

@interface RegisterOAuthViewController ()
{
    BOOL _behaveAsBrowser;
	NSURL *_oauthURL;
	UIBarButtonItem *_btnBack;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<RegisterOAuthViewControllerDelegate> delegate;
@end

@implementation RegisterOAuthViewController
- (id)initWithURL:(NSURL *)url behaveAsBrowser:(BOOL)behaveAsBrowser title:(NSString *)title delegate:(id<RegisterOAuthViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		self.title = title;
        _behaveAsBrowser = behaveAsBrowser;
		_oauthURL = url;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self buildBackButton];
    if(_behaveAsBrowser) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", @"UserAgent", nil];
        [NSUserDefaults.standardUserDefaults registerDefaults:dictionary];
    }
	NSHTTPCookieStorage *storage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
	for (NSHTTPCookie *cookie in storage.cookies) {
		if ([cookie.domain rangeOfString:@"google"].location != NSNotFound ||
			[cookie.domain rangeOfString:@"facebook"].location != NSNotFound) {
			[storage deleteCookie:cookie];
		}
	}
	[self openURL];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItems:@[_btnBack]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma - build buttons
- (void)buildBackButton {
	_btnBack = [[UIBarButtonItem alloc] init];
	[_btnBack setImage:[UIImage imageNamed:@"back"]];
	[_btnBack setTarget:self];
	[_btnBack setAction:@selector(back)];
}

#pragma - web view methods and delegate
- (void)openURL {
	NSURLRequest *request = [NSURLRequest requestWithURL:_oauthURL];
	[self.webView setDelegate:self];
	[self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.mainDocumentURL;
    if([url.host containsString:@"www.shootandprove.com"] || [url.host containsString:@"beta.shootandprove.com"]) {
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *urlComponents = [url.query componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            [queryStringDictionary setObject:value forKey:key];
        }
        NSLog(@"OAuth URL: %@\nHost: %@\nParameters: %@", url, url.host, queryStringDictionary.description);
        [self.activityIndicator stopAnimating];
        if([self.delegate respondsToSelector:@selector(didRegisterOAuthViewControllerReturnSuccess)]) {
            [self.delegate didRegisterOAuthViewControllerReturnSuccess];
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[[Dialog alloc] initWithType:DialogTypeError title:NSLocalizedString(@"TITLE_ERROR", nil) message:[error localizedDescription] confirmButtonTitle:NSLocalizedString(@"BUTTON_RETRY", nil) confirmTag:retryTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
	[self.activityIndicator stopAnimating];
}

- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
	if([tag isEqualToString:retryTag]) {
		[self openURL];
	}
}

- (void)back {
	if([self.delegate respondsToSelector:@selector(didRegisterOAuthViewControllerRequestCancel)]) {
		[self.delegate didRegisterOAuthViewControllerRequestCancel];
	}
}
@end
