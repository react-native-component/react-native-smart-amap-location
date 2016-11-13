# react-native-smart-amap-location

[![npm](https://img.shields.io/npm/v/react-native-smart-amap-location.svg)](https://www.npmjs.com/package/react-native-smart-amap-location)
[![npm](https://img.shields.io/npm/dm/react-native-smart-amap-location.svg)](https://www.npmjs.com/package/react-native-smart-amap-location)
[![npm](https://img.shields.io/npm/dt/react-native-smart-amap-location.svg)](https://www.npmjs.com/package/react-native-smart-amap-location)
[![npm](https://img.shields.io/npm/l/react-native-smart-amap-location.svg)](https://github.com/react-native-component/react-native-smart-amap-location/blob/master/LICENSE)

react-native 高德地图-定位SDK 插件, 支持ios与android,
关于使用高德地图SDK, 申请应用key等详细信息请点击[这里][1]

## 预览

![react-native-smart-amap-location-preview-ios][2]

## 安装

```
npm install react-native-smart-amap-location --save
```

## 安装 (iOS)

* 将RCTAMapLocation.xcodeproj作为Library拖进你的Xcode里的project中.

* 点击你的主project文件, 选择Build Phases -> Link Binary With Libraries, 将RCTAMapLocation.xcodeproj里Product目录下的libRCTAMapLocation.a拖进去.

* 同上位置, 将RCTAMapLocation目录里AMapLocationSDK目录下的AMapFoundationKit.framework拖进去.

* 同上位置, 将RCTAMapLocation目录里AMapLocationSDK目录下的AMapLocationKit.framework拖进去.

* 同上位置, 选择Add items, 将系统库libstdc++.6.0.9.tbd加入.

* 同上位置, 选择Add items, 将系统库libc++.tbd加入.

* 同上位置, 选择Add items, 将系统库libz.tbd加入.

* 同上位置, 选择Add items, 将系统库Security.framework加入.

* 同上位置, 选择Add items, 将系统库CoreTelephony.framework加入.

* 同上位置, 选择Add items, 将系统库SystemConfiguration.framework加入.

* 同上位置, 选择Add items, 将系统库JavaScriptCore.framework加入.

* 选择Build Settings, 找到Header Search Paths, 确认其中包含$(SRCROOT)/../../../react-native/React, 模式为recursive.

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
project(':react-native-smart-amap-location').projectDir = new File(rootProject.projectDir, '../react-native-smart-amap-location/android')
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

## Full Demo

see [ReactNativeComponentDemos][0]

## Usage

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

## 方法

* init
  * 描述: 初始化定位
  * 参数: locationOptions 类型: Object, 如使用默认值则传null

* getReGeocode
  * 描述: 单次定位并返回逆地理编码信息

* getLocation
  * 描述: 单次定位并返回地理编码信息

## 事件监听

* 事件: amap.location.onLocationResult
    * 描述: 监听获取定位返回信息

[0]: https://github.com/cyqresig/ReactNativeComponentDemos
[1]: http://lbs.amap.com/api/
[2]: http://cyqresig.github.io/img/react-native-smart-amap-location-preview-ios-v1.0.0.gif



