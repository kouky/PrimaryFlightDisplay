Pod::Spec.new do |spec|
  spec.name = "PrimaryFlightDisplay"
  spec.version = "0.6.0"
  spec.summary = "Primary Flight Display SpriteKit Framework for Mac + iOS."
  spec.homepage = "https://github.com/kouky/PrimaryFlightDisplay"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Michael Koukoullis" => 'mike@kouky.org' }
  spec.social_media_url = "http://twitter.com/kouky"

  spec.ios.deployment_target = '9.0'
  spec.osx.deployment_target = '10.10'
  spec.requires_arc = true

  spec.source = { git: "https://github.com/kouky/PrimaryFlightDisplay.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "Sources/**/*.{h,swift}"
end
