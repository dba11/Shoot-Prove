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

#import "FreeCaptureViewController.h"
#import "SWRevealViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "StoreManager.h"
#import "SettingsManager.h"
#import "SyncManager.h"
#import "TaskManager.h"
#import "UIColor+HexString.h"
#import "ImageHelper.h"
#import "EnumHelper.h"
#import "ErrorHelper.h"
#import "FileHash.h"
#import "ShadowButton.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "FreeCaptureImage.h"
#import "FreeCaptureImageCertificationError.h"
#import "Viewer.h"
#import "User.h"
#import "Task.h"
#import "CaptureImage.h"
#import "SubTaskPicture.h"
#import "SubTaskScan.h"

#define spacing 8.0f

@interface FreeCaptureViewController ()
{
	User *_user;
    int _itemsPerRow;
	NSMutableArray *_freeCaptureImages;
	UIBarButtonItem *_btnCancel;
	UIBarButtonItem *_btnDone;
    SPFormat _scannerFormat;
    SPResolution _scannerResolution;
    SPColorMode _scannerColorMode;
    BOOL _scannerFlashOn;
    BOOL _scannerAutoCapture;
    int _remainingPagesInProgress;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoContent;
@property (weak, nonatomic) IBOutlet ShadowButton *btnTakePicture;
@property (weak, nonatomic) IBOutlet ShadowButton *btnScanPage;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainingPages;
@property (weak, nonatomic) id<FreeCaptureViewControllerDelegate> delegate;
@end

@implementation FreeCaptureViewController
#pragma - view life cycle
- (id)initWithUser:(User *)user delegate:(id<FreeCaptureViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
        self.delegate = delegate;
		_user = user;
        _freeCaptureImages = [[NSMutableArray alloc] init];
        if(UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)) {
            _itemsPerRow = 2;
        } else {
            _itemsPerRow = 3;
        }
        if(isDeviceIPad)
            _itemsPerRow++;
	}
	return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"TITLE_FREE_TASK", nil);
	
	[self buildCancelButton];
	[self buildDoneButton];
	[self checkDoneButton];
	
    //configure collection view
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:spacing];
    [flowLayout setMinimumLineSpacing:spacing];
    [flowLayout setSectionInset:UIEdgeInsetsMake(spacing, spacing, spacing, spacing)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([FreeCaptureThumbCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([FreeCaptureThumbCell class])];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    //design buttons
    self.btnTakePicture.backgroundColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f];
	self.btnTakePicture.layer.cornerRadius = 40.0f;
	
	self.btnScanPage.backgroundColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f];
	self.btnScanPage.layer.cornerRadius = 40.0f;
    
    //design remaining pages label
    self.lblRemainingPages.font = [UIFont fontWithName:normalFontName size:normalFontSize];
    self.lblRemainingPages.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
    self.lblRemainingPages.backgroundColor = [UIColor colorWithHexString:colorGreen andAlpha:0.5f];
    self.lblRemainingPages.layer.cornerRadius = self.lblRemainingPages.frame.size.height / 2;
    self.lblRemainingPages.layer.masksToBounds = YES;
    self.lblRemainingPages.layer.borderWidth = 1.0f;
    self.lblRemainingPages.layer.borderColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f].CGColor;
    self.lblRemainingPages.alpha = 0.0f;
    
    //settings
    _scannerFormat = [[SettingsManager sharedManager] scannerFormat];
    _scannerColorMode = [[SettingsManager sharedManager] scannerColorMode];
    _scannerResolution = [[SettingsManager sharedManager] scannerResolution];
    _scannerAutoCapture = [[SettingsManager sharedManager] scannerAutoScan];
    _scannerFlashOn = _scannerAutoCapture;
    
    //Make sure the certification client returns its result to self
	[CertificationClient.sharedManager setDelegate:self];
	
    //Make self aware of screen orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItems:@[_btnCancel]];
	[self.navigationItem setRightBarButtonItems:@[_btnDone]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES animated:NO];
}

#pragma - orientation change
- (void)orientationChanged:(NSNotification *)notification {
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        _itemsPerRow = 2;
    } else {
        _itemsPerRow = 3;
    }
    if(isDeviceIPad)
        _itemsPerRow++;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma - build buttons
