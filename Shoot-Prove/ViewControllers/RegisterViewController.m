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

#import "RegisterViewController.h"
#import "RestClientManager.h"
#import "User.h"
#import "Ident.h"
#import "UIColor+HexString.h"
#import "UIView+FirstResponder.h"
#import "NSString+Email.h"
#import "ErrorHelper.h"
#import "EnumHelper.h"

#define ROW_HEIGHT 80.0f

@interface RegisterViewController ()
{
	BOOL _isRegistration;
    BOOL _registrationInProgress;
    BOOL _forgottenPasswordInProgress;
	UIBarButtonItem *_btnBack;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcome;
@property (weak, nonatomic) IBOutlet UILabel *lblRegisterOAuth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblRegisterOAuthTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogle;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UILabel *lblOr;
@property (weak, nonatomic) IBOutlet UILabel *lblRegisterPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblRegisterEmailTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblRegisterEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorEmail;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnForgottenPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnForgottenPasswordHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<RegisterViewControllerDelegate> delegate;
@end

@implementation RegisterViewController

#pragma - view life cycle
- (id)initForRegistration:(BOOL)isRegistration delegate:(id<RegisterViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		_isRegistration = isRegistration;
        self.delegate = delegate;
        if(_isRegistration) {
            NSHTTPCookieStorage *storage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
            for (NSHTTPCookie *cookie in storage.cookies) {
                if ([cookie.name isEqualToString:KcookieName]) {
                    [storage deleteCookie:cookie];
                    NSLog(@"Webda cookie deleted:\nDomain: %@\nName: %@\nValue: %@", cookie.domain, cookie.name, cookie.value);
                    break;
                }
            }
        }
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self buildBackButton];
    self.title = _isRegistration ? NSLocalizedString(@"TITLE_REGISTER", nil) : NSLocalizedString(@"NEW_IDENTITY_TITLE", nil);
    self.imageViewLogo.hidden = !_isRegistration;
    self.lblWelcome.font = [UIFont fontWithName:boldFontName size:largeFontSize];
    self.lblWelcome.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
    self.lblWelcome.text = NSLocalizedString(@"REGISTER_WELCOME", nil);
    self.lblWelcome.hidden = !_isRegistration;
    self.lblRegisterOAuth.font = [UIFont fontWithName:normalFontName size:smallFontSize];
    self.lblRegisterOAuth.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
    self.lblRegisterOAuth.text = _isRegistration ? NSLocalizedString(@"REGISTER_OAUTH", nil) : NSLocalizedString(@"NEW_IDENTITY_OAUTH", nil);
    self.lblRegisterOAuthTopConstraint.constant = _isRegistration ? self.lblWelcome.frame.origin.y + self.lblWelcome.frame.size.height + 8 : self.imageViewLogo.frame.origin.y;
    self.lblOr.font = [UIFont fontWithName:normalFontName size:normalFontSize];
    self.lblOr.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
    self.lblOr.text = _isRegistration ? NSLocalizedString(@"REGISTER_OR", nil) : NSLocalizedString(@"NEW_IDENTITY_OR", nil);
    self.lblRegisterPhone.font = [UIFont fontWithName:normalFontName size:smallFontSize];
    self.lblRegisterPhone.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
    self.lblRegisterPhone.text = NSLocalizedString(@"NEW_IDENTITY_PHONE", nil);
    self.lblRegisterPhone.hidden = _isRegistration; //hide during registration
    self.btnRegisterPhone.backgroundColor = [UIColor colorWithHexString:colorLightGrey andAlpha:0.4f];
    self.btnRegisterPhone.layer.borderColor = [UIColor colorWithHexString:colorLightGrey andAlpha:0.7f].CGColor;
    self.btnRegisterPhone.layer.cornerRadius = 5.0f;
    self.btnRegisterPhone.layer.masksToBounds = YES;
    [self.btnRegisterPhone setTitleColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f] forState:UIControlStateNormal];
    self.btnRegisterPhone.titleLabel.font = [UIFont fontWithName:boldFontName size:mediumFontSize];
    [self.btnRegisterPhone setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"TITLE_REGISTER_PHONE", nil)] forState:UIControlStateNormal] ;
    UIImage *image = [[UIImage imageNamed:@"phone_50"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.btnRegisterPhone setImage:image forState:UIControlStateNormal];
    self.btnRegisterPhone.imageView.tintColor = [UIColor colorWithHexString:colorBlue andAlpha:1.0f];
    self.btnRegisterPhone.hidden = _isRegistration; //hide during registration
    self.lblRegisterEmail.font = [UIFont fontWithName:normalFontName size:smallFontSize];
    self.lblRegisterEmail.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
    self.lblRegisterEmail.text = _isRegistration ? NSLocalizedString(@"REGISTER_EMAIL", nil) : NSLocalizedString(@"NEW_IDENTITY_EMAIL", nil);
    self.lblRegisterEmailTopConstraint.constant = _isRegistration ? 8 : 139;
    self.lblRegisterEmail.hidden = !_isRegistration; //show only during registration for now
    self.txtEmail.font = [UIFont fontWithName:normalFontName size:normalFontSize];
    self.txtEmail.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0];
    self.txtEmail.placeholder = NSLocalizedString(@"REGISTER_EMAIL_PLACEHOLDER", nil);
    self.txtEmail.delegate = self;
    self.txtEmail.hidden = !_isRegistration; //show only during registration for now
    self.txtPassword.font = [UIFont fontWithName:normalFontName size:normalFontSize];
    self.txtPassword.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0];
    self.txtPassword.placeholder = NSLocalizedString(@"REGISTER_EMAIL_PASSWORD_PLACEHOLDER", nil);
    self.txtPassword.delegate = self;
    self.txtPassword.hidden = !_isRegistration; //show only during registration for now
    self.btnDone.backgroundColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f];
    self.btnDone.layer.borderColor = [UIColor colorWithHexString:colorGreen andAlpha:0.5f].CGColor;
    self.btnDone.layer.cornerRadius = 5.0f;
    self.btnDone.layer.masksToBounds = YES;
    [self.btnDone setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
    self.btnDone.titleLabel.font = [UIFont fontWithName:boldFontName size:largeFontSize];
    [self.btnDone setTitle:NSLocalizedString(@"BUTTON_OK", nil) forState:UIControlStateNormal];
    self.btnDone.hidden = !_isRegistration; //show only during registration for now
    self.btnForgottenPassword.backgroundColor = [UIColor clearColor];
    [self.btnForgottenPassword setTitleColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f] forState:UIControlStateNormal];
    self.btnForgottenPassword.titleLabel.font = [UIFont fontWithName:normalFontName size:normalFontSize];
    [self.btnForgottenPassword setTitle:NSLocalizedString(@"BUTTON_FORGOTTEN_PASSWORD", nil) forState:UIControlStateNormal];
    self.btnForgottenPassword.hidden = !_isRegistration; //show only during registration
    self.btnForgottenPasswordHeightConstraint.constant = _isRegistration ? 20:0;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if(!_isRegistration && [self.delegate respondsToSelector:@selector(didRegisterViewControllerRequestCancel)]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationItem setLeftBarButtonItems:@[_btnBack]];
        [self.navigationItem setRightBarButtonItems:nil];
	} else {
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	}
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat availableWidth = self.view.frame.size.width;
    CGFloat contentHeight = self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 8;
    CGRect frame;
    if(availableWidth > viewMaxWidth) {
        frame = CGRectMake((self.scrollView.frame.size.width - viewMaxWidth)/2, 0, viewMaxWidth, contentHeight);
    } else {
        frame = CGRectMake((self.scrollView.frame.size.width - availableWidth)/2, 0, availableWidth, contentHeight);
    }
    self.contentView.frame = frame;
    [self.scrollView addSubview:self.contentView];
    [self.scrollView setContentSize:frame.size];
}

