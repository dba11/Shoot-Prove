//
//  LTAnnGroupsRolesSubClassing.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnGroupsRoles.h"

@interface LTAnnGroupsRoles(SubClassing)

- (NSString *)onGenerateRole:(LTAnnOperationInfoEventArgs *)info;

@end