
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

#import "RCTAMapLocation.h"
#import "RCTUtils.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface RCTAMapLocation() <AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation RCTAMapLocation

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(AMapLocation);

RCT_EXPORT_METHOD(init:(NSDictionary *)options)
{
    if(self.locationManager != nil) {
        return;
    }
    
//    NSLog(@"init locationManager");
    
    CLLocationAccuracy locationMode = kCLLocationAccuracyHundredMeters;
    BOOL pausesLocationUpdatesAutomatically = YES;
    BOOL allowsBackgroundLocationUpdates = NO;
    int locationTimeout = DefaultLocationTimeout;
    int reGeocodeTimeout = DefaultReGeocodeTimeout;
    
    if(options != nil) {
//        NSLog(@"set options");
        
        NSArray *keys = [options allKeys];
        
        if([keys containsObject:@"locationMode"]) {
            locationMode = [[options objectForKey:@"locationMode"] doubleValue];
        }
        
        if([keys containsObject:@"pausesLocationUpdatesAutomatically"]) {
            pausesLocationUpdatesAutomatically = [[options objectForKey:@"pausesLocationUpdatesAutomatically"] boolValue];
        }
        
        if([keys containsObject:@"allowsBackgroundLocationUpdates"]) {
            allowsBackgroundLocationUpdates = [[options objectForKey:@"allowsBackgroundLocationUpdates"] boolValue];
        }
        
        
        if([keys containsObject:@"locationTimeout"]) {
            locationTimeout = [[options objectForKey:@"locationTimeout"] intValue];
//            NSLog(@"locationTimeout = %d", locationTimeout);
        }
        
        if([keys containsObject:@"reGeocodeTimeout"]) {
            reGeocodeTimeout = [[options objectForKey:@"reGeocodeTimeout"] intValue];
//            NSLog(@"reGeocodeTimeout = %d", reGeocodeTimeout);
        }
    }
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:locationMode];
    
    //设置是否允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:pausesLocationUpdatesAutomatically];
    
    //设置是否允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:allowsBackgroundLocationUpdates];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:locationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:reGeocodeTimeout];
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        NSDictionary *resultDic;
        if (error)
        {
            resultDic = @{
                          @"error": @{
                                  @"code": @(error.code),
                                  @"localizedDescription": error.localizedDescription
                                  }
                          };
        }
        else {
            //得到定位信息
            if (location)
            {
                if(regeocode) {
                    resultDic = @{
                                  @"horizontalAccuracy": @(location.horizontalAccuracy),
                                  @"verticalAccuracy": @(location.verticalAccuracy),
                                  @"coordinate": @{
                                          @"latitude": @(location.coordinate.latitude),
                                          @"longitude": @(location.coordinate.longitude),
                                          },
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
                                  @"AOIName": regeocode.AOIName
                                  };
                }
                else {
                    resultDic = @{
                                  @"horizontalAccuracy": @(location.horizontalAccuracy),
                                  @"verticalAccuracy": @(location.verticalAccuracy),
                                  @"coordinate": @{
                                          @"latitude": @(location.coordinate.latitude),
                                          @"longitude": @(location.coordinate.longitude),
                                          }
                                  };
                    
                }
            }
            else {
                resultDic = @{
                             @"error": @{
                                     @"code": @(-1),
                                     @"localizedDescription": @"定位结果不存在"
                                     }
                             };
            }
        }
        [self.bridge.eventDispatcher sendAppEventWithName:@"amap.location.onLocationResult"
                                                     body:resultDic];
    };
}

RCT_EXPORT_METHOD(cleanUp)
{
//    NSLog(@"stop location and clean up");
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
    self.locationManager = nil;
}



RCT_EXPORT_METHOD(getReGeocode)
{
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

RCT_EXPORT_METHOD(getLocation)
{
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}


- (void)dealloc
{
    [self cleanUp];
}


- (NSDictionary *)constantsToExport
{
    return @{
             @"locationMode": @{
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
