Pod::Spec.new do |spec|
  spec.name         = 'OBTableViewController'
  spec.version      = '1.0.0'
  spec.summary      = "A table view controller that has models a datasource and you can define bindings between model properties and cell properties"
  spec.homepage     = "https://github.com/openbakery/OBTableViewController"
  spec.author       = { "René Pirringer" => "rene@openbakery.org" }
  spec.social_media_url = 'https://twitter.com/rpirringer'
  spec.source       = { :git => "https://github.com/openbakery/OBTableViewController.git", :tag => spec.version.to_s}
  spec.platform = :ios
  spec.ios.deployment_target = '6.0'
  spec.license      = 'BSD'
  spec.requires_arc = true
  spec.source_files = ['Core/Source/*.{h,m}', 'Core/Source/Binding/*.{h,m}', 'Core/Source/Model/*.{h,m}', 'Core/Source/OBReflection/*.{h,m}', , 'Core/Source/OBTableViewCells/*.{h,m}']
end
