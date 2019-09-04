//
//  DryFacebookUser.m
//  DryFacebook
//
//  Created by Ruiying Duan on 2019/6/3.
//

#import "DryFacebookUser.h"

@implementation DryFacebookUser

/// 构造
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

/// 析构
- (void)dealloc {
    
}

/// 编解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
    }
    
    return self;
}

@end
