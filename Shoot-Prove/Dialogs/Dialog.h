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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	DialogTypeError = 0,
	DialogTypeWarning = 1,
	DialogTypeInfo = 2
} DialogType;

@protocol DialogDelegate <NSObject>
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag;
@optional
- (void)didClickCancelButton;
@end
@interface Dialog : UIView
- (id)initWithType:(DialogType)dialogType title:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)confirmTag cancelButtonTitle:(NSString *)cancelButtonTitle target:(id<DialogDelegate>)target;
- (void)show;
- (void)hide;
@end

