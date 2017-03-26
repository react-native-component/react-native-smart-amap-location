# react-native-smart-amap-location

[![npm](https://img.shields.io/npm/v/react-native-smart-amap-location.svg)](https://www.npmjs.com/package/react-native-smart-amap-location)
[![npm](https://img.shields.io/npm/dm/react-native-smart-amap-location.svg)](https://www.npmjs.com/package/react-native-smart-amap-location)
[![npm](https://img.shields.io/npm/dt/react-native-smart-amap-location.svg)](https://www.npmjs.com/package/react-native-smart-amap-location)
[![npm](https://img.shields.io/npm/l/react-native-smart-amap-location.svg)](https://github.com/react-native-component/react-native-smart-amap-location/blob/master/LICENSE)

react-native 高德地图-定位SDK 插件, 支持ios与android,
关于使用高德地图SDK, 申请应用key等详细信息请点击[这里][1]

Mac下Android Studio中获取SHA1和MD5请点击[这里][3]

## 预览

![react-native-smart-amap-location-preview-ios][2]

## 安装

```
npm install react-native-smart-amap-location --save
```

## Notice

这个版本仅支持react-native 0.40及以上, 如果你想使用旧的版本，使用`npm install react-native-smart-amap-location@untilRN0.40 --save`


## 安装 (iOS)

* 将RCTAMapLocation.xcodeproj作为Library拖进你的Xcode里的project中.

* 将RCTAMapLocation目录里Frameworks目录拖进主project目录下, 选择copy items if needed, create groups, 另外add to target不要忘记选择主project.

* 点击你的主project, 选择Build Phases -> Link Binary With Libraries, 将RCTAMapLocation.xcodeproj里Product目录下的libRCTAMapLocation.a拖进去.

* 同上位置, 选择Add items, 将系统库libstdc++.6.0.9.tbd加入.

* 同上位置, 选择Add items, 将系统库libc++.tbd加入.

* 同上位置, 选择Add items, 将系统库libz.tbd加入.

* 同上位置, 选择Add items, 将系统库Security.framework加入.

* 同上位置, 选择Add items, 将系统库CoreTelephony.framework加入.

* 同上位置, 选择Add items, 将系统库SystemConfiguration.framework加入.

* 同上位置, 选择Add items, 将系统库JavaScriptCore.framework加入.

* 如需要开启后台定位, 选择Capabilities, 找到Background Modes选择ON, 勾选上Location Updates.

* 选择Build Settings, 找到Header Search Paths, 确认其中包含$(SRCROOT)/../../../react-native/React, 模式为recursive.

* 同上位置, 找到Framework Search Paths, 加入$(PROJECT_DIR)/Frameworks.

* 点击在Libraries下已拖进来的RCTAMapLocation.xcodeproj, 选择Build Settings, 找到Framework Search Paths, 将$(SRCROOT)/../../../ios/Frameworks替换成$(SRCROOT)/../../../../ios/Frameworks.

* 在`info.plist`中加入`Privacy - Location When In Use Usage Description`属性(ios 10)

* 在`info.plist`中加入`Allow Arbitrary Loads`属性, 并设置值为YES(ios 10)

* 在`AppDelegate.m`中

```

...
#import <AMapFoundationKit/AMapFoundationKit.h> //引入高德地图核心包
...
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  [AMapServices sharedServices].apiKey = @"请填写您的key"; //设置高德地图SDK服务key
  ...
}
...

```

## 安装 (Android)

* 在`android/settings.gradle`中

```
...
include ':react-native-smart-amap-location'
project(':react-native-smart-amap-location').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-smart-amap-location/android')
```

* 在`android/app/build.gradle`中

```
...
dependencies {
    ...
    // From node_modules
    compile project(':react-native-smart-amap-location')
}
```

* 在`MainApplication.java`中

```
...
import com.reactnativecomponent.amaplocation.RCTAMapLocationPackage;    //import package
...
/**
 * A list of packages used by the app. If the app uses additional views
 * or modules besides the default ones, add more packages here.
 */
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        new MainReactPackage(),
        new RCTAMapLocationPackage()  //register Module
    );
}
...

```

* 在`AndroidManifest.xml`中, 加入所需权限

```

...
 <!--*************************高德地图-定位所需要权限*************************-->
    <!-- Normal Permissions 不需要运行时注册 -->
    <!--获取运营商信息，用于支持提供运营商信息相关的接口-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!--用于访问wifi网络信息，wifi信息会用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <!--这个权限用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_CONFIGURATION" />

    <!-- 请求网络 -->
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- 不是SDK需要的权限，是示例中的后台唤醒定位需要的权限 -->
    <!--<uses-permission android:name="android.permission.WAKE_LOCK" />-->

    <!-- 需要运行时注册的权限 -->
    <!--用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <!--用于访问GPS定位-->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <!--用于提高GPS定位速度-->
    <uses-permission android:name="android.permission.ACCESS_LOCATION_EXTRA_COMMANDS" />
    <!--写入扩展存储，向扩展卡写入数据，用于写入缓存定位数据-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <!--读取缓存数据-->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <!--用于读取手机当前的状态-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />

    <!-- 更改设置 -->
    <uses-permission android:name="android.permission.WRITE_SETTINGS" />
<!--*************************高德地图-定位所需要权限*************************-->
...

```

* 在`AndroidManifest.xml`中, application标签内加入

```

...
    <!--高德地图SDK key设置-->
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="请填写您的key"/>
    <!--高德地图APS服务设置-->
    <service android:name="com.amap.api.location.APSService" >
    </service>
...

```

## 完整示例

点击这里 [ReactNativeComponentDemos][0]

## 使用简介

Install the package from npm with `npm install react-native-smart-amap-location --save`.
Then, require it from your app's JavaScript files with `import Barcode from 'react-native-smart-amap-location'`.

```js
import React, {
    Component
} from 'react'
import {
    StyleSheet,
    View,
    Text,
    Alert,
    NativeAppEventEmitter,
    ActivityIndicator,
    ActivityIndicatorIOS,
    ProgressBarAndroid,
} from 'react-native'

import AMapLocation from 'react-native-smart-amap-location'
import Button from 'react-native-smart-button'
import AppEventListenerEnhance from 'react-native-smart-app-event-listener-enhance'

class AMapLocationDemo extends Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {};
    }

    componentDidMount() {
        let viewAppearCallBack = (event) => {
            AMapLocation.init(null) //使用默认定位配置
        }
        this.addAppEventListener(
            this.props.navigator.navigationContext.addListener('didfocus', viewAppearCallBack),
            NativeAppEventEmitter.addListener('amap.location.onLocationResult', this._onLocationResult)
        )
    }

    componentWillUnmount () {
        //停止并销毁定位服务
        AMapLocation.cleanUp()
    }

    render() {
        return (
            <View style={{flex: 1, justifyContent: 'center', alignItems: 'center', }}>
                <Button
                    ref={ component => this._button_1 = component }
                    touchableType={Button.constants.touchableTypes.fade}
                    style={{margin: 10, width: 300, height: 40, backgroundColor: 'red', borderRadius: 3, borderWidth: StyleSheet.hairlineWidth, borderColor: 'red', justifyContent: 'center',}}
                    textStyle={{fontSize: 17, color: 'white'}}
                    loadingComponent={
                        <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                {this._renderActivityIndicator()}
                                <Text style={{fontSize: 17, color: 'white', fontWeight: 'bold', fontFamily: '.HelveticaNeueInterface-MediumP4',}}>努力定位中</Text>
                        </View>
                    }
                    onPress={this._showReGeocode}>
                    定位逆地理编码信息
                </Button>
                <Button
                    ref={ component => this._button_2 = component }
                    touchableType={Button.constants.touchableTypes.fade}
                    style={{margin: 10, width: 300, height: 40, backgroundColor: 'red', borderRadius: 3, borderWidth: StyleSheet.hairlineWidth, borderColor: 'red', justifyContent: 'center',}}
                    textStyle={{fontSize: 17, color: 'white'}}
                    loadingComponent={
                        <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                {this._renderActivityIndicator()}
                                <Text style={{fontSize: 17, color: 'white', fontWeight: 'bold', fontFamily: '.HelveticaNeueInterface-MediumP4',}}>努力定位中</Text>
                        </View>
                    }
                    onPress={this._showLocation}>
                    定位地理编码信息
                </Button>
            </View>
        )
    }

    _onLocationResult = (result) => {
        if(result.error) {
            Alert.alert(`错误代码: ${result.error.code}, 错误信息: ${result.error.localizedDescription}`)
        }
        else {
            if(result.formattedAddress) {
                Alert.alert(`格式化地址 = ${result.formattedAddress}`)
            }
            else {
                Alert.alert(`纬度 = ${result.coordinate.latitude}, 经度 = ${result.coordinate.longitude}`)
            }
        }
        if(this._button_1.state.loading) {
            this._button_1.setState({
                loading: false,
            })
        }
        if(this._button_2.state.loading) {
            this._button_2.setState({
                loading: false,
            })
        }
    }

    //单次定位并返回逆地理编码信息
    _showReGeocode = () => {
        this._button_1.setState({
            loading: true,
        })
        AMapLocation.getReGeocode()
    }

    //单次定位并返回地理编码信息
    _showLocation = () => {
        this._button_2.setState({
            loading: true,
        })
        AMapLocation.getLocation()
    }

    _renderActivityIndicator() {
        return ActivityIndicator ? (
            <ActivityIndicator
                style={{margin: 10,}}
                animating={true}
                color={'#fff'}
                size={'small'}/>
        ) : Platform.OS == 'android' ?
            (
                <ProgressBarAndroid
                    style={{margin: 10,}}
                    color={'#fff'}
                    styleAttr={'Small'}/>

            ) :  (
            <ActivityIndicatorIOS
                style={{margin: 10,}}
                animating={true}
                color={'#fff'}
                size={'small'}/>
        )
    }

}

export default AppEventListenerEnhance(AMapLocationDemo)
```

## 定位配置参数 (ios)
* locationOptions.locationMode  设定定位精度, 默认为百米误差内
* locationOptions.pausesLocationUpdatesAutomatically  指定定位是否会被系统自动暂停。默认为YES。
* locationOptions.allowsBackgroundLocationUpdates 是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
* locationOptions.locationTimeout 指定单次定位超时时间,默认为10s。最小值是2s。注意单次定位请求前设置。
* locationOptions.reGeocodeTimeout 指定单次定位逆地理超时时间,默认为5s。最小值是2s。注意单次定位请求前设置。

## 定位配置参数 (android)
* locationOptions.locationMode  设置定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
* locationOptions.gpsFirst 设置是否gps优先，只在高精度模式下有效。默认关闭
* locationOptions.allowsBackgroundLocationUpdates 是否允许后台定位。默认为NO
* locationOptions.httpTimeout 设置网络请求超时时间。默认为30秒。在仅设备模式下无效
* locationOptions.interval 设置连续定位间隔。
* locationOptions.needAddress 设置是否返回逆地理地址信息。默认是true。
* locationOptions.onceLocation 设置是否单次定位。默认是false
* locationOptions.locationCacheEnable 设置是否开启缓存，默认为true。
* locationOptions.onceLocationLatest 设置是否等待wifi刷新，默认为false.如果设置为true,会自动变为单次定位，持续定位时不要使用。
* locationOptions.locationProtocol 设置网络请求的协议。可选HTTP或者HTTPS。默认为HTTP。
* locationOptions.sensorEnable 设置是否使用传感器。默认是false。

## 方法

* init
  * 描述: 初始化定位
  * 参数: locationOptions 类型: Object, 如使用默认值则传null

* getReGeocode
  * 描述: 单次定位并返回逆地理编码信息

* getLocation
  * 描述: 单次定位并返回地理编码信息

* startUpdatingLocation
  * 描述: 连续定位并返回位置信息. 注:连续定位的使用请参见上述的完整示例

* stopUpdatingLocation
  * 描述: 结束连接定位. 注:连续定位的使用请参见上述的完整示例

## 事件监听

* 全局事件: amap.location.onLocationResult
    * 描述: 监听并获取定位信息

[0]: https://github.com/cyqresig/ReactNativeComponentDemos
[1]: http://lbs.amap.com/api/
[2]: http://cyqresig.github.io/img/react-native-smart-amap-location-preview-ios-v1.0.0.gif
[3]: http://blog.csdn.net/jackymvc/article/details/50222503