- (void)buildCancelButton {
    _btnCancel = [[UIBarButtonItem alloc] init];
    [_btnCancel setImage:[UIImage imageNamed:@"menu"]];
    [_btnCancel setTarget:self];
    [_btnCancel setAction:@selector(cancel)];
}

- (void)buildDoneButton {
	_btnDone = [[UIBarButtonItem alloc] init];
	[_btnDone setImage:[UIImage imageNamed:@"done"]];
	[_btnDone setTarget:self];
	[_btnDone setAction:@selector(done)];
}

#pragma - collection delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
    CGFloat availableWidth = self.collectionView.frame.size.width - ((_itemsPerRow + 1) * spacing);
    CGFloat width = availableWidth / _itemsPerRow;
    return CGSizeMake(width, width);
	
}

#pragma - collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSUInteger count = [_freeCaptureImages count];
	
	if (count > 0) {
		
		self.collectionView.backgroundView = nil;
		
	} else {
		
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.collectionView.bounds.size.width-48)/2, 8, 48, 48)];
        imageView.image = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView.tintColor = [UIColor colorWithHexString:colorGreen andAlpha:0.5f];
        [view addSubview:imageView];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, imageView.frame.origin.y + imageView.frame.size.height + 8, self.collectionView.bounds.size.width-16, self.collectionView.bounds.size.height - (imageView.frame.origin.y + imageView.frame.size.height + 16))];
        messageLabel.text = NSLocalizedString(@"FREE_TASK_NO_CONTENT", nil);;
        messageLabel.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:normalFontName size:normalFontSize];
        [view addSubview:messageLabel];
        [messageLabel sizeToFit];
        
        ShadowButton *button = [[ShadowButton alloc] initWithFrame:CGRectMake((view.frame.size.width - 48) / 2, messageLabel.frame.origin.y + messageLabel.frame.size.height + 16, 48, 48)];
        button.layer.cornerRadius = button.frame.size.height/2;
        [button setBackgroundColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
        [button setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openSettings:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        CGFloat viewHeight = button.frame.origin.y + button.frame.size.height + 8;
        CGRect frame = CGRectMake(0, 0, view.frame.size.width, viewHeight);
        view.frame = frame;
        [scrollView addSubview:view];
        scrollView.contentSize = frame.size;
        
        self.collectionView.backgroundView = scrollView;
        self.collectionView.backgroundView.userInteractionEnabled = YES;
        
	}
	
	return count;
	
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
    FreeCaptureImage *freeCaptureImage = [_freeCaptureImages objectAtIndex:indexPath.row];
    
	FreeCaptureThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FreeCaptureThumbCell class]) forIndexPath:indexPath];
	
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewItemLongPress:)];
    [longPress setMinimumPressDuration:1.0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setImage:freeCaptureImage delegate:self];
        if(freeCaptureImage.certified) {
            [cell stopAnimation];
        } else {
            [cell startAnimation];
        }
        [cell addGestureRecognizer:longPress];
    });
	
	return cell;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	[_freeCaptureImages exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
}

#pragma - long gesture recognizer
- (void)collectionViewItemLongPress:(UILongPressGestureRecognizer *)gesture {
	
	FreeCaptureThumbCell *cell = (FreeCaptureThumbCell *)gesture.view;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	
	switch(gesture.state) {
		case UIGestureRecognizerStateBegan:
			[self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
			break;
		case UIGestureRecognizerStateChanged:
			[self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.collectionView]];
			break;
		case UIGestureRecognizerStateEnded:
			[self.collectionView endInteractiveMovement];
			break;
		default:
			[self.collectionView cancelInteractiveMovement];
	}
	
}

#pragma - cell delegate methods
- (void)didFreeCaptureThumbCellRequestDelete:(UICollectionViewCell *)cell {
	
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	FreeCaptureImage *freeCaptureImage = [_freeCaptureImages objectAtIndex:indexPath.row];
	if([[NSFileManager defaultManager] fileExistsAtPath:freeCaptureImage.path]) {
		[[NSFileManager defaultManager] removeItemAtPath:freeCaptureImage.path error:nil];
	}
	[_freeCaptureImages removeObjectAtIndex:indexPath.row];
	[self.collectionView reloadData];
	[self checkDoneButton];
	
}

