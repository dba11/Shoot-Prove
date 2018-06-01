//
//  LTPDF417BarcodeWriteOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeWriteOptions.h"
#import "LTBarcodeWriteEnums.h"
#import "LTPDF417BarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPDF417BarcodeWriteOptions : LTBarcodeWriteOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeAlignment horizontalAlignment;
@property (nonatomic, assign)          LTBarcodeAlignment verticalAlignment;

@property (nonatomic, assign)          LTPDF417BarcodeECCLevel eccLevel;

@property (nonatomic, assign)          BOOL truncated;
@property (nonatomic, assign)          BOOL enableGroupMode;
@property (nonatomic, assign)          BOOL limitByRowsAndColumns;

@property (nonatomic, assign)          NSInteger symbolWidthAspectRatio;
@property (nonatomic, assign)          NSInteger symbolHeightAspectRatio;
@property (nonatomic, assign)          NSInteger rows;
@property (nonatomic, assign)          NSInteger columns;
@property (nonatomic, assign)          NSInteger xModule;
@property (nonatomic, assign)          NSInteger xModuleAspectRatio;
@property (nonatomic, assign)          NSInteger eccPercentage;

@end

NS_ASSUME_NONNULL_END