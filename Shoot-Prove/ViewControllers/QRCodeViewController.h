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
#import "BarcodeView.h"
#import "Dialog.h"

@class Task;
@protocol QRCodeViewControllerDelegate <NSObject>
- (void)didQRCodeViewControllerRequestRestart;
- (void)didQRCodeViewControllerRequestStartTask:(Task *)task;
- (void)didQRCodeViewControllerRequestSyncServices;
@end
@interface QRCodeViewController : UIViewController <BarcodeViewDelegate, DialogDelegate>
- (id)initWithDelegate:(id<QRCodeViewControllerDelegate>)delegate;
@end
