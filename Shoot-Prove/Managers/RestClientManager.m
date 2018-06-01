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

#import "RestClientManager.h"
#import "NSData+Hash.h"
#import "NSString+MD5.h"
#import "StoreManager.h"
#import "SettingsManager.h"
#import "TaskHelper.h"
#import "RestClientHelper.h"
#import "DateTimeHelper.h"
#import "EnumHelper.h"
#import "User.h"
#import "Device.h"
#import "Ident.h"
#import "Eula.h"
#import "Task.h"
#import "Service.h"
#import "AbstractSubTask.h"
#import "CaptureImage.h"
#import "SubTaskPicture.h"
#import "SubTaskScan.h"
#import "Rendition.h"
#import "DeleteImageReference.h"
#import "UnCheckedTransaction.h"

@interface RestClientManager()
@property (nonatomic, strong) NSURL *baseURL;
@end

@implementation RestClientManager

+ (instancetype)sharedManager {
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[RestClientManager alloc] init];
	});
	return manager;
}

- (id)init {
	
	self = [super init];
	
	if(self) {
		
        RKLogConfigureByName("*", RKLogLevelDebug);
		//RKLogConfigureByName("RestKit", RKLogLevelInfo);
		//RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
		//RKLogConfigureByName("RestKit/Network", RKLogLevelInfo);
		
		if([[SettingsManager sharedManager] devMode]) {
			[self setDevServerUrl:[[SettingsManager sharedManager] devUrl]];
		} else if([[SettingsManager sharedManager] betaMode]) {
			[self useBetaServer];
		} else {
			[self useProductionServer];
		}
		
        //add value transformer to handle subscription expiration date provided in milliseconds
        RKValueTransformer* transformer = [RestClientHelper millisecondsSince1970ToDateValueTransformer];
        [RKValueTransformer.defaultValueTransformer insertValueTransformer:transformer atIndex:0];
        
	}
	
	return self;
}

- (void)useProductionServer {
	self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", Khttp, Kdomain]];
	NSLog(@"RestClientManager.useProdServer: %@", self.baseURL);
}

- (void)useBetaServer {
	self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", Khttp, KdomainBeta]];
	NSLog(@"RestClientManager.useBetaServer: %@", self.baseURL);
}

- (void)setDevServerUrl:(NSString *)url {
	self.baseURL = [NSURL URLWithString:url];
    NSLog(@"RestClientManager.useDevServer: %@", self.baseURL);
}

- (NSURL *)serverUrl {
	return self.baseURL;
}

- (RKObjectManager *)getJsonObjectManager {
	RKObjectManager *manager = [RKObjectManager managerWithBaseURL:self.baseURL];
	[manager setManagedObjectStore:StoreManager.sharedManager.objectStore];
	[manager setRequestSerializationMIMEType:RKMIMETypeJSON];
	[manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    
	[[manager operationQueue] setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
	return manager;
}

- (RKObjectManager *)getFormObjectManager {
	RKObjectManager *manager = [RKObjectManager managerWithBaseURL:self.baseURL];
	[manager setManagedObjectStore:StoreManager.sharedManager.objectStore];
	[manager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];
	[manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
	[[manager operationQueue] setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
	return manager;
}

#pragma - generic get (json)
- (void)getParams:(NSDictionary *)params path:(NSString *)path block:(void(^)(NSDictionary *dictionary, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodGET
									path:path
									parameters:params];
	[request setTimeoutInterval:KrestTimeout];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
	 
		NSInteger statusCode = operation.response.statusCode;
		
		if(statusCode == 200 && operation.responseData) {
			
			NSError *error;
			NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:&error];
			
            if(error) {
                block(nil, statusCode, error);
            } else {
                block(dictionary, statusCode, error);
            }
            
		} else {
			
			block(nil, statusCode, nil);
			
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.response.statusCode;
		block(nil, statusCode, error);
		
	}];
	
	[operation start];
	
}

#pragma - generic post (json)
- (void)postParams:(NSDictionary *)params path:(NSString *)path block:(void(^)(NSDictionary *dictionary, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodPOST
									path:path
									parameters:params];
	[request setTimeoutInterval:KrestTimeout];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
	 
		NSInteger statusCode = operation.response.statusCode;
		
		if(statusCode == 200 && operation.responseData) {
			
			NSError *error;
			NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:&error];
			
            if(error) {
                block(nil, statusCode, error);
            } else {
                block(dictionary, statusCode, error);
            }
			
		} else {
			
			block(nil, statusCode, nil);
			
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.response.statusCode;
		block(nil, statusCode, error);
		
	}];
	
	[operation start];
	
}

