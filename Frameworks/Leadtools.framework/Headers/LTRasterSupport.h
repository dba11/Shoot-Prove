//
//  LTRasterSupport.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTError.h"

typedef NS_ENUM(NSInteger, LTRasterSupportType) {
    LTRasterSupportTypeDocument                      = 0,
    LTRasterSupportTypeBarcodes1D                    = 1,
    LTRasterSupportTypeBarcodes2D                    = 2,
    LTRasterSupportTypeRasterPdfRead                 = 3,
    LTRasterSupportTypeRasterPdfSave                 = 4,
    LTRasterSupportTypePdfAdvanced                   = 5,
    LTRasterSupportTypeJbig2                         = 6,
    LTRasterSupportTypeOcrAdvantage                  = 7,
    LTRasterSupportTypeOcrPlus                       = 8,
    LTRasterSupportTypeOcrProfessional               = 9,
    LTRasterSupportTypeOcrProfessionalAsian          = 10,
    LTRasterSupportTypeOcrArabic                     = 11,
    LTRasterSupportTypeOcrAdvantagePdfOutput         = 12,
    LTRasterSupportTypeOcrPlusPdfOutput              = 13,
    LTRasterSupportTypeOcrProfessionalPdfOutput      = 14,
    LTRasterSupportTypeOcrArabicPdfOutput            = 15,
    LTRasterSupportTypeOmr                           = 16,
    LTRasterSupportTypeIcrPlus                       = 17,
    LTRasterSupportTypeIcrProfessional               = 18,
    LTRasterSupportTypeDocumentWriters               = 19,
    LTRasterSupportTypeDocumentWritersPdf            = 20,
    LTRasterSupportTypePrintDriver                   = 21,
    LTRasterSupportTypePrintDriverServer             = 22,
    LTRasterSupportTypePrintDriverNetwork            = 23,
    LTRasterSupportTypeForms                         = 24,
    LTRasterSupportTypeMediaWriter                   = 25,
    LTRasterSupportTypeMedical                       = 26,
    LTRasterSupportTypeMedical3d                     = 27,
    LTRasterSupportTypeDicomCommunication            = 28,
    LTRasterSupportTypeCcow                          = 29,
    LTRasterSupportTypeVector                        = 30,
    LTRasterSupportTypeCloud                         = 31,
    LTRasterSupportTypeAppStore                      = 32,
    LTRasterSupportTypeBasic                         = 33
};

typedef NS_ENUM(NSInteger, LTRasterKernelType) {
    LTRasterKernelTypeRelease,
    LTRasterKernelTypeEvaluation,
};

NS_ASSUME_NONNULL_BEGIN

/**
 @brief The LTRasterSupport class provides methods for settings a LEADTOOLS runtime license and unlocking support for optional features, such as LEADTOOLS Document/Medical capabilities.
 */
@interface LTRasterSupport : NSObject // STATIC CLASS

/**
 @brief Sets the runtime license for LEADTOOLS and unlocks support for optional features such as LEADTOOLS Imaging Pro, Document and Medical capabilities, or PDF Support.
 @discussion This method uses a file containing the runtime license.
 
 @param licenseFile The path to the runtime license file. Raises a NSInvalidArgumentException if licenseFile is nil.
 @param developerKey The developer key that corresponds to the LEADTOOLS runtime license.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if the runtime license was set correctly, otherwise NO (if there was a problem setting the license).
 */
+ (BOOL)setLicenseFile:(NSString *)licenseFile developerKey:(NSString *)developerKey error:(NSError **)error;

/**
 @brief Sets the runtime license for LEADTOOLS and unlocks support for optional features such as LEADTOOLS Imaging Pro, Document and Medical capabilities, or PDF Support.
 @discussion This method uses a unmanaged byte buffer containing the runtime license.
 
 @param licenseBuffer The path to the runtime license file. Raises a NSInvalidArgumentException if licenseBuffer is NULL.
 @param developerKey The developer key that corresponds to the LEADTOOLS runtime license.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if the runtime license was set correctly, otherwise NO (if there was a problem setting the license).
 */
+ (BOOL)setLicenseBuffer:(const unsigned char *)licenseBuffer length:(NSUInteger)length developerKey:(NSString *)developerKey error:(NSError **)error;

/**
 @brief Sets the runtime license for LEADTOOLS and unlocks support for optional features such as LEADTOOLS Imaging Pro, Document and Medical capabilities, or PDF Support.
 @discussion This method uses a NSData object containing the runtime license.
 
 @param licenseData The path to the runtime license file. Raises a NSInvalidArgumentException if licenseData is nil.
 @param developerKey The developer key that corresponds to the LEADTOOLS runtime license.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if the runtime license was set correctly, otherwise NO (if there was a problem setting the license).
 */
+ (BOOL)setLicenseData:(NSData *)licenseData developerKey:(NSString *)developerKey error:(NSError **)error;

/** 
 @brief Clears any LEADTOOLS runtime licenses that were previously set
 
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES is the runtime licenses were cleared, otherwise NO.
 */
+ (BOOL)resetLicense:(NSError **)error;

/** 
 @brief Indicates whether support is locked for an options feature, such as LEADTOOLS Document/Medical capabilities.
 
 @param support The type of support
 
 @returns NO is the support type is unlocked and available for use, otherwise YES
 */
+ (BOOL)isLocked:(LTRasterSupportType)support;

/** 
 @brief Checks whether the LEADTOOLS kernel has expired.
 
 @returns YES if the LEADTOOLS kernel has expired, otherwise NO.
 */
+ (BOOL)kernelExpired;

/** 
 @brief Gets the type of the LEADTOOLS kernel.
 
 @discussion There are 2 types of LEADTOOLS kernels, as described below:
 
 @a Release This is the Release kernel.

 @a Evaluation This is the Evaluation kernel, which has all features unlocked, but displays an "eval" message during execution. This kernel will also expire
 
 @returns The LEADTOOLS kernel type.
 */
+ (LTRasterKernelType)kernelType;



- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
