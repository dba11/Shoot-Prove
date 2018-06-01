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

#import "MenuItem.h"

@implementation MenuItem
@synthesize section, name, image, resultController, treeLevel;

- (id)initWithName:(NSString *)itemName image:(UIImage *)itemImage resultController:(NSFetchedResultsController *)itemResultsController section:(NSInteger)itemSection treeLevel:(NSInteger)itemTreeLevel {
	
	self = [super init];
	
	if(self) {
		
		self.name = itemName;
		self.image = itemImage;
		self.resultController = itemResultsController;
        self.section = itemSection;
        self.treeLevel = itemTreeLevel;
		
	}
	
	return self;
	
}
@end