#pragma - generic put (json)
- (void)putParams:(NSDictionary *)params path:(NSString *)path block:(void(^)(NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodPUT
									path:path
									parameters:params];
	[request setTimeoutInterval:KrestTimeout];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
	 
		NSInteger statusCode = operation.response.statusCode;
        block(statusCode, nil);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.response.statusCode;
		block(statusCode, error);
		
	}];
	
	[operation start];
	
}

#pragma - generic get (data)
- (void)dataWithUrl:(NSString *)url block:(void(^)(NSData *data, NSString *contentType, NSInteger statusCode, NSError *error)) block {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:KrestTimeout];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger statusCode = operation.response.statusCode;
        NSString *mimeType;
        
        if ([operation.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
            NSDictionary *headerFields = response.allHeaderFields;
            mimeType = [headerFields objectForKey:@"Content-Type"];
        }
        
        if(operation.responseData) {
            block(operation.responseData, mimeType, statusCode, nil);
        } else {
            block(nil, nil, statusCode, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSInteger statusCode = operation.response.statusCode;
        block(nil, nil, statusCode, error);
        
    }];
    
    [operation start];
    
}

- (void)getDataWithParams:(NSDictionary *)params path:(NSString *)path block:(void(^)(NSData *data, NSString *contentType, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodGET
									path:path
									parameters:params];
	[request setTimeoutInterval:KrestTimeout];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
	 
		NSInteger statusCode = operation.response.statusCode;
        NSString *mimeType;
		
        if ([operation.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
            NSDictionary *headerFields = response.allHeaderFields;
            mimeType = [headerFields objectForKey:@"Content-Type"];
        }
        
        if(operation.responseData) {
            block(operation.responseData, mimeType, statusCode, nil);
        } else {
            block(nil, nil, statusCode, nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.response.statusCode;
		block(nil, nil, statusCode, error);
		
	}];
	
	[operation start];
	
}

#pragma - generic get (json)
- (void)getJsonWithParams:(NSDictionary *)params path:(NSString *)path block:(void(^)(NSDictionary *dictionary, NSInteger statusCode, NSError *error)) block {
	
	[self getDataWithParams:params path:path block:^(NSData *data, NSString* contentType, NSInteger statusCode, NSError *error) {
		
		if(data) {
			
			NSError *error;
			NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
			
            if(error) {
                block(nil, statusCode, error);
            } else {
                block(dictionary, statusCode, error);
            }
            
		} else {
			
			block(nil, statusCode, error);
			
		}
		
	}];
	
}

#pragma - generic delete (json)
- (void)deletePath:(NSString *)path block:(void(^)(NSInteger statusCode, NSError *error)) block {
	
	NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:self.baseURL]];
	[deleteRequest setTimeoutInterval:KrestTimeout];
	[deleteRequest setHTTPMethod:@"DELETE"];
	[deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[deleteRequest setHTTPBody:nil];
	
	AFHTTPRequestOperation *deleteOp = [[AFHTTPRequestOperation alloc] initWithRequest:deleteRequest];
	
	[deleteOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSInteger statusCode = operation.response.statusCode;
		block(statusCode, nil);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.response.statusCode;
		block(statusCode, error);
		
	}];

	[deleteOp start];
	
}

