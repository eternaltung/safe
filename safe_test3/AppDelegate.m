//
//  AppDelegate.m
//  safe_test3
//
//  Created by bbiiggppiigg on 2015/7/28.
//  Copyright (c) 2015年 bbiiggppiigg. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "EventModel.h"
#import "SqlHelper.h"

@interface AppDelegate () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) SqlHelper *sqlhelper;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.sqlhelper = [[SqlHelper alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    return YES;
}

//location update
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    //NSLog(@"update%f",location.coordinate.latitude);
    [self.sqlhelper createDB];
    NSArray *array = [self.sqlhelper selectAllEvent];
    
    for (EventModel *item in array) {
        if ([[[NSDate date] dateByAddingTimeInterval:28800] compare:item.alarmTime] == NSOrderedDescending) {
            [manager stopUpdatingLocation];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://smsserviceapi.azurewebsites.net/SendSMS?to=886979102172&msg=lat:%f,lon:%f&key=abcde",location.coordinate.latitude,location.coordinate.longitude]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
            [request setHTTPMethod:@"POST"];
            //[[NSURLConnection alloc]initWithRequest:request delegate:self];
            [self.sqlhelper removeEvent:item.ID];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
