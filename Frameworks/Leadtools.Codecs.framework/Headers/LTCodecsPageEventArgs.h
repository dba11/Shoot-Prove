//
//  LTCodecsPageEventArgs.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTCodecsPageEventCommand) {
    LTCodecsPageEventCommandContinue,
    LTCodecsPageEventCommandSkip,
    LTCodecsPageEventCommandStop
};

typedef NS_ENUM(NSInteger, LTCodecsPageEventState) {
    LTCodecsPageEventStateBefore,
    LTCodecsPageEventStateAfter
};

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsPageEventArgs : NSObject

@property (nonatomic, assign, readonly)           NSUInteger page;
@property (nonatomic, assign, readonly)           NSUInteger pageCount;

@property (nonatomic, strong, readonly, nullable) LTRasterImage *image;
@property (nonatomic, strong, readonly, nullable) LTLeadStream *stream;

@property (nonatomic, assign, readonly)           LTCodecsPageEventState state;
@property (nonatomic, assign)                     LTCodecsPageEventCommand command;

@end

NS_ASSUME_NONNULL_END