#pragma - binary put/post generic method
- (void)putBinaryData:(NSData *)data path:(NSString *)path params:(NSDictionary *)params block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSMutableURLRequest *jsonRequest = [manager
										requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
										method:RKRequestMethodPUT
										path:path
										parameters:params];
	[jsonRequest setTimeoutInterval:KrestTimeout];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:jsonRequest];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSInteger statusCode = operation.response.statusCode;
		
		NSError *error;
		NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:&error];
		
		if(error) {
			
			block(statusCode, error);
			
		} else {
			
			NSURL *targetUrl = [NSURL URLWithString:[urlDic objectForKey:@"url"]];
			NSString *newMD5 = [urlDic objectForKey:@"md5"];
			BOOL done = [[urlDic objectForKey:@"done"] boolValue];
			
            if(!done) {
				
				NSMutableURLRequest *binRequest = [[NSMutableURLRequest alloc] initWithURL:targetUrl];
				[binRequest setTimeoutInterval:KrestTimeout];
				[binRequest setHTTPMethod:@"PUT"];
				[binRequest setValue:@"application/octet-stream" forHTTPHeaderField:@"content-type"];
				[binRequest addValue:newMD5 forHTTPHeaderField:@"Content-MD5"];
				[binRequest setHTTPBody:data];
				
				AFHTTPRequestOperation *binOp = [[AFHTTPRequestOperation alloc] initWithRequest:binRequest];
				
				[binOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
					
					NSInteger statusCode = operation.response.statusCode;
					block(statusCode, nil);
					
				} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					
					NSInteger statusCode = operation.response.statusCode;
					block(statusCode, error);
					
				}];
				
				[binOp start];
				
			} else {
			
				block(statusCode, nil);
				
			}
			
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.response.statusCode;
		block(statusCode, error);
		
	}];
	
	[operation start];
	
}

#pragma - authentication methods
- (void)authDevice:(Device *)device andReturnUser:(void(^)(User *user, NSInteger statusCode, NSError *error))block {
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:device.token forKey:@"token"];
	[params setObject:device.uuid forKey:@"device_uuid"];
	
	NSString *path = @"device/auth";
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper fullUserEntityMapping]
												method:RKRequestMethodPOST
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	[manager addResponseDescriptor:responseDescriptor];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodPOST
									path:path
									parameters:params];
	[request setTimeoutInterval:KrestTimeout];
	
	RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc]
												  initWithRequest:request
												  responseDescriptors:@[responseDescriptor]];
	
    operation.managedObjectCache = StoreManager.sharedManager.objectStore.managedObjectCache;
    operation.managedObjectContext = StoreManager.sharedManager.objectStore.mainQueueManagedObjectContext;
	
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((User *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
	[operation start];
	
}

- (void)authEmail:(NSString *)email password:(NSString *)password requestRegister:(BOOL)requestRegister block:(void(^)(NSInteger statusCode, NSError *error)) block {
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:[email lowercaseString] forKey:@"login"];
	[params setObject:password forKey:@"password"];
	[params setObject:[NSNumber numberWithBool:requestRegister] forKey:@"register"];
	
	NSString *path = @"auth/email";
	
	[self postParams:params path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		block(statusCode, error);
	}];
	
}

- (void)forgottenPasswordForEmail:(NSString *)email block:(void(^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"auth/email/%@/recover", [email lowercaseString]];
	
	[self getParams:nil path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		block(statusCode, error);
	}];
	
}

- (void)authPhone:(NSString *)number block:(void(^)(NSInteger statusCode, NSError *error)) block {
	
    DeviceProperties *props = [DeviceHelper getDeviceProperties];
    
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:number forKey:@"phone_number"];
    [params setObject:props.preferredLanguage forKey:@"locale"];
	
    //TODO: make sure Accept-Language header is properly set
    
	NSString *path = @"auth/phone";
	
	[self postParams:params path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		block(statusCode, error);
	}];
	
}

- (void)verifyPhone:(NSString *)number code:(NSString *)code block:(void(^)(User *user, NSInteger statusCode, NSError *error)) block {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:number forKey:@"phone_number"];
    [params setObject:code forKey:@"code"];
    
    RKObjectManager *manager = [self getJsonObjectManager];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:[RestClientHelper fullUserEntityMapping]
                                                method:RKRequestMethodPOST
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    [manager addResponseDescriptor:responseDescriptor];
    
    NSMutableURLRequest *request = [manager
                                    requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
                                    method:RKRequestMethodPOST
                                    path:@"auth/phone/callback"
                                    parameters:params];
    [request setTimeoutInterval:KrestTimeout];
    
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc]
                                                  initWithRequest:request
                                                  responseDescriptors:@[responseDescriptor]];
    
    operation.managedObjectCache = StoreManager.sharedManager.objectStore.managedObjectCache;
    operation.managedObjectContext = StoreManager.sharedManager.objectStore.mainQueueManagedObjectContext;
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((User *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        block(nil, statusCode, error);
        
    }];
    
    [operation start];
    
}

