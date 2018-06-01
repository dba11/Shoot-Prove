//
//  LTReadEvents.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"
#import "LTBarcodeData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LTBarcodeReadSymbologyOperation)
{
   LTBarcodeReadSymbologyOperationPreRead,
   LTBarcodeReadSymbologyOperationPostRead
};

typedef NS_ENUM(NSInteger, LTBarcodeReadSymbologyStatus)
{
   LTBarcodeReadSymbologyStatusContinue,
   LTBarcodeReadSymbologyStatusSkip,
   LTBarcodeReadSymbologyStatusAbort
};

@interface LTBarcodeReadSymbologyEventArgs : NSObject

@property (nonatomic, assign, readonly)            LTBarcodeReadSymbologyOperation operation;

@property (nonatomic, assign, readonly, nullable)  LTBarcodeSymbology *symbologies;

@property (nonatomic, assign, readonly)            NSUInteger symbologiesCount;

@property (nonatomic, assign, readonly)            LTBarcodeReadSymbologyStatus status;

@property (nonatomic, strong, readonly, nullable)  LTBarcodeReadOptions *options;

@property (nonatomic, strong, readonly, nullable)  LTBarcodeData *data;

@property (nonatomic, strong, readonly, nullable)  NSError *error;

@end

@protocol LTReadSymbologyDelegate<NSObject>

@required

- (void)readSymbology:(id)sender e:(LTBarcodeReadSymbologyEventArgs*)e;

@end

NS_ASSUME_NONNULL_END