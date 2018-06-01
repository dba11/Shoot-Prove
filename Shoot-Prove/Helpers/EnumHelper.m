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

#import "EnumHelper.h"

@implementation EnumHelper
+ (CGSize)sizeFromSPsize:(SPSize)size {
	switch (size) {
		case SPsize2400x1800:
			return CGSizeMake(2400, 1800);
			break;
		case SPsize1800x1200:
			return CGSizeMake(1800, 1200);
			break;
		default:
			return CGSizeMake(1200, 900);
			break;
	}
}

+ (SPSize)sizeFromDescription:(NSString *)description {
	if([description isEqualToString:@"2400x1800"]) {
		return SPsize2400x1800;
	} else if ([description isEqualToString:@"1800x1200"]) {
		return SPsize1800x1200;
	} else {
		return SPsize1200x900;
	}
}

+ (NSString *)descriptionFromSize:(SPSize)size {
	switch (size) {
		case SPsize2400x1800:
			return @"2400x1800";
			break;
		case SPsize1800x1200:
			return @"1800x1200";
			break;
		default:
			return @"1200x900";
			break;
	}
}

+ (SPIdentType)identTypeFromDescription:(NSString *)description {
	if([description isEqualToString:@"facebook"]) {
		return SPIdentTypeFacebook;
	} else if ([description isEqualToString:@"google"]) {
		return SPIdentTypeGoogle;
	} else if ([description isEqualToString:@"phone"]) {
		return SPIdentTypePhone;
	} else if ([description isEqualToString:@"email"]) {
		return SPIdentTypeEmail;
	} else {
		return SPIdentTypeEmail;
	}
}

+ (NSString *)descriptionFromIdentType:(SPIdentType)type {
	switch (type) {
		case SPIdentTypeEmail:
			return @"email";
			break;
		case SPIdentTypeGoogle:
			return @"google";
			break;
		case SPIdentTypeFacebook:
			return @"facebook";
			break;
		case SPIdentTypePhone:
			return @"phone";
			break;
		default:
			return @"email";
			break;
	}
}

+ (NSString *)descriptionFromIndexType:(SPIndexType)type {
	switch (type) {
		case SPIndexTypeDate:
			return @"date";
			break;
		case SPIndexTypeList:
			return @"list";
			break;
		case SPIndexTypeMultiText:
			return @"multiText";
			break;
		case SPIndexTypeNumber:
			return @"number";
			break;
		default:
			return @"singleText";
			break;
	}
}

+ (SPIndexType)indexTypeFromDescription:(NSString *)description {
	if([description isEqualToString:@"date"]) {
		return SPIndexTypeDate;
	} else if ([description isEqualToString:@"list"]) {
		return SPIndexTypeList;
	} else if ([description isEqualToString:@"multiText"] || [description isEqualToString:@"multipleText"]) {
		return SPIndexTypeMultiText;
	} else if ([description isEqualToString:@"number"]) {
		return SPIndexTypeNumber;
	} else {
		return SPIndexTypeSingleText;
	}
}

+ (NSString *)descriptionFromFormat:(SPFormat)format {
	switch (format) {
		case SPFormatID1:
			return @"ID1";
			break;
		case SPFormatA5:
			return @"A5";
            break;
        case SPFormatA4:
            return @"A4";
            break;
		default:
			return @"any";
			break;
	}
}

+ (SPFormat)formatFromDescription:(NSString *)description {
	if([description isEqualToString:@"credit card"] || [description isEqualToString:@"ID1"]) {
		return SPFormatID1;
	} else if([description isEqualToString:@"A5"]) {
		return SPFormatA5;
    } else if([description isEqualToString:@"A4"]) {
		return SPFormatA4;
    } else {
        return SPFormatAny;
    }
}

+ (int)valueFromResolution:(SPResolution)resolution {
	switch (resolution) {
		case SPResolution200:
			//200 dpi
			return 200;
			break;
		case SPResolution300:
			//300 dpi
			return 300;
			break;
		default:
			//150 dpi;
			return 150;
			break;
	}
}

+ (SPResolution)resolutionFromValue:(int)value {
	switch (value) {
		case 200:
			//200 dpi
			return SPResolution200;
			break;
		case 300:
			//300 dpi
			return SPResolution300;
			break;
		default:
			//150 dpi;
			return SPResolution150;
			break;
	}
}

+ (SPSubTaskType)subTaskTypeFromDescription:(NSString *)description {
	if([description isEqualToString:@"form"]) {
		return SPSubTaskTypeForm;
	} else if([description isEqualToString:@"scan"]) {
		return SPSubTaskTypeScan;
	} else {
		return SPSubTaskTypePicture;
	}
}

+ (NSString *)descriptionFromSubTaskType:(SPSubTaskType)type {
	switch (type) {
		case SPSubTaskTypeForm:
			return @"form";
			break;
		case SPSubTaskTypeScan:
			return @"scan";
			break;
		default:
			return @"picture";
			break;
	}
}

+ (SPColorMode)colorModeFromDescription:(NSString *)description {
	if([description isEqualToString:@"grey"]) {
		return SPColorModeGrey;
	} else if([description isEqualToString:@"color"]) {
		return SPColorModeColor;
	} else {
		return SPColorModeBlackAndWhite;
	}
}

+ (NSString *)descriptionFromColorMode:(SPColorMode)colorMode {
	switch (colorMode) {
		case SPColorModeColor:
			return @"color";
			break;
		case SPColorModeGrey:
			return @"grey";
		default:
			return @"b&w";
			break;
	}
}

+ (SPSubscription)subscriptionFromType:(NSString *)type {
    if([type isEqualToString:@"PREMIUM"]) {
        return SPSubscriptionPremium;
    } else if([type isEqualToString:@"PROFESSIONAL"] || [type isEqualToString:@"PRO"]) {
        return SPSubscriptionPro;
    } else if([type isEqualToString:@"ENTERPRISE"] || [type isEqualToString:@"ENTREPRISE"]) {
        return SPSubscriptionEnterprise;
    } else {
        return SPSubscriptionFree;
    }
}
@end
