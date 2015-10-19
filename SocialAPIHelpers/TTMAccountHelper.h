//
//  AccountHelper.h
//  SocialAPIHelpers
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>


extern NSString * const TTMAccountErrorDomain;

typedef NS_ENUM(unsigned int, TTMAccountError) {
    TTMAccountErrorUnknown = 0,
    TTMAccountErrorNotGranted,
    TTMAccountErrorNoAccounts,
    TTMAccountErrorCredentialNotRenewed
};


#define kFBPermissionKeyEmail           @"email"
#define kFBPermissionKeyXMPPLogin       @"xmpp_login"
#define kFBPermissionKeyBasicInfo       @"basic_info"
#define kFBPermissionKeyReadStream      @"read_stream"
#define kFBPermissionKeyPublishStream   @"publish_stream"


@interface TTMAccountHelper : NSObject

+ (void)requestAccessToAccountsWithType:(NSString *)typeIdentifier
                                options:(NSDictionary *)options
                                handler:(void (^)(NSError *error))handler;

+ (void)requestAccessToTwitterAccountsWithHandler:(void (^)(NSError *error))handler;

+ (ACAccount *)facebookAccount;
+ (NSArray<ACAccount *> *)twitterAccounts;

+ (void)showAccountSelectWithDelegate:(id<UIActionSheetDelegate>)delegate
                               inView:(UIView *)view;

+ (void)renewCredentialsForFacebookAccountWithCompletion:(void (^)(NSError *error))completion;


#pragma mark - Methods to retrieve options

+ (NSDictionary *)optionsToInviteViaFacebookWithAppId:(NSString *)appID;

+ (NSDictionary *)optionsToReadBasicInfoOnFacebookWithAppId:(NSString *)appID;

+ (NSDictionary *)optionsToReadStreamOnFacebookWithAppId:(NSString *)appID;

+ (NSDictionary *)optionsToWriteOnFacebookWithAppId:(NSString *)appID;

@end
