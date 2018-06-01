//
//  LTAltoXmlDocumentOptions.h
//  Leadtools.Forms.DocumentWriters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTDocumentOptions.h"

typedef NS_ENUM(NSInteger, LTAltoXmlMeasurementUnit) {
    LTAltoXmlMeasurementUnitMM10,
    LTAltoXmlMeasurementUnitInch1200,
    LTAltoXmlMeasurementUnitDpi,
    LTAltoXmlMeasurementUnitPixel
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAltoXmlDocumentOptions : LTDocumentOptions <NSCopying, NSCoding>

@property (nonatomic, assign)         LTAltoXmlMeasurementUnit measurementUnit;

@property (nonatomic, assign)         NSInteger firstPhysicalPageNumber;

@property (nonatomic, assign)         BOOL formatted;

@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, copy, nullable) NSString *processingDateTime;
@property (nonatomic, copy, nullable) NSString *processingAgency;
@property (nonatomic, copy, nullable) NSString *processingStepDescription;
@property (nonatomic, copy, nullable) NSString *processingStepSettings;
@property (nonatomic, copy, nullable) NSString *softwareCreator;
@property (nonatomic, copy, nullable) NSString *softwareName;
@property (nonatomic, copy, nullable) NSString *softwareVersion;
@property (nonatomic, copy, nullable) NSString *applicationDescription;

@property (nonatomic, copy)           NSString *indentation; // Default is \t

@end

NS_ASSUME_NONNULL_END