#pragma - user management methods

- (void)getMe:(void (^)(User *user, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper fullUserEntityMapping]
												method:RKRequestMethodGET
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	[manager addResponseDescriptor:responseDescriptor];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodGET
									path:@"me"
									parameters:nil];
	[request setTimeoutInterval:KrestTimeout];
	
	RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc]
												  initWithRequest:request
												  responseDescriptors:@[responseDescriptor]];
	
    operation.managedObjectCache = StoreManager.sharedManager.objectStore.managedObjectCache;
    operation.managedObjectContext = StoreManager.sharedManager.objectStore.mainQueueManagedObjectContext;
	
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((User *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
	[operation start];
	
}

- (void)getUser:(NSString *)uuid block:(void (^)(User *user, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper fullUserEntityMapping]
												method:RKRequestMethodGET
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	[manager addResponseDescriptor:responseDescriptor];
	
	NSString *path = [NSString stringWithFormat:@"users/%@", uuid];
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodGET
									path:path
									parameters:nil];
	[request setTimeoutInterval:KrestTimeout];
	
	RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc]
												  initWithRequest:request
												  responseDescriptors:@[responseDescriptor]];
	
    operation.managedObjectCache = StoreManager.sharedManager.objectStore.managedObjectCache;
    operation.managedObjectContext = StoreManager.sharedManager.objectStore.mainQueueManagedObjectContext;
	
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((User *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
	[operation start];
	
}

- (void)putUser:(User *)user block:(void(^)(NSInteger statusCode, NSError *error)) block {

	RKObjectManager *manager = [self getJsonObjectManager];
	
	RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor
											  requestDescriptorWithMapping:[RestClientHelper simpleUserRequestMapping]
											  objectClass:[User class]
											  rootKeyPath:nil
											  method:RKRequestMethodPUT];
	[manager addRequestDescriptor:requestDescriptor];
	
	/*NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper simpleUserEntityMapping]
												method:RKRequestMethodPUT
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	[manager addResponseDescriptor:responseDescriptor];*/
	
	NSString *path = [NSString stringWithFormat:@"users/%@", user.uuid];
	
	[manager putObject:user path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(statusCode, nil);
	 
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(statusCode, error);
	 
	}];

}

- (void)deleteUser:(User *)user block:(void(^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"users/%@", user.uuid];
	
	[self deletePath:path block:^(NSInteger statusCode, NSError *error) {
		block(statusCode, error);
	}];
	
}

