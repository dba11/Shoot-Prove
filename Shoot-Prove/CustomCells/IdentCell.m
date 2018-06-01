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

#import "IdentCell.h"
#import "ImageHelper.h"
#import "UIColor+HexString.h"
#import "Ident.h"

@interface IdentCell()
{
    Ident *_ident;
}
@property (weak, nonatomic) IBOutlet UIView *identImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblIdentity;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@end

@implementation IdentCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.lblIdentity setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    [self.lblIdentity setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
    [self.lblType setFont:[UIFont fontWithName:boldFontName size:smallFontSize]];
    [self.lblType setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    for(UIView *view in self.identImageView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)displayImage {
    NSString *imageName = [NSString stringWithFormat:@"%@_50", [_ident.type lowercaseString]];
    if([_ident.type containsString:@"google"] || [_ident.type containsString:@"facebook"]) {
        [ImageHelper displayImageData:_ident.icon_data url:_ident.icon_url mime:mimeJPG name:imageName inView:self.identImageView waitColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f] block:^(NSData *data, NSString *mime) {
            if(_ident.icon_data.hash != data.hash)
                _ident.icon_data = data;
        }];
    } else {
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [ImageHelper displayImage:image duration:0.8 inView:self.identImageView tintColor:[UIColor colorWithHexString:colorBlue andAlpha:1.0f]];
    }
}

- (void)displayIdentity {
    self.lblType.text = [NSString stringWithFormat:@"%@%@", [[_ident.type substringToIndex:1] uppercaseString], [[_ident.type substringFromIndex:1] lowercaseString]];
    if(_ident.email.length > 0) {
        self.lblIdentity.text = _ident.email;
    } else {
        
        NSArray *identityParts = [_ident.uuid componentsSeparatedByString:@"_"];
        self.lblIdentity.text = identityParts.firstObject;
    }
}

- (void)setIdent:(Ident *)ident {
    _ident = ident;
    [self displayImage];
    [self displayIdentity];
}
@end
