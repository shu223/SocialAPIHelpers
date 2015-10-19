//
//  FacebookViewController.m
//  SocialAPIHelpersDemo
//
//  Created by Shuichi Tsutsumi on 2015/01/31.
//  Copyright (c) 2015年 Shuichi Tsutsumi. All rights reserved.
//

#import "FacebookViewController.h"
#import "SocialAPIHelpers.h"
#import "SVProgressHUD.h"


@interface FacebookViewController ()

@end


@implementation FacebookViewController

- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)closeBtnTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)readNewsFeed {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    ACAccount *account = [TTMAccountHelper facebookAccount];
    
    [TTMFacebookAPIHelper newsfeedForAccount:account
                                     handler:
     ^(id result, NSError *error) {
         
         [SVProgressHUD dismiss];
         
         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         NSArray<NSDictionary *> *feeds = result[@"data"];
         
         for (NSDictionary *aFeed in feeds) {
             
             NSDictionary *fromDic = aFeed[@"from"];
             NSArray<NSDictionary *> *likes = aFeed[@"likes"][@"data"];
             
             NSLog(@"from:%@, message:%@, likes:%lu",
                   fromDic[@"name"],
                   aFeed[@"message"],
                   [likes count]);
             NSLog(@"type:%@, title:%@, link:%@, picture:%@, description:%@\n\n",
                   aFeed[@"type"],
                   aFeed[@"name"],
                   aFeed[@"link"],
                   aFeed[@"picture"],
                   aFeed[@"description"]);
         }
     }];
}

- (IBAction)getFriends {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    ACAccount *account = [TTMAccountHelper facebookAccount];
    
    [TTMFacebookAPIHelper friendsForAccount:account
                                    handler:
     ^(NSArray<TTMFacebookProfile *> *friends, NSDictionary *result, NSError *error) {

         [SVProgressHUD dismiss];

         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         NSLog(@"friends:%@, result:%@", friends, result);
     }];
}

@end
