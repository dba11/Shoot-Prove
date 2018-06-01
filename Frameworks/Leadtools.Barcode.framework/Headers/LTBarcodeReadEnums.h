//
//  LTBarcodeReadEnums.h
//  Leadtools.Barcode
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

// Search direction in a barcode
typedef NS_ENUM(NSInteger, LTBarcodeSearchDirection) {
   LTBarcodeSearchDirectionHorizontal,
   LTBarcodeSearchDirectionVertical,
   LTBarcodeSearchDirectionHorizontalAndVertical
};

// Return check digit mode
typedef NS_ENUM(NSInteger, LTBarcodeReturnCheckDigit) {
   LTBarcodeReturnCheckDigitDefault,    // Default mode, depend on the standard. Currently equals to Yes for UPC and EAN barcodes
   LTBarcodeReturnCheckDigitYes,        // (BARCODE_RETURNCHECK) Always return the digit if symbology supports it
   LTBarcodeReturnCheckDigitNo          // (BARCODE_DONOTRETURNCHECK). Do not return the digit if symbology supports it
};