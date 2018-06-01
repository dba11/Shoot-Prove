//
//  LTOcrMicrData.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrMicrData : NSObject <NSCopying>

@property (nonatomic, copy, nullable) NSString *auxiliary;
@property (nonatomic, copy, nullable) NSString *routing;
@property (nonatomic, copy, nullable) NSString *account;
@property (nonatomic, copy, nullable) NSString *checkNumber;
@property (nonatomic, copy, nullable) NSString *amount;

@property (nonatomic, assign)         wchar_t epc;

@end

NS_ASSUME_NONNULL_END