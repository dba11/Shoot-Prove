//
//  LTRasterBufferResize.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

/**
 @brief Provides support for resizing image data buffers.
 */
@interface LTRasterBufferResize : NSObject

/** @brief Holds the resulting line width of the resized image data. */
@property (nonatomic, assign, readonly) NSInteger lineWidth;

/** @brief Holds the required number of copy repetitions. */
@property (nonatomic, assign, readonly) NSInteger copyRepetitions;

/**
 @brief Sets up information for the @p resizeBuffer:row:bitsPerPixel:error: method.
 
 @param oldWidth Specifies the original width of the image.
 @param oldHeight Specifies the original height of the image.
 @param newWidth Specifies the new width for the image.
 @param newHeight Specifies the new height for the image.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if it started succcessfull, otherwise NO.
 */
- (BOOL)start:(NSInteger)oldWidth oldHeight:(NSInteger)oldHeight newWidth:(NSInteger)newWidth newHeight:(NSInteger)newHeight error:(NSError **)error;

/**
 @brief Resizes a buffer to the new size specified with the @p start:oldHeight:newWidth:newHeight:error: method.
 
 @param buffer A NSData object contain the original scanline to be resized.
 @param row Current row of the original bitmap.
 @param bitsPerPixel Bits per pixel, which is the same for the original and the resized bitmap.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @discussion @p buffer contains a line from the original image to be resized. Your code must allocate the buffer and copy the data into it before calling this method. The same buffer holds the data before and after it is resized. Therefore, the buffer must be big enough to hold whichever is larger.
 
 Before calling this method, you must call the @p start:oldHeight:newWidth:newHeight:error: method.
 
 @returns YES if the buffer was resized successfully, otherwise NO.
 */
- (BOOL)resizeBuffer:(NSData *)buffer row:(NSInteger)row bitsPerPixel:(NSInteger)bitsPerPixel error:(NSError **)error;

/**
 @brief Cleans up all data variables and buffers allocated by the @p start:oldHeight:newWidth:newHeight:error: method.
 
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in nil.
 
 @returns YES if it stopped successfully, otherwise NO.
 */
- (BOOL)stop:(NSError **)error;

@end