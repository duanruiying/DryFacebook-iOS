# DryFacebook-iOS
iOS: Facebbok功能集成简化(登录)
* [集成文档地址](https://developers.facebook.com/docs/facebook-login)
* [手动集成](https://developers.facebook.com/docs/facebook-login/ios?sdk=fbsdk)
* [cocoapods](https://developers.facebook.com/docs/facebook-login/ios?sdk=cocoapods)

## Prerequisites
* iOS 10.0+
* ObjC、Swift

## Installation
* pod 'DryFacebook-iOS'

## App工程配置
* 为URL Types 添加回调scheme(identifier:""、URL Schemes:"fb+AppID")
* info.plist文件属性LSApplicationQueriesSchemes中增加fbapi、fb-messenger-share-api、fbauth2、fbshareextension字段
* info.plist文件新增两个属性:
```
<key>FacebookAppID</key>
<string>应用程序在fb的appid</string>
<key>FacebookDisplayName</key>
<string>应用程序名称</string>
```

## Features
### SDK配置
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DryFacebook registerSDK:application launchOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [DryFacebook handleOpenURL:url application:app options:options];
    return YES;
}
```
### 授权、获取用户信息
```
[DryFacebook login:^(DryFacebookUser * _Nullable user, DryFacebookCode code) {

}];
```
