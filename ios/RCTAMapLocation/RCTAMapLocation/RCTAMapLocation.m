
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

#import "RCTAMapLocation.h"
#import <React/RCTUtils.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
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
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self setOptions:options];
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        NSDictionary *resultDic;
        if (error)
        {
            resultDic = [self setErrorResult:error];
        }
        else {
            resultDic = [self setSuccessResult:location regeocode:regeocode];
        }
        [self.bridge.eventDispatcher sendAppEventWithName:@"amap.location.onLocationResult"
                                                     body:resultDic];
    };
}

RCT_EXPORT_METHOD(setOptions:(NSDictionary *)options)
{
    CLLocationAccuracy locationMode = kCLLocationAccuracyHundredMeters;
    BOOL pausesLocationUpdatesAutomatically = YES;
    BOOL allowsBackgroundLocationUpdates = NO;
    int locationTimeout = DefaultLocationTimeout;
    int reGeocodeTimeout = DefaultReGeocodeTimeout;
    
    if(options != nil) {
        
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
        }
        
        if([keys containsObject:@"reGeocodeTimeout"]) {
            reGeocodeTimeout = [[options objectForKey:@"reGeocodeTimeout"] intValue];
        }
    }
    
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

}

RCT_EXPORT_METHOD(cleanUp)
{
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

RCT_EXPORT_METHOD(startUpdatingLocation)
{
    //开始进行连续定位
    [self.locationManager startUpdatingLocation];
}

RCT_EXPORT_METHOD(stopUpdatingLocation)
{
    //停止连续定位
    [self.locationManager stopUpdatingLocation];

}

- (void)dealloc
{
    [self cleanUp];
}

- (NSDictionary*)setErrorResult:(NSError *)error
{
    NSDictionary *resultDic;
    
    resultDic = @{
                  @"error": @{
                          @"code": @(error.code),
                          @"localizedDescription": error.localizedDescription
                          }
                  };
    return resultDic;
}

- (NSDictionary*)setSuccessResult:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode
{
    NSDictionary *resultDic;
    
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
    return resultDic;
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
//    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
    NSDictionary *resultDic;
    
    resultDic = [self setErrorResult:error];
    
    [self.bridge.eventDispatcher sendAppEventWithName:@"amap.location.onLocationResult"
                                                 body:resultDic];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)regeocode
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; regeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, regeocode.formattedAddress);
    
    NSDictionary *resultDic;
    
    resultDic = [self setSuccessResult:location regeocode:regeocode];
    
    [self.bridge.eventDispatcher sendAppEventWithName:@"amap.location.onLocationResult"
                                                 body:resultDic];

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
