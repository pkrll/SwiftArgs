#
#  Be sure to run `pod spec lint SwiftArgs.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SwiftArgs"
  s.version      = "0.5.4"
  s.summary      = "A small Swift framework for creating simple command line interfaces."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
										`SwiftArgs` lets you handle command line arguments with ease. Just supply the valid arguments, and let `SwiftArgs` handle the rest.
                   DESC

  s.homepage     = "https://github.com/pkrll/SwiftArgs"
  s.license      = "MIT"
  s.author             = { "Ardalan Samimi" => "ardalan@saturnfive.se" }
  s.social_media_url   = "http://twitter.com/ardalansamimi"

  # s.platform     = :osx
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.10"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/pkrll/SwiftArgs.git", :tag => s.version }
  s.source_files  = "Sources/SwiftArgs/*.{swift}", "Sources/SwiftArgs/**/*.{swift}"

	s.swift_version = "4.0"
	s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
	s.static_framework = true

end
