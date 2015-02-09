//
//  SocialHelper.m
//  SocialAPIHelpers
//
//  Created by shuichi on 10/20/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMSocialHelper.h"
#import "TTMAccountHelper.h"


NSString * const TTMSocialErrorDomain = @"com.shu223.SocialAPIHelpers.TTMSocialHelper";


@implementation TTMSocialHelper

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
            
            NSUInteger errorCode = [errorDic[@"code"] intValue];
            

            // Need to renew credentials
            if (errorCode == 2500 || errorCode == 190) {
                
                [TTMAccountHelper renewCredentialsForFacebookAccountWithCompletion:^(NSError *error) {

                    NSError *err;
                    
                    // Failed to renew credentials
                    if (error) {
                        err = error;
                    }
                    // Credential renewed
                    else {
                        err = [NSError errorWithDomain:TTMSocialErrorDomain
                                                  code:TTMSocialErrorCredentialRenewed
                                              userInfo:@{NSLocalizedDescriptionKey: @"ACAccountCredentialRenewResultRenewed"}];
                    }
                    handler(nil, err);
                }];
            }
            // other errors
            else {
                NSError *err = [NSError errorWithDomain:TTMSocialErrorDomain
                                          code:errorCode
                                      userInfo:@{NSLocalizedDescriptionKey: errorDic[@"message"]}];
                handler(nil, err);
            }
            
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