#pragma - build buttons
- (void)buildBackButton {
    _btnBack = [[UIBarButtonItem alloc] init];
    [_btnBack setImage:[UIImage imageNamed:@"back"]];
    [_btnBack setTarget:self];
    [_btnBack setAction:@selector(back)];
}

#pragma - text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
    } else if(textField == self.txtPassword) {
        [self done:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    if(textField == self.txtEmail) {
        self.txtEmail.text = [self.txtEmail.text lowercaseString];
        [self checkEmail];
    } else if(textField == self.txtPassword) {
        [self checkPassword];
    }
}

#pragma - email registration verification helpers
- (void)checkEmail {
    [self.activityIndicatorEmail startAnimating];
    if([self.txtEmail.text length] == 0) {
        if(_registrationInProgress || _forgottenPasswordInProgress) {
            [self.txtEmail setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:0.3f]];
            [self showRegistrationError:NSLocalizedString(@"REGISTER_EMAIL_CANT_BE_EMPTY", nil) andSetFirstResponder:self.txtEmail];
        }
        [self.activityIndicatorEmail stopAnimating];
    } else if(![self.txtEmail.text isValidEmail]) {
        [self.txtEmail setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:0.3f]];
        if(_registrationInProgress || _forgottenPasswordInProgress) {
            [self showRegistrationError:NSLocalizedString(@"REGISTER_EMAIL_INVALID_EMAIL", nil) andSetFirstResponder:self.txtEmail];
        }
        [self.activityIndicatorEmail stopAnimating];
    } else {
        [self.txtEmail setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:0.3f]];
        if(_registrationInProgress) {
            [self checkPassword];
        } else if(_forgottenPasswordInProgress) {
            [self sendForgottenPasswordRequest];
        }
        [self.activityIndicatorEmail stopAnimating];
    }
}

