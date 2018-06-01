//
//  LTRasterDefaults.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTLeadtoolsDefines.h"

typedef NS_ENUM(NSInteger, LTLEADResourceDirectory) {
    LTLEADResourceDirectoryLibraries,
    LTLEADResourceDirectoryFonts,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTRasterDefaults : NSObject

+ (NSInteger)xResolution;
+ (NSInteger)yResolution;

+ (void)xResolution:(NSInteger)xres;
+ (void)yResolution:(NSInteger)yres;

+ (LTRasterDitheringMethod)ditheringMethod;

+ (void)ditheringMethod:(LTRasterDitheringMethod)dmethod;

+ (nullable NSString *)resourceDirectory:(LTLEADResourceDirectory)resource error:(NSError **)error;
+ (BOOL)setDirectory:(NSString *)directory forResource:(LTLEADResourceDirectory)resource error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END