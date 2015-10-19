//
//  SLRequest+TTMExtensions.h
//  SocialAPIHelpers
//
//  Created by Shuichi Tsutsumi on 2015/01/23.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

#import <Social/Social.h>


typedef void(^TTMRequestHandler)(id result, NSError *error);


@interface SLRequest (TTMExtensions)

- (void)performAsyncRequestWithHandler:(TTMRequestHandler)handler;

@end
