//
//  SLRequest+TTMExtensions.h
//  SocialAPIHelpers
//
//  Created by Shuichi Tsutsumi on 2015/01/23.
//  Copyright (c) 2015年 Shuichi Tsutsumi. All rights reserved.
//

#import <Social/Social.h>

@interface SLRequest (TTMExtensions)

- (void)performAsyncRequestWithHandler:(SLRequestHandler)handler;

@end
