#
#  Be sure to run `pod spec lint Decomposed.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = 'Decomposed'
  spec.version      = '0.0.4'
  spec.summary      = 'CATransform3D manipulation made easy.'
  spec.description  = <<-DESC
  Decomposed allows for CATransform3D, matrix_double4x4, and matrix_float4x4, to be decomposed, recomposed, and mutated without complex math.
  Decomposition is the act of breaking something down into smaller components, in this case transformation matrices into things like translation, scale, etc. in a way that they can all be individually changed or reset. The following are supported: Translation, Scale, Rotation, Skew, and Perspective.
                   DESC
  spec.homepage     = 'https://github.com/b3ll/Decomposed'
  spec.screenshots  = 'https://github.com/b3ll/Decomposed/blob/master/Resources/Decomposed.gif?raw=true', 'https://github.com/b3ll/Decomposed/raw/master/Resources/Decomposed2.gif?raw=true'

  spec.license      = { :type => 'BSD', :file => 'LICENSE' }
  spec.author             = { 'Adam Bell' => 'adam@adambell.me' }
  spec.social_media_url   = 'https://twitter.com/b3ll'

  spec.ios.deployment_target = '13.0'
  spec.osx.deployment_target = '10.15'

  spec.swift_version = '5.0'
  spec.module_name = 'Decomposed'
  spec.source       = { :git => 'https://github.com/b3ll/Decomposed.git', :tag => "v#{spec.version}" }
  spec.source_files  = 'Sources/**/*.{h,m,swift}'
  spec.header_dir = 'Decomposed'
  spec.framework  = 'Accelerate'
  spec.requires_arc = true
end
