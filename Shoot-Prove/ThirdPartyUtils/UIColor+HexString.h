//
//  UIColor+HexString.h
//  soHunt
//
//  Created by Wallerand Réquillart on 06/07/2014.
//  Copyright (c) 2014 Wallerand Réquillart. All rights reserved.
//

@interface UIColor (ColorWithHex)

+(UIColor*)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha;
+(UIColor*)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha;

@end

@implementation UIColor (ColorWithHex)

+(UIColor*)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha {
    return [UIColor
			colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
			green:((float)((hexValue & 0xFF00) >> 8))/255.0
			blue:((float)(hexValue & 0xFF))/255.0
			alpha:alpha];
}

+(UIColor*)colorWithHexString:(NSString*)hexString andAlpha:(float)alpha {
    UIColor *col;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
													 withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [self colorWithHexValue:hexValue andAlpha:alpha];
    } else {
        // invalid hex string
        col = [self blackColor];
    }
    return col;
}

@end