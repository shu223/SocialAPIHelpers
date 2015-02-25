//
//  FacebookAPIHelper.h
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "SLRequest+TTMExtensions.h"
#import "TTMFacebookProfile.h"


@interface TTMFacebookAPIHelper : NSObject

// The user's profile
+ (void)userProfileWithUserId:(NSString *)userId
               requestAccount:(ACAccount *)requestAccount
                      handler:(TTMRequestHandler)handler;
+ (void)userProfileForAccount:(ACAccount *)account
                      handler:(void (^)(TTMFacebookProfile *profile, NSDictionary *result, NSError *error))handler;

// The user's friends.
+ (void)friendsForAccount:(ACAccount *)account
                  handler:(TTMRequestHandler)handler;

// Profile Picture
+ (NSString *)profilePictureURLForUserId:(NSString *)userId;

// News Feed
// You can retrieve only posts with a location when "withLocation" is YES
+ (void)newsfeedForAccount:(ACAccount *)account
                parameters:(NSDictionary *)parameters
              withLocation:(BOOL)withLocation
                   handler:(TTMRequestHandler)handler;

+ (void)newsfeedForAccount:(ACAccount *)account
                   handler:(TTMRequestHandler)handler;

+ (void)newsfeedWithPreviousURL:(NSString *)previousUrl
                        account:(ACAccount *)account
                   withLocation:(BOOL)withLocation
                        handler:(TTMRequestHandler)handler;

+ (void)newsfeedWithNextURL:(NSString *)nextUrl
                    account:(ACAccount *)account
               withLocation:(BOOL)withLocation
                    handler:(TTMRequestHandler)handler;

// Posts
+ (void)postsOfUserId:(NSString *)userId
              account:(ACAccount *)account
              handler:(TTMRequestHandler)handler;

// Publish a new post or Upload a photo
+ (void)postMessage:(NSString *)message
              image:(UIImage *)image
            account:(ACAccount *)account
            handler:(TTMRequestHandler)handler;

// Post an apprequest
+ (void)postAppRequestToUserId:(NSString *)userId
                       message:(NSString *)message
                    trackingId:(NSString *)trackingId
                       account:(ACAccount *)account
                       handler:(TTMRequestHandler)handler;

// Other
+ (NSDate *)dateOfPost:(NSDictionary *)post;
+ (NSArray *)sortedPostsWithLikes:(NSArray *)posts;

@end
