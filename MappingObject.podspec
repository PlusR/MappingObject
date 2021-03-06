#
# Be sure to run `pod lib lint MappingObject.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MappingObject"
  s.version          = "0.1.0"
  s.summary          = "A short description of MappingObject."
  s.description      = <<-DESC
                       An optional longer description of MappingObject

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/akuraru/MappingObject"
  s.license          = 'MIT'
  s.author           = { "akuraru" => "akuraru@gmail.com" }
  s.source           = { :git => "https://github.com/PlusR/MappingObject.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/akuraru'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
