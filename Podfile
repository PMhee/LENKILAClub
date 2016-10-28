# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'LenkilaClub' do
    pod 'RealmSwift', ‘~> 2.0.2’
    pod 'Charts', '~> 3.0.0’
    pod 'CVCalendar'
    pod 'SCLAlertView’, ‘~> 0.7.0’
    pod 'Alamofire'
end

target 'LenkilaClubTests' do

end

target 'LenkilaClubUITests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3' # or '3.0'
    end
  end
end