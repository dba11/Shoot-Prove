//
//  LTMICRCodeDetectionCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTMICRCodeDetectionCommand : LTRasterCommand

@property (nonatomic, assign)           LeadRect searchingZone;
@property (nonatomic, assign, readonly) LeadRect micrZone;

- (instancetype)initWithSearchingZone:(LeadRect)searchingZone NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END