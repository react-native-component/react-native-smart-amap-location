
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

#import "RCTAMapLocation.h"
#import "RCTUtils.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface RCTAMapLocation() <AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation RCTAMapLocation

RCT_EXPORT_MODULE(AMapLocation);

RCT_EXPORT_METHOD(init:(NSDictionary *)options)
{
    if(self.locationManager != nil) {
        return;
    }
    
    CLLocationAccuracy locationAccuracy = kCLLocationAccuracyHundredMeters;
    BOOL pausesLocationUpdatesAutomatically = YES;
    BOOL allowsBackgroundLocationUpdates = NO;
    NSInteger locationTimeout = DefaultLocationTimeout;
    NSInteger reGeocodeTimeout = DefaultReGeocodeTimeout;
    
    if(options != nil) {
        if([[options objectForKey:@"locationAccuracy"] count] > 0) {
            locationAccuracy = [[options objectForKey:@"locationAccuracy"] doubleValue];
        }
        
        
        if([[options objectForKey:@"pausesLocationUpdatesAutomatically"] count] > 0) {
            pausesLocationUpdatesAutomatically = [[options objectForKey:@"pausesLocationUpdatesAutomatically"] boolValue];
        }
        
        
        if([[options objectForKey:@"allowsBackgroundLocationUpdates"] count] > 0) {
            allowsBackgroundLocationUpdates = [[options objectForKey:@"allowsBackgroundLocationUpdates"] boolValue];
        }
        
        
        if([[options objectForKey:@"locationTimeout"] count] > 0) {
            locationTimeout = [[options objectForKey:@"locationTimeout"] integerValue];
        }
        
        if([[options objectForKey:@"reGeocodeTimeout"] count] > 0) {
            reGeocodeTimeout = [[options objectForKey:@"reGeocodeTimeout"] integerValue];
        }
    }
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:locationAccuracy];
    
    //设置是否允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:pausesLocationUpdatesAutomatically];
    
    //设置是否允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:allowsBackgroundLocationUpdates];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:locationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:reGeocodeTimeout];
}

RCT_EXPORT_METHOD(cleanUp)
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
}

RCT_EXPORT_METHOD(getReGeocode:(RCTResponseSenderBlock)callback)
{
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
     {
         if (error)
         {
             NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
             
             //如果为定位失败的error，则不进行后续操作
//             if (error.code == AMapLocationErrorLocateFailed)
//             {
                 callback(@[RCTMakeError([NSString stringWithFormat:@"%d", error.code], nil, nil)]);
                 return;
//             }
         }
         
         //得到定位信息(regeocode)
         if (location)
         {
//             NSDictionary *dict = [[NSDictionary alloc] init];
//             [dict setValue:regeocode.formattedAddress forKey:@"formattedAddress"];
//             [dict setValue:regeocode.country forKey:@"country"];
//             [dict setValue:regeocode.province forKey:@"province"];
//             [dict setValue:regeocode.city forKey:@"city"];
//             [dict setValue:regeocode.district forKey:@"district"];
//             [dict setValue:regeocode.citycode forKey:@"citycode"];
//             [dict setValue:regeocode.adcode forKey:@"adcode"];
//             [dict setValue:regeocode.street forKey:@"street"];
//             [dict setValue:regeocode.number forKey:@"number"];
//             [dict setValue:regeocode.POIName forKey:@"POIName"];
//             [dict setValue:regeocode.AOIName forKey:@"AOIName"];
//             [dict setValue:@(location.horizontalAccuracy) forKey:@"horizontalAccuracy"];
//             [dict setValue:@(location.verticalAccuracy) forKey:@"verticalAccuracy"];
             callback(@[[NSNull null], @{
                            @"horizontalAccuracy": @(location.horizontalAccuracy),
                            @"verticalAccuracy": @(location.verticalAccuracy),
                            @"formattedAddress": regeocode.formattedAddress,
                            @"country": regeocode.country,
                            @"province": regeocode.province,
                            @"city": regeocode.city,
                            @"district": regeocode.district,
                            @"citycode": regeocode.citycode,
                            @"adcode": regeocode.adcode,
                            @"street": regeocode.street,
                            @"number": regeocode.number,
                            @"POIName": regeocode.POIName,
                            @"AOIName": regeocode.AOIName,
                            }]);
         }
         // unknown error
         else {
             callback(@[RCTMakeError(@"", nil, nil)]);
         }
     }];
}

RCT_EXPORT_METHOD(getLocation:(RCTResponseSenderBlock)callback)
{
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
     {
         if (error)
         {
             NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
             
             //如果为定位失败的error，则不进行后续操作
//             if (error.code == AMapLocationErrorLocateFailed)
//             {
                 callback(@[RCTMakeError([NSString stringWithFormat:@"%d", error.code], nil, nil)]);
                 return;
//             }
         }
         
         //得到定位信息(not regeocode)
         if (location)
         {
//             NSDictionary *dict = [[NSDictionary alloc] init];
//             [dict setValue:@(location.coordinate.latitude) forKey:@"latitude"];
//             [dict setValue:@(location.coordinate.longitude) forKey:@"longitude"];
//             [dict setValue:@(location.horizontalAccuracy) forKey:@"horizontalAccuracy"];
//             [dict setValue:@(location.verticalAccuracy) forKey:@"verticalAccuracy"];
             callback(@[[NSNull null], @{
                                    @"horizontalAccuracy": @(location.horizontalAccuracy),
                                    @"verticalAccuracy": @(location.verticalAccuracy),
                                    @"coordinate": @{
                                                @"latitude": @(location.coordinate.latitude),
                                                @"longitude": @(location.coordinate.longitude),
                                            }
                                    }]);
         }
         // unknown error
         else {
             callback(@[RCTMakeError(@"", nil, nil)]);
         }
     }];
}


- (void)dealloc
{
    [self cleanUp];
}


- (NSDictionary *)constantsToExport
{
    return @{
             @"locationAccuracies": @{
                     @"bestForNavigation": @(kCLLocationAccuracyBestForNavigation),
                     @"best": @(kCLLocationAccuracyBest),
                     @"nearestTenMeters": @(kCLLocationAccuracyNearestTenMeters),
                     @"hundredMeters": @(kCLLocationAccuracyHundredMeters),
                     @"kilometer":  @(kCLLocationAccuracyKilometer),
                     @"threeKilometers": @(kCLLocationAccuracyThreeKilometers)
                     }
             };
}


@end
