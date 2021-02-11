#
# Be sure to run `pod lib lint QBLevelTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QBLevelTableView'
  s.version          = '0.0.2'
  s.summary          = 'iOS多级TableView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                              QBLevelTableView iOS多级TableView OC
                       DESC

  s.homepage         = 'https://github.com/luqinbin/QBLevelTableView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luqinbin' => '751536545@qq.com' }
  s.source           = { :git => 'https://github.com/luqinbin/QBLevelTableView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'QBLevelTableView/QBLevelTableView/*', 'QBLevelTableView/QBLevelTableView/Model/*','QBLevelTableView/QBLevelTableView/protocol/*'
  
  # s.resource_bundles = {
  #   'QBLevelTableView' => ['QBLevelTableView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'CoreServices'
  s.dependency 'libextobjc'
end