- (void)checkPassword {
    [self.activityIndicatorPassword startAnimating];
    [self.txtPassword setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:0.3f]];
    if(_registrationInProgress) {
        [self registerUser];
    }
    [self.activityIndicatorPassword stopAnimating];
}

#pragma - helper to register the user email and password and return to delegate
- (void)registerUser {
    [[RestClientManager sharedManager] authEmail:self.txtEmail.text password:self.txtPassword.text requestRegister:NO block:^(NSInteger statusCode, NSError *error) {
        _registrationInProgress = NO;
        
        if(statusCode <= 204) {
            if(self.txtPassword.text.length < 8) {

                [[RestClientManager sharedManager] forgottenPasswordForEmail:self.txtEmail.text block:^(NSInteger statusCode, NSError *error) {
                    [self.activityIndicator stopAnimating];
                    if(statusCode <= 204) {
                        [[[Dialog alloc] initWithType:DialogTypeInfo title:NSLocalizedString(@"REGISTER_PASSWORD_POLICY", nil) message:NSLocalizedString(@"REGISTER_POLICY_CHANGED", nil) confirmButtonTitle:nil confirmTag:nil cancelButtonTitle:NSLocalizedString(@"BUTTON_OK", nil) target:nil] show];
                    } else {
                        [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
                    }
                    [self.btnDone setHidden:NO];
                    [self.btnForgottenPassword setHidden:NO];
                    [self.txtPassword setText:nil];
                }];
            } else {
                [self.activityIndicator stopAnimating];
                [self returnSuccess];
            }
        } else {
            [self.activityIndicator stopAnimating];
            if(statusCode == 404) {
                if([self.txtPassword.text length] < 8) {
                    [self.txtPassword setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:0.3f]];
                    [self showRegistrationError:NSLocalizedString(@"REGISTER_EMAIL_PASSWORD_LENGTH", nil) andSetFirstResponder:self.txtPassword];
                } else {
                    [[[Dialog alloc] initWithType:DialogTypeInfo title:NSLocalizedString(@"TITLE_NO_ACCOUNT", nil) message:NSLocalizedString(@"REGISTER_EMAIL_NEW_ACCOUNT", nil) confirmButtonTitle:NSLocalizedString(@"BUTTON_YES", nil) confirmTag:registerTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
                }
            } else if(statusCode == 403) {
                [self.btnDone setHidden:NO];
                [self.btnForgottenPassword setHidden:NO];
                [ErrorHelper popToastWithMessage:NSLocalizedString(@"REGISTER_EMAIL_WRONG_PASSWORD", nil) style:ToastHelper.styleError];
            } else {
                [self.btnDone setHidden:NO];
                [self.btnForgottenPassword setHidden:NO];
                [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
            }
        }
    }];
}

#pragma - helper to send a forgotten password request
- (void)sendForgottenPasswordRequest {
    [[RestClientManager sharedManager] forgottenPasswordForEmail:self.txtEmail.text block:^(NSInteger statusCode, NSError *error) {
        [self.activityIndicator stopAnimating];
        _forgottenPasswordInProgress = NO;
        if(statusCode <= 204) {
            [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_INFO", nil) message:NSLocalizedString(@"REGISTER_PASSWORD_RECOVERY_EMAIL_SENT", nil) type:DialogTypeInfo];
        } else {
            [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleWarning];
        }
        [self.btnDone setHidden:NO];
        [self.btnForgottenPassword setHidden:NO];
    }];
}

#pragma - helper to handle email account creation confirmation
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
    if([tag isEqualToString:registerTag]) {
        [self.activityIndicator startAnimating];
        [[RestClientManager sharedManager] authEmail:self.txtEmail.text password:self.txtPassword.text requestRegister:YES  block:^(NSInteger statusCode, NSError *error) {
            [self.activityIndicator stopAnimating];
            if(!error && statusCode <= 204) {
                [self returnSuccess];
            } else {
                [self.btnDone setHidden:NO];
                [self.btnForgottenPassword setHidden:NO];
                [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
            }
        }];
    }
}

#pragma - helper to display warning and error messages
- (void) showRegistrationWarning:(NSString *)message andSetFirstResponder:(UITextField *)textField {
    [self.view makeToast:message duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
        [self.btnDone setHidden:NO];
        [self.btnForgottenPassword setHidden:NO];
        [textField becomeFirstResponder];
    }];
    [self.activityIndicator stopAnimating];
    _registrationInProgress = NO;
    _forgottenPasswordInProgress = NO;
}

- (void) showRegistrationError:(NSString *)message andSetFirstResponder:(UITextField *)textField {
    [self.view makeToast:message duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageError style:ToastHelper.styleError completion:^(BOOL didTap) {
        [self.btnDone setHidden:NO];
        [self.btnForgottenPassword setHidden:NO];
        [textField becomeFirstResponder];
    }];
    [self.activityIndicator stopAnimating];
    _registrationInProgress = NO;
    _forgottenPasswordInProgress = NO;
}

#pragma - return registration success method to delegate
- (void)returnSuccess {
	if([self.delegate respondsToSelector:@selector(didRegisterViewControllerReturnEmailRegistrationSuccess)]) {
		[self.delegate didRegisterViewControllerReturnEmailRegistrationSuccess];
	}
}

#pragma - button actions
- (void)back {
	if([self.delegate respondsToSelector:@selector(didRegisterViewControllerRequestCancel)]) {
		[self.delegate didRegisterViewControllerRequestCancel];
	}
}

- (IBAction)registerWithGoogle:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@", Khttp, Kdomain, @"auth/google"]];
    NSString *title = NSLocalizedString(@"REGISTER_GOOGLE_TITLE", nil);
    if([self.delegate respondsToSelector:@selector(didRegisterViewControllerRequestOAuthAtURL:title:fakeBrowser:)]){
        [self.delegate didRegisterViewControllerRequestOAuthAtURL:url title:title fakeBrowser:YES];
    }
}

- (IBAction)registerWithFacebook:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@", Khttp, Kdomain, @"auth/facebook"]];
    NSString *title = NSLocalizedString(@"REGISTER_FACEBOOK_TITLE", nil);
    if([self.delegate respondsToSelector:@selector(didRegisterViewControllerRequestOAuthAtURL:title:fakeBrowser:)]){
        [self.delegate didRegisterViewControllerRequestOAuthAtURL:url title:title fakeBrowser:NO];
    }
}

- (IBAction)registerPhone:(id)sender {
    if([self.delegate respondsToSelector:@selector(didRegisterViewControllerRequestPhoneAuth)]) {
        [self.delegate didRegisterViewControllerRequestPhoneAuth];
    }
}

- (IBAction)forgottenPassword:(id)sender {
    if(!_forgottenPasswordInProgress) {
        [[self.view findFirstResponder] resignFirstResponder];
        [self.activityIndicator startAnimating];
        _registrationInProgress = NO;
        _forgottenPasswordInProgress = YES;
        [self.btnDone setHidden:YES];
        [self.btnForgottenPassword setHidden:YES];
    }
    self.txtEmail.text = [self.txtEmail.text lowercaseString];
    [self checkEmail];
}

- (IBAction)done:(id)sender {
    if(!_registrationInProgress) {
        [[self.view findFirstResponder] resignFirstResponder];
        [self.activityIndicator startAnimating];
        _registrationInProgress = YES;
        _forgottenPasswordInProgress = NO;
        [self.btnDone setHidden:YES];
        [self.btnForgottenPassword setHidden:YES];
    }
    self.txtEmail.text = [self.txtEmail.text lowercaseString];
    [self checkEmail];
}
@end