#pragma - InApp purchase management methods
- (void)postTransaction:(UnCheckedTransaction *)transaction onStore:(NSString *)store block:(void (^)(User *user, NSInteger statusCode, NSError *error)) block {
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:store forKey:@"store"];
	[params setObject:transaction.identifier forKey:@"identifier"];
	[params setObject:[DateTimeHelper jsonFromDate:transaction.date] forKey:@"date"];
	NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
	NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
	if(receiptData) {
		[params setObject:[receiptData base64EncodedStringWithOptions:0] forKey:@"data"];
	}
	[params setObject:transaction.product_id forKey:@"product_id"];
	[params setObject:transaction.quantity forKey:@"quantity"];
	
	NSString *path = @"buy";
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper fullUserEntityMapping]
												method:RKRequestMethodPOST
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	[manager addResponseDescriptor:responseDescriptor];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodPOST
									path:path
									parameters:params];
	[request setTimeoutInterval:KrestTimeout];
	
	RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc]
												  initWithRequest:request
												  responseDescriptors:@[responseDescriptor]];
	
    operation.managedObjectCache = StoreManager.sharedManager.objectStore.managedObjectCache;
    operation.managedObjectContext = StoreManager.sharedManager.objectStore.mainQueueManagedObjectContext;
	
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((User *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
	[operation start];
	
}

#pragma - device management methods

- (void)getDevice:(NSString *)uuid block:(void (^)(Device *device, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper deviceEntityMapping]
												method:RKRequestMethodGET
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	
	NSString *path = [NSString stringWithFormat:@"devices/%@", uuid];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodGET
									path:path
									parameters:nil];
	[request setTimeoutInterval:KrestTimeout];
	
	RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc]
												  initWithRequest:request
												  responseDescriptors:@[responseDescriptor]];
	
    operation.managedObjectCache = StoreManager.sharedManager.objectStore.managedObjectCache;
    operation.managedObjectContext = StoreManager.sharedManager.objectStore.mainQueueManagedObjectContext;
	
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((Device *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
	[operation start];
	
}

- (void)postDevice:(Device *)device block:(void (^)(Device *device, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor
											  requestDescriptorWithMapping:[RestClientHelper deviceRequestMapping]
											  objectClass:[Device class]
											  rootKeyPath:nil
											  method:RKRequestMethodPOST];
	
	[manager addRequestDescriptor:requestDescriptor];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper deviceEntityMapping]
												method:RKRequestMethodPOST
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];

	[manager addResponseDescriptor:responseDescriptor];
	
	[manager postObject:device path:@"devices" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((Device *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
	 
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
}

- (void)putDevice:(Device *)device block:(void (^)(Device *device, NSInteger statusCode, NSError *error)) block {
	
	RKObjectManager *manager = [self getJsonObjectManager];
	
	RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor
											  requestDescriptorWithMapping:[RestClientHelper deviceRequestMapping]
											  objectClass:[Device class]
											  rootKeyPath:nil
											  method:RKRequestMethodPUT];
	
	[manager addRequestDescriptor:requestDescriptor];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper deviceEntityMapping]
												method:RKRequestMethodPUT
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	
	[manager addResponseDescriptor:responseDescriptor];
	
	NSString *path = [NSString stringWithFormat:@"devices/%@", device.uuid];
	
	[manager putObject:device path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((Device *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
	 
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
}

- (void)deleteDevice:(Device *)device block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"devices/%@", device.uuid];
	
	[self deletePath:path block:^(NSInteger statusCode, NSError *error) {
		if(statusCode <= 204 || statusCode == 404) {
			[StoreManager.sharedManager deleteDevice:device];
		}
		block(statusCode, error);
	}];
	
}

#pragma - identity management method

- (void)deleteIdent:(Ident *)ident block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"idents/%@", ident.uuid];
	
	[self deletePath:path block:^(NSInteger statusCode, NSError *error) {
		if(statusCode <= 204 || statusCode == 404) {
			[StoreManager.sharedManager deleteIdent:ident];
            [StoreManager.sharedManager saveContext:nil];
		}
		block(statusCode, error);
        
	}];
	
}

#pragma - EULA method
- (void)getEula:(void(^)(Eula *eula, NSInteger statusCode, NSError *error)) block {

	RKObjectManager *manager = [self getJsonObjectManager];
	
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
												responseDescriptorWithMapping:[RestClientHelper eulaEntityMapping]
												method:RKRequestMethodGET
												pathPattern:nil
												keyPath:nil
												statusCodes:statusCodes];
	
	NSMutableURLRequest *request = [manager
									requestWithObject:[NSURLRequest requestWithURL:self.baseURL]
									method:RKRequestMethodGET
									path:@"eula"
									parameters:nil];
	[request setTimeoutInterval:KrestTimeout];
	
	RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc]
												  initWithRequest:request
												  responseDescriptors:@[responseDescriptor]];
	
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
	    
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
        if(result) {
            block((Eula *)[result firstObject], statusCode, nil);
        } else {
            block(nil, statusCode, nil);
        }
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		
		NSInteger statusCode = operation.HTTPRequestOperation.response.statusCode;
		block(nil, statusCode, error);
	 
	}];
	
	[operation start];

}

