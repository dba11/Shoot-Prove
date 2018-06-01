//
//  LTApplyModalityLookupTableCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"
#import "LTDicomLookupTableDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTApplyModalityLookupTableCommand : LTRasterCommand

@property (nonatomic, strong)           LTDicomLookupTableDescriptor *lookupTableDescriptor;
@property (nonatomic, assign, nullable) const unsigned short *lookupTable;
@property (nonatomic, assign)           NSUInteger lookupTableLength;
@property (nonatomic, assign)           LTModalityLookupTableCommandFlags flags;

- (instancetype)initWithLookupTableDescriptor:(LTDicomLookupTableDescriptor *)lookupTableDescriptor lookupTable:(const unsigned short *)lookupTable lookupTableLength:(NSUInteger)lookupTableLength flags:(LTModalityLookupTableCommandFlags)flags NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END