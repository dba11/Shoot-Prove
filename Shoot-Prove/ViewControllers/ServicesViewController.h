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

#import <UIKit/UIKit.h>
#import "ServiceCell.h"
#import "Dialog.h"

@class User;
@class Task;
@protocol ServicesViewControllerDelegate <NSObject>
- (void)didServicesViewControllerRequestStartTask:(Task *)task;
- (void)didServicesViewControllerRequestStartQRCodeReader;
@end
@interface ServicesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, ServiceCellDelegate>
- (id)initWithUser:(User *)user delegate:(id<ServicesViewControllerDelegate>)delegate;
- (void)setEnabled:(BOOL)enabled;
@end
