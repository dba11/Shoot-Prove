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

#import "CaptureViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "StoreManager.h"
#import "SettingsManager.h"
#import "UIColor+HexString.h"
#import "ImageHelper.h"
#import "EnumHelper.h"
#import "ErrorHelper.h"
#import "FileHash.h"
#import "StyleHelper.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "CaptureCollectionViewHeader.h"
#import "Viewer.h"
#import "User.h"
#import "Task.h"
#import "UIStyle.h"
#import "AbstractSubTaskCapture.h"
#import "CaptureImage.h"
#import "SubTaskPicture.h"
#import "SubTaskScan.h"

#define spacing 8.0f

@interface CaptureViewController ()
{
	int _itemsPerRow;
	Task *_task;
	AbstractSubTaskCapture *_subTaskCapture;
	NSInteger _stepCount;
	NSInteger _totalSteps;
	UIBarButtonItem *_btnBack;
	UIBarButtonItem *_btnCancel;
	UIBarButtonItem *_btnDone;
    BOOL _scannerFlashOn;
    BOOL _scannerAutoCapture;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id<CaptureViewControllerDelegate> delegate;
@end

@implementation CaptureViewController
#pragma - view life cycle
- (id)initWithSubTaskCapture:(AbstractSubTaskCapture *)subTaskCapture stepCount:(NSInteger)stepCount delegate:(id<CaptureViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		_task = (Task *) subTaskCapture.abstractService;
		_subTaskCapture = subTaskCapture;
		_stepCount = stepCount;
		_totalSteps = _task.subTasks.count;
		self.delegate = delegate;
        if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
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
	
	self.title = _task.title;
    
	[self buildBackAndCancelButtons];
	[self buildDoneButton];
	
    //configure collection view
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:spacing];
    [flowLayout setMinimumLineSpacing:spacing];
    [flowLayout setSectionInset:UIEdgeInsetsMake(spacing, spacing, spacing, spacing)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CaptureThumbCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([CaptureThumbCell class])];
    nib = [UINib nibWithNibName:NSStringFromClass([CaptureCollectionViewHeader class]) bundle:nil];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CaptureCollectionViewHeader class])];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:YES];
    [self.collectionView setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.viewBackgroundColor andAlpha:1.0]];
    
    //settings
    _scannerAutoCapture = [SettingsManager.sharedManager scannerAutoScan];
    _scannerFlashOn = _scannerAutoCapture;
    
    //set certification manager delegate
	[CertificationClient.sharedManager setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [StyleHelper setStyle:_task.uiStyle viewController:self];
    if(_stepCount>1)
        [self.navigationItem setLeftBarButtonItems:@[_btnBack, _btnCancel]];
    else
        [self.navigationItem setLeftBarButtonItems:@[_btnCancel]];
	[self.navigationItem setRightBarButtonItems:@[_btnDone]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
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
- (void)buildBackAndCancelButtons {
	
    _btnBack = [[UIBarButtonItem alloc] init];
    [_btnBack setImage:[UIImage imageNamed:@"back"]];
    [_btnBack setTarget:self];
    [_btnBack setAction:@selector(back)];
    
	_btnCancel = [[UIBarButtonItem alloc] init];
	[_btnCancel setImage:[UIImage imageNamed:@"close"]];
	[_btnCancel setTarget:self];
	[_btnCancel setAction:@selector(cancel)];
	
}

- (void)buildDoneButton {
	_btnDone = [[UIBarButtonItem alloc] init];
	if(_stepCount == _totalSteps) {
		[_btnDone setImage:[UIImage imageNamed:@"done"]];
	} else {
		[_btnDone setImage:[UIImage imageNamed:@"next"]];
	}
	[_btnDone setTarget:self];
	[_btnDone setAction:@selector(done)];
	
}

#pragma collection delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	
	return CGSizeMake(self.collectionView.frame.size.width, 60);
	
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	
	UICollectionReusableView *reusableview = nil;
	
	if(kind == UICollectionElementKindSectionHeader) {
		
		CaptureCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([CaptureCollectionViewHeader class]) forIndexPath:indexPath];
        [header setTask:_task subTaskCapture:_subTaskCapture stepCount:_stepCount totalSteps:_totalSteps];
		reusableview = header;
	
	}
	
	return reusableview;
	
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
    CGFloat availableWidth = self.collectionView.frame.size.width - ((_itemsPerRow + 1) * spacing);
    CGFloat width = availableWidth / _itemsPerRow;
    return CGSizeMake(width, width);
    
}

