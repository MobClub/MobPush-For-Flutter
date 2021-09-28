#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'mobpush_plugin'
  s.version          = '1.1.0'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://www.mob.com/mobService/mobpush'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mob' => 'mobproducts@mob.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'mob_pushsdk'
  s.static_framework = true

  s.ios.deployment_target = '8.0'
end

