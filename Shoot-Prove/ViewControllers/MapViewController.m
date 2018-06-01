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

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SettingsManager.h"
#import "ImageHelper.h"
#import "DateTimeHelper.h"
#import "StyleHelper.h"
#import "UIColor+HexString.h"
#import "MapPin.h"
#import "CaptureImage.h"
#import "Task.h"
#import "UIStyle.h"

@interface MapViewController ()
{
	CaptureImage *_captureImage;
    UIStyle *_style;
	UIBarButtonItem *_btnBack;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) id<MapViewControllerDelegate> delegate;
@end

@implementation MapViewController
- (id)initWithImage:(CaptureImage *)captureImage delegate:(id<MapViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		self.delegate = delegate;
		_captureImage = captureImage;
        _style = captureImage.task.uiStyle;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self buildBackButton];
	self.title = NSLocalizedString(@"TITLE_MAP", nil);

	[self.segmentedControl setTitle:NSLocalizedString(@"MAP_TYPE_STANDARD", nil) forSegmentAtIndex:0];
	[self.segmentedControl setTitle:NSLocalizedString(@"MAP_TYPE_SATELLITE", nil) forSegmentAtIndex:1];
	[self.segmentedControl setTitle:NSLocalizedString(@"MAP_TYPE_HYBRID", nil) forSegmentAtIndex:2];
	self.segmentedControl.tintColor = [UIColor colorWithHexString:_style.toolbarBackgroundColor andAlpha:1.0f];
	[self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:_style.toolbarBackgroundColor andAlpha:1.0f], NSFontAttributeName:[UIFont fontWithName:normalFontName size:normalFontSize]} forState:UIControlStateNormal];
	
	self.mapView.zoomEnabled = YES;
	self.mapView.scrollEnabled = YES;
	self.mapView.rotateEnabled = YES;
	self.mapView.pitchEnabled = YES;
	self.mapView.userInteractionEnabled = YES;
	
	MKMapType mapType = [[SettingsManager sharedManager] mapType];
	
	self.mapView.mapType = mapType;
	self.mapView.delegate = self;
		
	if(mapType == MKMapTypeHybrid) {
		self.segmentedControl.selectedSegmentIndex = 2;
	} else if(mapType == MKMapTypeSatellite) {
		self.segmentedControl.selectedSegmentIndex = 1;
	} else if(mapType == MKMapTypeStandard) {
		self.segmentedControl.selectedSegmentIndex = 0;
	}
	
	UIImage *pinImage = [ImageHelper resizeImage:_captureImage.image proportionalToSize:CGSizeMake(pinImageSize, pinImageSize)];
	NSString *title = [DateTimeHelper gmtDateTime:_captureImage.timestamp];
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_captureImage.latitude doubleValue], [_captureImage.longitude doubleValue]);
	
	MapPin *pin = [[MapPin alloc] initWithImage:pinImage title:title coordinate:coordinate];
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 150, 150);
	[self.mapView setRegion:viewRegion animated:YES];
	
	[self.mapView addAnnotation:pin];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    //[StyleHelper setStyle:_style viewController:self];
	[self.navigationItem setLeftBarButtonItems:@[_btnBack]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma - build buttons
- (void)buildBackButton {
	_btnBack = [[UIBarButtonItem alloc] init];
	[_btnBack setImage:[UIImage imageNamed:@"back"]];
	[_btnBack setTarget:self];
	[_btnBack setAction:@selector(back)];
}

#pragma - custom map pin
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if([annotation isKindOfClass:[MapPin class]]) {
		MapPin *pin = (MapPin *)annotation;
		MKAnnotationView *annotationView = pin.annotationView;
		return annotationView;
	} else
		return nil;
}

#pragma - button actions
- (IBAction)mapTypeValueChange:(id)sender {
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0:
			self.mapView.mapType = MKMapTypeStandard;
			break;
		case 1:
			self.mapView.mapType = MKMapTypeSatellite;
			break;
		case 2:
			self.mapView.mapType = MKMapTypeHybrid;
			break;
		default:
			break;
	}
	[SettingsManager.sharedManager setMapType:self.mapView.mapType];
	[SettingsManager.sharedManager save];
}

- (void)back {
	if([self.delegate respondsToSelector:@selector(didMapViewControllerCancel)]) {
		[self.delegate didMapViewControllerCancel];
	}
}
@end
