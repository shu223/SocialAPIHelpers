//
//  TTMFacebookProfile.h
//  SocialAPIHelpers
//
//  Created by Shuichi Tsutsumi on 2015/01/23.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    TTMFacebookProfileGenderTypeUnknown = 0,
    TTMFacebookProfileGenderTypeMale,
    TTMFacebookProfileGenderTypeFemale,
} TTMFacebookProfileGenderType;


@interface TTMFacebookProfile : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) TTMFacebookProfileGenderType gender;
@property (nonatomic, readonly) NSString *birthday;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSNumber *timeZone;
@property (nonatomic, readonly) NSString *link;
@property (nonatomic, readonly) NSString *locationId;
@property (nonatomic, readonly) NSString *locationName;

- (id)initWithDictionray:(NSDictionary *)profileDic;

@end
