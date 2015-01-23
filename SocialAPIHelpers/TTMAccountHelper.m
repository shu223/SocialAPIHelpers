//
//  AccountHelper.m
//  SocialAPIHelpers
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMAccountHelper.h"
#import <Social/Social.h>


@implementation TTMAccountHelper

+ (void)requestAccessToAccountsWithType:(NSString *)typeIdentifier
                                options:(NSDictionary *)options
                                  store:(ACAccountStore *)store
                                handler:(void (^)(NSError *error))handler
{
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
                 
                 error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                             code:1
                                         userInfo:@{NSLocalizedDescriptionKey: @"not granted."}];
             }
             // granted!
             else {
                 
                 // http://stackoverflow.com/questions/13349187/strange-behaviour-when-trying-to-use-twitter-acaccount
                 if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
                     
                     ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                     
                     NSArray *accounts = [store accountsWithAccountType:accountType];
                     
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

+ (void)requestAccessToTwitterAccountsWithStore:(ACAccountStore *)store
                                        handler:(void (^)(NSError *error))handler
{
    [TTMAccountHelper requestAccessToAccountsWithType:ACAccountTypeIdentifierTwitter
                                           options:nil
                                             store:store
                                           handler:handler];
}

+ (ACAccount *)facebookAccountWithAccountStore:(ACAccountStore *)store {
    
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    return [[store accountsWithAccountType:accountType] lastObject];
}

+ (NSArray *)twitterAccountsWithAccountStore:(ACAccountStore *)store {
    
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    return [store accountsWithAccountType:accountType];
}

+ (void)showAccountSelectWithStore:(ACAccountStore *)store
                          delegate:(id<UIActionSheetDelegate>)delegate
                            inView:(UIView *)view
{
    NSString *title = NSLocalizedString(@"Choose Twitter Account", nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:delegate
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    NSArray *accounts = [TTMAccountHelper twitterAccountsWithAccountStore:store];
    
    for (ACAccount *anAccount in accounts) {
        
        [actionSheet addButtonWithTitle:anAccount.username];
    }
    
    [actionSheet showInView:view];
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