//
//  TTMFacebookProfile.m
//  SocialAPIHelpers
//
//  Created by Shuichi Tsutsumi on 2015/01/23.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMFacebookProfile.h"


@interface TTMFacebookProfile ()
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, assign) TTMFacebookProfileGenderType gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *timeZone;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSString *locationName;
@end


@implementation TTMFacebookProfile

- (id)initWithDictionray:(NSDictionary *)profileDic {
    self = [super init];
    if (self) {
        
        self.identifier = profileDic[@"id"];
        self.firstName = profileDic[@"first_name"];
        self.lastName = profileDic[@"last_name"];
        self.fullName = profileDic[@"name"];
        
        self.gender = TTMFacebookProfileGenderTypeUnknown;
        NSString *gender = profileDic[@"gender"];
        if ([gender isKindOfClass:[NSString class]]) {
            if ([gender isEqualToString:@"male"]) {
                self.gender = TTMFacebookProfileGenderTypeMale;
            }
            else if ([gender isEqualToString:@"female"]) {
                self.gender = TTMFacebookProfileGenderTypeFemale;
            }
        }
        
        self.birthday = profileDic[@"birthday"];
        self.email = profileDic[@"email"];
        self.timeZone = profileDic[@"timezone"];
        self.link = profileDic[@"link"];
        
        NSDictionary *locationDic = profileDic[@"location"];
        self.locationId = locationDic[@"id"];
        self.locationName = locationDic[@"name"];
    }
    return self;
}

@end
