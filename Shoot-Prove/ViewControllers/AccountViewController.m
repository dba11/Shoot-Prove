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

#import "AccountViewController.h"
#import "SWRevealViewController.h"
#import "StoreManager.h"
#import "RestClientManager.h"
#import "DeviceHelper.h"
#import "ErrorHelper.h"
#import "UIColor+HexString.h"
#import "UIView+FirstResponder.h"
#import "NSString+MD5.h"
#import "DeviceCell.h"
#import "IdentCell.h"
#import "ProductCell.h"
#import "TaskCellRowAction.h"
#import "ShadowButton.h"
#import "User.h"
#import "Subscription.h"
#import "Ident.h"
#import "Device.h"
#import "UnCheckedTransaction.h"

static const CGFloat DEFAULT_ROW_HEIGHT = 80;
static const CGFloat PRODUCT_ROW_HEIGHT = 150;
static const CGFloat HEADER_HEIGHT = 44;

@interface AccountViewController ()
{
	UIBarButtonItem *_btnMenu;
	GravatarPicker *_gravatarPicker;
	CGFloat _gravatarPickerY;
	User *_user;
	NSFetchedResultsController *_identsResultController;
	NSFetchedResultsController *_devicesResultController;
    NSMutableArray *_availableProducts;
	NSIndexPath *_indexPath;
    BOOL _didChange;
    BOOL _didDisplayTransactionErrorMessage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageViewActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UIButton *btnShowIdentifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnShowIdentifierWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnCopyIdentifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCopyIdentifierWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblIdentifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblIdentifierHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountType;
@property (weak, nonatomic) IBOutlet UILabel *lblExpirationDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblExpirationDateHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblCredits;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblCreditsTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblCreditHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) id<AccountViewControllerDelegate> delegate;
@end

