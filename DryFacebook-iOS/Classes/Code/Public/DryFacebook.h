//
//  DryFacebook.h
//  DryFacebook
//
//  Created by Ruiying Duan on 2019/6/3.
//

#import <Foundation/Foundation.h>
#import "DryFacebookUser.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DryFacebookCode(状态码)
typedef NS_ENUM(NSInteger, DryFacebookCode) {
    /// 成功
    kDryFacebookCodeSuccess,
    /// 用户取消
    kDryFacebookCodeCancel,
    /// 其他错误
    kDryFacebookCodeOther,
};

#pragma mark - Block
/// 用户信息回调
typedef void (^BlockDryFacebookUser) (DryFacebookUser *_Nullable user, DryFacebookCode code);

#pragma mark - DryFacebook
@interface DryFacebook : NSObject

/// @说明 初始化客户端
/// @注释 在 application:applicationdidFinishLaunchingWithOptions: 调用
/// @参数 application:    注释方法中的application参数
/// @参数 launchOptions:  注释方法中的launchOptions参数
/// @返回 void
+ (void)registerSDK:(UIApplication *)application launchOptions:(nullable NSDictionary *)launchOptions;

/// @说明 Facebook通过URL启动App时传递的数据(必须调用，否则登录成功后无回调)
/// @注释 需要在 application:openURL:options: 中调用
/// @参数 url:            注释方法中的url参数
/// @参数 application:    注释方法中的application参数
/// @参数 options:        注释方法中的options参数
/// @返回 BOOL
+ (BOOL)handleOpenURL:(NSURL *)url
          application:(UIApplication *)application
              options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

/// @说明 登录
/// @注释 登录成功后缓存用户的信息和令牌，未 singOut 或 disconnect，再次登录不会启动 Facebook 直接返回用户信息
/// @参数 completion: 用户信息回调
/// @返回 void
+ (void)login:(BlockDryFacebookUser)completion;

/// @说明 退出登录
/// @返回 void
+ (void)logout;

@end

NS_ASSUME_NONNULL_END
