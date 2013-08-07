//
//  TwitterAPIClient.h
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "TwitterAPIHelper.h"
#import <Accounts/Accounts.h>


@implementation TwitterAPIHelper


// =============================================================================
#pragma mark - GET users/show

+ (void)userInformationWithScreenName:(NSString *)screenName
                       requestAccount:(ACAccount *)requestAccount
                              handler:(SLRequestHandler)handler
{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/users/show.json"];
    NSDictionary *parameters = @{@"screen_name": screenName,
                                 @"include_entities": @"false"};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:parameters];
    
    request.account = requestAccount;
    
    [request performRequestWithHandler:handler];
}

+ (void)userInformationForAccount:(ACAccount *)account
                       completion:(SLRequestHandler)completion
{
    [TwitterAPIHelper userInformationWithScreenName:account.username
                                     requestAccount:account
                                            handler:completion];
}


// =============================================================================
#pragma mark - GET friends/list

+ (void)friendsListForAccount:(ACAccount *)account
                   nextCursor:(NSString *)nextCursor
                      handler:(SLRequestHandler)handler
{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/friends/list.json"];
    
    NSDictionary *parameters;
    if (nextCursor.intValue > 0) {
        
        parameters = @{@"cursor": nextCursor,
                       @"skip_status": @"true"};
    }
    else {
        
        parameters = @{@"skip_status": @"true"};
    }

    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:parameters];
    
    request.account = account;
    
    [request performRequestWithHandler:handler];
}


// =============================================================================
#pragma mark - POST statuses/update

+ (void)updateStatus:(NSString *)status
               image:(UIImage *)image
             account:(ACAccount *)account
             handler:(SLRequestHandler)handler
{
    BOOL withMedia = [image isKindOfClass:[UIImage class]] ? YES : NO;
    
    NSURL *url;
    NSDictionary *params = @{@"status": status};
    
    // 画像あり
    if (withMedia) {
        
        url = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/update_with_media.json"];
    }
    // 画像なし
    else {
        url = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/update.json"];
    }
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    
    if (withMedia) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
        [request addMultipartData:imageData
                         withName:@"media[]"
                             type:@"image/jpeg"
                         filename:@"image.jpg"];
    }
    
    request.account = account;

    [request performRequestWithHandler:handler];
}


// =============================================================================
#pragma mark - POST direct_messages/new

+ (void)sendDirectMessageToScreenName:(NSString *)screenName
                              message:(NSString *)message
                              account:(ACAccount *)account
                              handler:(SLRequestHandler)handler
{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/direct_messages/new.json"];
    
    NSDictionary *parameters = @{@"text": message,
                                 @"screen_name": screenName};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:parameters];
    
    request.account = account;
    
    [request performRequestWithHandler:handler];
}
@end
