package com.reactnativecomponent.amaplocation;


import android.os.Handler;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationClientOption.AMapLocationMode;
import com.amap.api.location.AMapLocationClientOption.AMapLocationProtocol;
import com.amap.api.location.AMapLocationListener;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;


public class RCTAMapLocationModule extends ReactContextBaseJavaModule {

    private ReactApplicationContext reactContext;

    private AMapLocationClient locationClient = null;
    private AMapLocationClientOption locationOption = null;


    public RCTAMapLocationModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "AMapLocation";
    }

    @ReactMethod
    public void init(final ReadableMap options) {
        if(locationClient != null) {
            return;
        }
        locationOption = new AMapLocationClientOption();
        locationOption.setOnceLocation(true);   //调整为单次定位, 默认是多次
        //初始化client
        locationClient = new AMapLocationClient(getCurrentActivity());
        if(options != null) {
            setUserOption(options);
        }
        //设置定位参数
        locationClient.setLocationOption(locationOption);
        // 设置定位监听
        locationClient.setLocationListener(locationListener);
    }

    AMapLocationListener locationListener = new AMapLocationListener() {
        @Override
        public void onLocationChanged(AMapLocation location) {
            WritableMap resultMap = Arguments.createMap();
            if (null != location) {
                //errCode等于0代表定位成功，其他的为定位失败，具体的可以参照官网定位错误码说明
                if(location.getErrorCode() == 0){
                    WritableMap coordinateMap = Arguments.createMap();
                    coordinateMap.putDouble("longitude", location.getLongitude());
                    coordinateMap.putDouble("latitude", location.getLatitude());
                    resultMap.putMap("coordinate", coordinateMap);
                    resultMap.putInt("locationType", location.getLocationType());
                    resultMap.putDouble("accuracy", location.getAccuracy());
                    resultMap.putDouble("locationType", location.getAccuracy());
                    resultMap.putString("provider", location.getProvider());
                    if (location.getProvider().equalsIgnoreCase(
                            android.location.LocationManager.GPS_PROVIDER)) {
                        // 以下信息只有提供者是GPS时才会有
                        resultMap.putDouble("speed", location.getSpeed());
                        resultMap.putDouble("bearing", location.getBearing());
                        // 获取当前提供定位服务的卫星个数
                        resultMap.putInt("satellites", location.getSatellites());
                    } else {
                        // 提供者是GPS时是没有以下信息的
                        resultMap.putString("country", location.getCountry());
                        resultMap.putString("province", location.getProvince());
                        resultMap.putString("city", location.getCity());
                        resultMap.putString("citycode", location.getCityCode());
                        resultMap.putString("district", location.getDistrict());
                        resultMap.putString("adcode", location.getAdCode());
                        resultMap.putString("formattedAddress", location.getAddress());
                        resultMap.putString("street", location.getStreet());
                        resultMap.putString("number", location.getStreetNum());
                        resultMap.putString("POIName", location.getPoiName());
                        resultMap.putString("AOIName", location.getAoiName());
                    }
                }
                else {
                    WritableMap errorMap = Arguments.createMap();
                    errorMap.putInt("code", location.getErrorCode());
                    errorMap.putString("localizedDescription", location.getErrorInfo());
                    resultMap.putMap("error", errorMap);
                }
            } else {
                WritableMap errorMap = Arguments.createMap();
                errorMap.putInt("code", -1);
                errorMap.putString("localizedDescription", "定位结果不存在");
                resultMap.putMap("error", errorMap);
            }
            locationClient.stopLocation();
            Log.i("amaplocation", "locationClient.stopLocation();");
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit("amap.location.onLocationResult", resultMap);
        }
    };

    @ReactMethod
    public void cleanUp() {
        if (null != locationClient) {
            locationClient.stopLocation();
            locationClient.onDestroy();
            locationClient = null;
            locationOption = null;
        }
    }

    @ReactMethod
    public void getReGeocode() {
        locationOption.setNeedAddress(true);    //可选，设置是否返回逆地理地址信息。默认是true
        // 设置定位参数
        locationClient.setLocationOption(locationOption);
        // 启动定位
        locationClient.startLocation();
    }

    @ReactMethod
    public void getLocation() {
        locationOption.setNeedAddress(false);    //可选，设置是否返回逆地理地址信息。默认是true
        // 设置定位参数
        locationClient.setLocationOption(locationOption);
        // 启动定位
        locationClient.startLocation();
    }

    private void setUserOption(final ReadableMap options){
        if(options.hasKey("locationMode")) {
            locationOption.setLocationMode(AMapLocationMode.valueOf(options.getString("locationMode")));//可选，设置定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
        }
        if(options.hasKey("gpsFirst")) {
            locationOption.setGpsFirst(options.getBoolean("gpsFirst"));//可选，设置是否gps优先，只在高精度模式下有效。默认关闭
        }
        if(options.hasKey("httpTimeout")) {
            locationOption.setHttpTimeOut(options.getInt("httpTimeout"));//可选，设置网络请求超时时间。默认为30秒。在仅设备模式下无效
        }
        if(options.hasKey("interval")) {
            locationOption.setInterval(options.getInt("interval"));//可选，设置定位间隔。默认为2秒
        }
        if(options.hasKey("needAddress")) {
            locationOption.setNeedAddress(options.getBoolean("needAddress"));//可选，设置是否返回逆地理地址信息。默认是true
        }
        if(options.hasKey("onceLocation")) {
            Log.i("amaplocation",  "onceLocation -> " + String.valueOf(options.getBoolean("onceLocation")));
            locationOption.setOnceLocation(options.getBoolean("onceLocation"));//可选，设置是否单次定位。默认是false
        }
        if(options.hasKey("locationCacheEnable")) {
            locationOption.setLocationCacheEnable(options.getBoolean("locationCacheEnable"));//可选，设置是否开启缓存，默认为true.
        }
        if(options.hasKey("onceLocationLatest")) {
            locationOption.setOnceLocationLatest(options.getBoolean("onceLocationLatest"));//可选，设置是否等待wifi刷新，默认为false.如果设置为true,会自动变为单次定位，持续定位时不要使用
        }
        if(options.hasKey("locationProtocol")) {
            AMapLocationClientOption.setLocationProtocol(AMapLocationProtocol.valueOf(options.getString("locationProtocol")));//可选， 设置网络请求的协议。可选HTTP或者HTTPS。默认为HTTP
        }
        if(options.hasKey("sensorEnable")) {
            locationOption.setSensorEnable(options.getBoolean("sensorEnable"));//可选，设置是否使用传感器。默认是false
        }
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return Collections.unmodifiableMap(new HashMap<String, Object>() {
            {
                put("locationMode", getLocationModeTypes());
                put("locationProtocol", getLocationProtocolTypes());
            }
            private Map<String, Object> getLocationModeTypes() {
                return Collections.unmodifiableMap(new HashMap<String, Object>() {
                    {
                        put("batterySaving", String.valueOf(AMapLocationMode.Battery_Saving));
                        put("deviceSensors", String.valueOf(AMapLocationMode.Device_Sensors));
                        put("hightAccuracy", String.valueOf(AMapLocationMode.Hight_Accuracy));
                    }
                });
            }
            private Map<String, Object> getLocationProtocolTypes() {
                return Collections.unmodifiableMap(new HashMap<String, Object>() {
                    {
                        put("http", String.valueOf(AMapLocationProtocol.HTTP));
                        put("https", String.valueOf(AMapLocationProtocol.HTTPS));
                    }
                });
            }
        });
    }

}

