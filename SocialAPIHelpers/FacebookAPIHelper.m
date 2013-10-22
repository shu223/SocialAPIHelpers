//
//  FacebookAPIHelper.m
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "FacebookAPIHelper.h"


#define kBaseURL @"https://graph.facebook.com"


@implementation FacebookAPIHelper

// =============================================================================
#pragma mark - User

// The user's profile
+ (void)userProfileWithUserId:(NSString *)userId
               requestAccount:(ACAccount *)requestAccount
                      handler:(SLRequestHandler)handler
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", kBaseURL, userId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];

    request.account = requestAccount;
    
    [request performRequestWithHandler:handler];
}

+ (void)userProfileForAccount:(ACAccount *)account
                      handler:(SLRequestHandler)handler
{
    // https://developers.facebook.com/docs/reference/api/using-pictures/
    NSString *urlStr = [NSString stringWithFormat:@"%@/me", kBaseURL];
    NSURL *url = [NSURL URLWithString:urlStr];

    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];
    
    request.account = account;
    
    [request performRequestWithHandler:handler];
}

// The user's friends.
+ (void)friendsForAccount:(ACAccount *)account
                  handler:(SLRequestHandler)handler
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/me/friends", kBaseURL];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];

    request.account = account;
    
    [request performRequestWithHandler:handler];
}


// =============================================================================
#pragma mark - Pictures

+ (NSString *)profilePictureURLForUserId:(NSString *)userId {

    NSString *urlStr = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", userId];
    
    return urlStr;
}


// =============================================================================
#pragma mark - News Feed

+ (void)newsfeedForAccount:(ACAccount *)requestAccount
              withLocation:(BOOL)withLocation
                   handler:(SLRequestHandler)handler
{
    // https://developers.facebook.com/docs/reference/api/user/#home
    NSString *urlStr = [NSString stringWithFormat:@"%@/me/home", kBaseURL];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if (withLocation) {
        params[@"with"] = @"location";
    }
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];
    
    request.account = requestAccount;
    
    [request performRequestWithHandler:handler];
}


// =============================================================================
#pragma mark - Publish

// Publish a new post or Upload a photo
+ (void)postMessage:(NSString *)message
              image:(UIImage *)image
            account:(ACAccount *)account
            handler:(SLRequestHandler)handler
{
    NSDictionary *params = @{@"message": message};

    BOOL withMedia = [image isKindOfClass:[UIImage class]] ? YES : NO;

    NSString *urlStr;
    
    if (withMedia) {
        
        // https://developers.facebook.com/docs/reference/api/photo/
        urlStr = @"https://graph.facebook.com/me/photos";
    }
    else {
        
        // https://developers.facebook.com/docs/reference/api/post/
        urlStr = @"https://graph.facebook.com/me/feed";
    }

    NSURL *url = [NSURL URLWithString:urlStr];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    
    if (withMedia) {
        
        NSData* photo = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
        [request addMultipartData:photo
                         withName:@"name"
                             type:@"multipart/form-data"
                         filename:@"@image.png"];
    }
    
    request.account = account;

    [request performRequestWithHandler:handler];
}


// =============================================================================
#pragma mark - App Request

// Post an apprequest
// https://developers.facebook.com/docs/reference/api/user/#apprequests
+ (void)postAppRequestToUserId:(NSString *)userId
                       message:(NSString *)message
                    trackingId:(NSString *)trackingId
                       account:(ACAccount *)account
                       handler:(SLRequestHandler)handler
{
    NSAssert(message, @"message is required");
    
    NSMutableDictionary *params = @{@"message": message}.mutableCopy;
    
    if (trackingId) {
        
        params[@"data"] = trackingId;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/apprequests", kBaseURL, userId];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    
    request.account = account;

    [request performRequestWithHandler:handler];
}

@end
