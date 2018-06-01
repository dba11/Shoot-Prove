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

#import "MenuViewController.h"
#import "StoreManager.h"
#import "NotificationManager.h"
#import "UIColor+HexString.h"
#import "ErrorHelper.h"
#import "MenuItem.h"
#import "MenuCell.h"

@interface MenuViewController()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSFetchedResultsController *inboxResultController;
@property (strong, nonatomic) NSFetchedResultsController *historyResultController;
@property (strong, nonatomic) NSFetchedResultsController *servicesResultController;
@property (strong, nonatomic) NSFetchedResultsController *trashResultController;
@end

@implementation MenuViewController
@synthesize delegate, freeCaptureMenuItem = _freeCaptureMenuItem, inboxMenuItem = _inboxMenuItem, servicesMenuItem = _servicesMenuItem, historyMenuItem = _historyMenuItem, trashMenuItem = _trashMenuItem, qrCodeReaderMenuItem = _qrCodeReaderMenuItem, settingsMenuItem = _settingsMenuItem, accountMenuItem = _accountMenuItem;

#pragma - view life cycle
- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"APPLICATION_TITLE", nil);
	
	self.inboxResultController = [StoreManager.sharedManager fetchedPendingTasksController];
	self.historyResultController = [StoreManager.sharedManager fetchedHistoryTasksController];
	self.servicesResultController = [StoreManager.sharedManager fetchedActiveServicesController];
	self.trashResultController = [StoreManager.sharedManager fetchedTrashedTasksController];
	
	_freeCaptureMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_FREE_CAPTURE", nil) image:[UIImage imageNamed:@"add"] resultController:nil section:0 treeLevel:0];
	_inboxMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_INBOX", nil) image:[UIImage imageNamed:@"inbox"] resultController:self.inboxResultController section:0 treeLevel:0];
    _servicesMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_SERVICES", nil) image:[UIImage imageNamed:@"services"] resultController:self.servicesResultController section:0 treeLevel:0];
    
	_historyMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_HISTORY", nil) image:[UIImage imageNamed:@"history"] resultController:self.historyResultController section:1 treeLevel:0];
	_trashMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_TRASH", nil) image:[UIImage imageNamed:@"trash"] resultController:self.trashResultController section:1 treeLevel:0];
	
    _qrCodeReaderMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_QRCODE", nil) image:[UIImage imageNamed:@"qr_code"] resultController:nil section:2 treeLevel:0];
	_settingsMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_SETTINGS", nil) image:[UIImage imageNamed:@"settings"] resultController:nil section:2 treeLevel:0];
	_accountMenuItem = [[MenuItem alloc] initWithName:NSLocalizedString(@"MENU_ACCOUNT", nil) image:[UIImage imageNamed:@"account"] resultController:nil section:2 treeLevel:0];
    
	self.menuItems = [[NSArray alloc] initWithObjects:_freeCaptureMenuItem, _inboxMenuItem, _servicesMenuItem, _historyMenuItem, _trashMenuItem, _qrCodeReaderMenuItem, _settingsMenuItem, _accountMenuItem, nil];
	
	UINib *nib = [UINib nibWithNibName:NSStringFromClass([MenuCell class]) bundle:nil];
	[self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MenuCell class])];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[self refreshCounters];
}

#pragma - helper to refresh menu items counters
- (void)refreshCounters {
	NSError *error;
	if (![self.inboxResultController performFetch:&error]){
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	} else {
		[[NotificationManager sharedManager] setNotificationCounterValue:[[self.inboxResultController fetchedObjects] count]];
	}
	if (![self.historyResultController performFetch:&error]){
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
	if (![self.servicesResultController performFetch:&error]){
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
	if (![self.trashResultController performFetch:&error]){
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger maxSection = 0;
    for(MenuItem *menuItem in self.menuItems) {
        if(menuItem.section > maxSection)
            maxSection = menuItem.section;
    }
    return maxSection+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section>0)
        return 1;
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    view.backgroundColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    for(MenuItem *menuItem in self.menuItems) {
        if(menuItem.section == section) {
            count++;
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MenuCell class])];
	if(!cell) {
		cell = (MenuCell *) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MenuCell class])];
	}
	[cell setMenuItem:[self menuItemAtIndexPath:indexPath]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *menuItem = [self menuItemAtIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(didClickMenuItem:)]) {
		[self.delegate didClickMenuItem:menuItem];
	}
    self.title = menuItem.name;
}

#pragma - helper to get MenuItem at indexPath
- (MenuItem *)menuItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for(MenuItem *menuItem in self.menuItems) {
        if(menuItem.section == indexPath.section) {
            [items addObject:menuItem];
        }
    }
    return (MenuItem *) [items objectAtIndex:indexPath.row];
}
@end
