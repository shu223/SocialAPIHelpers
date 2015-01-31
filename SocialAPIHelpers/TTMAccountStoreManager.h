//
//  TTMAccountStoreManager.h
//  SocialAPIHelpersDemo
//
//  Created by Shuichi Tsutsumi on 2015/01/31.
//  Copyright (c) 2015年 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ACAccountStore;
@class ACAccount;


@interface TTMAccountStoreManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) ACAccountStore *store;

@end