- (void)didFreeCaptureThumbCellRequestRotate:(UICollectionViewCell *)cell {
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	FreeCaptureImage *freeCaptureImage = [_freeCaptureImages objectAtIndex:indexPath.row];
	
    NSError *error;
	LTRasterImage *rasterImage = [ImageHelper rasterImageFromPath:freeCaptureImage.path error:&error];
	if(rasterImage) {
        [ImageHelper rotateRightRasterImage:rasterImage error:&error];
		if(!error) {
			[ImageHelper saveRasterImage:rasterImage path:freeCaptureImage.path error:&error];
		}
	}
	if(error) {
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
	
	[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
	[self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)didFreeCaptureThumbCellRequestView:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FreeCaptureImage *freeCaptureImage = [_freeCaptureImages objectAtIndex:indexPath.row];
    [[[Viewer alloc] initWithFilePath:freeCaptureImage.path mimeType:freeCaptureImage.mimetype] show];
}

#pragma - picture task methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	FreeCaptureImage *freeCaptureImage = [[FreeCaptureImage alloc] initWithMimeType:mimeJPG];
	freeCaptureImage.format = SPFormatPicture;
	freeCaptureImage.size = SettingsManager.sharedManager.pictureSize;
	
	NSError *error = nil;
	LTRasterImage *rasterImage = [ImageHelper rasterImageFromUIImage:[info objectForKey:UIImagePickerControllerOriginalImage] error:&error];
	[ImageHelper resizeImage:rasterImage toSize:[EnumHelper sizeFromSPsize:freeCaptureImage.size] allowStretch:NO error:&error];
    [ImageHelper saveJpegImage:rasterImage quality:LTCodecsCmpQualityFactorPredefinedSuperQuality path:freeCaptureImage.path error:&error];
	if(error) {
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
		return;
	} else {
		[_freeCaptureImages addObject:freeCaptureImage];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_freeCaptureImages.count - 1) inSection:0];
		[self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [CertificationClient.sharedManager queueCaptureImageObject:freeCaptureImage indexPath:indexPath];
	}

	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma - scan task methods
- (void)willScanViewControllerReturnRasterImage {
    _remainingPagesInProgress++;
    [self displayRemainingNumberOfPages];
}

- (void)didScanViewControllerReturnRasterImage:(LTRasterImage *)image format:(SPFormat)format dpi:(int)dpi colorMode:(SPColorMode)colorMode flashOn:(BOOL)flashOn autoCapture:(BOOL)autoCapture {
    //save user inputs
    _scannerFormat = format;
    _scannerResolution = [EnumHelper resolutionFromValue:dpi];
    _scannerColorMode = colorMode;
    _scannerFlashOn = flashOn;
    _scannerAutoCapture = autoCapture;
    //prepare new capture image
	FreeCaptureImage *freeCaptureImage = [[FreeCaptureImage alloc] initWithMimeType:mimeTIF];
	freeCaptureImage.format = format;
	freeCaptureImage.resolution = [EnumHelper resolutionFromValue:dpi];
	freeCaptureImage.colorMode = colorMode;
	
	NSError *error = nil;
	[ImageHelper saveJpegImage:image quality:LTCodecsCmpQualityFactorPredefinedSuperQuality path:freeCaptureImage.path error:&error];
	if(error) {
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	} else {
		[_freeCaptureImages addObject:freeCaptureImage];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_freeCaptureImages.count - 1) inSection:0];
		[self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [CertificationClient.sharedManager queueCaptureImageObject:freeCaptureImage indexPath:indexPath];
	}
}

