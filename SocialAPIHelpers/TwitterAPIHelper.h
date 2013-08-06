//
//  TwitterAPIClient.h
//
//  Created by Shuichi Tsutsumi on 8/6/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>


@interface TwitterAPIHelper : NSObject

// GET users/show
+ (void)userInformationWithScreenName:(NSString *)screenName
                       requestAccount:(ACAccount *)requestAccount
                              handler:(SLRequestHandler)handler;
+ (void)userInformationForAccount:(ACAccount *)account
                       completion:(SLRequestHandler)completion;


// GET friends/list
+ (void)friendsListForAccount:(ACAccount *)account
                   nextCursor:(NSString *)nextCursor
                      handler:(SLRequestHandler)handler;

// POST statuses/update
+ (void)updateStatus:(NSString *)status
               image:(UIImage *)image
             account:(ACAccount *)account
             handler:(SLRequestHandler)handler;

@end
