//
//  NSString+URL.m
//  Summarizer
//
//  Created by shuichi on 10/23/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSDictionary *)dictionaryFromURLString{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
