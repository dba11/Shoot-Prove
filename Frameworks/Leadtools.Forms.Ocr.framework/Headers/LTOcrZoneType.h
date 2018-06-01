//
//  LTOcrZoneType.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTOcrZoneType) {
   LTOcrZoneTypeText = 0,
   LTOcrZoneTypeTable,
   LTOcrZoneTypeGraphic,
   LTOcrZoneTypeOmr,
   LTOcrZoneTypeMicr,
   LTOcrZoneTypeIcr,
   LTOcrZoneTypeMrz,
   LTOcrZoneTypeBarcode,
   LTOcrZoneTypeNone,
   LTOcrZoneTypeFieldData
};