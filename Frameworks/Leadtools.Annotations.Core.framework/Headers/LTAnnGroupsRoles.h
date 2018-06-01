//
//  LTAnnGroupsRoles.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnGroupsRoles.h"
#import "LTAnnObservableCollection.h"

@class LTAnnGroupsRoles;

typedef NS_ENUM(NSInteger, LTAnnOperationType) {
   LTAnnOperationTypeCreateObjects    = 0,
   LTAnnOperationTypeDeleteObject     = 1,
   LTAnnOperationTypeEditObjects      = 2,
   LTAnnOperationTypeLockObjects      = 3,
   LTAnnOperationTypeUnlockObjects    = 4,
   LTAnnOperationTypeRealizeRedact    = 5,
   LTAnnOperationTypeRestoreRedact    = 6,
   LTAnnOperationTypeSave             = 7,
   LTAnnOperationTypeLoad             = 8,
   LTAnnOperationTypeBurnObjecs       = 9,
   LTAnnOperationTypeCopyObjects      = 10,
   LTAnnOperationTypePasteObjects     = 11,
   LTAnnOperationTypeEncryptObjects   = 12,
   LTAnnOperationTypeDecryptObjects   = 13,
   LTAnnOperationTypeRenderingObjects = 14,
   LTAnnOperationTypeHitTestObjects   = 15,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnOperationInfoEventArgs : NSObject

@property (nonatomic, assign)                     BOOL ignoreUserCheck;

@property (nonatomic, assign, readonly)           LTAnnOperationType type;
@property (nonatomic, copy, nullable)             NSString *role;

@property (nonatomic, strong, readonly, nullable) LTAnnObject *annObject;

- (instancetype)initWithOperation:(LTAnnOperationType)type object:(nullable LTAnnObject *)annObject;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnRoles : LTAnnObservableCollection

+ (NSString *)view;
+ (NSString *)edit;
+ (NSString *)viewAll;
+ (NSString *)editAll;
+ (NSString *)fullControl;

- (void)addRoleObject:(NSString *)obj;

- (NSString *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(NSString *)object atIndexedSubscript:(NSUInteger)index;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@protocol LTAnnGroupsRolesDelegate<NSObject>

- (void)annGroupsRole:(LTAnnGroupsRoles *)engine args:(LTAnnOperationInfoEventArgs *)args;

@end

@interface LTAnnGroupsRoles : NSObject

@property (nonatomic, weak, nullable) id<LTAnnGroupsRolesDelegate> delegate;

@property (nonatomic, strong)         NSDictionary<NSString *, NSArray<NSString *> *> *groupUsers;
@property (nonatomic, strong)         NSDictionary<NSString *, LTAnnRoles *> *groupRoles;

@property (nonatomic, copy, nullable) NSString *currentUser;
@property (nonatomic, assign)         BOOL useDefaultRole;
@property (nonatomic, strong)         LTAnnRoles *role;

- (NSArray<NSString *> *)getUserGroup:(NSString *)userName;
- (nullable LTAnnRoles *)getUserRoles:(NSString *)userName;

- (BOOL)isCurrentUserInRole:(LTAnnOperationInfoEventArgs *)info;
- (BOOL)isUser:(NSString *)userName inRole:(LTAnnOperationInfoEventArgs *)info;

@end

NS_ASSUME_NONNULL_END