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

#import "ServicesViewController.h"
#import "SWRevealViewController.h"
#import "StoreManager.h"
#import "RestClientManager.h"
#import "SyncManager.h"
#import "TaskHelper.h"
#import "UIColor+HexString.h"
#import "ErrorHelper.h"
#import "DeviceHelper.h"
#import "TaskCellRowAction.h"
#import "ShadowButton.h"
#import "User.h"
#import "Subscription.h"
#import "Service.h"
#import "UIStyle.h"

@interface ServicesViewController ()
{
	NSFetchedResultsController *_resultController;
	User *_user;
	UIBarButtonItem *_btnMenu;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<ServicesViewControllerDelegate> delegate;
@end

@implementation ServicesViewController
#pragma view life cycle
- (id)initWithUser:(User *)user delegate:(id<ServicesViewControllerDelegate>)delegate {
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
	self.title = NSLocalizedString(@"MENU_SERVICES", nil);
	
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	
	UINib *nib = [UINib nibWithNibName:NSStringFromClass([ServiceCell class]) bundle:nil];
	[self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([ServiceCell class])];
	
    [self.maskView setHidden:YES];
    [self.activityIndicator stopAnimating];
    
	_resultController = [[StoreManager sharedManager] fetchedActiveServicesController];
	[_resultController setDelegate:self];
	
	NSError *error;
	if (![_resultController performFetch:&error]){
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItems:@[_btnMenu]];
	[self.navigationItem setRightBarButtonItems:nil];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma - public methods
- (void)setEnabled:(BOOL)enabled {
    [self.maskView setHidden:enabled];
    if(enabled) {
        [self.activityIndicator stopAnimating];
    } else {
        [self.activityIndicator startAnimating];
    }
}

#pragma - build buttons
- (void)buildMenuButton {
	_btnMenu = [[UIBarButtonItem alloc] init];
	[_btnMenu setImage:[UIImage imageNamed:@"menu"]];
	[_btnMenu setTarget:[self revealViewController]];
	[_btnMenu setAction:@selector(revealToggle:)];
}

#pragma table view delegate and datasource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return serviceCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id<NSFetchedResultsSectionInfo> sectionInfo = [_resultController.sections objectAtIndex:section];
	NSUInteger count = sectionInfo.numberOfObjects;
	if (count > 0) {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		self.tableView.backgroundView = nil;
	} else {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.tableView.bounds.size.width-48)/2, 8, 48, 48)];
        imageView.image = [[UIImage imageNamed:@"services"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView.tintColor = [UIColor colorWithHexString:colorGreen andAlpha:0.5f];
        [view addSubview:imageView];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, imageView.frame.origin.y + imageView.frame.size.height + 8, self.tableView.bounds.size.width-16, self.tableView.bounds.size.height - (imageView.frame.origin.y + imageView.frame.size.height + 16))];
        messageLabel.text = NSLocalizedString(@"SERVICES_NO_SERVICE", nil);;
        messageLabel.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:normalFontName size:normalFontSize];
        [view addSubview:messageLabel];
        [messageLabel sizeToFit];
        
        ShadowButton *button = [[ShadowButton alloc] initWithFrame:CGRectMake((view.frame.size.width - 48) / 2, messageLabel.frame.origin.y + messageLabel.frame.size.height + 16, 48, 48)];
        button.layer.cornerRadius = button.frame.size.height/2;
        [button setBackgroundColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
        [button setImage:[UIImage imageNamed:@"qr_code"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openQRCodeReader:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        CGFloat viewHeight = button.frame.origin.y + button.frame.size.height + 8;
        CGRect frame = CGRectMake(0, 0, view.frame.size.width, viewHeight);
        view.frame = frame;
        [scrollView addSubview:view];
        scrollView.contentSize = frame.size;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = scrollView;
	}
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Service *service = (Service *)[_resultController objectAtIndexPath:indexPath];
	ServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServiceCell class])];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setService:service delegate:self indexPath:indexPath];
    });
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

#if defined __IPHONE_11_0 && __has_builtin(__builtin_available)
- (id)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        NSMutableArray *actions = [[NSMutableArray alloc] init];
        
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            Service *service = [_resultController objectAtIndexPath:indexPath];
            service.status = [NSNumber numberWithInt:SPStatusQueuedForDelete];
            [[SyncManager sharedManager] addSyncServiceRequest];
            completionHandler(YES);
        }];
        deleteAction.image = [UIImage imageNamed:@"close"];
        deleteAction.title = nil;
        deleteAction.backgroundColor = [UIColor colorWithHexString:colorRed andAlpha:1.0f];
        [actions addObject:deleteAction];
        UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:actions];
        configuration.performsFirstActionWithFullSwipe = YES;
        return configuration;
    }
    return nil;
}
#endif

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	TaskCellRowAction *buttonDelete = [TaskCellRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"BUTTON_FAKE", nil) icon:[UIImage imageNamed:@"close"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
		Service *service = [_resultController objectAtIndexPath:indexPath];
		service.status = [NSNumber numberWithInt:SPStatusQueuedForDelete];
		[[SyncManager sharedManager] addSyncServiceRequest];
	}];
	[buttonDelete setFont:[UIFont fontWithName:normalFontName size:largeFontSize]];
	[buttonDelete setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
	return @[buttonDelete];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	//required for custom row action to work properly
}

# pragma - fetch service controller delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
 
	if(type == NSFetchedResultsChangeInsert) {
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
	} else if(type == NSFetchedResultsChangeDelete) {
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;

	switch(type) {
        case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeUpdate:
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

#pragma - service cell delegate methods
- (void)didServiceCellRequestStartTaskWithService:(Service *)service {
    
	if([self.delegate respondsToSelector:@selector(didServicesViewControllerRequestStartTask:)]) {
        
        if([service.postPaid isEqualToNumber:[NSNumber numberWithBool:NO]] && !_user.activeSubscription.postPaid) {
            int serviceCost = [service.cost intValue];
            int userCredits = [_user.credits intValue];
            if(serviceCost > userCredits) {
                [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_NOT_ENOUGH_CREDITS", nil) message:[NSString stringWithFormat:NSLocalizedString(@"SERVICE_NOT_ENOUGH_CREDITS", nil), _user.credits, service.cost] type:DialogTypeInfo];
                return;
            }
        }
        
        NSError *error;
        Task *task = [StoreManager.sharedManager createTaskWithService:service error:&error];
        if(!error) {
            [self.delegate didServicesViewControllerRequestStartTask:task];
        } else {
            [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
        }
	}
}

#pragma - button event
- (void)openQRCodeReader:(id)sender {
    if([self.delegate respondsToSelector:@selector(didServicesViewControllerRequestStartQRCodeReader)]) {
        [self.delegate didServicesViewControllerRequestStartQRCodeReader];
    }
}
@end