#pragma - task management methods
- (void)getNewTask:(NSString *)uuid block:(void (^)(Task *task, NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"tasks/%@", uuid];
	
	[self getJsonWithParams:nil path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		
		if(dictionary) {
			NSError *createTaskError;
			Task *task = [TaskHelper createTaskFromDictionary:dictionary visible:YES error:&createTaskError];
			if(task) {
				[self getTaskImages:task block:^(NSInteger statusCode, NSError *error) {
					
					if(error) {
						block(nil, statusCode, error);
					} else {
						[self getTaskRendition:task block:^(Rendition *rendition, NSInteger statusCode, NSError *error) {
                            if(error) {
                                block(nil, statusCode, error);
                            } else {
                                block(task, statusCode, error);
                            }
						}];
					}
					
				}];
            } else {
                block(nil, statusCode, createTaskError);
			}
		} else {
			block(nil, statusCode, error);
		}
	
	}];
	
}

- (void)getUpdatedTask:(Task *)task block:(void (^)(Task *newTask, NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"tasks/%@", task.uuid];
	
	[self getJsonWithParams:nil path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		
		if(dictionary) {
			__block NSDate *lastUpdate = task.lastUpdate;
			NSError *updateTaskError;
			[TaskHelper updateTask:task withDictionary:dictionary error:&updateTaskError];
			if(!updateTaskError) {
			
				[self getTaskImages:task block:^(NSInteger statusCode, NSError *error) {
					if(error) {
						task.lastUpdate = lastUpdate;
						block(task, statusCode, error);
					} else {
						[self getTaskRendition:task block:^(Rendition *rendition, NSInteger statusCode, NSError *error) {
							task.icon_data = nil;
							if(error) {
								task.lastUpdate = lastUpdate;
								block(task, statusCode, error);
							} else {
								block(task, statusCode, error);
							}
						}];
					}
				}];
                
			} else {
				block(task, statusCode, updateTaskError);
			}
		} else {
			block(nil, statusCode, error);
		}
		
	}];
	
}

- (void)postTask:(Task *)task block:(void(^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = @"tasks";
	NSDictionary *params = [task dictionary];
	
	[self postParams:params path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		
		if(dictionary) {
			task.uuid = [dictionary objectForKey:@"uuid"];
            task.lastUpdate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"lastUpdate"]];
			[self putTaskBinaries:task imageIndex:0 block:^(NSInteger statusCode, NSError *error) {
				
				if(error) {
					task.lastUpdate = [NSDate date];
					block(statusCode, error);
                } else {
                    if([task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]]) {
                        [self finishTask:task block:^(NSInteger statusCode, NSError *error) {
                            block(statusCode, error);
                        }];
                    } else {
                        block(statusCode, error);
                    }
                }
				
			}];
		} else {
			block(statusCode, error);
		}
		
	}];
	
}

- (void)putTask:(Task *)task block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	[self deleteTaskReferences:task block:^(NSInteger statusCode, NSError *error) {
		
		if(error) {
			block(statusCode, error);
		} else {
			NSString *path = [NSString stringWithFormat:@"tasks/%@", task.uuid];
			NSDictionary *params = [task dictionary];
			[self putParams:params path:path block:^(NSInteger statusCode, NSError *error) {
				
				if(!error) {
                    if([task.finished isEqualToNumber:@0]) {
                        [self putTaskBinaries:task imageIndex:0 block:^(NSInteger statusCode, NSError *error) {
                            
                            if(error) {
                                block(statusCode, error);
                            } else {
                                if([task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]]) {
                                    [self finishTask:task block:^(NSInteger statusCode, NSError *error) {
                                        block(statusCode, error);
                                    }];
                                } else {
                                    block(statusCode, error);
                                }
                            }
                            
                        }];
                    } else {
                        block(statusCode, error);
                    }
				} else {
					block(statusCode, error);
				}
				
			}];
		}
		
	}];
	
}

- (void)finishTask:(Task *)task block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"tasks/%@/%@", task.uuid, task.serviceId ? @"finish":@"rendition"];
    
	[self getParams:nil path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		
		if(error) {
            NSLog(@"%@: %@", path, [error localizedDescription]);
            task.lastUpdate = [NSDate date];
            task.finished = @0;
            if(statusCode == 402) {
                task.noCredit = @1;
            }
        } else {
            NSLog(@"%@: OK", path);
            task.lastUpdate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"lastUpdate"]];
            task.finished = @1;
            task.noCredit = @0;
            [StoreManager.sharedManager applyTaskCost:task];
        }
		block(statusCode, error);
		
	}];
	
}

