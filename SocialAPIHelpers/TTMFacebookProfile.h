//
//  TTMFacebookProfile.h
//  SocialAPIHelpers
//
//  Created by Shuichi Tsutsumi on 2015/01/23.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, TTMFacebookProfileGenderType) {
    TTMFacebookProfileGenderTypeUnknown = 0,
    TTMFacebookProfileGenderTypeMale,
    TTMFacebookProfileGenderTypeFemale,
};

typedef NS_ENUM(NSUInteger, TTMFacebookProfilePictureType) {
    TTMFacebookProfilePictureTypeSquare = 0,
    TTMFacebookProfilePictureTypeSmall,
    TTMFacebookProfilePictureTypeNormal,
    TTMFacebookProfilePictureTypeLarge,
};


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

- (NSURL *)urlForProfilePictureWithType:(TTMFacebookProfilePictureType)type;

@end
