Pod::Spec.new do |s|
  s.name         = "HaidoraScrollPageView"
  s.version      = "0.1"
  s.summary      = "A custom ScrollView with PageController"

  s.description  = <<-DESC
                   A longer description of HaidoraScrollPageView in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/Haidora/HaidoraScrollPageView"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  s.author             = { "mrdaios" => "mrdaios@gmail.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/Haidora/HaidoraScrollPageView.git", :branch => "developer" }
  s.source_files  = "Source", "Source/**/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
end
