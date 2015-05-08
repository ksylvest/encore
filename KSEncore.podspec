Pod::Spec.new do |s|
  s.name             = "KSEncore"
  s.version          = "1.0.0"
  s.summary          = "Encore eliminates duplicate calls by queueing callbacks."
  s.description      = <<-DESC
                       * Queue up callbacks using `queue:block:`
                       * Flush callbacks using `flush:`
                       DESC

  s.homepage         = "https://github.com/ksylvest/encore"

  s.license          = 'MIT'
  s.author           = { "Kevin Sylvestre" => "kevin@ksylvest.com" }
  s.source           = { :git => "https://github.com/ksylvest/encore.git", :tag => s.version.to_s }

  s.platform         = :ios, '7.0'

  s.source_files     = 'Pod/Classes/**/*'
end