#pragma collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger count = 0;
	
	int minItems = [_subTaskCapture.minItems intValue];
	int maxItems = [_subTaskCapture.maxItems intValue];
	int numberOfImages = (int) [_subTaskCapture.images count];
	
	if(numberOfImages < minItems) {
		count = minItems;
	} else if(numberOfImages < maxItems) {
		count = numberOfImages + 1;
	} else {
		count = maxItems;
	}
	
	return count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CaptureThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CaptureThumbCell class]) forIndexPath:indexPath];
	
	[cell setSubTask:_subTaskCapture imageIndex:indexPath.row delegate:self];
	
    if(_subTaskCapture.images.count > indexPath.row) {
        
        CaptureImage *captureImage = [_subTaskCapture.images objectAtIndex:indexPath.row];
        
        if([captureImage.certified isEqualToNumber:@0]) {
            [CertificationClient.sharedManager queueCaptureImageObject:captureImage indexPath:indexPath];
            [cell startAnimation];
        } else {
            [cell stopAnimation];
        }
        
    } else {
        
        [cell stopAnimation];
        
    }
    
	return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma cell delegate methods
- (void)didCaptureThumbCellRequestDelete:(UICollectionViewCell *)cell; {
	
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	CaptureImage *captureImage = [_subTaskCapture imageAtIndex:indexPath.row];
	[StoreManager.sharedManager deleteImage:captureImage];
	
	if(_subTaskCapture.images.count < [_subTaskCapture.minItems intValue]) {
		_subTaskCapture.endDate = nil;
	}
	
	NSError *error;
	[StoreManager.sharedManager saveContext:&error];
	if(error) {
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}

	[self.collectionView reloadData];
	
}