- (void)deleteTask:(Task *)task block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"tasks/%@", task.uuid];
	
	[self deletePath:path block:^(NSInteger statusCode, NSError *error) {
		
		if(statusCode <= 204 || statusCode == 404) {
			error = [StoreManager.sharedManager deleteTask:task];
			block(statusCode, error);
		} else {
			block(statusCode, error);
		}
		
	}];
	
}

#pragma - task image management
- (void)postImage:(CaptureImage *)image block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"binary/upload/tasks/%@/images/add", image.task.uuid];
	NSDictionary *params = [image dictionary];
	
	[self putBinaryData:image.data path:path params:params block:^(NSInteger statusCode, NSError *error) {
        image.md5 = statusCode <= 204 ? [params objectForKey:@"hash"]:nil;
		block(statusCode, error);
	}];
	
}

- (void)getTaskImages:(Task *)task block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	__block int numberOfImages = (int) [task.images count];
	
	if(numberOfImages == 0)
		block(200, nil);
    
	__block int index = 0;
	__block int imageCount = 0;
	
	for(CaptureImage *image in task.images) {
		
		if(image.md5) {
			
			[self getTaskImage:task index:index block:^(CaptureImage *image, NSInteger statusCode, NSError *error) {
				
                if(error) {
                    imageCount = numberOfImages;
                } else {
                    imageCount++;
                }
				if(imageCount == numberOfImages) {
					block(statusCode, error);
				}
				
			}];
			
		} else {
			
			imageCount++;
			if(imageCount == numberOfImages) {
				block(200, nil);
			}
			
		}
		index++;
		
	}
	
}

- (void)getTaskImage:(Task *)task index:(int)index block:(void (^)(CaptureImage *image, NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"binary/tasks/%@/images/%d", task.uuid, index];
	
	[self getDataWithParams:nil path:path block:^(NSData *data, NSString* contentType, NSInteger statusCode, NSError *error) {
		
		if(data) {
			CaptureImage *image = [task.images objectAtIndex:index];
			[data writeToFile:image.privatePath atomically:NO];
			block(image, statusCode, error);
		} else {
			block(nil, statusCode, error);
		}
		
	}];
	
}

- (void)putImage:(CaptureImage *)image block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	Task *task = image.task;
	int index = 0;
	
	for(CaptureImage *taskImage in task.images) {
		
		if([taskImage.uuid isEqualToString:image.uuid] && [taskImage.order isEqualToNumber:image.order]) {
			break;
		} else {
			index++;
		}
		
	}
	
	NSString *path = [NSString stringWithFormat:@"binary/upload/tasks/%@/images/%d", image.task.uuid, index];
	NSDictionary *params = [image dictionary];
	
	[self putBinaryData:image.data path:path params:params block:^(NSInteger statusCode, NSError *error) {
        image.md5 = statusCode <= 204 ? [params objectForKey:@"hash"]:nil;
		block(statusCode, error);
	}];
	
}

- (void)deleteTaskReferences:(Task *)task block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	__block int numberOfReferences = (int) [task.deleteImageReferences count];
	__block int referenceCount = 0;
	
	if(numberOfReferences > 0) {
		
		for(DeleteImageReference *reference in task.deleteImageReferences) {
			
			NSString *path = [NSString stringWithFormat:@"binary/tasks/%@/images/%@/%@", task.uuid, reference.index, reference.md5];
			
			[self deletePath:path block:^(NSInteger statusCode, NSError *error) {
				
				if(statusCode <= 204 || statusCode == 404) {
					[StoreManager.sharedManager deleteImageReference:reference];
					referenceCount++;
				} else {
					referenceCount = numberOfReferences;
				}
				
				if(referenceCount == numberOfReferences) {
					block(statusCode, error);
				}
				
			}];
			
		}
		
	} else {
		
		block(204, nil);
		
	}
	
}

