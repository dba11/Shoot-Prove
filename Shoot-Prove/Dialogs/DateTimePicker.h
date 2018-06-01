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

@class UIStyle;
@protocol DateTimePickerDelegate <NSObject>
- (void)didDateTimePickerReturnDate:(NSDate *)date tag:(NSInteger)tag;
@end
@interface DateTimePicker : UIView
- (id)initWithCurrentDate:(NSDate *)currentDate displayDate:(BOOL)displayDate displayTime:(BOOL)displayTime maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate style:(UIStyle *)style delegate:(id<DateTimePickerDelegate>)delegate tag:(NSInteger)tag;
- (void)show;
@end
