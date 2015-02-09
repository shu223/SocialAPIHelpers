//
//  SocialHelper.h
//  SocialAPIHelpers
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const TTMSocialErrorDomain;


typedef enum {
    TTMSocialErrorUnknown = 0,
    TTMSocialErrorCredentialRenewed,
} TTMSocialError;


@interface TTMSocialHelper : NSObject

+ (void)parseSLRequestResponseData:(NSData *)responseData
                           handler:(void (^)(id result, NSError *error))handler;

@end