#pragma - task rendition management
- (void)getTaskRendition:(Task *)task block:(void (^)(Rendition *rendition, NSInteger statusCode, NSError *error)) block {
	
	if([task.renditions count] > 0) {
	
		NSString *path = [NSString stringWithFormat:@"binary/tasks/%@/renditions/0", task.uuid];
		
		[self getDataWithParams:nil path:path block:^(NSData *data, NSString* contentType, NSInteger statusCode, NSError *error) {
			
			if(data) {
				Rendition *rendition = [task.renditions objectAtIndex:0];
				[data writeToFile:rendition.privatePath atomically:NO];
				block(rendition, statusCode, error);
			} else {
                block(nil, statusCode, error);
			}
			
		}];
		
	} else {
		block(nil, 204, nil);
	}
	
}

#pragma - post/put task images recursively
- (void)putTaskBinaries:(Task *)task imageIndex:(int)imageIndex block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	if(imageIndex < [task.images count]) {
		
		CaptureImage *image = [task.images objectAtIndex:imageIndex];
		
		if(image.isNew) {

			[self postImage:image block:^(NSInteger statusCode, NSError *err) {
				if(!err) {
					[self putTaskBinaries:task imageIndex:(imageIndex+1) block:^(NSInteger statusCode, NSError *error) {
						block(statusCode, error);
					}];
				} else {
					block(statusCode, err);
				}
			}];
			
		} else if(!image.isSync) {
				
			[self putImage:image block:^(NSInteger statusCode, NSError *err) {
				if(!err) {
					[self putTaskBinaries:task imageIndex:(imageIndex+1) block:^(NSInteger statusCode, NSError *error) {
						block(statusCode, error);
					}];
				} else {
					block(statusCode, err);
				}
			}];
			
		} else {
			
			[self putTaskBinaries:task imageIndex:(imageIndex+1) block:^(NSInteger statusCode, NSError *error) {
				block(statusCode, error);
			}];
			
		}
		
	} else {
		block(200, nil);
	}
	
}

#pragma - template management methods
- (void)getNewService:(NSString *)uuid block:(void (^)(Service *service, NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"templates/%@", uuid];
	
	[self getJsonWithParams:nil path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
        
		if(!error && dictionary) {
			NSError *createServiceError;
			Service *service = [TaskHelper createServiceFromDictionary:dictionary error:&createServiceError];
			block(service, statusCode, createServiceError);
		} else {
			block(nil, statusCode, error);
		}
		
	}];
	
}

- (void)getServiceLastUpdate:(NSString *)uuid block:(void (^)(NSDate *lastUpdate, NSInteger statusCode, NSError *error)) block {
    
    NSString *path = [NSString stringWithFormat:@"templates/%@", uuid];
    
    [self getJsonWithParams:nil path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
        
        if(!error && dictionary) {
            NSDate *date = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"lastUpdate"]];
            block(date, statusCode, nil);
        } else {
            block(nil, statusCode, error);
        }
        
    }];
    
}

- (void)getUpdatedService:(Service *)service block:(void (^)(Service *service, NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"templates/%@", service.uuid];
	
	[self getJsonWithParams:nil path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		
		if(!error && dictionary) {
			NSError *updateError;
			[TaskHelper updateService:service withDictionary:dictionary error:&updateError];
			block(service, statusCode, updateError);
		} else {
			block(nil, statusCode, error);
		}
		
	}];
	
}

- (void)postQRCode:(NSDictionary *)qrCodeDictionary block:(void (^)(NSDictionary *dictionary, NSInteger statusCode, NSError *error)) block {
	
	NSString *path = @"qrcode";
	
	[self postParams:qrCodeDictionary path:path block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
		block(dictionary, statusCode, error);
	}];
	
}

- (void)unregisterService:(Service *)service block:(void (^)(NSInteger statusCode, NSError *error)) block {
	
	NSString *path = [NSString stringWithFormat:@"templates/%@/unregister", service.uuid];
	
	[self deletePath:path block:^(NSInteger statusCode, NSError *error) {
		
		if(statusCode <= 204 || statusCode == 404) {
			[StoreManager.sharedManager deleteService:service];
		}
		block(statusCode, error);
		
	}];
	
}

@end
