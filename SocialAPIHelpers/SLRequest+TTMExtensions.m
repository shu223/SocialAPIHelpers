//
//  SLRequest+TTMExtensions.m
//  SocialAPIHelpers
//
//  Created by Shuichi Tsutsumi on 2015/01/23.
//  Copyright (c) 2015年 Shuichi Tsutsumi. All rights reserved.
//

#import "SLRequest+TTMExtensions.h"

@implementation SLRequest (TTMExtensions)

- (void)performAsyncRequestWithHandler:(SLRequestHandler)handler {

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [self performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                handler(responseData, urlResponse, error);
            });
        }];
    });
}

@end
