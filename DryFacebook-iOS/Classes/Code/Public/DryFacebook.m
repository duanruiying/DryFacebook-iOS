//
//  DryFacebook.m
//  DryFacebook
//
//  Created by Ruiying Duan on 2019/6/3.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DryFacebook.h"

#pragma mark - DryFacebook
@implementation DryFacebook

/// 初始化客户端
+ (void)registerSDK:(UIApplication *)application launchOptions:(nullable NSDictionary *)launchOptions {
    
    /// 注册SDK
    FBSDKApplicationDelegate *delegate = [FBSDKApplicationDelegate sharedInstance];
    [delegate application:application didFinishLaunchingWithOptions:launchOptions];
    
    /// 设置
    [FBSDKSettings setAutoInitEnabled:YES];
    [FBSDKSettings setAutoLogAppEventsEnabled:NO];
    [FBSDKSettings setAdvertiserIDCollectionEnabled:NO];
    [FBSDKApplicationDelegate initializeSDK:nil];
    
    /// Profiled自动跟随Token更新
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

/// Facebook通过URL启动App时传递的数据(必须调用，否则登录成功后无回调)
+ (BOOL)handleOpenURL:(NSURL *)url
          application:(UIApplication *)application
              options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    FBSDKApplicationDelegate *delegate = [FBSDKApplicationDelegate sharedInstance];
    BOOL result = [delegate application:application
                                openURL:url
                      sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                             annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return result;
}

/// 登录
+ (void)login:(BlockDryFacebookUser)completion {
    
    /// 检查数据
    if (completion == nil) {
        return;
    }
    
    /// 应用一次只能允许一位用户登录
    /// 我们会以 [FBSDKAccessToken currentAccessToken] 代表登录应用的每位用户
    /// FBSDKLoginManager 将为您设置此口令，且在设置 currentAccessToken 时，还会自动将口令写入 keychain 缓存
    /// FBSDKAccessToken 包含 userID，您可以使用此编号识别用户
    FBSDKAccessToken *currentAccessToken = [FBSDKAccessToken currentAccessToken];
    DryFacebookUser *localUser = [DryFacebook readUserFromLocal];
    if (currentAccessToken
        && !currentAccessToken.isExpired
        && currentAccessToken.userID
        && localUser
        && localUser.userID
        && [currentAccessToken.userID isEqualToString:localUser.userID]) {
        
        /// 回调
        completion(localUser, kDryFacebookCodeSuccess);
        return;
    }
    
    /// 设置参数
    NSMutableArray *permissions = [[NSMutableArray alloc] init];
    [permissions addObject:@"public_profile"];
    [permissions addObject:@"email"];
    
    /// 获取用户信息
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    [manager logInWithPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        
        /// 回调
        if (error) {
            completion(nil, kDryFacebookCodeOther);
        }else if (result.isCancelled) {
            completion(nil, kDryFacebookCodeCancel);
        }else {
            [DryFacebook user:result completion:completion];
        }
    }];
}

/// 登录成功后获取用户信息
+ (void)user:(FBSDKLoginManagerLoginResult *)result completion:(BlockDryFacebookUser)completion {
    
    /// 初始化用户数据
    DryFacebookUser *user = [[DryFacebookUser alloc] init];
    
    /// 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *key = @"fields";
    NSString *value = @"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified";
    [params setValue:value forKey:key];
    
    /// 获取用户信息
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:result.token.userID parameters:params HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        /// 数据检查
        if (error || !result || ![result isKindOfClass:[NSDictionary class]]) {
            completion(nil, kDryFacebookCodeOther);
        }else {
            //NSLog(@"%@", result);
            /// 用户基本信息解析
            if ([[result allKeys] containsObject:@"email"]) {
                user.email = [result valueForKey:@"email"];
            }
            if ([[result allKeys] containsObject:@"id"]) {
                user.userID = [result valueForKey:@"id"];
            }
            if ([[result allKeys] containsObject:@"first_name"]) {
                user.firstName = [result valueForKey:@"first_name"];
            }
            if ([[result allKeys] containsObject:@"last_name"]) {
                user.lastName = [result valueForKey:@"last_name"];
            }
            if ([[result allKeys] containsObject:@"name"]) {
                user.name = [result valueForKey:@"name"];
            }
            
            /// 用户头像解析
            id picture = nil;
            if ([[result allKeys] containsObject:@"picture"]) {
                picture = [result valueForKey:@"picture"];
            }
            id data = nil;
            if (picture && [picture isKindOfClass:[NSDictionary class]] && [[picture allKeys] containsObject:@"data"]) {
                data = [picture valueForKey:@"data"];
            }
            if (data && [data isKindOfClass:[NSDictionary class]] && [[data allKeys] containsObject:@"url"]) {
                user.avatarUrl = [data valueForKey:@"url"];
            }
            
            /// 保存用户数据到本地
            [DryFacebook saveUserToLocal:user];
            
            /// 回调
            completion(user, kDryFacebookCodeSuccess);
        }
    }];
}

/// 退出登录
+ (void)logout {
    
    /// 退出登录
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    [manager logOut];
    
    /// 移除本地数据
    [DryFacebook saveUserToLocal:nil];
}

#pragma mark - 用户数据持久化
/// 本地文件路径
+ (nonnull NSString *)dbPath {
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:@"DryFacebook"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:@"user"];
}

/// 保存用户数据到本地
+ (void)saveUserToLocal:(nullable DryFacebookUser *)user {
    
    NSString *dbPath = [DryFacebook dbPath];
    if (user == nil) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:dbPath error:nil];
    }else {
        [NSKeyedArchiver archiveRootObject:user toFile:dbPath];
    }
}

/// 读取本地用户数据
+ (nullable DryFacebookUser *)readUserFromLocal {
    
    NSString *dbPath = [DryFacebook dbPath];
    DryFacebookUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:dbPath];
    return user;
}

@end
