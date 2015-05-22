//
//  PLUtil.m
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/01/05.
//  Copyright (c) 2014年 Plegineer, Inc. All rights reserved.
//

#import "PLUtil.h"
#import "Reachability.h"
#import "sys/utsname.h"
//#import "PLCommon.h"

#define KEY_TRACKING_VERSION @"keyTrackingVersion"

@implementation PLUtil

#pragma mark - 汎用的なもの

+ (void)showAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+ (BOOL)is4inchDisplay
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    return (result.height == 1136.0);
}

+ (float)osVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString*)appVersionString
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)trackingAppVersion
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:KEY_TRACKING_VERSION];
}

+ (NSNumber*)appVersionNumber
{
    return [PLUtil convertToNumberVersion:[PLUtil appVersionString]];
}

+ (PLGAppVersionState)appVersionState
{
    NSString *trackingAppVersion = [PLUtil trackingAppVersion];
    NSString *currentAppVersion = [PLUtil appVersionString];
    if (trackingAppVersion == nil) {
        return PLGAppVersionStateFirst;
    }
    
    if (![trackingAppVersion isEqualToString:currentAppVersion]) {
        return PLGAppVersionStateBumpedUp;
    }
    
    return PLGAppVersionStateNotChanged;
}

+ (CGSize)displaySize
{
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGRect)displayFrame
{
    return CGRectMake(0, 0, [PLUtil displaySize].width, [PLUtil displaySize].height);
}

+ (CGPoint)displayCenter
{
    return CGPointMake([PLUtil displaySize].width/2, [PLUtil displaySize].height/2);
}

+ (NSString *)changeURLencode:(NSString *)str
{
    CFStringRef strRef = CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)str, NULL, (CFStringRef)@";,?:@&=+$#", kCFStringEncodingUTF8);
    NSString *text = [NSString stringWithString:(__bridge NSString *)strRef];
    CFRelease(strRef);
    return text;
}

+ (NSString *)changeURLdecode:(NSString *)str
{
    CFStringRef strRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef) str, CFSTR(""), kCFStringEncodingUTF8);
    NSString * text = [NSString stringWithString:(__bridge NSString *)strRef];
    CFRelease(strRef);
    return text;
}

+ (BOOL)isOnline
{
    //通信状態をチェック
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:
            return NO;
        case ReachableViaWWAN://3G
        case ReachableViaWiFi://Wifi
            return YES;
        default:
            return YES;
    }
}

+ (UIImage *)imageWithFillColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    UIImage *image = [[UIImage alloc]init];
    [image drawAtPoint:CGPointZero];
    [color setFill];
    UIRectFill(rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (FILE *)writeToConsoleLog
{
    FILE *consoleLog;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *oldConsoleFilename = @"CONSOLELOG_OLD_FILE";
    NSString *lastConsoleFilename = [self consoleLogFileWithDate];
    //    NSString *oldLastPath = [documentsDirectory stringByAppendingPathComponent:oldConsoleFilename];
    NSString *lastPath = [documentsDirectory stringByAppendingPathComponent:lastConsoleFilename];
    
    //    NSError *err;
    //    BOOL ret1 = [[NSFileManager defaultManager]removeItemAtPath:oldLastPath error:&err];
    //    BOOL ret2 =  [[NSFileManager defaultManager]moveItemAtPath:lastPath toPath:oldLastPath error:&err];
    
    consoleLog = freopen([lastPath cStringUsingEncoding:NSASCIIStringEncoding], "w", stderr);
    
    return consoleLog;
}

+ (NSString *)consoleLogFileWithDate
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [inputDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    NSString *dateStr = [inputDateFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"console%@.log",dateStr];
}

+ (BOOL)includedStringInString:(NSString *)keyStr inStr:(NSString *)inStr
{
    NSRange match = [inStr rangeOfString:keyStr];
    if (match.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

+ (UIImage *)resizeImage:(UIImage*)image width:(CGFloat)w height:(CGFloat)h
{
    UIImage *resultImage;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 2.0f);
    [image drawInRect:CGRectMake(0, 0, w, h)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)resizeImageWithRatio:(UIImage*)image widthRatio:(CGFloat)wR heightRatio:(CGFloat)hR
{
    CGSize size = CGSizeMake(image.size.width*wR,image.size.height*hR);
    UIImage *resultImage;
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0f);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


+ (NSNumber *)convertToNumberVersion:(NSString *)appVersionString
{
    NSArray *array = [appVersionString componentsSeparatedByString:@"."];
    if([array count] == 2){
        appVersionString = [NSString stringWithFormat:@"%d%02d", (int)[array[0] integerValue], (int)[array[1] integerValue]];
        return [NSNumber numberWithInteger:[appVersionString integerValue]];
    }else if([array count] == 3){
        appVersionString = [NSString stringWithFormat:@"%d%02d%02d", (int)[array[0] integerValue], (int)[array[1] integerValue],(int)[array[2] integerValue]];
        return [NSNumber numberWithInteger:[appVersionString integerValue]];
    }else{
        return [NSNumber numberWithInteger:[appVersionString integerValue]];
    }
}

+ (NSDate *)unixDate:(NSString *)unixDateString thousand:(BOOL)isMiriSec
{
    if (unixDateString == nil) {
        return nil;
    }
    
    NSDate *nDate = (isMiriSec) ? [NSDate dateWithTimeIntervalSince1970:[unixDateString longLongValue]/1000] : [NSDate dateWithTimeIntervalSince1970:[unixDateString longLongValue]];
    
    return nDate;
}

+ (id)notNull:(NSString *)string
{
    if(string == nil){
        return [NSNull null];
    }else{
        return string;
    }
}

/* 画像を重ね合わせる*/
+ (UIImage *)imageOverlay:(UIImage *)overlayImage originalImage:(UIImage *)originalImage
{
    CGSize newSize = originalImage.size;
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 1.0);
    
    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [overlayImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/* 複数の画像を重ね合わせる*/
+ (UIImage *)overlayedImage:(NSArray *)images size:(CGSize)size
{
    CGSize newSize = size;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    
    for (UIImage *avatar in images) {
        [avatar drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - NSUserDefault

+ (void)saveObject:(id)obj key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)loadObject:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveInteger:(NSInteger)val key:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] setInteger:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)loadInteger:(NSString *)key
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)saveBool:(BOOL)val key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)loadBool:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)remove:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+ (void)clearAllSavedData
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+ (void)saveWithArchiving:(id)obj key:(NSString *)key
{
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [[NSUserDefaults standardUserDefaults] setObject:arrayData forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)loadWithUnarchiving:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(data == nil){
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)saveTrackingAppVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[PLUtil appVersionString] forKey:KEY_TRACKING_VERSION];
    [defaults synchronize];
}

#pragma mark - 通信関連

+ (NSString *)userAgent
{
    struct utsname u;
    uname(&u);
    NSString *machine = [NSString stringWithCString:(const char*)u.machine encoding:NSUTF8StringEncoding];
    NSString *os      = [[UIDevice currentDevice] systemVersion];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@" v%@ Device:%@ iOS:%@", version,machine, os];
}

+ (NSString *)deviceName
{
    struct utsname u;
    uname(&u);
    return [NSString stringWithCString:(const char*)u.machine encoding:NSUTF8StringEncoding];
}

@end
