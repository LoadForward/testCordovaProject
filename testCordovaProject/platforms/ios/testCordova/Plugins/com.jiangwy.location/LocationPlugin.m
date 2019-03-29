//
//  LocationPlugin.m
//  testCordova
//
//  Created by 江威严 on 2019/3/28.
//

#import "LocationPlugin.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationPlugin () <CLLocationManagerDelegate>
{
    CDVInvokedUrlCommand *_command;
}

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation LocationPlugin

- (void)showCurrentLocation:(CDVInvokedUrlCommand *)command {
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        // 前台定位授权 官方文档中说明info.plist中必须有NSLocationWhenInUseUsageDescription键
        [_manager requestWhenInUseAuthorization];
    }
    // 设置定位所需的精度 枚举值 精确度越高越耗电
    _manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    // 每10米更新一次定位
    _manager.distanceFilter = 10;
    [_manager startUpdatingLocation];
    _command = command;
}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    NSString *str = [NSString stringWithFormat:@"lat: %f, lon: %f", location.coordinate.latitude, location.coordinate.longitude];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
    [self.commandDelegate sendPluginResult:result callbackId:_command.callbackId];
}

@end