@implementation AccountViewController
#pragma view life cycle
- (id)initWithUser:(User *)user delegate:(id<AccountViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		_user = user;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self buildMenuButton];
	self.title = NSLocalizedString(@"MENU_ACCOUNT", nil);
    [self.imageView.layer setCornerRadius:self.imageView.frame.size.height /2];
    [self.imageView.layer setMasksToBounds:YES];
    UITapGestureRecognizer *gravatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGravatarPicker)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:gravatarTap];
    [self.txtFirstName setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [self.txtFirstName setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
    [self.txtFirstName setPlaceholder:NSLocalizedString(@"ACCOUNT_FIRSTNAME_PLACEHOLDER", nil)];
    [self.txtFirstName setText:_user.firstName ? _user.firstName:@""];
    [self.txtFirstName setDelegate:self];
    [self.txtLastName setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [self.txtLastName setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
    [self.txtLastName setPlaceholder:NSLocalizedString(@"ACCOUNT_LASTNAME_PLACEHOLDER", nil)];
    [self.txtLastName setText:_user.lastName ? _user.lastName:@""];
    [self.txtLastName setDelegate:self];
    [self.lblIdentifier setFont:[UIFont fontWithName:normalFontName size:xSmallFontSize]];
    [self.lblIdentifier setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [self.lblIdentifier setNumberOfLines:0];
    [self.lblIdentifier setText:_user.uuid];
    [self.lblIdentifier setHidden:YES];
    [self.btnShowIdentifier setBackgroundColor:[UIColor clearColor]];
    [self.btnShowIdentifier setTitleColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f] forState:UIControlStateNormal];
    [[self.btnShowIdentifier titleLabel] setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [self.btnShowIdentifier setTitle:NSLocalizedString(@"BUTTON_SHOW_IDENTIFIER", nil) forState:UIControlStateNormal];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:boldFontName size:normalFontSize]};
    CGRect rect = [NSLocalizedString(@"BUTTON_SHOW_IDENTIFIER", nil) boundingRectWithSize:CGSizeMake(MAXFLOAT, normalFontSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    [self.btnShowIdentifierWidthConstraint setConstant:rect.size.width + self.btnShowIdentifier.titleEdgeInsets.left + self.btnShowIdentifier.titleEdgeInsets.right];
    [self.btnShowIdentifier setHidden:NO];
    [self.btnCopyIdentifier setBackgroundColor:[UIColor clearColor]];
    [self.btnCopyIdentifier setTitleColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f] forState:UIControlStateNormal];
    [[self.btnCopyIdentifier titleLabel] setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [self.btnCopyIdentifier setTitle:NSLocalizedString(@"BUTTON_COPY_IDENTIFIER", nil) forState:UIControlStateNormal];
    attributes = @{NSFontAttributeName: [UIFont fontWithName:boldFontName size:normalFontSize]};
    rect = [NSLocalizedString(@"BUTTON_COPY_IDENTIFIER", nil) boundingRectWithSize:CGSizeMake(MAXFLOAT, normalFontSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    [self.btnCopyIdentifierWidthConstraint setConstant:rect.size.width + self.btnCopyIdentifier.titleEdgeInsets.left + self.btnCopyIdentifier.titleEdgeInsets.right];
    [self.btnCopyIdentifier setHidden:YES];
    [self.lblAccountType setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
    [self.lblAccountType setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [self.lblAccountType setNumberOfLines:1];
    [self.lblExpirationDate setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
    [self.lblExpirationDate setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [self.lblExpirationDate setNumberOfLines:1];
    [self.lblCredits setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
    [self.lblCredits setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
    [self.lblCredits setNumberOfLines:1];
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	UINib *nib = [UINib nibWithNibName:NSStringFromClass([DeviceCell class]) bundle:nil];
	[self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([DeviceCell class])];
    nib = [UINib nibWithNibName:NSStringFromClass([IdentCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([IdentCell class])];
    nib = [UINib nibWithNibName:NSStringFromClass([ProductCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([ProductCell class])];
    self.maskView.backgroundColor = [UIColor colorWithHexString:colorLightGrey andAlpha:0.8f];
    self.maskView.hidden = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification
											   object:nil];
	_identsResultController = [StoreManager.sharedManager fetchedIdentsController];
	[_identsResultController setDelegate:self];
	[self getIdents];
	_devicesResultController = [StoreManager.sharedManager fetchedDevicesController];
	[_devicesResultController setDelegate:self];
	[self getDevices];
    _availableProducts = [[NSMutableArray alloc] initWithArray:InAppPurchaseManager.sharedManager.availableProducts];
    [self cleanProducts];
    [InAppPurchaseManager.sharedManager setDelegate:self];
    _didDisplayTransactionErrorMessage = NO;
	_didChange = NO;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGFloat availableWidth = self.view.frame.size.width;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:normalFontName size:smallFontSize]};
    CGFloat lblMaxWidth = self.btnCopyIdentifier.frame.origin.x - 8 - self.lblIdentifier.frame.origin.x;
    CGRect rect = [self.lblIdentifier.text boundingRectWithSize:CGSizeMake(lblMaxWidth, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    [self.lblIdentifierHeightConstraint setConstant:rect.size.height];
	CGFloat contentHeight = self.tableView.frame.origin.y + self.tableViewHeightConstraint.constant;
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItems:@[_btnMenu]];
	[self.navigationItem setRightBarButtonItems:nil];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self displayGravatarImage];
    [self displaySubscriptionInfo];
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma - clean available products depending on user subscription type
- (void)cleanProducts {
    if(_user.activeSubscription.postPaid) {
        [_availableProducts removeAllObjects];
    } else if([EnumHelper subscriptionFromType:_user.activeSubscription.type] >= SPSubscriptionPremium) {
        for(SKProduct *product in _availableProducts) {
            if([product.productIdentifier isEqualToString:premiumAccountProductId]) {
                [_availableProducts removeObject:product];
                break;
            }
        }
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma - build buttons
- (void)buildMenuButton {
	_btnMenu = [[UIBarButtonItem alloc] init];
	[_btnMenu setImage:[UIImage imageNamed:@"menu"]];
	[_btnMenu setTarget:self];
	[_btnMenu setAction:@selector(menu)];
}

#pragma - fetch idents controller fetch method
- (void)getIdents {
	NSError *error;
	if (![_identsResultController performFetch:&error]){
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
}

- (CGFloat)numberOfIdents {
    id<NSFetchedResultsSectionInfo> sectionInfo = [_identsResultController.sections objectAtIndex:0];
    return sectionInfo.numberOfObjects;
}

#pragma - fetch devices controller fetch method
- (void)getDevices {
	NSError *error;
	if (![_devicesResultController performFetch:&error]){
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
}

- (CGFloat)numberOfDevices {
    id<NSFetchedResultsSectionInfo> sectionInfo = [_devicesResultController.sections objectAtIndex:0];
    return sectionInfo.numberOfObjects;
}

#pragma - helper to display the user gravatar
- (void)displayGravatarImage {
    if(_user.avatar_data) {
        [self.imageView setImage:[UIImage imageWithData:_user.avatar_data]];
    } else {
        [self.imageViewActivityIndicator startAnimating];
        NSString *url;
        if(_user.avatar.length > 0) {
            url = _user.avatar;
        } else if(_user.avatar_email.length > 0) {
            url = [NSString stringWithFormat:gravatarUrl, _user.avatar_email, (int)self.imageView.frame.size.height];
        } else {
            NSString *fakeEmail = @"default@shootandprove.com";
            url = [NSString stringWithFormat:gravatarUrl, [fakeEmail MD5], (int)self.imageView.frame.size.height];
        }
        [RestClientManager.sharedManager dataWithUrl:url block:^(NSData *data, NSString *contentType, NSInteger statusCode, NSError *error) {
            [self.imageViewActivityIndicator stopAnimating];
            if(!error) {
                [self.imageView setImage:[UIImage imageWithData:data]];
                _user.avatar_data = data;
                _didChange = YES;
            }
        }];
    }
}

#pragma - Helper to display user subscription info
- (void)displaySubscriptionInfo {
    [self.lblAccountType setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ACCOUNT_TYPE", nil), _user.activeSubscription ? _user.activeSubscription.type:NSLocalizedString(@"ACCOUNT_TYPE_FREE", nil)]];
    if(_user.activeSubscription) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
        df.timeStyle = NSDateFormatterNoStyle;
        [self.lblExpirationDate setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ACCOUNT_EXPIRATION", nil), [NSString stringWithFormat:NSLocalizedString(@"ACCOUNT_EXPIRATION_VALUE", nil), [df stringFromDate:_user.activeSubscription.expirationDate], (long)_user.activeSubscription.daysUntilExpiracy]]];
        self.lblExpirationDateHeightConstraint.constant = 21;
        self.lblCreditsTopConstraint.constant = 37;
    } else {
        self.lblExpirationDateHeightConstraint.constant = 0;
        self.lblCreditsTopConstraint.constant = 8;
    }
    if([_user.credits intValue]>0) {
        [self.lblCredits setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ACCOUNT_CREDITS", nil), [_user.credits stringValue]]];
        self.lblCreditHeightConstraint.constant = 21;
    } else {
        self.lblCreditHeightConstraint.constant = 0;
    }
}

#pragma table view delegate and datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self numberOfIdents] > 0 ? HEADER_HEIGHT:0;
            break;
        case 1:
            return [self numberOfDevices] > 0 ? HEADER_HEIGHT:0;
            break;
        case 2:
            return _availableProducts.count > 0 ? HEADER_HEIGHT:0;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if((section == 0 && [self numberOfIdents] == 0) || (section == 1 && [self numberOfDevices] == 0) || (section == 2 && _availableProducts.count == 0))
        return nil;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    view.backgroundColor = [UIColor colorWithHexString:colorLightGrey andAlpha:0.8f];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 11.5, tableView.frame.size.width, 21)];
    [label setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
    [label setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
    switch (section) {
        case 0: {
            //Identities
            [label setText:NSLocalizedString(@"ACCOUNT_IDENTITIES", nil)];
            //display add identity button
            ShadowButton *button = [[ShadowButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, (view.frame.size.height - 32)/2, 32, 32)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addIdentity:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            break;
        }
        case 1:
            //Devices
            [label setText:NSLocalizedString(@"ACCOUNT_DEVICES", nil)];
            break;
        case 2:
            //Products
            [label setText:NSLocalizedString(@"ACCOUNT_IAP", nil)];
            break;
        default:
            break;
    }
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            //Identities
            return [self numberOfIdents];
            break;
        case 1:
            //Devices
            return [self numberOfDevices];
            break;
        case 2:
            //Products
            return _availableProducts.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 2) ? PRODUCT_ROW_HEIGHT : DEFAULT_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            //Identities
            Ident *ident = [[_identsResultController fetchedObjects] objectAtIndex:indexPath.row];
            IdentCell *cell = (IdentCell *) [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IdentCell class])];
            [cell setIdent:ident];
            return cell;
            break;
        }
        case 1: {
            //Devices
            Device *device = [[_devicesResultController fetchedObjects] objectAtIndex:indexPath.row];
            DeviceCell *cell = (DeviceCell *) [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DeviceCell class])];
            [cell setDevice:device];
            return cell;
            break;
        }
        case 2: {
            //Products
            SKProduct *product = [_availableProducts objectAtIndex:indexPath.row];
            ProductCell *cell = (ProductCell *) [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductCell class])];
            [cell setProduct:product];
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2) {
        SKProduct *product = [_availableProducts objectAtIndex:indexPath.row];
        if([InAppPurchaseManager.sharedManager purchaseProduct:product]) {
            [self.maskView setHidden:NO];
            ProductCell *cell = (ProductCell *) [self.tableView cellForRowAtIndexPath:indexPath];
            _indexPath = indexPath;
            [cell startAnimation];
        } else {
            [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_CANT_BUY", nil) message:NSLocalizedString(@"IAP_DISABLED", nil) type:DialogTypeWarning];
            _indexPath = nil;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section != 2 && [self.delegate respondsToSelector:@selector(didAccountViewControllerRequestReset)]);
}

#if defined __IPHONE_11_0 && __has_builtin(__builtin_available)
- (id)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 11.0, *)) {
        if(indexPath.section != 2) {
            NSMutableArray *actions = [[NSMutableArray alloc] init];
            UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                [self requestDeleteTableViewItem:tableView atIndexPath:indexPath];
                completionHandler(YES);
            }];
            deleteAction.image = [UIImage imageNamed:@"close"];
            deleteAction.title = nil;
            deleteAction.backgroundColor = [UIColor colorWithHexString:colorRed andAlpha:1.0f];
            [actions addObject:deleteAction];
            UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:actions];
            configuration.performsFirstActionWithFullSwipe = NO;
            return configuration;
        }
    }
    return nil;
}
#endif

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.section != 2) {
        TaskCellRowAction *buttonDelete = [TaskCellRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"BUTTON_FAKE", nil) icon:[UIImage imageNamed:@"close"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self requestDeleteTableViewItem:tableView atIndexPath:indexPath];
        }];
        [buttonDelete setFont:[UIFont fontWithName:normalFontName size:largeFontSize]];
        [buttonDelete setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
        return @[buttonDelete];
    } else {
        return nil;
    }
}

- (void)requestDeleteTableViewItem:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    switch (indexPath.section) {
        case 0: {
            //Identities
            [[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:([self numberOfIdents] == 1) ? NSLocalizedString(@"ACCOUNT_DELETE_LAST_IDENTITY_MESSAGE", nil) : NSLocalizedString(@"ACOUNT_DELETE_IDENTITY_MESSAGE", nil) confirmButtonTitle:NSLocalizedString(@"BUTTON_YES", nil) confirmTag:deleteIdentTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
            break;
        }
        case 1: {
            //Devices
            Device *currentDevice = [DeviceHelper getCurrentDevice];
            Device *device = [[_devicesResultController fetchedObjects] objectAtIndex:indexPath.row];
            [[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:[device.uid isEqualToString:currentDevice.uid] ? NSLocalizedString(@"ACCOUNT_DELETE_CURRENT_DEVICE", nil) : NSLocalizedString(@"ACCOUNT_DELETE_DEVICE_MESSAGE", nil) confirmButtonTitle:NSLocalizedString(@"BUTTON_YES", nil) confirmTag:deleteDeviceTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	//nothing to do but this method must exist to avoid a bug
}

# pragma - fetch task controller delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if(type == NSFetchedResultsChangeInsert) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
    } else if(type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
    NSIndexPath *previousIndexPath;
    NSIndexPath *nextIndexPath;
    if([controller isEqual:_devicesResultController]) {
        previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
        nextIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:1];
    } else {
        previousIndexPath = indexPath;
        nextIndexPath = newIndexPath;
    }
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:nextIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:previousIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[previousIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:previousIndexPath toIndexPath:nextIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    self.tableViewHeightConstraint.constant = ([self numberOfIdents] > 0 ? HEADER_HEIGHT + ([self numberOfIdents] * DEFAULT_ROW_HEIGHT):0) + ([self numberOfDevices] > 0 ? HEADER_HEIGHT + ([self numberOfDevices] * DEFAULT_ROW_HEIGHT):0) + (_availableProducts.count > 0 ? HEADER_HEIGHT + (_availableProducts.count * PRODUCT_ROW_HEIGHT):0);
	_indexPath = nil;
}

#pragma - InApp purchase manager methods delegate
- (void)didInAppPurchaseFinishRefreshAvailableProducts {
    _availableProducts = [[NSMutableArray alloc] initWithArray:[[InAppPurchaseManager sharedManager] availableProducts]];
    [self cleanProducts];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    [self.maskView setHidden:YES];
}

- (void)didInAppPurchaseManagerReturnTransactionInProgressWithProductIdentifier:(NSString *)productIdentifier {
    [self.maskView setHidden:NO];
    [self startProductCellAnimation];
}

- (void)didInAppPurchaseManagerReturnTransactionDoneWithProductIdentifier:(NSString *)productIdentifier {
    [ErrorHelper popToastWithMessage:NSLocalizedString(@"IAP_PURCHASE_DONE", nil) style:ToastHelper.styleInfo];
    [self displaySubscriptionInfo];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    [self.maskView setHidden:YES];
    [self stopProductCellAnimation];
    _indexPath = nil;
}

- (void)didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:(NSString *)productIdentifier error:(NSError *)error {
    if(error) {
        [ErrorHelper popToastWithMessage:[NSString stringWithFormat:NSLocalizedString(@"IAP_PURCHASE_ERROR", nil), error.localizedDescription] style:ToastHelper.styleError];
    }
    [self.maskView setHidden:YES];
    [self stopProductCellAnimation];
}

#pragma - product cell stop animation
- (void)startProductCellAnimation {
    if(_indexPath) {
        ProductCell *cell = (ProductCell *) [self.tableView cellForRowAtIndexPath:_indexPath];
        [cell startAnimation];
    }
}

- (void)stopProductCellAnimation {
    if(_indexPath) {
        ProductCell *cell = (ProductCell *) [self.tableView cellForRowAtIndexPath:_indexPath];
        [cell stopAnimation];
    }
}

#pragma text field delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == self.txtFirstName) {
		[self.txtLastName becomeFirstResponder];
	} else if(textField == self.txtLastName) {
		[self.txtLastName resignFirstResponder];
	}
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma gravatar method and delegate

- (void)showGravatarPicker {
	_gravatarPicker = [[GravatarPicker alloc] initWithDelegate:self email:_user.avatar_email imageSize:(int)self.imageView.frame.size.height];
	[_gravatarPicker show];
}

- (void)didGravatarPickerReturnUrl:(NSString *)url email:(NSString *)email {
    _user.avatar_data = nil;
	_user.avatar = url;
    _user.avatar_email = email;
	[self displayGravatarImage];
	_gravatarPicker = nil;
}

- (void)didGravatarPickerCancel {
	_gravatarPicker = nil;
}

#pragma keyboard detection methods
- (void)keyboardDidShow:(NSNotification *)notification {
	if(_gravatarPicker) {
		NSDictionary *info  = notification.userInfo;
		NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
		CGRect rawFrame      = [value CGRectValue];
		CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
		_gravatarPickerY = _gravatarPicker.frame.origin.y;
		if(_gravatarPickerY + _gravatarPicker.frame.size.height > keyboardFrame.origin.y) {
			[UIView animateWithDuration:0.5 animations:^{
				CGRect frame = CGRectMake(_gravatarPicker.frame.origin.x, keyboardFrame.origin.y - _gravatarPicker.frame.size.height - 4, _gravatarPicker.frame.size.width, _gravatarPicker.frame.size.height);
				_gravatarPicker.frame = frame;
			} completion:^(BOOL finished) {}];
		}
	}
}

- (void)keyboardDidHide:(NSNotification *)notification {
	if(_gravatarPicker) {
		[UIView animateWithDuration:0.5 animations:^{
			CGRect frame = CGRectMake(_gravatarPicker.frame.origin.x, _gravatarPickerY, _gravatarPicker.frame.size.width, _gravatarPicker.frame.size.height);
			_gravatarPicker.frame = frame;
		} completion:^(BOOL finished) {}];
	}
}

#pragma buttons methods

- (IBAction)showIdentifier:(id)sender {
	[self.btnShowIdentifier setHidden:YES];
	[self.lblIdentifier setHidden:NO];
	[self.btnCopyIdentifier setHidden:NO];
}

- (IBAction)copyIdentifier:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.lblIdentifier.text;
    [ErrorHelper popToastWithMessage:NSLocalizedString(@"ACCOUNT_IDENTIFIER_COPIED", nil) style:ToastHelper.styleInfo];
}

#pragma - helper to set user names
- (void)setUserNames {
    [[self.view findFirstResponder] resignFirstResponder];
    if(![_user.firstName isEqualToString:self.txtFirstName.text]) {
        _user.firstName = self.txtFirstName.text;
        _didChange = YES;
    }
    if(![_user.lastName isEqualToString:self.txtLastName.text]) {
        _user.lastName = self.txtLastName.text;
        _didChange = YES;
    }
    if([_user.displayName length] == 0 || _didChange) {
        NSMutableString *displayName = [[NSMutableString alloc] init];
        if([_user.firstName length] > 0) {
            [displayName appendString:_user.firstName];
        }
        if([_user.lastName length] > 0) {
            [displayName appendString:[NSString stringWithFormat:@" %@", _user.lastName]];
        } else {
            [displayName appendString:_user.lastName];
        }
        _user.displayName = displayName;
    }
}

- (void)menu {
    [self setUserNames];
    if(_didChange) {
        [RestClientManager.sharedManager putUser:_user block:^(NSInteger statusCode, NSError *error) {
            if(statusCode >= 400) {
                [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleWarning];
            }
        }];
        if([self.delegate respondsToSelector:@selector(didAccountViewControllerUpdateUser:)]) {
            [self.delegate didAccountViewControllerUpdateUser:_user];
        }
    }
	SWRevealViewController *revealController = [self revealViewController];
	[revealController revealToggle:_btnMenu];
}

- (void)addIdentity:(id)sender {
    RegisterViewController *controller = [[RegisterViewController alloc] initForRegistration:NO delegate:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)getMe {
    [RestClientManager.sharedManager getMe:^(User *user, NSInteger statusCode, NSError *error) {
        if(statusCode == 200) {
            NSData *avatar_data = _user.avatar_data;
            NSString *avatar_email = _user.avatar_email;
            _user = user;
            [self setUserNames];
            _user.avatar_email = avatar_email;
            _user.avatar_data = avatar_data;
            _didChange = YES;
            [self cleanProducts];
        } else {
            [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
        }
    }];
}

#pragma - registration view controller delegate
- (void)didRegisterViewControllerRequestCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRegisterViewControllerReturnEmailRegistrationSuccess {
    [self.navigationController popToViewController:self animated:YES];
    [self getMe];
}

- (void)didRegisterViewControllerRequestOAuthAtURL:(NSURL *)url title:(NSString *)title fakeBrowser:(BOOL)fakeBrowser {
    RegisterOAuthViewController *oauthVc = [[RegisterOAuthViewController alloc] initWithURL:url behaveAsBrowser:fakeBrowser title:title delegate:self];
    [self.navigationController pushViewController:oauthVc animated:YES];
}

- (void)didRegisterViewControllerRequestPhoneAuth {
    RegisterPhoneViewController *phoneVc = [[RegisterPhoneViewController alloc] initForRegistration:NO delegate:self];
    [self.navigationController pushViewController:phoneVc animated:YES];
}

#pragma - OAuth view controller delegate
- (void)didRegisterOAuthViewControllerRequestCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRegisterOAuthViewControllerReturnSuccess {
    [self.navigationController popToViewController:self animated:YES];
    [self getMe];
}

#pragma - Phone view controller delegate
- (void)didRegisterPhoneViewControllerRequestCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRegisterPhoneViewControllerReturnUser:(User *)user {
    [self.navigationController popToViewController:self animated:YES];
    NSData *avatar_data = _user.avatar_data;
    NSString *avatar_email = _user.avatar_email;
    _user = user;
    [self setUserNames];
    _user.avatar_email = avatar_email;
    _user.avatar_data = avatar_data;
    _didChange = YES;
    [self cleanProducts];
}

#pragma - dialog confirmation delegate method
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
	if([tag isEqualToString:deleteIdentTag] && [self.delegate respondsToSelector:@selector(didAccountViewControllerRequestReset)]) {
		Ident *ident = [_identsResultController.fetchedObjects objectAtIndex:_indexPath.row];
        [RestClientManager.sharedManager deleteIdent:ident block:^(NSInteger statusCode, NSError *error) {
            if(statusCode <= 204 || statusCode == 404) {
                if(_user.idents.count == 0) {
                    [self deleteUser];
                }
            } else {
                [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
            }
        }];
	} else if([tag isEqualToString:deleteDeviceTag] && [self.delegate respondsToSelector:@selector(didAccountViewControllerRequestReset)]) {
		Device *device = [_devicesResultController.fetchedObjects objectAtIndex:_indexPath.row];
        NSString *deviceId = device.uid;
        [RestClientManager.sharedManager deleteDevice:device block:^(NSInteger statusCode, NSError *error) {
            if(statusCode <= 204) {
                DeviceProperties *deviceProperties = [DeviceHelper getDeviceProperties];
                if([deviceProperties.uid isEqualToString:deviceId]) {
                    [self.delegate didAccountViewControllerRequestReset];
                }
            } else if(statusCode == 404) {
                [StoreManager.sharedManager deleteDevice:device];
                DeviceProperties *deviceProperties = [DeviceHelper getDeviceProperties];
                if([deviceProperties.uid isEqualToString:deviceId]) {
                    [self.delegate didAccountViewControllerRequestReset];
                }
            } else {
                [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
            }
        }];
	}
}

#pragma - user delete methods
- (void)deleteUser {
    [RestClientManager.sharedManager deleteUser:_user block:^(NSInteger statusCode, NSError *error) {
        if(statusCode <= 204 || statusCode == 404) {
            [self.delegate didAccountViewControllerRequestReset];
        } else {
            [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleError];
        }
    }];
}
@end

