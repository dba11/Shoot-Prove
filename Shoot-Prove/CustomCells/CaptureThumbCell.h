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
#import <QuartzCore/QuartzCore.h>

@class AbstractSubTaskCapture;
@protocol CaptureThumbCellDelegate <NSObject>
@required
- (void)didCaptureThumbCellRequestRotate:(UICollectionViewCell *)cell;
- (void)didCaptureThumbCellRequestDelete:(UICollectionViewCell *)cell;
- (void)didCaptureThumbCellRequestView:(UICollectionViewCell *)cell;
- (void)didCaptureThumbCellRequestCapture:(UICollectionViewCell *)cell;
@end
@interface CaptureThumbCell : UICollectionViewCell
- (void)setSubTask:(AbstractSubTaskCapture *)subTask imageIndex:(NSInteger)index delegate:(id<CaptureThumbCellDelegate>)delegate;
- (void)startAnimation;
- (void)stopAnimation;
@end
