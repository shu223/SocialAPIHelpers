//
//  ViewController.m
//  SocialAPIHelpersDemo
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "AccountHelper.h"
#import "TwitterAPIHelper.h"
#import "SocialHelper.h"
#import "SVProgressHUD.h"


@interface ViewController ()
<UIActionSheetDelegate>
@property (nonatomic, weak) IBOutlet UIButton *userInfoBtn;
@property (nonatomic, strong) ACAccountStore *store;
@property (nonatomic, strong) ACAccount *selectedAccount;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak ViewController *weakSelf = self;
    
    self.store = [[ACAccountStore alloc] init];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


// =============================================================================
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSArray *accounts = [AccountHelper twitterAccountsWithAccountStore:self.store];
    self.selectedAccount = [accounts objectAtIndex:buttonIndex];
}

@end
