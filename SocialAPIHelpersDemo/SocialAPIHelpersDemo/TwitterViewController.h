//
//  TwitterViewController.h
//  SocialAPIHelpersDemo
//
//  Created by Shuichi Tsutsumi on 2015/01/31.
//  Copyright (c) 2015年 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ACAccount;


@interface TwitterViewController : UIViewController

@property (nonatomic, strong) ACAccount *selectedAccount;

@end
