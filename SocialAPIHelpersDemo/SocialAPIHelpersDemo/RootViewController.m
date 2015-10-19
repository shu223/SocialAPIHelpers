//
//  RootViewController.m
//  SocialAPIHelpersDemo
//
//  Created by Shuichi Tsutsumi on 2015/01/31.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "RootViewController.h"
#import "SocialAPIHelpers.h"
#import "SVProgressHUD.h"
#import "TwitterViewController.h"


#define kFacebookAppId @"117100645022644"


@interface RootViewController ()
<UIActionSheetDelegate>
@property (nonatomic, strong) ACAccount *selectedAccount;
@end


@implementation RootViewController

- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[TwitterViewController class]]) {
    
        ((TwitterViewController *)segue.destinationViewController).selectedAccount = self.selectedAccount;
    }
}


// =============================================================================
#pragma mark - Private

- (void)requestAccessToFacebook {

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary *options = [TTMAccountHelper optionsToReadStreamOnFacebookWithAppId:kFacebookAppId];
    
    [TTMAccountHelper requestAccessToAccountsWithType:ACAccountTypeIdentifierFacebook
                                              options:options
                                              handler:
     ^(NSError *error) {
         
         
         if (error) {
             NSLog(@"error:%@", error);
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
             return;
         }
         
         [SVProgressHUD dismiss];
         [self performSegueWithIdentifier:@"ShowFacebook" sender:self];
     }];
}

- (void)requestAccessToTwitter {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [TTMAccountHelper requestAccessToTwitterAccountsWithHandler:
     ^(NSError *error) {
         
         if (error) {
             NSLog(@"error:%@", error);
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
             return;
         }
         
         [SVProgressHUD dismiss];
         
         NSArray<ACAccount *> *accounts = [TTMAccountHelper twitterAccounts];
         
         if (accounts.count >= 2) {
             
             [TTMAccountHelper showAccountSelectWithDelegate:self
                                                      inView:self.view];
         }
         else if (accounts.count == 1) {
             
             self.selectedAccount = accounts[0];
             [self performSegueWithIdentifier:@"ShowTwitter" sender:self];
         }
     }];
}


// =============================================================================
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSArray<ACAccount *> *accounts = [TTMAccountHelper twitterAccounts];
    self.selectedAccount = accounts[buttonIndex];

    [self performSegueWithIdentifier:@"ShowTwitter" sender:self];
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)twitterBtnTapped:(id)sender {
    
    [self requestAccessToTwitter];
}

- (IBAction)facebookBtnTapped:(id)sender {
    
    [self requestAccessToFacebook];
}

@end
