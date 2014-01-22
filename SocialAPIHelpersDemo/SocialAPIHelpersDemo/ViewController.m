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
    
    __weak ViewController *weakSelf = self;

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSDictionary *options = [AccountHelper optionsToReadStreamOnFacebookWithAppId:kFacebookAppId];
        
        [AccountHelper requestAccessToAccountsWithType:ACAccountTypeIdentifierFacebook
                                               options:options
                                                 store:weakSelf.store
                                               handler:
         ^(NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [SVProgressHUD dismiss];
                 
                 if (error) {
                     
                     NSLog(@"error:%@", error);
                     
                     return;
                 }

                 // start requesting access to twitter
                 [weakSelf requestAccessToTwitter];
             });
         }];
    });
}

- (void)requestAccessToTwitter {

    __weak ViewController *weakSelf = self;

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [AccountHelper requestAccessToTwitterAccountsWithStore:self.store
                                                       handler:
         ^(NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [SVProgressHUD dismiss];
                 
                 if (error) {
                     
                     NSLog(@"error:%@", error);
                     
                     return;
                 }
                 
                 NSArray *accounts = [AccountHelper twitterAccountsWithAccountStore:self.store];
                 
                 if ([accounts count] >= 2) {
                     
                     [AccountHelper showAccountSelectWithStore:weakSelf.store
                                                      delegate:weakSelf
                                                        inView:weakSelf.view];
                 }
                 else if ([accounts count] == 1) {
                     
                     weakSelf.selectedAccount = accounts[0];
                 }
             });
         }];
    });
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)retrieveUserInformation {

    __weak ViewController *weakSelf = self;

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
       
        [TwitterAPIHelper userInformationForAccount:weakSelf.selectedAccount
                                            handler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{

                 [SVProgressHUD dismiss];
                 
                 if (error) {
                     
                     NSLog(@"error:%@", error);
                     
                     return;
                 }
                 
                 [SocialHelper parseSLRequestResponseData:responseData
                                                  handler:
                  ^(id result, NSError *error) {
                      
                      if (error) {
                          
                          NSLog(@"error:%@", error);
                          
                          return;
                      }
                      
                      NSLog(@"result:%@", result);
                  }];;
             });
         }];
    });
}

- (IBAction)readHomeTimeline {

    __weak ViewController *weakSelf = self;

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [TwitterAPIHelper homeTimelineForAccount:weakSelf.selectedAccount
                                         handler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [SVProgressHUD dismiss];
                 
                 if (error) {
                     
                     NSLog(@"error:%@", error);
                     
                     return;
                 }
                 
                 [SocialHelper parseSLRequestResponseData:responseData
                                                  handler:
                  ^(id result, NSError *error) {
                      
                      if (error) {
                          
                          NSLog(@"error:%@", error);
                          
                          return;
                      }
                      
                      NSLog(@"result:%@", result);
                  }];;
             });
         }];
    });
}

- (IBAction)readUserTimeline {
    
    __weak ViewController *weakSelf = self;

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [TwitterAPIHelper userTimelineWithScreenName:@"shu223"
                                             account:weakSelf.selectedAccount
                                             handler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [SVProgressHUD dismiss];
                 
                 if (error) {
                     
                     NSLog(@"error:%@", error);
                     
                     return;
                 }
                 
                 [SocialHelper parseSLRequestResponseData:responseData
                                                  handler:
                  ^(id result, NSError *error) {
                      
                      if (error) {
                          
                          NSLog(@"error:%@", error);
                          
                          return;
                      }
                      
                      NSLog(@"result:%@", result);
                  }];;
             });
         }];
    });
}

- (IBAction)readNewsFeed {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        ACAccount *account = [AccountHelper facebookAccountWithAccountStore:self.store];
        
        [FacebookAPIHelper newsfeedForAccount:account
                                      handler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [SVProgressHUD dismiss];
                 
                 [SocialHelper parseSLRequestResponseData:responseData
                                                  handler:
                  ^(id result, NSError *error) {
                      
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
                  }];;
             });
         }];
    });
}


// =============================================================================
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSArray *accounts = [AccountHelper twitterAccountsWithAccountStore:self.store];
    self.selectedAccount = [accounts objectAtIndex:buttonIndex];
}

@end
