//
//  FacebookAPIHelper.m
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMFacebookAPIHelper.h"
#import "NSString+URL.h"
#import "SLRequest+TTMExtensions.h"


#define kBaseURL @"https://graph.facebook.com"


@implementation TTMFacebookAPIHelper

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

+ (void)newsfeedForAccount:(ACAccount *)account
                parameters:(NSDictionary *)parameters
              withLocation:(BOOL)withLocation
                   handler:(SLRequestHandler)handler
{
    // https://developers.facebook.com/docs/reference/api/user/#home
    NSString *urlStr = [NSString stringWithFormat:@"%@/me/home", kBaseURL];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableDictionary *params = parameters.mutableCopy;
    if (withLocation) {
        params[@"with"] = @"location";
    }
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    request.account = account;

    [request performAsyncRequestWithHandler:handler];
}

+ (void)newsfeedForAccount:(ACAccount *)account
                   handler:(SLRequestHandler)handler
{
    [TTMFacebookAPIHelper newsfeedForAccount:account
                               parameters:@{}
                             withLocation:NO
                                  handler:handler];
}

+ (void)newsfeedWithPreviousURL:(NSString *)previousUrl
                        account:(ACAccount *)account
                   withLocation:(BOOL)withLocation
                        handler:(SLRequestHandler)handler
{
    NSDictionary *allParams = [previousUrl dictionaryFromURLString];
    
    NSDictionary *params = @{@"since": allParams[@"since"],
                             @"__previous": allParams[@"__previous"]};
    
    [TTMFacebookAPIHelper newsfeedForAccount:account
                               parameters:params
                             withLocation:withLocation
                                  handler:handler];
}

+ (void)newsfeedWithNextURL:(NSString *)nextUrl
                    account:(ACAccount *)account
               withLocation:(BOOL)withLocation
                    handler:(SLRequestHandler)handler
{
    NSDictionary *allParams = [nextUrl dictionaryFromURLString];
    
    NSDictionary *params = @{@"until": allParams[@"until"]};
    
    [TTMFacebookAPIHelper newsfeedForAccount:account
                               parameters:params
                             withLocation:withLocation
                                  handler:handler];
}


// =============================================================================
#pragma mark - Posts

+ (void)postsOfUserId:(NSString *)userId
              account:(ACAccount *)account
              handler:(SLRequestHandler)handler
{
    // https://developers.facebook.com/docs/graph-api/reference/user/
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/posts", kBaseURL, userId];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];
    
    request.account = account;

    [request performAsyncRequestWithHandler:handler];
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

    [request performAsyncRequestWithHandler:handler];
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


// =============================================================================
#pragma mark - Others

+ (NSDate *)dateOfPost:(NSDictionary *)post {
    
    NSString *dateStr = post[@"created_time"];
    
    NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
    [inputFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *date = [inputFormat dateFromString:dateStr];
    
    return date;
}

+ (NSArray *)sortedPostsWithLikes:(NSArray *)posts {
    
    NSMutableArray *sorted = @[].mutableCopy;
    
    for (NSDictionary *aPost in posts) {

        NSArray *likes = aPost[@"likes"][@"data"];

        BOOL inserted = NO;
        for (int i=0; i<[sorted count]; i++) {
            
            NSDictionary *aSortedPost = sorted[i];
            NSArray *compareLikes = aSortedPost[@"likes"][@"data"];
            if ([likes count] > [compareLikes count]) {
                
                [sorted insertObject:aPost atIndex:i];
                
                inserted = YES;
                break;
            }
        }
        
        if (!inserted) {
            [sorted addObject:aPost];
        }
    }
    
    return sorted;
}

@end