- (void)didScanViewControllerCancel {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma - helper to determine enable/disable done button
- (void)checkDoneButton {
	[_btnDone setEnabled:_freeCaptureImages.count > 0];
    [_btnCancel setImage:[UIImage imageNamed:_freeCaptureImages.count > 0 ? @"close":@"menu"]];
}

#pragma - helper to show/hide the remaining number of pages in progress by scan view controller
- (void)displayRemainingNumberOfPages {
    
    if(_remainingPagesInProgress > 1) {
        self.lblRemainingPages.text = [NSString stringWithFormat:NSLocalizedString(@"FREE_TASK_REMAINING_PAGES", nil), _remainingPagesInProgress];
    } else {
        self.lblRemainingPages.text = [NSString stringWithFormat:NSLocalizedString(@"FREE_TASK_REMAINING_PAGE", nil), _remainingPagesInProgress];
    }
    
    if(_remainingPagesInProgress > 0 && self.lblRemainingPages.alpha == 0.0f) {
        
        [UIView animateWithDuration:0.8 animations:^{
            self.lblRemainingPages.alpha = 1.0f;
        } completion:^(BOOL finished) {
            //
        }];
        
    } else if(_remainingPagesInProgress == 0 && self.lblRemainingPages.alpha == 1.0f) {
        
        [UIView animateWithDuration:0.8 animations:^{
            self.lblRemainingPages.alpha = 0.0f;
        } completion:^(BOOL finished) {
            //
        }];
        
    }
    
}

#pragma - buttons events
- (void)openSettings:(id)sender {
    if([self.delegate respondsToSelector:@selector(didFreeTaskViewControllerRequestDisplaySettings)]) {
        [self.delegate didFreeTaskViewControllerRequestDisplaySettings];
    }
}

- (void)cancel {
    if(_freeCaptureImages.count > 0) {
        [[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:NSLocalizedString(@"WARNING_FREE_TASK_EXISTING_PAGES", nil) confirmButtonTitle:NSLocalizedString(@"BUTTON_YES", nil) confirmTag:confirmBackTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
    } else {
        SWRevealViewController *revealController = [self revealViewController];
        [revealController revealToggle:_btnCancel];
    }
}

- (void)done {
	
	if(_freeCaptureImages.count == 0)
		return;
	
	NSError *error;
	UIView * topView = UIApplication.sharedApplication.keyWindow.subviews.lastObject;
	
	Task *task = [StoreManager.sharedManager createFreeTask:&error];
	
	if(!error) {
        
		for(FreeCaptureImage *freeCaptureImage in _freeCaptureImages) {
			
			CaptureImage *captureImage;
			
			if(freeCaptureImage.format == SPFormatPicture) {
				
				SubTaskPicture *subTaskPicture = [[StoreManager sharedManager] createSubTaskPictureForAbstractService:task uuid:nil title:NSLocalizedString(@"FREE_TASK_PICTURE_TITLE", nil) description:nil];
				subTaskPicture.startDate = freeCaptureImage.creationDate;
				subTaskPicture.endDate = [NSDate date];
				subTaskPicture.imageSize = [EnumHelper descriptionFromSize:freeCaptureImage.size];
				captureImage = [StoreManager.sharedManager createImageForTask:task uuid:subTaskPicture.uuid order:[subTaskPicture nextOrder] mime:mimeJPG];
				
			} else {
				SubTaskScan *subTaskScan = [StoreManager.sharedManager createSubTaskScanForAbstractService:task uuid:nil title:NSLocalizedString(@"FREE_TASK_SCAN_TITLE", nil) description:nil];
				subTaskScan.startDate = freeCaptureImage.creationDate;
				subTaskScan.endDate = [NSDate date];
				subTaskScan.dpi = [NSNumber numberWithInt:[EnumHelper valueFromResolution:freeCaptureImage.resolution]];
				subTaskScan.format = [EnumHelper descriptionFromFormat:freeCaptureImage.format];
				subTaskScan.mode = [EnumHelper descriptionFromColorMode:freeCaptureImage.colorMode];
				captureImage = [StoreManager.sharedManager createImageForTask:task uuid:subTaskScan.uuid order:[subTaskScan nextOrder] mime:mimeTIF];
			}
			[NSFileManager.defaultManager copyItemAtPath:freeCaptureImage.path toPath:captureImage.privatePath error:nil];
			captureImage.sha1 = freeCaptureImage.sha1;
			captureImage.latitude = freeCaptureImage.latitude;
			captureImage.longitude = freeCaptureImage.longitude;
			captureImage.accuracy = freeCaptureImage.accuracy;
			captureImage.timestamp = freeCaptureImage.timestamp;
			captureImage.certified = [NSNumber numberWithBool:freeCaptureImage.certified];
			
			if(freeCaptureImage.errors.count > 0) {
				BOOL isCritical = NO;
				for(NSError *err in freeCaptureImage.errors) {
					if([err.domain isEqualToString:SPCertificationErrorDomain])
						isCritical = YES;
					[StoreManager.sharedManager createCertificationErrorForImage:captureImage code:err.code description:err.description domain:err.domain];
				}
				captureImage.errorLevel = (isCritical ? [NSNumber numberWithInt:SPErrorLevelError] : [NSNumber numberWithInt:SPErrorLevelWarning]);
			}
		}
		[task createFreeSubTaskForm];
        if(!_user.activeSubscription) {
            [task createRendition];
        }
        [TaskManager.sharedManager finalizeTask:task];
		[StoreManager.sharedManager saveContext:&error];
		if(error) {
            [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
			[StoreManager.sharedManager deleteTask:task];
		} else {
            for(FreeCaptureImage *freeCaptureImage in _freeCaptureImages) {
                [[NSFileManager defaultManager] removeItemAtPath:freeCaptureImage.path error:nil];
            }
            [_freeCaptureImages removeAllObjects];
            [self.collectionView reloadData];
            [self checkDoneButton];
            [StoreManager.sharedManager syncSharedDirectory];
            if(_user.activeSubscription) {
                [SyncManager.sharedManager addSyncTaskRequest];
            }
			[topView makeToast:NSLocalizedString(@"FREE_TASK_FINALIZED", nil) duration:(toastDuration*1.5) position:CSToastPositionBottom title:nil image:ToastHelper.imageInfo style:ToastHelper.styleInfo completion:^(BOOL didTap) {
                if(didTap && [self.delegate respondsToSelector:@selector(didFreeTaskViewControllerRequestDisplayHistory)]) {
                        [self.delegate didFreeTaskViewControllerRequestDisplayHistory];
                }
			}];
		}
	} else {
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
	
}

- (IBAction)takePicture:(id)sender {
	[DeviceHelper checkCameraGranted:^(BOOL granted) {
		if(granted) {
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
			[imagePicker setMediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil]];
			[imagePicker setModalPresentationStyle:UIModalPresentationCurrentContext];
			[imagePicker setAllowsEditing:NO];
			[imagePicker setDelegate:self];
			[self.navigationController presentViewController:imagePicker animated:YES completion:nil];
		} else {
			[[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"DEVICE_CAMERA_DISABLED", nil), NSLocalizedString(@"DEVICE_OPEN_SETTINGS", nil)] confirmButtonTitle:NSLocalizedString(@"BUTTON_SETTINGS", nil) confirmTag:openSettingsTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
		}
	}];
}

- (IBAction)scanPage:(id)sender {
	[DeviceHelper checkCameraGranted:^(BOOL granted) {
		if(granted) {
            int dpi = [EnumHelper valueFromResolution:_scannerResolution];
            _remainingPagesInProgress = 0;
			ScanViewController *scanViewController = [[ScanViewController alloc] initWithFormat:_scannerFormat dpi:dpi colorMode:_scannerColorMode flashOn:_scannerFlashOn autoCapture:_scannerAutoCapture freeMode:YES delegate:self];
			[self.navigationController pushViewController:scanViewController animated:YES];
		} else {
			[[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"DEVICE_CAMERA_DISABLED", nil), NSLocalizedString(@"DEVICE_OPEN_SETTINGS", nil)] confirmButtonTitle:NSLocalizedString(@"BUTTON_SETTINGS", nil) confirmTag:openSettingsTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
		}
	}];
}

#pragma - dialog delegate method
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
	if([tag isEqualToString:openSettingsTag]) {
		[DeviceHelper openDeviceSettings];
    } else if([tag isEqualToString:confirmBackTag]) {
        [_freeCaptureImages removeAllObjects];
        [self.collectionView reloadData];
        [self checkDoneButton];
        SWRevealViewController *revealController = [self revealViewController];
        [revealController revealToggle:_btnCancel];
    }
}

#pragma - certification client delegate method
- (void)didCertificationClientFinishWithCaptureImageObject:(id)imageObject indexPath:(NSIndexPath *)indexPath {
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self checkDoneButton];
    _remainingPagesInProgress--;
    [self displayRemainingNumberOfPages];
}
@end
