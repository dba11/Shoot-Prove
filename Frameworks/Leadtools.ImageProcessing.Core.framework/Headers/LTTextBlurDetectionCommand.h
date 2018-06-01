//
//  LTTextBlurDetectionCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTTextBlurDetectionCommand : LTRasterCommand

@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *inFocusBlocks; //LeadRect
@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *outOfFocusBlocks; //LeadRect
@property (nonatomic, assign, readonly) LeadRect combinedTextBlocks;

@end
