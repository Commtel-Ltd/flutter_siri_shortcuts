#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_siri_shortcuts.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_siri_shortcuts'
  s.version          = '1.0.0'
  s.summary          = 'A comprehensive Flutter plugin for iOS Siri Shortcuts integration.'
  s.description      = <<-DESC
A comprehensive Flutter plugin for iOS Siri Shortcuts integration. Easily add, manage, and respond to Siri shortcuts in your Flutter apps.
                       DESC
  s.homepage         = 'https://github.com/Commtel-Ltd/flutter_siri_shortcuts'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Commtel Ltd' => 'info@commtel.co.uk' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end