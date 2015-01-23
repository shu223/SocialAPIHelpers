//
//  ViewController.m
//  SocialAPIHelpersDemo
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "SocialAPIHelpers.h"
#import "SVProgressHUD.h"


#define kFacebookAppId @"117100645022644"


@interface ViewController ()
<UIActionSheetDelegate>
@property (nonatomic, strong) ACAccountStore *store;
@property (nonatomic, strong) ACAccount *selectedAccount;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.store = [[ACAccountStore alloc] init];
    
    [self requestAccessToFacebook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =============================================================================
#pragma mark - Private

- (void)requestAccessToFacebook {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary *options = [TTMAccountHelper optionsToReadStreamOnFacebookWithAppId:kFacebookAppId];
    
    [TTMAccountHelper requestAccessToAccountsWithType:ACAccountTypeIdentifierFacebook
                                           options:options
                                             store:self.store
                                           handler:
     ^(NSError *error) {
         
         [SVProgressHUD dismiss];
         
         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         // start requesting access to twitter
         [self requestAccessToTwitter];
     }];
}

- (void)requestAccessToTwitter {

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [TTMAccountHelper requestAccessToTwitterAccountsWithStore:self.store
                                                   handler:
     ^(NSError *error) {
         
         [SVProgressHUD dismiss];
         
         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         NSArray *accounts = [TTMAccountHelper twitterAccountsWithAccountStore:self.store];
         
         if ([accounts count] >= 2) {
             
             [TTMAccountHelper showAccountSelectWithStore:self.store
                                              delegate:self
                                                inView:self.view];
         }
         else if ([accounts count] == 1) {
             
             self.selectedAccount = accounts[0];
         }
     }];
}


// =============================================================================
#pragma mark - IBAction

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

- (IBAction)readNewsFeed {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    ACAccount *account = [TTMAccountHelper facebookAccountWithAccountStore:self.store];

    [TTMFacebookAPIHelper newsfeedForAccount:account
                                     handler:
     ^(id result, NSError *error) {
         
         [SVProgressHUD dismiss];
         
         if (error) {
             NSLog(@"error:%@", error);
             return;
         }
         
         NSArray *feeds = result[@"data"];
         
         for (NSDictionary *aFeed in feeds) {
             
             NSDictionary *fromDic = aFeed[@"from"];
             NSArray *likes = aFeed[@"likes"][@"data"];
             
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


// =============================================================================
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSArray *accounts = [TTMAccountHelper twitterAccountsWithAccountStore:self.store];
    self.selectedAccount = [accounts objectAtIndex:buttonIndex];
}

@end
