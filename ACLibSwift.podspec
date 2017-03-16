#
# Be sure to run `pod lib lint ACLibSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'ACLibSwift'
s.version          = '0.1.1'
s.summary          = 'ACLibSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
ACLibSwift for swift
DESC

s.homepage         = 'https://github.com'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'AaronChanLover' => 'aaronchanlover@outlook.com' }
s.source           = { :git => 'https://github.com/aaronchanlover/ACLibSwift.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '8.0'

s.subspec 'QRCode' do |ss|
ss.source_files = 'Libs/QRCode/**/*'
end


s.subspec 'ACTabbarController' do |ss|
ss.source_files = 'Libs/ACTabbarController/**/*'
end


end
