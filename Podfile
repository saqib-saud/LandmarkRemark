platform :ios, '14.0'

target 'Landmark Remark' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  
  target 'Landmark RemarkTests' do
    inherit! :search_paths
    use_frameworks!
      pod 'Nimble'
      pod 'Quick'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
