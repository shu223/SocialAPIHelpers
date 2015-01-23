//
//  FacebookAPIHelper.h
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>


@interface TTMFacebookAPIHelper : NSObject

// The user's profile
+ (void)userProfileWithUserId:(NSString *)userId
               requestAccount:(ACAccount *)requestAccount
                      handler:(SLRequestHandler)handler;
+ (void)userProfileForAccount:(ACAccount *)account
                      handler:(SLRequestHandler)handler;

// The user's friends.
+ (void)friendsForAccount:(ACAccount *)account
                  handler:(SLRequestHandler)handler;

// Profile Picture
+ (NSString *)profilePictureURLForUserId:(NSString *)userId;

// News Feed
// You can retrieve only posts with a location when "withLocation" is YES
+ (void)newsfeedForAccount:(ACAccount *)account
                parameters:(NSDictionary *)parameters
              withLocation:(BOOL)withLocation
                   handler:(SLRequestHandler)handler;

+ (void)newsfeedForAccount:(ACAccount *)account
                   handler:(SLRequestHandler)handler;

+ (void)newsfeedWithPreviousURL:(NSString *)previousUrl
                        account:(ACAccount *)account
                   withLocation:(BOOL)withLocation
                        handler:(SLRequestHandler)handler;

+ (void)newsfeedWithNextURL:(NSString *)nextUrl
                    account:(ACAccount *)account
               withLocation:(BOOL)withLocation
                    handler:(SLRequestHandler)handler;

// Posts
+ (void)postsOfUserId:(NSString *)userId
              account:(ACAccount *)account
              handler:(SLRequestHandler)handler;

// Publish a new post or Upload a photo
+ (void)postMessage:(NSString *)message
              image:(UIImage *)image
            account:(ACAccount *)account
            handler:(SLRequestHandler)handler;

// Post an apprequest
+ (void)postAppRequestToUserId:(NSString *)userId
                       message:(NSString *)message
                    trackingId:(NSString *)trackingId
                       account:(ACAccount *)account
                       handler:(SLRequestHandler)handler;

// Other
+ (NSDate *)dateOfPost:(NSDictionary *)post;
+ (NSArray *)sortedPostsWithLikes:(NSArray *)posts;

@end
