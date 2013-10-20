//
//  SocialHelper.h
//  SocialAPIHelpersDemo
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialHelper : NSObject

+ (void)parseSLRequestResponseData:(NSData *)responseData
                           handler:(void (^)(id result, NSError *error))handler;

@end
