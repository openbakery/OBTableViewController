Pod::Spec.new do |spec|
	spec.name         = 'OBTableViewController'
	spec.version      = '1.0.4'
	spec.summary      = "A table view controller that has models a datasource and you can define bindings between model properties and cell properties"
	spec.homepage     = "https://github.com/openbakery/OBTableViewController"
	spec.author       = { "René Pirringer" => "rene@openbakery.org" }
	spec.social_media_url = 'https://twitter.com/rpirringer'
	spec.source       = { :git => "https://github.com/openbakery/OBTableViewController.git", :tag => spec.version.to_s}
	spec.platform = :ios
	spec.ios.deployment_target = '8.0'
	spec.license      = 'BSD'
	spec.requires_arc = true
	
	spec.default_subspecs = 'Default'
	spec.dependency 'OBInjector', '~>1.3.0'
	
	spec.subspec 'Default' do |ss|
		ss.source_files = 'Core/Source/*.{h,m}'
		ss.dependency 'OBTableViewController/Binding'
		ss.dependency 'OBTableViewController/Model'
  end

	spec.subspec 'Binding' do |ss|
		ss.source_files = 'Core/Source/Binding/*.{h,m}'
		ss.dependency 'OBTableViewController/OBReflection' 
	end

	spec.subspec 'Model' do |ss|
		ss.source_files = 'Core/Source/Model/*.{h,m}'
	end

	spec.subspec 'OBReflection' do |ss|
		ss.source_files = 'Core/Source/OBReflection/*.{h,m}'
	end
	
end
