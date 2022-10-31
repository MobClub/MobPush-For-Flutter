#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  # 标准: 名字需要和文件名字保持一致，不带后缀
  s.name             = 'mobpush_plugin' 
  # 标准: ios目录有改动，需要更新版本号
  s.version          = '1.1.0' 
  # 标准: 需要添加内容
  s.summary          = 'mobpush 是一款推送SDK.' 
  # 标准: 需要添加内容
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  # 标准: 添加官网对应插件项目的首页
  s.homepage         = 'http://www.mob.com/mobService/mobpush'
  # 标准: 固定为 { :file => '../LICENSE' }
  s.license          = { :file => '../LICENSE' }
  # 标准: 固定为 { 'Mob' => 'mobproducts@mob.com' }
  s.author           = { 'Mob' => 'mobproducts@mob.com' }
  # 标准: 固定为 { :path => '.' }
  s.source           = { :path => '.' }
  # 标准: 固定为 'Classes/**/*'
  s.source_files = 'Classes/**/*'
  # 标准: 固定为'Classes/**/*.h'
  s.public_header_files = 'Classes/**/*.h'
  # 标准: 固定为'Flutter'
  s.dependency 'Flutter'
  # 标准: 根据具体需要引入库,如 'mob_pushsdk'
  s.dependency 'mob_pushsdk_spec2'
  # 标准: 固定为true
  s.static_framework = true
  
  # 标准: 固定为 '8.0'
  s.ios.deployment_target = '8.0'
end

