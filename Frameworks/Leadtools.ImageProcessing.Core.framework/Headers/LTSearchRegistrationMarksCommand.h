//
//  LTSearchRegistrationMarksCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSearchRegistrationMarksCommandData : NSObject

@property (nonatomic, assign)           LTRegistrationMarkCommandType type;

@property (nonatomic, assign)           NSUInteger width;
@property (nonatomic, assign)           NSUInteger height;
@property (nonatomic, assign)           NSUInteger minimumScale;
@property (nonatomic, assign)           NSUInteger maximumScale;
@property (nonatomic, assign)           NSUInteger searchMarkCount;
@property (nonatomic, assign)           NSUInteger markDetectedCount;

@property (nonatomic, assign)                     LeadRect rectangle;
@property (nonatomic, copy, nullable)             NSArray<NSValue *> *data; //LeadPoint
@property (nonatomic, strong)                     NSMutableArray<NSValue *> *markDetectedPoints; //LeadPoint
@property (nonatomic, assign, readonly)           NSUInteger dataSize;
@property (nonatomic, assign, readonly, nullable) void *dataPointer;

- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height minimumScale:(NSUInteger)minimumScale maximumScale:(NSUInteger)maximumScale rectangle:(LeadRect)rectangle searchMarkCount:(NSUInteger)searchMarkCount markDetectedPoints:(NSArray<NSValue *> *)markDetectedPoints type:(LTRegistrationMarkCommandType)type NS_DESIGNATED_INITIALIZER;

- (void)setDataPointer:(void *)data size:(NSUInteger)size;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTSearchRegistrationMarksCommand : LTRasterCommand

@property (nonatomic, strong) NSMutableArray<LTSearchRegistrationMarksCommandData *> *searchMarks;

- (instancetype)initWithSearchMarks:(NSArray<LTSearchRegistrationMarksCommandData *> *)searchMarks NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END