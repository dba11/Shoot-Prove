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

@class ListItem;
@protocol ItemPickerDelegate <NSObject>
- (void)didItemPickerReturnItem:(ListItem *)item tag:(NSInteger)tag;
@end
@interface ItemPicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
- (id)initWithTitle:(NSString *)title items:(NSArray *)items delegate:(id<ItemPickerDelegate>)delegate tag:(NSInteger)tag;
- (void)show;
@end
