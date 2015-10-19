Pod::Spec.new do |s|
  s.name         = "SocialAPIHelpers"
  s.version      = "0.0.9"
  s.summary      = "Twitter and Facebook API Helper classes for iOS using Social.framework"
  s.homepage     = "https://github.com/shu223/SocialAPIHelpers"
  s.license      = 'MIT'
  s.author       = { "shu223" => "shuichi0526@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/shu223/SocialAPIHelpers.git", :tag => "0.0.9" }
  s.source_files  = 'SocialAPIHelpers/*.{h,m}'
  s.framework  = 'Social', 'Accounts'
  s.requires_arc = true
end
