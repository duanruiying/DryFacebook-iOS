//
//  DryFacebookUser.h
//  DryFacebook
//
//  Created by Ruiying Duan on 2019/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DryFacebookUser : NSObject <NSCoding>

@property (nonatomic, readwrite, nonnull, copy) NSString *userID;
@property (nonatomic, readwrite, nonnull, copy) NSString *email;
@property (nonatomic, readwrite, nonnull, copy) NSString *firstName;
@property (nonatomic, readwrite, nonnull, copy) NSString *lastName;
@property (nonatomic, readwrite, nonnull, copy) NSString *name;
@property (nonatomic, readwrite, nonnull, copy) NSString *avatarUrl;

@end

NS_ASSUME_NONNULL_END
