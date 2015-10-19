//
//  TTMAccountStoreManager.m
//  SocialAPIHelpersDemo
//
//  Created by Shuichi Tsutsumi on 2015/01/31.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMAccountStoreManager.h"
@import Accounts;


@interface TTMAccountStoreManager ()
@property (nonatomic, strong) ACAccountStore *store;
@end


@implementation TTMAccountStoreManager

+ (instancetype)sharedManager {
    
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        [instance initInstance];
    });
    
    return instance;
}

- (void)initInstance {

    self.store = [[ACAccountStore alloc] init];
}

@end
