//
//  TwitterViewController.m
//  SocialAPIHelpersDemo
//
//  Created by Shuichi Tsutsumi on 2015/01/31.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "TwitterViewController.h"
#import "SocialAPIHelpers.h"
#import "SVProgressHUD.h"


@interface TwitterViewController ()

@end


@implementation TwitterViewController

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

- (IBAction)retrieveUserInformation {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [TTMTwitterAPIHelper userInformationForAccount:self.selectedAccount
                                           handler:
     ^(id result, NSError *error) {
         
         [SVProgressHUD dismiss];
         
         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         NSLog(@"result:%@", result);
     }];
}

- (IBAction)readHomeTimeline {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [TTMTwitterAPIHelper homeTimelineForAccount:self.selectedAccount
                                        handler:
     ^(id result, NSError *error) {
         
         [SVProgressHUD dismiss];
         
         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         NSLog(@"result:%@", result);
     }];
}

- (IBAction)readUserTimeline {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [TTMTwitterAPIHelper userTimelineWithScreenName:@"shu223"
                                            account:self.selectedAccount
                                            handler:
     ^(id result, NSError *error) {
         
         [SVProgressHUD dismiss];
         
         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         NSLog(@"result:%@", result);
     }];
}

@end
