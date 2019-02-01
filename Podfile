platform :ios, '11.4.1'
use_frameworks!

def install_pods
    # Resource
    pod 'SwiftGen', '~> 6.0.2'
    pod 'SwiftLint', '~> 0.27.0'
end

target 'RecordMap' do
  # Pods for NewYearLottery
  install_pods

  target 'RecordMapTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RecordMapUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
