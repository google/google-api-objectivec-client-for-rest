Pod::Spec.new do |s|
  s.name         = 'GoogleAPIClientForREST'
  s.version      = '2.0.0'
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

      This version can be used with iOS ≥ 9.0, OS X ≥ 10.9, tvOS ≥ 10.0, watchOS ≥ 6.0.
                   DESC

  ios_deployment_target = '9.0'
  osx_deployment_target = '10.12'
  tvos_deployment_target = '10.0'
  watchos_deployment_target = '6.0'

  s.ios.deployment_target = ios_deployment_target
  s.osx.deployment_target = osx_deployment_target
  s.tvos.deployment_target = tvos_deployment_target
  s.watchos.deployment_target = watchos_deployment_target

  # Require at least 1.6.1 of the SessionFetcher since it has the same
  # deployment targets.
  s.dependency 'GTMSessionFetcher/Full', '>= 1.6.1', '< 3.0'

  s.prefix_header_file = false

  s.default_subspec = 'Core'

  s.subspec 'Core' do |sp|
    sp.source_files = 'Sources/Core/**/*.{h,m}'
    sp.public_header_files = 'Sources/Core/Public/GoogleAPIClientForREST/*.h'
  end

  s.test_spec 'Tests' do |sp|
    sp.source_files = 'UnitTests/*.{h,m}'

    sp.platforms = {
      :ios => ios_deployment_target,
      :osx => osx_deployment_target,
      :tvos => tvos_deployment_target,
      # Seem to need a higher min to get a good test runner picked/supported.
      :watchos => '7.4'
    }
  end

  # subspecs for all the services.
  s.subspec 'AbusiveExperienceReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AbusiveExperienceReport/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AbusiveExperienceReport/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Acceleratedmobilepageurl' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Acceleratedmobilepageurl/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Acceleratedmobilepageurl/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AccessApproval' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AccessApproval/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AccessApproval/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AccessContextManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AccessContextManager/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AccessContextManager/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AdExchangeBuyerII' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdExchangeBuyerII/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AdExchangeBuyerII/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AdExperienceReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdExperienceReport/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AdExperienceReport/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AdMob' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdMob/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AdMob/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Adsense' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Adsense/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Adsense/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AdSenseHost' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdSenseHost/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AdSenseHost/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AIPlatformNotebooks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AIPlatformNotebooks/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AIPlatformNotebooks/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AlertCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AlertCenter/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AlertCenter/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Analytics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Analytics/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Analytics/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AnalyticsData' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AnalyticsData/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AnalyticsData/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AnalyticsHub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AnalyticsHub/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AnalyticsHub/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AnalyticsReporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AnalyticsReporting/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AnalyticsReporting/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AndroidEnterprise' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidEnterprise/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AndroidEnterprise/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AndroidManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AndroidManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AndroidProvisioningPartner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidProvisioningPartner/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AndroidProvisioningPartner/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AndroidPublisher' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidPublisher/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AndroidPublisher/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'APIGateway' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/APIGateway/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/APIGateway/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Apigee' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Apigee/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Apigee/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ApigeeRegistry' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ApigeeRegistry/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ApigeeRegistry/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ApiKeysService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ApiKeysService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ApiKeysService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Appengine' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Appengine/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Appengine/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Area120Tables' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Area120Tables/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Area120Tables/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ArtifactRegistry' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ArtifactRegistry/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ArtifactRegistry/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Assuredworkloads' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Assuredworkloads/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Assuredworkloads/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'AuthorizedBuyersMarketplace' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AuthorizedBuyersMarketplace/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/AuthorizedBuyersMarketplace/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BackupforGKE' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BackupforGKE/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BackupforGKE/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BareMetalSolution' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BareMetalSolution/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BareMetalSolution/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BeyondCorp' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BeyondCorp/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BeyondCorp/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Bigquery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Bigquery/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Bigquery/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BigQueryConnectionService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigQueryConnectionService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BigQueryConnectionService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BigQueryDataTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigQueryDataTransfer/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BigQueryDataTransfer/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BigQueryReservation' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigQueryReservation/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BigQueryReservation/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BigtableAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigtableAdmin/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BigtableAdmin/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BinaryAuthorization' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BinaryAuthorization/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BinaryAuthorization/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Blogger' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Blogger/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Blogger/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Books' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Books/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Books/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'BusinessProfilePerformance' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BusinessProfilePerformance/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/BusinessProfilePerformance/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Calendar' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Calendar/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Calendar/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CertificateAuthorityService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CertificateAuthorityService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CertificateAuthorityService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CertificateManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CertificateManager/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CertificateManager/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ChromeManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ChromeManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ChromeManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ChromePolicy' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ChromePolicy/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ChromePolicy/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ChromeUXReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ChromeUXReport/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ChromeUXReport/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CivicInfo' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CivicInfo/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CivicInfo/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Classroom' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Classroom/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Classroom/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudAsset' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudAsset/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudAsset/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Cloudbilling' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Cloudbilling/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Cloudbilling/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudBillingBudget' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudBillingBudget/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudBillingBudget/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudBuild' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudBuild/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudBuild/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Cloudchannel' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Cloudchannel/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Cloudchannel/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudComposer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudComposer/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudComposer/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudDataplex' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDataplex/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudDataplex/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudDebugger' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDebugger/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudDebugger/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudDeploy' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDeploy/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudDeploy/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudDomains' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDomains/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudDomains/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Clouderrorreporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Clouderrorreporting/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Clouderrorreporting/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudFilestore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudFilestore/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudFilestore/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudFunctions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudFunctions/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudFunctions/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudHealthcare' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudHealthcare/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudHealthcare/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudIAP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudIAP/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudIAP/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudIdentity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudIdentity/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudIdentity/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudKMS' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudKMS/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudKMS/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudLifeSciences' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudLifeSciences/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudLifeSciences/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudMachineLearningEngine' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudMachineLearningEngine/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudMachineLearningEngine/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudMemorystoreforMemcached' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudMemorystoreforMemcached/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudMemorystoreforMemcached/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudNaturalLanguage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudNaturalLanguage/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudNaturalLanguage/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudOSLogin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudOSLogin/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudOSLogin/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudProfiler' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudProfiler/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudProfiler/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudRedis' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRedis/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudRedis/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudResourceManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudResourceManager/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudResourceManager/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudRetail' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRetail/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudRetail/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudRun' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRun/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudRun/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudRuntimeConfig' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRuntimeConfig/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudRuntimeConfig/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudScheduler' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudScheduler/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudScheduler/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudSearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSearch/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudSearch/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudSecurityToken' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSecurityToken/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudSecurityToken/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudShell' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudShell/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudShell/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudSourceRepositories' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSourceRepositories/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudSourceRepositories/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudSupport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSupport/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudSupport/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudTalentSolution' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudTalentSolution/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudTalentSolution/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudTasks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudTasks/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudTasks/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudTrace' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudTrace/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudTrace/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CloudVideoIntelligence' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudVideoIntelligence/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CloudVideoIntelligence/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Compute' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Compute/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Compute/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Connectors' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Connectors/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Connectors/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Contactcenterinsights' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Contactcenterinsights/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Contactcenterinsights/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Container' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Container/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Container/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ContainerAnalysis' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ContainerAnalysis/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ContainerAnalysis/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'CustomSearchAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CustomSearchAPI/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/CustomSearchAPI/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DatabaseMigrationService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DatabaseMigrationService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DatabaseMigrationService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DataCatalog' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataCatalog/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DataCatalog/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Dataflow' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dataflow/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Dataflow/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DataFusion' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataFusion/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DataFusion/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DataLabeling' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataLabeling/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DataLabeling/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Datapipelines' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Datapipelines/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Datapipelines/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Dataproc' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dataproc/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Dataproc/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DataprocMetastore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataprocMetastore/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DataprocMetastore/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Datastore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Datastore/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Datastore/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Datastream' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Datastream/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Datastream/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DataTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataTransfer/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DataTransfer/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DeploymentManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DeploymentManager/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DeploymentManager/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Dfareporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dfareporting/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Dfareporting/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Dialogflow' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dialogflow/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Dialogflow/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DigitalAssetLinks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DigitalAssetLinks/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DigitalAssetLinks/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Directory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Directory/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Directory/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Discovery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Discovery/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Discovery/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DisplayVideo' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DisplayVideo/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DisplayVideo/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DLP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DLP/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DLP/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Dns' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dns/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Dns/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Docs' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Docs/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Docs/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Document' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Document/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Document/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DomainsRDAP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DomainsRDAP/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DomainsRDAP/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DoubleClickBidManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DoubleClickBidManager/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DoubleClickBidManager/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Doubleclicksearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Doubleclicksearch/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Doubleclicksearch/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Drive' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Drive/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Drive/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DriveActivity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DriveActivity/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DriveActivity/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'DriveLabels' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DriveLabels/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/DriveLabels/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Essentialcontacts' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Essentialcontacts/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Essentialcontacts/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Eventarc' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Eventarc/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Eventarc/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FactCheckTools' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FactCheckTools/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FactCheckTools/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Fcmdata' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Fcmdata/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Fcmdata/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Firebaseappcheck' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Firebaseappcheck/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Firebaseappcheck/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FirebaseCloudMessaging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseCloudMessaging/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FirebaseCloudMessaging/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FirebaseDynamicLinks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseDynamicLinks/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FirebaseDynamicLinks/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FirebaseHosting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseHosting/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FirebaseHosting/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FirebaseManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FirebaseManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FirebaseML' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseML/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FirebaseML/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FirebaseRealtimeDatabase' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseRealtimeDatabase/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FirebaseRealtimeDatabase/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'FirebaseRules' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseRules/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/FirebaseRules/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Firebasestorage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Firebasestorage/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Firebasestorage/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Firestore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Firestore/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Firestore/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Fitness' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Fitness/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Fitness/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Forms' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Forms/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Forms/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Games' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Games/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Games/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'GamesConfiguration' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GamesConfiguration/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/GamesConfiguration/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'GameServices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GameServices/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/GameServices/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'GamesManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GamesManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/GamesManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Genomics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Genomics/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Genomics/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'GKEHub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GKEHub/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/GKEHub/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Gmail' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Gmail/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Gmail/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'GoogleAnalyticsAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GoogleAnalyticsAdmin/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/GoogleAnalyticsAdmin/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'GroupsMigration' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GroupsMigration/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/GroupsMigration/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'GroupsSettings' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GroupsSettings/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/GroupsSettings/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'HangoutsChat' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/HangoutsChat/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/HangoutsChat/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'HomeGraphService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/HomeGraphService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/HomeGraphService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Iam' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Iam/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Iam/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'IAMCredentials' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/IAMCredentials/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/IAMCredentials/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Ideahub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Ideahub/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Ideahub/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'IdentityToolkit' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/IdentityToolkit/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/IdentityToolkit/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'IDS' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/IDS/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/IDS/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Indexing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Indexing/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Indexing/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Keep' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Keep/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Keep/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Kgsearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Kgsearch/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Kgsearch/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Libraryagent' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Libraryagent/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Libraryagent/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Licensing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Licensing/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Licensing/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Localservices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Localservices/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Localservices/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Logging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Logging/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Logging/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ManagedServiceforMicrosoftActiveDirectoryConsumerAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ManagedServiceforMicrosoftActiveDirectoryConsumerAPI/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ManagedServiceforMicrosoftActiveDirectoryConsumerAPI/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ManufacturerCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ManufacturerCenter/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ManufacturerCenter/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Monitoring' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Monitoring/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Monitoring/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessAccountManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessAccountManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessAccountManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessBusinessCalls' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessBusinessCalls/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessBusinessCalls/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessBusinessInformation' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessBusinessInformation/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessBusinessInformation/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessLodging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessLodging/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessLodging/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessNotificationSettings' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessNotificationSettings/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessNotificationSettings/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessPlaceActions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessPlaceActions/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessPlaceActions/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessQA' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessQA/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessQA/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'MyBusinessVerifications' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessVerifications/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/MyBusinessVerifications/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Networkconnectivity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Networkconnectivity/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Networkconnectivity/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'NetworkManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/NetworkManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/NetworkManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'NetworkSecurity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/NetworkSecurity/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/NetworkSecurity/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'NetworkServices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/NetworkServices/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/NetworkServices/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Oauth2' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Oauth2/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Oauth2/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'OnDemandScanning' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/OnDemandScanning/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/OnDemandScanning/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'OrgPolicyAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/OrgPolicyAPI/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/OrgPolicyAPI/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'OSConfig' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/OSConfig/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/OSConfig/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PagespeedInsights' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PagespeedInsights/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PagespeedInsights/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PaymentsResellerSubscription' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PaymentsResellerSubscription/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PaymentsResellerSubscription/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PeopleService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PeopleService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PeopleService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Playcustomapp' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Playcustomapp/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Playcustomapp/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Playdeveloperreporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Playdeveloperreporting/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Playdeveloperreporting/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PlayIntegrity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PlayIntegrity/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PlayIntegrity/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PolicyAnalyzer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolicyAnalyzer/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PolicyAnalyzer/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PolicySimulator' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolicySimulator/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PolicySimulator/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PolicyTroubleshooter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolicyTroubleshooter/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PolicyTroubleshooter/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PolyService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolyService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PolyService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PostmasterTools' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PostmasterTools/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PostmasterTools/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Pubsub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Pubsub/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Pubsub/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'PubsubLite' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PubsubLite/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/PubsubLite/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'RealTimeBidding' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/RealTimeBidding/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/RealTimeBidding/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'RecaptchaEnterprise' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/RecaptchaEnterprise/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/RecaptchaEnterprise/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'RecommendationsAI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/RecommendationsAI/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/RecommendationsAI/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Recommender' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Recommender/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Recommender/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Reports' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Reports/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Reports/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Reseller' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Reseller/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Reseller/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ResourceSettings' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ResourceSettings/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ResourceSettings/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Safebrowsing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Safebrowsing/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Safebrowsing/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'SASPortal' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SASPortal/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/SASPortal/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Script' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Script/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Script/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'SearchConsole' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SearchConsole/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/SearchConsole/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'SecretManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SecretManager/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/SecretManager/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'SecurityCommandCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SecurityCommandCenter/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/SecurityCommandCenter/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ServiceConsumerManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceConsumerManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ServiceConsumerManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ServiceControl' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceControl/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ServiceControl/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ServiceDirectory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceDirectory/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ServiceDirectory/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ServiceManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ServiceManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ServiceNetworking' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceNetworking/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ServiceNetworking/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ServiceUsage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceUsage/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ServiceUsage/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Sheets' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Sheets/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Sheets/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ShoppingContent' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ShoppingContent/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ShoppingContent/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'SiteVerification' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SiteVerification/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/SiteVerification/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Slides' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Slides/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Slides/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'SmartDeviceManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SmartDeviceManagement/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/SmartDeviceManagement/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Spanner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Spanner/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Spanner/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Speech' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Speech/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Speech/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'SQLAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SQLAdmin/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/SQLAdmin/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Storage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Storage/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Storage/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'StorageTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/StorageTransfer/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/StorageTransfer/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'StreetViewPublish' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/StreetViewPublish/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/StreetViewPublish/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'TagManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/TagManager/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/TagManager/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Tasks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Tasks/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Tasks/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Testing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Testing/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Testing/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Texttospeech' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Texttospeech/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Texttospeech/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'ToolResults' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ToolResults/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/ToolResults/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'TPU' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/TPU/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/TPU/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'TrafficDirectorService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/TrafficDirectorService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/TrafficDirectorService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Transcoder' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Transcoder/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Transcoder/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Translate' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Translate/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Translate/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Vault' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Vault/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Vault/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Verifiedaccess' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Verifiedaccess/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Verifiedaccess/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'VersionHistory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/VersionHistory/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/VersionHistory/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Vision' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Vision/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Vision/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'VMMigrationService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/VMMigrationService/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/VMMigrationService/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Webfonts' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Webfonts/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Webfonts/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'WebRisk' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/WebRisk/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/WebRisk/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'WebSecurityScanner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/WebSecurityScanner/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/WebSecurityScanner/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'WorkflowExecutions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/WorkflowExecutions/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/WorkflowExecutions/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'Workflows' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Workflows/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/Workflows/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'YouTube' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/YouTube/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/YouTube/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'YouTubeAnalytics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/YouTubeAnalytics/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/YouTubeAnalytics/Public/GoogleAPIClientForREST/*.h'
  end
  s.subspec 'YouTubeReporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/YouTubeReporting/**/*.{h,m}'
    sp.public_header_files = 'Sources/GeneratedServices/YouTubeReporting/Public/GoogleAPIClientForREST/*.h'
  end
end
