//
//  AccountHelper.h
//  SocialAPIHelpers
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>


#define kFBPermissionKeyEmail           @"email"
#define kFBPermissionKeyXMPPLogin       @"xmpp_login"
#define kFBPermissionKeyBasicInfo       @"basic_info"
#define kFBPermissionKeyReadStream      @"read_stream"
#define kFBPermissionKeyPublishStream   @"publish_stream"


@interface TTMAccountHelper : NSObject

+ (void)requestAccessToAccountsWithType:(NSString *)typeIdentifier
                                options:(NSDictionary *)options
                                  store:(ACAccountStore *)store
                                handler:(void (^)(NSError *error))handler;

+ (void)requestAccessToTwitterAccountsWithStore:(ACAccountStore *)store
                                        handler:(void (^)(NSError *error))handler;

+ (ACAccount *)facebookAccountWithAccountStore:(ACAccountStore *)store;
+ (NSArray *)twitterAccountsWithAccountStore:(ACAccountStore *)store;

+ (void)showAccountSelectWithStore:(ACAccountStore *)store
                          delegate:(id<UIActionSheetDelegate>)delegate
                            inView:(UIView *)view;


#pragma mark - Methods to retrieve options

+ (NSDictionary *)optionsToInviteViaFacebookWithAppId:(NSString *)appID;

+ (NSDictionary *)optionsToReadBasicInfoOnFacebookWithAppId:(NSString *)appID;

+ (NSDictionary *)optionsToReadStreamOnFacebookWithAppId:(NSString *)appID;

+ (NSDictionary *)optionsToWriteOnFacebookWithAppId:(NSString *)appID;

@end
