//
//  SocialHelper.m
//  SocialAPIHelpersDemo
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "SocialHelper.h"

@implementation SocialHelper

+ (void)parseSLRequestResponseData:(NSData *)responseData
                           handler:(void (^)(id result, NSError *error))handler
{
    NSError *jsonError = nil;
    
    id jsonData = [NSJSONSerialization JSONObjectWithData:responseData
                                                  options:0
                                                    error:&jsonError];
    
    if (jsonError) {
        
        handler(nil, jsonError);
        
        return;
    }
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        
        if (jsonData[@"error"]) {
            
            NSLog(@"jsonData[@\"error\"]:%@", jsonData[@"error"]);
            
            /* sample
             error =     {
             code = 190;
             message = "The access token was invalidated on the device.";
             type = OAuthException;
             };
             */
            
            NSDictionary *errorDic = jsonData[@"error"];
            
            NSError *err = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                               code:[errorDic[@"code"] intValue]
                                           userInfo:@{NSLocalizedDescriptionKey: errorDic[@"message"]}];
            
            handler(nil, err);
            
            return;
        }
        
        if (jsonData[@"errors"]) {
            
            /* sample
             errors =     (
             {
             code = 88;
             message = "Rate limit exceeded";
             }
             );
             */
            NSArray *errors = jsonData[@"errors"];
            NSLog(@"jsonData[@\"errors\"]:%@", errors);
            
            if ([errors count]) {
                
                // ひとつめのエラーだけ見る
                NSDictionary *errorDic = [errors objectAtIndex:0];
                NSError *err = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                   code:[errorDic[@"code"] intValue]
                                               userInfo:@{NSLocalizedDescriptionKey: errorDic[@"message"]}];
                
                handler(nil, err);
                
                return;
            }
        }
    }
    
    handler(jsonData, nil);
}

@end
