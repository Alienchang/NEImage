#
# Be sure to run `pod lib lint NEImage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NEImage'
  s.version          = '1.0.3'
  s.summary          = 'A short description of NEImage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Alienchang/NEImage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1217493217@qq.com' => 'chang.liu.meme@funpuls.com' }
  s.source           = { :git => 'https://github.com/Alienchang/NEImage.git', :tag => s.version.to_s }
   s.social_media_url = 'https://www.jianshu.com/u/b1b964b19576'

  s.ios.deployment_target = '9.0'

  s.source_files = 'NEImage/Classes/*.{h,m,mm}'
  # s.resource_bundles = {
  #   'NEImage' => ['NEImage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks   = "UIKit", "Foundation" #支持的框架
  s.dependency 'SDWebImage' # 依赖库
  s.dependency 'SDWebImage/WebP'
  s.dependency 'APNGImageSerialization', '~> 0.1.3'
end
