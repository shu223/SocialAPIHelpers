//
//  TwitterAPIClient.h
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Social/Social.h>
#import "SLRequest+TTMExtensions.h"


#define kAPIResponseKeyRTCount          @"retweet_count"
#define kAPIResponseKeyFavCount         @"favorite_count"
#define kAPIResponseKeyRetweetedStatus  @"retweeted_status"


@interface TTMTwitterAPIHelper : NSObject

// GET statuses/home_timeline
+ (void)homeTimelineWithCount:(NSUInteger)count
                      sinceId:(NSString *)sinceId
                      account:(ACAccount *)account
                      handler:(TTMRequestHandler)handler;

+ (void)homeTimelineForAccount:(ACAccount *)account
                       handler:(TTMRequestHandler)handler;


// GET statuses/user_timeline
+ (void)userTimelineWithScreenName:(NSString *)screenName
                             count:(NSUInteger)count
                           sinceId:(NSString *)sinceId
                           account:(ACAccount *)account
                           handler:(TTMRequestHandler)handler;

+ (void)userTimelineWithScreenName:(NSString *)screenName
                           account:(ACAccount *)account
                           handler:(TTMRequestHandler)handler;

// GET users/show
+ (void)userInformationWithScreenName:(NSString *)screenName
                              account:(ACAccount *)account
                              handler:(TTMRequestHandler)handler;

+ (void)userInformationForAccount:(ACAccount *)account
                          handler:(TTMRequestHandler)completion;


// GET friends/list
+ (void)friendsListForAccount:(ACAccount *)account
                   nextCursor:(NSString *)nextCursor
                      handler:(TTMRequestHandler)handler;

// GET friends/ids
+ (void)friendsIdsForAccount:(ACAccount *)account
                  nextCursor:(NSString *)nextCursor
                     handler:(TTMRequestHandler)handler;

// GET users/lookup
+ (void)userInformationsForIDs:(NSArray<NSString *> *)ids
                requestAccount:(ACAccount *)requestAccount
                       handler:(TTMRequestHandler)handler;

// POST statuses/update
+ (void)updateStatus:(NSString *)status
               image:(UIImage *)image
             account:(ACAccount *)account
             handler:(TTMRequestHandler)handler;

// POST direct_messages/new
+ (void)sendDirectMessageToScreenName:(NSString *)screenName
                              message:(NSString *)message
                              account:(ACAccount *)account
                              handler:(TTMRequestHandler)handler;

// Other
+ (NSDate *)dateOfStatus:(NSDictionary *)status;

@end
