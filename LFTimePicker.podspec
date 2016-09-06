Pod::Spec.new do |s|
  s.name         = "LFTimePicker"
  s.version      = "0.2.1"
  s.summary      = "Custom Time Picker ViewController with Selection of start and end times in Swift"
  s.homepage     = "https://github.com/awesome-labs/LFTimePicker/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Lucas Farah" => "lucas.farah@me.com" }
  s.social_media_url   = "https://twitter.com/7farah7"
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/awesome-labs/LFTimePicker.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.requires_arc = true
end

