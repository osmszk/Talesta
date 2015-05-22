//
//  PLUtil.h
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/01/05.
//  Copyright (c) 2014年 Plegineer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLGAppVersionState) {
    PLGAppVersionStateNotChanged,
    PLGAppVersionStateFirst,
    PLGAppVersionStateBumpedUp,
};

@interface PLUtil : NSObject

#pragma mark - 汎用的なもの
+ (void)showAlert:(NSString*)title message:(NSString*)msg;
+ (BOOL)is4inchDisplay;
+ (float)osVersion;
+ (NSString *)appVersionString;
+ (NSString *)trackingAppVersion;
+ (void)saveTrackingAppVersion;
+ (NSNumber*)appVersionNumber;
+ (PLGAppVersionState)appVersionState;
+ (CGSize)displaySize;
+ (CGRect)displayFrame;
+ (CGPoint)displayCenter;
+ (NSString *)changeURLencode:(NSString *)str;
+ (NSString *)changeURLdecode:(NSString *)str;
+ (BOOL)isOnline;
+ (UIImage *)imageWithFillColor:(UIColor *)color rect:(CGRect)rect;
+ (FILE *)writeToConsoleLog;
+ (BOOL)includedStringInString:(NSString *)keyStr inStr:(NSString *)inStr;
+ (UIImage *)resizeImage:(UIImage*)image width:(CGFloat)w height:(CGFloat)h;
+ (UIImage *)resizeImageWithRatio:(UIImage*)image widthRatio:(CGFloat)wR heightRatio:(CGFloat)hR;
+ (NSNumber *)convertToNumberVersion:(NSString *)appVersionString;
+ (NSDate *)unixDate:(NSString *)unixDateString thousand:(BOOL)isMiriSec;
+ (id)notNull:(NSString *)string;
+ (UIImage *)imageOverlay:(UIImage *)overlayImage originalImage:(UIImage *)originalImage;
+ (UIImage *)overlayedImage:(NSArray *)images size:(CGSize)size;

#pragma mark - NSUserDefault
+ (void)saveObject:(id)obj key:(NSString *)key;
+ (id)loadObject:(NSString *)key;
+ (void)saveInteger:(NSInteger)val key:(NSString *)key;
+ (NSInteger)loadInteger:(NSString *)key;
+ (void)saveBool:(BOOL)val key:(NSString *)key;
+ (BOOL)loadBool:(NSString *)key;
+ (void)remove:(NSString *)key;
+ (void)clearAllSavedData;
+ (void)saveWithArchiving:(id)obj key:(NSString *)key;
+ (id)loadWithUnarchiving:(NSString *)key;

#pragma mark - 通信関連
+ (NSString *)userAgent;
+ (NSString *)deviceName;

@end
