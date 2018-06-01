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

#import "RegisterPhoneViewController.h"
#import "RestClientManager.h"
#import "UIColor+HexString.h"
#import "NSString+Phone.h"
#import "UIView+FirstResponder.h"
#import "ErrorHelper.h"
#import "User.h"

@interface RegisterPhoneViewController ()
{
    BOOL _isRegistration;
	NSString *_phoneNumber;
	UIBarButtonItem *_btnBack;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblInfoHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnValidate;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<RegisterPhoneViewControllerDelegate>delegate;
@end

@implementation RegisterPhoneViewController
- (id)initForRegistration:(BOOL)isRegistration delegate:(id<RegisterPhoneViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
        _isRegistration = isRegistration;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self buildBackButton];
	self.title = NSLocalizedString(@"TITLE_REGISTER_PHONE", nil);
	
    [self.lblInfo setText:NSLocalizedString(@"REGISTER_PHONE_NEW_MESSAGE", nil)];
    self.lblInfo.font = [UIFont fontWithName:normalFontName size:smallFontSize];
    [self.lblInfo setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [self.lblInfo setTextAlignment:NSTextAlignmentCenter];
    
	[self.txtPhone setPlaceholder:NSLocalizedString(@"REGISTER_PHONE_PLACEHOLDER", nil)];
	[self.txtPhone setDelegate:self];
	
	[self.btnOk setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[[self.btnOk layer] setBorderColor:[[UIColor colorWithHexString:colorGreen andAlpha:0.5f] CGColor]];
	[[self.btnOk layer] setCornerRadius:5.0f];
	[[self.btnOk layer] setMasksToBounds:YES];
	[self.btnOk setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
	[[self.btnOk titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
	[self.btnOk setTitle:NSLocalizedString(@"BUTTON_OK", nil) forState:UIControlStateNormal];
	
	[self.lblMessage setText:NSLocalizedString(@"REGISTER_PHONE_TYPE_CODE", nil)];
    self.lblMessage.font = [UIFont fontWithName:normalFontName size:normalFontSize];
    [self.lblMessage setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.lblMessage setHidden:YES];
	
	[self.txtCode setPlaceholder:NSLocalizedString(@"REGISTER_PHONE_CODE_PLACEHOLDER", nil)];
	[self.txtCode setDelegate:self];
	[self.txtCode setHidden:YES];
	
	[self.btnValidate setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[[self.btnValidate layer] setBorderColor:[[UIColor colorWithHexString:colorGreen andAlpha:0.5f] CGColor]];
	[[self.btnValidate layer] setCornerRadius:5.0f];
	[[self.btnValidate layer] setMasksToBounds:YES];
	[self.btnValidate setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
	[[self.btnValidate titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
	[self.btnValidate setTitle:NSLocalizedString(@"BUTTON_VALIDATE", nil) forState:UIControlStateNormal];
	[self.btnValidate setHidden:YES];
    
    [self.btnSkip setBackgroundColor:[UIColor colorWithHexString:colorOrange andAlpha:0.8f]];
    [[self.btnSkip layer] setBorderColor:[[UIColor colorWithHexString:colorOrange andAlpha:1.0f] CGColor]];
    [[self.btnSkip layer] setCornerRadius:5.0f];
    [[self.btnSkip layer] setMasksToBounds:YES];
    [self.btnSkip setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
    [[self.btnSkip titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
    [self.btnSkip setTitle:NSLocalizedString(@"BUTTON_SKIP", nil) forState:UIControlStateNormal];
    [self.btnSkip setHidden:YES];
	
	_phoneNumber = @"";
    [self.txtPhone becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    if(!_isRegistration && [self.delegate respondsToSelector:@selector(didRegisterPhoneViewControllerRequestCancel)]) {
        [self.navigationItem setLeftBarButtonItems:@[_btnBack]];
    }
    [self.navigationItem setRightBarButtonItems:nil];
    self.toolbarItems = nil;
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat availableWidth = self.view.frame.size.width;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:normalFontName size:smallFontSize]};
    CGRect rect = [self.lblInfo.text boundingRectWithSize:CGSizeMake(self.lblInfo.frame.size.width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    self.lblInfoHeightConstraint.constant = rect.size.height;
    CGFloat contentHeight = self.btnSkip.frame.origin.y + self.btnSkip.frame.size.height + 8;
    CGRect frame;
    if(availableWidth > viewMaxWidth && isDeviceIPad) {
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == self.txtPhone) {
		[self done:nil];
	} else if(textField == self.txtCode) {
		[self validate:nil];
	}
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	//nothing to do
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if([textField isEqual:(self.txtPhone)] && ![self.txtPhone.text isEqualToString:_phoneNumber]) {
		[self.btnOk setHidden:NO];
		[self.lblMessage setHidden:YES];
		[self.txtCode setText:@""];
		[self.txtCode setHidden:YES];
		[self.btnValidate setHidden:YES];
        [self.btnSkip setHidden:YES];
	}
}

#pragma - button events
- (IBAction)done:(id)sender {
	
	[[self.view findFirstResponder] resignFirstResponder];
	
    NSArray* parts = [self.txtPhone.text componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _phoneNumber = [parts componentsJoinedByString:@""];
    
	if(![_phoneNumber isValidPhoneNumber]) {
		[self.view makeToast:NSLocalizedString(@"REGISTER_PHONE_FORMAT_ERROR", nil) duration:(toastDuration*1.5) position:CSToastPositionBottom title:nil image:[ToastHelper imageWarning] style:[ToastHelper styleWarning] completion:^(BOOL didTap) {
            _phoneNumber = nil;
			[self.txtPhone becomeFirstResponder];
        }];
		return;
	}
	
	[self.btnOk setHidden:YES];
	[self.activityIndicator startAnimating];

	[RestClientManager.sharedManager authPhone:_phoneNumber block:^(NSInteger statusCode, NSError *error) {
		
		[self.activityIndicator stopAnimating];
		
        if(statusCode == 204) {
            
            //204: OK
            [self.lblMessage setHidden:NO];
            [self.txtCode setHidden:NO];
            [self.btnValidate setHidden:NO];
            [self.txtCode becomeFirstResponder];
            
        } else if(statusCode == 401) {
            
            //401: access denied
            [self.view makeToast:NSLocalizedString(@"ERROR_401", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                [self.txtPhone becomeFirstResponder];
                [self.btnOk setHidden:NO];
            }];
            
        } else if(statusCode == 403) {
            
            //403: access denied
            [self.view makeToast:NSLocalizedString(@"ERROR_403", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                [self.txtPhone becomeFirstResponder];
                [self.btnOk setHidden:NO];
            }];
            
        } else if(statusCode == 409) {
            
            //409: conflict (already used)
            [self.view makeToast:NSLocalizedString(@"REGISTER_PHONE_NUMBER_ALREADY_EXISTS", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                [self.txtPhone becomeFirstResponder];
                [self.btnOk setHidden:NO];
            }];
            
        } else if(statusCode == 429) {
            
            //429: too many request
            [self.view makeToast:NSLocalizedString(@"REGISTER_PHONE_TOO_MANY_REQUEST", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                [self.lblMessage setHidden:NO];
                [self.txtCode setHidden:NO];
                [self.btnValidate setHidden:NO];
                [self.txtCode becomeFirstResponder];
            }];
            
        } else if(error) {
			[self.view makeToast:error.localizedDescription duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageError style:ToastHelper.styleError completion:^(BOOL didTap) {
				[self.txtPhone becomeFirstResponder];
				[self.btnOk setHidden:NO];
			}];
		}
	}];
}

- (IBAction)skip:(id)sender {
    if([self.delegate respondsToSelector:@selector(didRegisterPhoneViewControllesSkip)]) {
        [self.delegate didRegisterPhoneViewControllesSkip];
    }
}

- (void)back {
	if([self.delegate respondsToSelector:@selector(didRegisterPhoneViewControllerRequestCancel)]) {
		[self.delegate didRegisterPhoneViewControllerRequestCancel];
	}
}

- (IBAction)validate:(id)sender {
	[[self.view findFirstResponder] resignFirstResponder];
    [self.activityIndicator startAnimating];
    [RestClientManager.sharedManager verifyPhone:_phoneNumber code:self.txtCode.text block:^(User *user, NSInteger statusCode, NSError *error) {
		
        if(statusCode == 200) {
            
            //200: with the user in return
            if([self.delegate respondsToSelector:@selector(didRegisterPhoneViewControllerReturnUser:)]) {
                [self.delegate didRegisterPhoneViewControllerReturnUser:user];
            }
            
        } else if(statusCode == 401) {
        
            //401: forbidden (need auth)
            [self.view makeToast:NSLocalizedString(@"ERROR_401", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                if(_isRegistration)
                    self.btnSkip.hidden = NO;
                else
                    [self.txtCode becomeFirstResponder];
            }];
            
            [self.activityIndicator stopAnimating];
            
        } else if(statusCode == 403) {
            
            //403: invalid code
            [self.view makeToast:NSLocalizedString(@"REGISTER_PHONE_CODE_INVALID", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                [self.txtCode becomeFirstResponder];
            }];
            
            [self.activityIndicator stopAnimating];
            
        } else if(statusCode == 409) {
            
            //409: conflict (already used)
            [self.view makeToast:NSLocalizedString(@"REGISTER_PHONE_NUMBER_ALREADY_EXISTS", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                if(_isRegistration)
                    self.btnSkip.hidden = NO;
                else
                    [self.txtCode becomeFirstResponder];
            }];
            
            [self.activityIndicator stopAnimating];
            
        } else if(statusCode == 429) {
        
            //429: too many request
            [self.view makeToast:NSLocalizedString(@"ERROR_429", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageWarning style:ToastHelper.styleWarning completion:^(BOOL didTap) {
                [self.txtCode becomeFirstResponder];
            }];
            
            [self.activityIndicator stopAnimating];
            
        } else if(error) {
            
            [self.view makeToast:error.localizedDescription duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageError style:ToastHelper. styleError completion:^(BOOL didTap) {
                [self.txtCode becomeFirstResponder];
            }];
            
            [self.activityIndicator stopAnimating];
            
        }
        
	}];
}
@end
