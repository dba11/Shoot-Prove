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

#import "AbstractSubTaskCapture.h"
#import "Task.h"
#import "CaptureImage.h"

@implementation AbstractSubTaskCapture
- (NSArray *)images {
	if([self.abstractService isKindOfClass:[Task class]]) {
		Task *task = (Task *) self.abstractService;
		NSMutableArray *images = [[NSMutableArray alloc] init];
		for(CaptureImage *image in task.images) {
			if([image.uuid isEqualToString:self.uuid]) {
				[images addObject:image];
			}
		}
		NSArray *sortedImages = [[NSArray alloc] initWithArray:[images sortedArrayUsingComparator:^(CaptureImage *image1, CaptureImage *image2) {
			return (NSComparisonResult)[image1.order compare:image2.order];
		}]];
		return sortedImages;
	}
	return nil;
}

- (CaptureImage *)imageAtIndex:(NSInteger)index {
	NSArray *images = self.images;
	if(index < [images count]) {
		return [images objectAtIndex:index];
	} else {
		return nil;
	}
}

- (NSInteger)nextOrder {
	NSInteger order = 0;
	NSArray *images = self.images;
	if(images.count > 0) {
		CaptureImage *lastImage = [images objectAtIndex:images.count - 1];
		order = [lastImage.order integerValue] + 1;
	}
	return order;
}

- (BOOL)isComplete {
    return self.images.count >= [self.minItems intValue];
}
@end
