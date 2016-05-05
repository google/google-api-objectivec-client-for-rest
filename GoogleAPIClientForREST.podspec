Pod::Spec.new do |s|
  s.name         = 'GoogleAPIClientForREST'
  s.version      = '1.0.0'
  s.author       = 'Google Inc.'
  s.homepage     = 'https://github.com/google/google-api-objectivec-client-for-rest'
  s.license      = { :type => 'Apache', :file => 'LICENSE' }
  s.source       = { :git => 'https://github.com/google/google-api-objectivec-client-for-rest.git',
                     :tag => "v#{s.version}" }
  s.summary      = 'Google APIs Client Library for Objective-C (REST)'
  s.description  = <<-DESC
      Written by Google, this library is a flexible and efficient Objective-C
      framework for accessing JSON REST APIs.  This is the recommended library
      for accessing JSON-based Google APIs for iOS, OS X, and tvOS applications.

      This version can be used with iOS ≥ 7.0, OS X ≥ 10.9, tvOS ≥ 9.0.
                   DESC
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'

  s.user_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GTLR_USE_FRAMEWORK_IMPORTS=1' }
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GTLR_HAS_SESSION_UPLOAD_FETCHER_IMPORT=1' }

  # Require atleast 1.1.3 of the SessionFetcher so it has the backgroundTask
  # Testing support.
  s.dependency 'GTMSessionFetcher', '~> 1.1', '>= 1.1.3'

  s.subspec 'Core' do |sp|
    sp.source_files = 'Source/GTLRDefines.h',
                      'Source/Objects/*.{h,m}',
                      'Source/Utilities/*.{h,m}'
  end
  s.default_subspec = 'Core'

  # subspecs for all the services.
  s.subspec 'AdExchangeBuyer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdExchangeBuyer/*.{h,m}'
  end
  s.subspec 'AdExchangeBuyerII' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdExchangeBuyerII/*.{h,m}'
  end
  s.subspec 'AdExchangeSeller' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdExchangeSeller/*.{h,m}'
  end
  s.subspec 'AdSense' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdSense/*.{h,m}'
  end
  s.subspec 'AdSenseHost' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdSenseHost/*.{h,m}'
  end
  s.subspec 'Analytics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Analytics/*.{h,m}'
  end
  s.subspec 'AnalyticsReporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AnalyticsReporting/*.{h,m}'
  end
  s.subspec 'AndroidEnterprise' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AndroidEnterprise/*.{h,m}'
  end
  s.subspec 'AndroidPublisher' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AndroidPublisher/*.{h,m}'
  end
  s.subspec 'AppState' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AppState/*.{h,m}'
  end
  s.subspec 'Autoscaler' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Autoscaler/*.{h,m}'
  end
  s.subspec 'Bigquery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Bigquery/*.{h,m}'
  end
  s.subspec 'Blogger' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Blogger/*.{h,m}'
  end
  s.subspec 'Books' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Books/*.{h,m}'
  end
  s.subspec 'Calendar' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Calendar/*.{h,m}'
  end
  s.subspec 'CivicInfo' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CivicInfo/*.{h,m}'
  end
  s.subspec 'Classroom' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Classroom/*.{h,m}'
  end
  s.subspec 'CloudBuild' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudBuild/*.{h,m}'
  end
  s.subspec 'CloudMonitoring' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudMonitoring/*.{h,m}'
  end
  s.subspec 'CloudResourceManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudResourceManager/*.{h,m}'
  end
  s.subspec 'CloudUserAccounts' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudUserAccounts/*.{h,m}'
  end
  s.subspec 'Compute' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Compute/*.{h,m}'
  end
  s.subspec 'Container' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Container/*.{h,m}'
  end
  s.subspec 'Coordinate' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Coordinate/*.{h,m}'
  end
  s.subspec 'Customsearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Customsearch/*.{h,m}'
  end
  s.subspec 'DataTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DataTransfer/*.{h,m}'
  end
  s.subspec 'Dataflow' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Dataflow/*.{h,m}'
  end
  s.subspec 'Datastore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Datastore/*.{h,m}'
  end
  s.subspec 'DeploymentManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DeploymentManager/*.{h,m}'
  end
  s.subspec 'Directory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Directory/*.{h,m}'
  end
  s.subspec 'Discovery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Discovery/*.{h,m}'
  end
  s.subspec 'Dns' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Dns/*.{h,m}'
  end
  s.subspec 'DoubleClickBidManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DoubleClickBidManager/*.{h,m}'
  end
  s.subspec 'Drive' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Drive/*.{h,m}'
  end
  s.subspec 'Fitness' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Fitness/*.{h,m}'
  end
  s.subspec 'Freebase' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Freebase/*.{h,m}'
  end
  s.subspec 'Games' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Games/*.{h,m}'
  end
  s.subspec 'GamesConfiguration' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/GamesConfiguration/*.{h,m}'
  end
  s.subspec 'GamesManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/GamesManagement/*.{h,m}'
  end
  s.subspec 'Gmail' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Gmail/*.{h,m}'
  end
  s.subspec 'GroupsMigration' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/GroupsMigration/*.{h,m}'
  end
  s.subspec 'IdentityToolkit' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/IdentityToolkit/*.{h,m}'
  end
  s.subspec 'Licensing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Licensing/*.{h,m}'
  end
  s.subspec 'Logging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Logging/*.{h,m}'
  end
  s.subspec 'Manager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Manager/*.{h,m}'
  end
  s.subspec 'Mirror' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Mirror/*.{h,m}'
  end
  s.subspec 'Monitoring' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Monitoring/*.{h,m}'
  end
  s.subspec 'Oauth2' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Oauth2/*.{h,m}'
  end
  s.subspec 'Pagespeedonline' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Pagespeedonline/*.{h,m}'
  end
  s.subspec 'Partners' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Partners/*.{h,m}'
  end
  s.subspec 'People' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/People/*.{h,m}'
  end
  s.subspec 'Plus' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Plus/*.{h,m}'
  end
  s.subspec 'PlusDomains' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PlusDomains/*.{h,m}'
  end
  s.subspec 'Prediction' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Prediction/*.{h,m}'
  end
  s.subspec 'Pubsub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Pubsub/*.{h,m}'
  end
  s.subspec 'QPXExpress' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/QPXExpress/*.{h,m}'
  end
  s.subspec 'Reports' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Reports/*.{h,m}'
  end
  s.subspec 'Reseller' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Reseller/*.{h,m}'
  end
  s.subspec 'SQLAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SQLAdmin/*.{h,m}'
  end
  s.subspec 'Script' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Script/*.{h,m}'
  end
  s.subspec 'ServiceRegistry' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ServiceRegistry/*.{h,m}'
  end
  s.subspec 'ShoppingContent' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ShoppingContent/*.{h,m}'
  end
  s.subspec 'SiteVerification' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SiteVerification/*.{h,m}'
  end
  s.subspec 'Spectrum' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Spectrum/*.{h,m}'
  end
  s.subspec 'Storage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Storage/*.{h,m}'
  end
  s.subspec 'TagManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/TagManager/*.{h,m}'
  end
  s.subspec 'Taskqueue' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Taskqueue/*.{h,m}'
  end
  s.subspec 'Tasks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Tasks/*.{h,m}'
  end
  s.subspec 'ToolResults' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ToolResults/*.{h,m}'
  end
  s.subspec 'Translate' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Translate/*.{h,m}'
  end
  s.subspec 'Vision' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Vision/*.{h,m}'
  end
  s.subspec 'Webfonts' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Webfonts/*.{h,m}'
  end
  s.subspec 'Webmasters' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Webmasters/*.{h,m}'
  end
  s.subspec 'YouTube' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/YouTube/*.{h,m}'
  end
  s.subspec 'YouTubeAnalytics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/YouTubeAnalytics/*.{h,m}'
  end
  s.subspec 'YouTubeReporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/YouTubeReporting/*.{h,m}'
  end
end