- (void)didCaptureThumbCellRequestRotate:(UICollectionViewCell *)cell; {
	
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	CaptureImage *captureImage = [_subTaskCapture imageAtIndex:indexPath.row];
	
	NSError *error;
	LTRasterImage *rasterImage = [ImageHelper rasterImageFromPath:captureImage.privatePath error:&error];
	if(rasterImage) {
		[ImageHelper rotateRightRasterImage:rasterImage error:&error];
		if(!error) {
			[ImageHelper saveRasterImage:rasterImage path:captureImage.privatePath error:&error];
		}
	}
	if(error) {
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
	
	[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
	[self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
	
}

- (void)didCaptureThumbCellRequestView:(UICollectionViewCell *)cell; {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    CaptureImage *captureImage = [_subTaskCapture imageAtIndex:indexPath.row];
    [[[Viewer alloc] initWithFilePath:captureImage.privatePath mimeType:captureImage.mimetype] show];
}

- (void)didCaptureThumbCellRequestCapture:(UICollectionViewCell *)cell; {
	
	[DeviceHelper checkCameraGranted:^(BOOL granted) {
		
		if(granted) {
			if(!_subTaskCapture.startDate) {
				_subTaskCapture.startDate = [NSDate date];
			}
			if([_subTaskCapture isKindOfClass:[SubTaskPicture class]]) {
				[self takePicture];
			} else if([_subTaskCapture isKindOfClass:[SubTaskScan class]]) {
				[self scanPage];
			}
		} else {
			[[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"DEVICE_CAMERA_DISABLED", nil), NSLocalizedString(@"DEVICE_OPEN_SETTINGS", nil)] confirmButtonTitle:NSLocalizedString(@"BUTTON_SETTINGS", nil) confirmTag:openSettingsTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
		}
		
	}];
	
}

#pragma - picture task methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	SubTaskPicture *subTaskPicture = (SubTaskPicture *)_subTaskCapture;
	
	NSError *error = nil;
	LTRasterImage *rasterImage = [ImageHelper rasterImageFromUIImage:[info objectForKey:UIImagePickerControllerOriginalImage] error:&error];
    [ImageHelper resizeImage:rasterImage toSize:[EnumHelper sizeFromSPsize:[EnumHelper sizeFromDescription:subTaskPicture.imageSize]] allowStretch:NO error:&error];
	if(error) {
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
		return;
	}
	
	CaptureImage *captureImage = [StoreManager.sharedManager createImageForTask:_task uuid:subTaskPicture.uuid order:[subTaskPicture nextOrder] mime:mimeJPG];
	
	[ImageHelper saveJpegImage:rasterImage quality:LTCodecsCmpQualityFactorPredefinedSuperQuality path:captureImage.privatePath error:&error];
	if(error) {
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
		[StoreManager.sharedManager deleteImage:captureImage];
	} else {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_subTaskCapture.images.count - 1) inSection:0];
		[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
		[CertificationClient.sharedManager queueCaptureImageObject:captureImage indexPath:indexPath];
	}

	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma - scan task methods

- (void)didScanViewControllerReturnRasterImage:(LTRasterImage *)image format:(SPFormat)format dpi:(int)dpi colorMode:(SPColorMode)colorMode flashOn:(BOOL)flashOn autoCapture:(BOOL)autoCapture {
	
    //save user inputs
    _scannerAutoCapture = autoCapture;
    _scannerFlashOn = flashOn;
    //link subTask with image
	SubTaskScan *subTaskScan = (SubTaskScan *)_subTaskCapture;
	subTaskScan.dpi = [NSNumber numberWithInt:dpi];
	subTaskScan.format = [EnumHelper descriptionFromFormat:format];
	subTaskScan.mode = [EnumHelper descriptionFromColorMode:colorMode];
	
	CaptureImage *captureImage = [[StoreManager sharedManager] createImageForTask:_task uuid:subTaskScan.uuid order:[subTaskScan nextOrder] mime:mimeTIF];
	
	NSError *error = nil;
	[ImageHelper saveJpegImage:image quality:LTCodecsCmpQualityFactorPredefinedSuperQuality path:captureImage.privatePath error:&error];
	if(error) {
		[ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
		[StoreManager.sharedManager deleteImage:captureImage];
	} else {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_subTaskCapture.images.count - 1) inSection:0];
		[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
		[CertificationClient.sharedManager queueCaptureImageObject:captureImage indexPath:indexPath];
	}
	
}

- (void)didScanViewControllerCancel {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma - buttons events
- (void)back {
	if([self.delegate respondsToSelector:@selector(didCaptureViewControllerRequestBackOnSubTask:)]) {
		[self.delegate didCaptureViewControllerRequestBackOnSubTask:_subTaskCapture];
	}
}

- (void)cancel {
	if([self.delegate respondsToSelector:@selector(didCaptureViewControllerCancelSubTask:)]) {
		[self.delegate didCaptureViewControllerCancelSubTask:_subTaskCapture];
	}
}

- (void)done {
	if([self.delegate respondsToSelector:@selector(didCaptureViewControllerCompleteSubTask:)]) {
		[self.delegate didCaptureViewControllerCompleteSubTask:_subTaskCapture];
	}
}

- (void)takePicture {
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
	[imagePicker setMediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil]];
	[imagePicker setModalPresentationStyle:UIModalPresentationCurrentContext];
	[imagePicker setAllowsEditing:NO];
	[imagePicker setDelegate:self];
	[self.navigationController presentViewController:imagePicker animated:YES completion:nil];
	
}

- (void)scanPage {
	
	SubTaskScan *subTask = (SubTaskScan *) _subTaskCapture;
	if(!subTask.startDate)
		subTask.startDate = [NSDate date];
	SPFormat format = [EnumHelper formatFromDescription:subTask.format];
	SPColorMode colorMode = [EnumHelper colorModeFromDescription:subTask.mode];
	int dpi = [subTask.dpi intValue];
	ScanViewController *scanViewController = [[ScanViewController alloc] initWithFormat:format dpi:dpi colorMode:colorMode flashOn:_scannerFlashOn autoCapture:_scannerAutoCapture freeMode:NO delegate:self];
	[self.navigationController pushViewController:scanViewController animated:YES];
	
}

#pragma - dialog delegate method
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
	if([tag isEqualToString:confirmBackTag]) {
		_subTaskCapture.endDate = nil;
		if([self.delegate respondsToSelector:@selector(didCaptureViewControllerRequestBackOnSubTask:)]) {
			[self.delegate didCaptureViewControllerRequestBackOnSubTask:_subTaskCapture];
		}
	} else if([tag isEqualToString:openSettingsTag]) {
		[DeviceHelper openDeviceSettings];
	}
}

#pragma - certification client delegate method
- (void)didCertificationClientFinishWithCaptureImageObject:(id)imageObject indexPath:(NSIndexPath *)indexPath {
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

@end
