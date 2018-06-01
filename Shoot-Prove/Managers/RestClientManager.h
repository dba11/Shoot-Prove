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

@class User;
@class Ident;
@class Device;
@class Eula;
@class Service;
@class Task;
@class AbstractSubTask;
@class CaptureImage;
@class DeleteImageReference;
@class Rendition;
@class UnCheckedTransaction;

@interface RestClientManager : NSObject

#pragma - public instance
+ (instancetype)sharedManager;

#pragma - public methods
- (void)useProductionServer;
- (void)useBetaServer;
- (void)setDevServerUrl:(NSString *)url;
- (NSURL *)serverUrl;

#pragma - generic methods
- (void)dataWithUrl:(NSString *)url block:(void(^)(NSData *data, NSString *contentType, NSInteger statusCode, NSError *error)) block;

#pragma authentication methods
- (void)authDevice:(Device *)device andReturnUser:(void(^)(User *user, NSInteger statusCode, NSError *error))block;
- (void)authEmail:(NSString *)email password:(NSString *)password requestRegister:(BOOL)requestRegister block:(void(^)(NSInteger statusCode, NSError *error)) block;
- (void)forgottenPasswordForEmail:(NSString *)email block:(void(^)(NSInteger statusCode, NSError *error)) block;
- (void)authPhone:(NSString *)number block:(void(^)(NSInteger statusCode, NSError *error)) block;
- (void)verifyPhone:(NSString *)number code:(NSString *)code block:(void(^)(User *user, NSInteger statusCode, NSError *error)) block;

#pragma - user management methods
- (void)getMe:(void (^)(User *user, NSInteger statusCode, NSError *error)) block;
- (void)getUser:(NSString *)uuid block:(void (^)(User *user, NSInteger statusCode, NSError *error)) block;
- (void)putUser:(User *)user block:(void(^)(NSInteger statusCode, NSError *error)) block;
- (void)deleteUser:(User *)user block:(void(^)(NSInteger statusCode, NSError *error)) block;

#pragma - InApp purchase management methods
- (void)postTransaction:(UnCheckedTransaction *)transaction onStore:(NSString *)store block:(void (^)(User *user, NSInteger statusCode, NSError *error)) block;

#pragma - device management methods
- (void)getDevice:(NSString *)uuid block:(void (^)(Device *device, NSInteger statusCode, NSError *error)) block;
- (void)postDevice:(Device *)device block:(void (^)(Device *device, NSInteger statusCode, NSError *error)) block;
- (void)putDevice:(Device *)device block:(void (^)(Device *device, NSInteger statusCode, NSError *error)) block;
- (void)deleteDevice:(Device *)device block:(void (^)(NSInteger statusCode, NSError *error)) block;

#pragma - ident management methods
- (void)deleteIdent:(Ident *)ident block:(void (^)(NSInteger statusCode, NSError *error)) block;

#pragma - eula management methods
- (void)getEula:(void(^)(Eula *eula, NSInteger statusCode, NSError *error)) block;

#pragma - task management methods
- (void)getNewTask:(NSString *)uuid block:(void (^)(Task *task, NSInteger statusCode, NSError *error)) block;
- (void)getUpdatedTask:(Task *)task block:(void (^)(Task *task, NSInteger statusCode, NSError *error)) block;
- (void)postTask:(Task *)task block:(void(^)(NSInteger statusCode, NSError *error)) block;
- (void)putTask:(Task *)task block:(void (^)(NSInteger statusCode, NSError *error)) block;
- (void)deleteTask:(Task *)task block:(void (^)(NSInteger statusCode, NSError *error)) block;

#pragma - task image management
- (void)postImage:(CaptureImage *)image block:(void (^)(NSInteger statusCode, NSError *error)) block;
- (void)getTaskImage:(Task *)task index:(int)index block:(void (^)(CaptureImage *image, NSInteger statusCode, NSError *error)) block;
- (void)putImage:(CaptureImage *)image block:(void (^)(NSInteger statusCode, NSError *error)) block;

#pragma - template management methods
- (void)getNewService:(NSString *)uuid block:(void (^)(Service *service, NSInteger statusCode, NSError *error)) block;
- (void)getServiceLastUpdate:(NSString *)uuid block:(void (^)(NSDate *lastUpdate, NSInteger statusCode, NSError *error)) block;
- (void)getUpdatedService:(Service *)service block:(void (^)(Service *service, NSInteger statusCode, NSError *error)) block;
- (void)postQRCode:(NSDictionary *)qrCodeDictionary block:(void (^)(NSDictionary *dictionary, NSInteger statusCode, NSError *error)) block;
- (void)unregisterService:(Service *)service block:(void (^)(NSInteger statusCode, NSError *error)) block;

@end
