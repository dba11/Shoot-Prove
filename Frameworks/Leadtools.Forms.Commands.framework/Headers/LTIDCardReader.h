//
//  LTIDCardReader.h
//  Leadtools.Forms.Commands
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTIDCardRegion)
{
    LTIDCardRegionUSA = 0,
    LTIDCardRegionEU = 1
};


/********************************************************************************
 *                                                                              *
 * LTFieldResult Interface                                                      *
 *                                                                              *
 ********************************************************************************/

@interface LTFieldResult : NSObject<NSCopying, NSCoding>

- (instancetype)initWithText:(NSString *)text confidence:(NSInteger)confidence;
- (instancetype)init;

@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, assign) NSInteger confidence;

@end


/********************************************************************************
 *                                                                              *
 * LTIDCardResults Interface                                                    *
 *                                                                              *
 ********************************************************************************/

@interface LTIDCardResults : NSObject

@property (nonatomic, copy) LTFieldResult *birthDate;
@property (nonatomic, copy) LTFieldResult *issueDate;
@property (nonatomic, copy) LTFieldResult *expireDate;
@property (nonatomic, copy) LTFieldResult *idNumber;
@property (nonatomic, copy) LTFieldResult *country;

@end


/********************************************************************************
 *                                                                              *
 * LTIDCardReader Interface                                                     *
 *                                                                              *
 ********************************************************************************/

@interface LTIDCardReader : NSObject

- (instancetype)initWithOcrEngine:(LTOcrEngine *)ocrEngine;
- (instancetype)init __unavailable;

- (BOOL)processFrame:(LTRasterImage *)image;
- (void)reset;

#if defined (DEBUG)
@property (nonatomic, strong, readonly) LTRasterImage *processedImage;
@property (nonatomic, strong, readonly) LTRasterImage *processedZonedImage;
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> *outText;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> *timing;
#endif // #if defined (DEBUG)

@property (nonatomic, strong          ) LTOcrEngine *ocrEngine;
@property (nonatomic, assign          ) LTIDCardRegion region;
@property (nonatomic, strong, readonly) LTIDCardResults *results;

@end