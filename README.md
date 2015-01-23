Social API Helpers
======================

**Twitter and Facebook API Helper classes** for iOS using Social.framework. It works on iOS 6 or later.

##How to install

Add to Podfile.

```
pod 'SocialAPIHelpers', :git => 'https://github.com/shu223/SocialAPIHelpers'
```

##Examples

###Request access to Twitter

Just call 1 method.

```
[TTMAccountHelper requestAccessToTwitterAccountsWithStore:self.store
                                                  handler:^(NSError *error) {
                                                  }];
```

###Request access to Facebook

Create a dictionary for options (permissions) and call the request method.

```
NSDictionary *options = [TTMAccountHelper optionsToReadStreamOnFacebookWithAppId:kFacebookAppId];

[TTMAccountHelper requestAccessToAccountsWithType:ACAccountTypeIdentifierFacebook
                                          options:options
                                            store:self.store
                                          handler:^(NSError *error) {
                                          }];
```