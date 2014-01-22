//
//  TwitterAPIClient.h
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>


#define kAPIResponseKeyRTCount          @"retweet_count"
#define kAPIResponseKeyFavCount         @"favorite_count"
#define kAPIResponseKeyRetweetedStatus  @"retweeted_status"


@interface TwitterAPIHelper : NSObject

// GET statuses/home_timeline
+ (void)homeTimelineWithCount:(NSUInteger)count
                      sinceId:(NSString *)sinceId
                      account:(ACAccount *)account
                      handler:(SLRequestHandler)handler;

+ (void)homeTimelineForAccount:(ACAccount *)account
                       handler:(SLRequestHandler)handler;


// GET statuses/user_timeline
+ (void)userTimelineWithScreenName:(NSString *)screenName
                             count:(NSUInteger)count
                           sinceId:(NSString *)sinceId
                           account:(ACAccount *)account
                           handler:(SLRequestHandler)handler;

+ (void)userTimelineWithScreenName:(NSString *)screenName
                           account:(ACAccount *)account
                           handler:(SLRequestHandler)handler;

// GET users/show
+ (void)userInformationWithScreenName:(NSString *)screenName
                              account:(ACAccount *)account
                              handler:(SLRequestHandler)handler;

+ (void)userInformationForAccount:(ACAccount *)account
                          handler:(SLRequestHandler)completion;


// GET friends/list
+ (void)friendsListForAccount:(ACAccount *)account
                   nextCursor:(NSString *)nextCursor
                      handler:(SLRequestHandler)handler;

// GET friends/ids
+ (void)friendsIdsForAccount:(ACAccount *)account
                  nextCursor:(NSString *)nextCursor
                     handler:(SLRequestHandler)handler;

// GET users/lookup
+ (void)userInformationsForIDs:(NSArray *)ids
                requestAccount:(ACAccount *)requestAccount
                       handler:(SLRequestHandler)handler;

// POST statuses/update
+ (void)updateStatus:(NSString *)status
               image:(UIImage *)image
             account:(ACAccount *)account
             handler:(SLRequestHandler)handler;

// POST direct_messages/new
+ (void)sendDirectMessageToScreenName:(NSString *)screenName
                              message:(NSString *)message
                              account:(ACAccount *)account
                              handler:(SLRequestHandler)handler;

// Other
+ (NSDate *)dateOfStatus:(NSDictionary *)status;

@end
