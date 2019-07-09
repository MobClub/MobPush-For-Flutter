#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'mobpush'
  s.version          = '0.0.1'
  s.summary          = 'flutter plugin for mobpush.'
  s.description      = 'MobPush is a Push SDK'
  s.homepage         = 'http://www.mob.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mob' => 'mobproducts@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'mob_pushsdk'
  s.static_framework = true


  s.ios.deployment_target = '8.0'
end

