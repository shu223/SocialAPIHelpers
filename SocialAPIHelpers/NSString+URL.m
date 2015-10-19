//
//  NSString+URL.m
//
//  Created by shuichi on 10/23/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSDictionary *)dictionaryFromURLString{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray<NSString *> *pairs = [self componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray<NSString *> *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
