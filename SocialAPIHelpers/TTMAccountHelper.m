//
//  AccountHelper.m
//  SocialAPIHelpers
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMAccountHelper.h"
@import Social;
@import Accounts;
#import "TTMAccountStoreManager.h"


NSString * const TTMAccountErrorDomain = @"com.shu223.SocialAPIHelpers.TTMAccountHelper";


@implementation TTMAccountHelper

+ (NSError *)errorWithCode:(TTMAccountError)code message:(NSString *)message {
    
    NSError *err = [NSError errorWithDomain:TTMAccountErrorDomain
                                       code:code
                                   userInfo:@{NSLocalizedDescriptionKey: message}];
    return err;
}

+ (void)requestAccessToAccountsWithType:(NSString *)typeIdentifier
                                options:(NSDictionary *)options
                                handler:(void (^)(NSError *error))handler
{
    ACAccountStore *store = [[TTMAccountStoreManager sharedManager] store];
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:typeIdentifier];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [store requestAccessToAccountsWithType:type
                                       options:options
                                    completion:
         ^(BOOL granted, NSError *error) {
             
             if (error) {

             }
             // no error, but not granted
             else if (!granted) {
                 
                 error = [NSError errorWithDomain:NSStringFromClass([self class])
                                             code:TTMAccountErrorNotGranted
                                         userInfo:@{NSLocalizedDescriptionKey: @"not granted"}];
             }
             // granted!
             else {

                 ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:typeIdentifier];
                 NSArray *accounts = [store accountsWithAccountType:accountType];

                 if ([accounts count] == 0) {
                     
                     error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:TTMAccountErrorNoAccounts
                                             userInfo:@{NSLocalizedDescriptionKey: @"no accounts"}];
                 }
                 // http://stackoverflow.com/questions/13349187/strange-behaviour-when-trying-to-use-twitter-acaccount
                 else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
                     
                     for (ACAccount *anAccount in accounts) {
                         
                         anAccount.accountType = accountType;
                     }
                 }
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 handler(error);
             });
         }];
    });
}

+ (void)requestAccessToTwitterAccountsWithHandler:(void (^)(NSError *error))handler
{
    [TTMAccountHelper requestAccessToAccountsWithType:ACAccountTypeIdentifierTwitter
                                           options:nil
                                           handler:handler];
}

+ (ACAccount *)facebookAccount {
    
    ACAccountStore *store = [[TTMAccountStoreManager sharedManager] store];

    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    return [[store accountsWithAccountType:accountType] lastObject];
}

+ (NSArray *)twitterAccounts {
    
    ACAccountStore *store = [[TTMAccountStoreManager sharedManager] store];

    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    return [store accountsWithAccountType:accountType];
}

+ (void)showAccountSelectWithDelegate:(id<UIActionSheetDelegate>)delegate
                               inView:(UIView *)view
{
    NSString *title = NSLocalizedString(@"Choose Twitter Account", nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:delegate
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    NSArray *accounts = [TTMAccountHelper twitterAccounts];
    
    for (ACAccount *anAccount in accounts) {
        
        [actionSheet addButtonWithTitle:anAccount.username];
    }
    
    [actionSheet showInView:view];
}

+ (void)renewCredentialsForFacebookAccountWithCompletion:(void (^)(NSError *error))completion
{
    ACAccountStore *store = [[TTMAccountStoreManager sharedManager] store];

    [store renewCredentialsForAccount:[self facebookAccount]
                           completion:
     ^(ACAccountCredentialRenewResult renewResult, NSError *error) {
         
         if (error) {

             completion(error);
         }
         else {
             
             switch (renewResult) {
                     
                 case ACAccountCredentialRenewResultRenewed:
                 {
                     NSLog(@"ACAccountCredentialRenewResultRenewed");
                     completion(nil);
                     
                     break;
                 }
                 case ACAccountCredentialRenewResultRejected:
                 {
                     NSLog(@"ACAccountCredentialRenewResultRejected");
                     NSError *err = [self errorWithCode:TTMAccountErrorCredentialNotRenewed
                                                message:@"Failed to renew credentials: ACAccountCredentialRenewResultRejected"];
                     completion(err);
                     
                     break;
                 }
                 case ACAccountCredentialRenewResultFailed:
                 {
                     NSLog(@"ACAccountCredentialRenewResultFailed");
                     NSError *err = [self errorWithCode:TTMAccountErrorCredentialNotRenewed
                                                message:@"Failed to renew credentials: ACAccountCredentialRenewResultFailed"];
                     completion(err);
                     
                     break;
                 }
                 default:
                 {
                     NSError *err = [self errorWithCode:TTMAccountErrorCredentialNotRenewed
                                                message:@"Failed to renew credentials: Other"];
                     completion(err);
                     break;
                 }
             }
         }
     }];
}



// =============================================================================
#pragma mark - Methods to retrieve options

+ (NSDictionary *)optionsToInviteViaFacebookWithAppId:(NSString *)appID {
    
    NSAssert([appID length], @"Facebook App ID must be set.");
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey: appID,
                              ACFacebookPermissionsKey: @[kFBPermissionKeyEmail, kFBPermissionKeyXMPPLogin]
                              };
    
    return options;
}

+ (NSDictionary *)optionsToReadBasicInfoOnFacebookWithAppId:(NSString *)appID {
    
    NSAssert([appID length], @"Facebook App ID must be set.");
    
    // http://stackoverflow.com/questions/16472383/parse-facebook-login-app-must-ask-for-basic-read-permission
    NSDictionary *options = @{
                              ACFacebookAppIdKey: appID,
                              ACFacebookPermissionsKey: @[kFBPermissionKeyBasicInfo]
                              };
    
    return options;
}

+ (NSDictionary *)optionsToReadStreamOnFacebookWithAppId:(NSString *)appID {

    NSAssert([appID length], @"Facebook App ID must be set.");
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey: appID,
                              ACFacebookPermissionsKey: @[kFBPermissionKeyBasicInfo, kFBPermissionKeyReadStream]
                              };
    
    return options;
}

+ (NSDictionary *)optionsToWriteOnFacebookWithAppId:(NSString *)appID {
    
    NSAssert([appID length], @"Facebook App ID must be set.");
    
    // 投稿用のoptionを作成
    NSDictionary *options = @{
                              ACFacebookAppIdKey: appID,
                              ACFacebookPermissionsKey: @[kFBPermissionKeyPublishStream],
                              ACFacebookAudienceKey : ACFacebookAudienceFriends,
                              };
    
    return options;
}

@end
