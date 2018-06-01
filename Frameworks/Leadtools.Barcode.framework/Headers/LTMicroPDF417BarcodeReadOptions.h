//
//  LTMicroPDF417BarcodeReadOptions.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTBarcodeReadOptions.h"
#import "LTBarcodeReadEnums.h"
#import "LTMicroPDF417BarcodeEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTMicroPDF417BarcodeReadOptions : LTBarcodeReadOptions

@property (nonatomic, copy, readonly)  NSString *friendlyName;

@property (nonatomic, assign)          LTBarcodeSearchDirection searchDirection;

@property (nonatomic, assign)          LTMicroPDF417BarcodeReadMode readMode;

@property (nonatomic, assign)          BOOL enableDoublePass;
@property (nonatomic, assign)          BOOL enableDoublePassIfSuccess;
@property (nonatomic, assign)          BOOL readOptionalMacroFileNameField;
@property (nonatomic, assign)          BOOL readOptionalMacroSegmentCountField;
@property (nonatomic, assign)          BOOL readOptionalMacroTimestampField;
@property (nonatomic, assign)          BOOL readOptionalMacroSenderField;
@property (nonatomic, assign)          BOOL readOptionalMacroAddresseeField;
@property (nonatomic, assign)          BOOL readOptionalMacroFileSizeField;
@property (nonatomic, assign)          BOOL readOptionalMacroChecksumField;
@property (nonatomic, assign)          BOOL readOptionalMacro79AndAZField;

@end

NS_ASSUME_NONNULL_END