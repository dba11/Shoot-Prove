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

#import "TaskCell.h"
#import "UIColor+HexString.h"
#import "ImageHelper.h"
#import "Task.h"
#import "UIStyle.h"
#import "AbstractSubTask.h"
#import "AbstractSubTaskCapture.h"
#import "CaptureImage.h"

@interface TaskCell()
{
	Task *_task;
	NSIndexPath *_indexPath;
	SPTaskDisplayMode _displayMode;
}
@property (weak, nonatomic) IBOutlet UIView *taskView;
@property (weak, nonatomic) IBOutlet UIImageView *certifiedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *syncImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblSubTitleHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnDetailsRightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnExport;
@property (weak, nonatomic) IBOutlet UIButton *btnRendition;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) id<TaskCellDelegate> delegate;
@end

@implementation TaskCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.lblTitle setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
	[self.lblTitle setNumberOfLines:1];
	[self.lblSubTitle setFont:[UIFont fontWithName:boldFontName size:normalFontSize]];
	[self.lblSubTitle setNumberOfLines:1];
	[self.lblDate setFont:[UIFont fontWithName:normalFontName size:xSmallFontSize]];
	[self.lblDate setNumberOfLines:1];
	[self.lblStatus setFont:[UIFont fontWithName:boldFontName size:smallFontSize]];
	[self.lblStatus setNumberOfLines:1];
	[self.progressView setProgressViewStyle:UIProgressViewStyleBar];
	[self.progressView setProgress:0];
	[self.progressView setUserInteractionEnabled:NO];
	[self.progressView setTrackTintColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.progressView setProgressTintColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
    self.btnStart.layer.cornerRadius = self.btnStart.frame.size.height/2;
    self.btnStart.layer.masksToBounds = YES;
    [self.btnStart setHidden:YES];
    self.btnExport.layer.cornerRadius = self.btnExport.frame.size.height/2;
    self.btnExport.layer.masksToBounds = YES;
	[self.btnExport setHidden:YES];
    self.btnDetails.layer.cornerRadius = self.btnDetails.frame.size.height/2;
    self.btnDetails.layer.masksToBounds = YES;
	[self.btnDetails setHidden:YES];
    self.btnRendition.layer.cornerRadius = self.btnRendition.frame.size.height/2;
    self.btnRendition.layer.masksToBounds = YES;
	[self.btnRendition setHidden:YES];
    self.syncImageView.layer.cornerRadius = self.syncImageView.frame.size.height/2;
    self.syncImageView.layer.masksToBounds = YES;
    [self.syncImageView setHidden:YES];
    self.syncImageView.image = [self.syncImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.certifiedImageView.layer.cornerRadius = self.syncImageView.frame.size.height/2;
    self.certifiedImageView.layer.masksToBounds = YES;
    [self.certifiedImageView setHidden:YES];
    self.certifiedImageView.image = [self.certifiedImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [UIView animateWithDuration:0.8 animations:^{
        [self.btnStart setHidden:!(selected && [_task.status isEqualToNumber:[NSNumber numberWithInteger: SPStatusInProgress]])];
        [self.btnRendition setHidden:!(selected && [_task.status isEqualToNumber:[NSNumber numberWithInteger: SPStatusCompleted]] && [_task.renditions count]>0)];
        [self.btnDetails setHidden:!(selected && [_task.status isEqualToNumber:[NSNumber numberWithInteger: SPStatusCompleted]])];
        [self.btnExport setHidden:!(selected && [_task.status isEqualToNumber:[NSNumber numberWithInteger: SPStatusCompleted]] && [_task.renditions count] > 0)];
        if(!_task.serviceId) {
            [self.lblTitle setFont:[UIFont fontWithName:selected ? boldFontName:normalFontName size:mediumFontSize]];
        }
    } completion:^(BOOL finished) {}];
}

- (void)displayImage {
    CaptureImage *captureImage = _task.firstCaptureImage;
    [ImageHelper displayImageData:captureImage ? UIImageJPEGRepresentation([ImageHelper thumbnailImage:captureImage.image], 1.0f):_task.icon_data url:_task.icon_url mime:captureImage ? mimeJPG:_task.icon_mime name:@"cloud_question" inView:self.taskView waitColor:[UIColor colorWithHexString:_task.uiStyle.headerColor andAlpha:1.0f] block:^(NSData *data, NSString *mime) {
        if(_task.icon_data.hash != data.hash) {
            _task.icon_data = data;
            _task.icon_mime = mime;
        }
        if(_displayMode == SPTaskDisplayModeHistory) {
            if(_task.isSync) {
                [self.syncImageView setImage:[UIImage imageNamed:@"cloud"]];
                [self.syncImageView setHidden:NO];
            } else if([_task.noCredit isEqualToNumber:@1]) {
                [self.syncImageView setImage:[UIImage imageNamed:@"no_credit"]];
                [self.syncImageView setHidden:NO];
            } else {
                [self.syncImageView setHidden:YES];
            }
            [self.certifiedImageView setHidden:!_task.isCertified];
            [self.taskView bringSubviewToFront:self.syncImageView];
            [self.taskView bringSubviewToFront:self.certifiedImageView];
        } else {
            [self.syncImageView setHidden:YES];
            [self.certifiedImageView setHidden:YES];
        }
    }];
}

- (void)setTaskStatusAndProgress {
	if([_task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusInProgress]]) {
		int numberOfSubTasks = (int)[_task.subTasks count];
		int numberOfAchievedSubTasks = 0;
		for(AbstractSubTask *subTask in _task.subTasks) {
			if(subTask.endDate)
				numberOfAchievedSubTasks++;
		}
		[self.lblStatus setText:[NSString stringWithFormat:@"%@ (%ld/%ld)", NSLocalizedString(@"TASK_PENDING", nil), (long)numberOfAchievedSubTasks, (long)numberOfSubTasks]];
		CGFloat progress = (float)numberOfAchievedSubTasks / (float)numberOfSubTasks;
		[self.progressView setProgress:progress animated:YES];
		[self.lblStatus setHidden:NO];
		[self.progressView setHidden:NO];
	} else {
		[self.lblStatus setHidden:YES];
		[self.progressView setHidden:YES];
	}
}

- (void)setTask:(Task *)task indexPath:(NSIndexPath *)indexPath displayMode:(SPTaskDisplayMode)displayMode delegate:(id<TaskCellDelegate>)delegate {
	self.delegate = delegate;
	_task = task;
	_indexPath = indexPath;
	_displayMode = displayMode;
    self.contentView.backgroundColor = [UIColor colorWithHexString:_task.uiStyle.viewBackgroundColor andAlpha:1.0f];
    self.syncImageView.tintColor = [UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
    self.certifiedImageView.tintColor = [UIColor colorWithHexString:colorRed andAlpha:1.0f];
    self.btnStart.tintColor = [UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
    self.btnRendition.tintColor = [UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
    self.btnDetails.tintColor = [UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
    self.btnExport.tintColor = [UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
    [self displayImage];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterShortStyle];
	if([_task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]]) {
		[self.lblDate setText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TASK_END_DATE", nil), [df stringFromDate:_task.endDate]]];
	} else if([_task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusTrash]]) {
		[self.lblDate setText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TASK_DELETE_DATE", nil), [df stringFromDate:_task.lastUpdate]]];
	} else {
		[self.lblDate setText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TASK_LAST_UPDATE", nil), [df stringFromDate:_task.lastUpdate]]];
	}
	if(!_task.serviceId) {
		[self.lblTitle setFont:[UIFont fontWithName:normalFontName size:mediumFontSize]];
		[self.lblTitle setText:_task.displayTitle];
        [self.lblTitle setTextColor:[UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f]];
        [self.lblDate setTextColor:[UIColor colorWithHexString:_task.uiStyle.promptColor andAlpha:1.0f]];
		[self.lblSubTitle setHidden:YES];
		[self.lblSubTitleHeightConstraint setConstant:0];
		[self.lblStatus setHidden:YES];
		[self.progressView setHidden:YES];
		[self.btnStart setHidden:YES];
	} else {
		[self.lblTitle setText:_task.provider];
		[self.lblSubTitle setText:_task.displayTitle];
        [self.lblTitle setTextColor:[UIColor colorWithHexString:_task.uiStyle.promptColor andAlpha:1.0f]];
        [self.lblSubTitle setTextColor:[UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f]];
        [self.lblDate setTextColor:[UIColor colorWithHexString:_task.uiStyle.promptColor andAlpha:1.0f]];
        [self.lblStatus setTextColor:[UIColor colorWithHexString:colorOrange andAlpha:1.0f]];
        [self.progressView setTrackTintColor:[UIColor colorWithHexString:_task.uiStyle.promptColor andAlpha:1.0f]];
        [self.progressView setProgressTintColor:[UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f]];
		[self setTaskStatusAndProgress];
	}
	if(_task.renditions.count == 0) {
		[self.btnDetailsRightConstraint setConstant:0];
	} else {
		[self.btnDetailsRightConstraint setConstant:52];
	}
}
#pragma - button actions
- (IBAction)start:(id)sender {
	if([self.delegate respondsToSelector:@selector(didTaskCellRequestStartTask:)]) {
		[self.delegate didTaskCellRequestStartTask:_task];
	}
}

- (IBAction)details:(id)sender {
	if([self.delegate respondsToSelector:@selector(didTaskCellRequestDisplayDetailsForTask:atIndexPath:)]) {
		[self.delegate didTaskCellRequestDisplayDetailsForTask:_task atIndexPath:_indexPath];
	}
}

- (IBAction)export:(id)sender {
	if([self.delegate respondsToSelector:@selector(didTaskCellRequestExportTask:atIndexPath:)]) {
		[self.delegate didTaskCellRequestExportTask:_task atIndexPath:_indexPath];
	}
}

- (IBAction)rendition:(id)sender {
	if([self.delegate respondsToSelector:@selector(didTaskCellRequestDisplayRenditionForTask:atIndexPath:)]) {
		[self.delegate didTaskCellRequestDisplayRenditionForTask:_task atIndexPath:_indexPath];
	}
}
@end
