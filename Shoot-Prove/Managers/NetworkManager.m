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

#import "NetworkManager.h"
#import "Reachability.h"

@interface NetworkManager()

@property (nonatomic, strong) NSTimer *networkTimer;
@property (nonatomic) CFAbsoluteTime startTime;
@property (nonatomic) CFAbsoluteTime stopTime;
@property (nonatomic) long long bytesReceived;
@property (nonatomic, copy) void (^speedTestCompletionHandler)(CGFloat kiloBytesPerSecond, NSError *error);

@end

@implementation NetworkManager
@synthesize
	internetAvailable = _internetAvailable,
	serverAvailable = _serverAvailable,
	bandWidth = _bandWidth;

@synthesize
	delegate;

+ (instancetype)sharedManager {
	
	static id manager = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		manager = [[NetworkManager alloc] init];
	});
	
	return manager;
	
}

- (id)init {
	
	self = [super init];
	
	if(self) {
		
		self.delegate = nil;
		
		_bandWidth = 0;
		_internetAvailable = NO;
		_serverAvailable = NO;
		
	}
	
	return self;
	
}

- (BOOL)internetAvailable {
	return _internetAvailable;
}

- (BOOL)serverAvailable {
	return _serverAvailable;
}

- (CGFloat)bandWidth {
	return _bandWidth;
}

- (void)startNetworkPooling:(double)interval {
	
    if(self.networkTimer) {
        [self.networkTimer invalidate];
        self.networkTimer = nil;
    }
		
	[self notifyDelegateAboutNetwork];
	self.networkTimer = [NSTimer scheduledTimerWithTimeInterval:interval
														 target:self
													   selector:@selector(notifyDelegateAboutNetwork)
													   userInfo: nil
														repeats:YES];
}

- (void)stopNetworkPooling {
	if(!self.networkTimer)
		return;
	[self.networkTimer invalidate];
	self.networkTimer = nil;
}

- (void)notifyDelegateAboutNetwork {
	
	if([self.delegate respondsToSelector:@selector(isInternetAvailable:andServerOnline:)]) {
	
		[AFNetworkActivityIndicatorManager.sharedManager setEnabled:NO];
		
		_serverAvailable = NO;
		
		[self checkInternet:^(BOOL internetOK) {
			
			_internetAvailable = internetOK;
			
			if(internetOK) {
				
				[self checkServer:^(BOOL serverOK) {
					
					_serverAvailable = serverOK;
					
					dispatch_async(dispatch_get_main_queue(), ^{
						
						[self.delegate isInternetAvailable:internetOK andServerOnline:serverOK];
						
					});
					
				}];
				
			} else {
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					[self.delegate isInternetAvailable:NO andServerOnline:NO];
					
				});
				
			}
			
		}];
		
		[AFNetworkActivityIndicatorManager.sharedManager setEnabled:YES];
		
	}
	
}

- (void)checkServer:(connection)block {
	
	[self testDownloadSpeedWithTimeout:5 completionHandler:^(CGFloat kiloBytesPerSecond, NSError * _Nullable error) {
		
		NSLog(@"Network Manager bandwidth (KiloBytes/sec): %0.2f", kiloBytesPerSecond);
		_bandWidth = kiloBytesPerSecond;
		
		if(!error) {
			
			if(fabs(_bandWidth) >= fabs(minimumBandWidth)) {
				block(YES);
			} else {
				block(NO);
			}
			
		} else {
			
			NSLog(@"Network Manager error: %@", error.localizedDescription);
			block(NO);
			
		}
		
	}];
	
}

- (void)checkInternet:(connection)block {
	
	Reachability *networkReachability = Reachability.reachabilityForInternetConnection;
	NetworkStatus networkStatus = networkReachability.currentReachabilityStatus;
	block(networkStatus != NotReachable);
	
}

- (void)testDownloadSpeedWithTimeout:(NSTimeInterval)timeout completionHandler:(nonnull void (^)(CGFloat kiloBytesPerSecond, NSError * _Nullable error))completionHandler {
	
	NSURL *url = [NSURL URLWithString:KiconUrl];
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	configuration.timeoutIntervalForResource = timeout;
	NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
	
	self.bytesReceived = 0;
	self.speedTestCompletionHandler = completionHandler;
	self.startTime = CFAbsoluteTimeGetCurrent();
	self.stopTime = self.startTime;
	
	[[session dataTaskWithURL:url] resume];
}

#pragma  - URL Session delegates
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
	
	self.bytesReceived += [data length];
	self.stopTime = CFAbsoluteTimeGetCurrent();
	
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
	
	CFAbsoluteTime elapsed = self.stopTime - self.startTime;
	CGFloat speed = elapsed != 0 ? self.bytesReceived / (CFAbsoluteTimeGetCurrent() - self.startTime) / 1024.0 : -1;
	
	if (error == nil || ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorTimedOut)) {
		self.speedTestCompletionHandler(speed, nil);
	} else {
		self.speedTestCompletionHandler(speed, error);
	}
	
}

@end
