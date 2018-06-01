//
//  LTLeadFileStream.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTLeadStream.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @brief The LTLeadFileStream class provides an implementation of the LTLeadStream class that operates on a disk file.
 */
@interface LTLeadFileStream : LTLeadStream

/** The name of the file associated with this LTLeadFileStream. */
@property (nonatomic, strong, readonly) NSString *fileName;

/**
 @brief Initializes this LTLeadStream instance using the specified file as storage.
 
 @param fileName The path to a file that will be used as storage.
 
 @returns The initialized LTLeadFileStream instance.
 */
- (instancetype)initWithFileName:(NSString *)fileName NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END