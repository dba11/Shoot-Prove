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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MenuItem : NSObject
@property (nonatomic) NSInteger section;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSFetchedResultsController* resultController;
@property (strong, nonatomic) UIImage* image;
@property (nonatomic) NSInteger treeLevel;

- (id)initWithName:(NSString *)name image:(UIImage *)image resultController:(NSFetchedResultsController *)resultsController section:(NSInteger)section treeLevel:(NSInteger)treeLevel;
@end
