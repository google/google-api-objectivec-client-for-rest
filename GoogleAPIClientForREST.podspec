Pod::Spec.new do |s|
  s.name         = 'GoogleAPIClientForREST'
  s.version      = '1.7.0'
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
  s.dependency 'GTMSessionFetcher/Full', '>= 1.6.1', '< 2.0'

  s.prefix_header_file = false

  s.default_subspec = 'Core'

  s.subspec 'Core' do |sp|
    sp.source_files = 'Sources/Core/**/*.{h,m}'
    sp.public_header_files = 'Sources/Core/Public/GoogleAPIClientForREST/*.h'
  end

  s.test_spec 'Tests' do |sp|
    sp.source_files = 'UnitTests/*.{h,m}'
    sp.resource = 'UnitTests/Data/*.txt'

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
    sp.source_files = 'Sources/GeneratedServices/AbusiveExperienceReport/*.{h,m}'
  end
  s.subspec 'Acceleratedmobilepageurl' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Acceleratedmobilepageurl/*.{h,m}'
  end
  s.subspec 'AccessApproval' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AccessApproval/*.{h,m}'
  end
  s.subspec 'AccessContextManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AccessContextManager/*.{h,m}'
  end
  s.subspec 'AdExchangeBuyerII' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdExchangeBuyerII/*.{h,m}'
  end
  s.subspec 'AdExperienceReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdExperienceReport/*.{h,m}'
  end
  s.subspec 'AdMob' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdMob/*.{h,m}'
  end
  s.subspec 'Adsense' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Adsense/*.{h,m}'
  end
  s.subspec 'AdSenseHost' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AdSenseHost/*.{h,m}'
  end
  s.subspec 'AIPlatformNotebooks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AIPlatformNotebooks/*.{h,m}'
  end
  s.subspec 'AlertCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AlertCenter/*.{h,m}'
  end
  s.subspec 'Analytics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Analytics/*.{h,m}'
  end
  s.subspec 'AnalyticsData' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AnalyticsData/*.{h,m}'
  end
  s.subspec 'AnalyticsReporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AnalyticsReporting/*.{h,m}'
  end
  s.subspec 'AndroidEnterprise' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidEnterprise/*.{h,m}'
  end
  s.subspec 'AndroidManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidManagement/*.{h,m}'
  end
  s.subspec 'AndroidProvisioningPartner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidProvisioningPartner/*.{h,m}'
  end
  s.subspec 'AndroidPublisher' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AndroidPublisher/*.{h,m}'
  end
  s.subspec 'APIGateway' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/APIGateway/*.{h,m}'
  end
  s.subspec 'Apigee' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Apigee/*.{h,m}'
  end
  s.subspec 'ApigeeRegistry' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ApigeeRegistry/*.{h,m}'
  end
  s.subspec 'ApiKeysService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ApiKeysService/*.{h,m}'
  end
  s.subspec 'Appengine' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Appengine/*.{h,m}'
  end
  s.subspec 'Area120Tables' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Area120Tables/*.{h,m}'
  end
  s.subspec 'ArtifactRegistry' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ArtifactRegistry/*.{h,m}'
  end
  s.subspec 'Assuredworkloads' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Assuredworkloads/*.{h,m}'
  end
  s.subspec 'AuthorizedBuyersMarketplace' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/AuthorizedBuyersMarketplace/*.{h,m}'
  end
  s.subspec 'BackupforGKE' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BackupforGKE/*.{h,m}'
  end
  s.subspec 'BareMetalSolution' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BareMetalSolution/*.{h,m}'
  end
  s.subspec 'Bigquery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Bigquery/*.{h,m}'
  end
  s.subspec 'BigQueryConnectionService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigQueryConnectionService/*.{h,m}'
  end
  s.subspec 'BigQueryDataTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigQueryDataTransfer/*.{h,m}'
  end
  s.subspec 'BigQueryReservation' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigQueryReservation/*.{h,m}'
  end
  s.subspec 'BigtableAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BigtableAdmin/*.{h,m}'
  end
  s.subspec 'BinaryAuthorization' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/BinaryAuthorization/*.{h,m}'
  end
  s.subspec 'Blogger' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Blogger/*.{h,m}'
  end
  s.subspec 'Books' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Books/*.{h,m}'
  end
  s.subspec 'Calendar' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Calendar/*.{h,m}'
  end
  s.subspec 'CertificateAuthorityService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CertificateAuthorityService/*.{h,m}'
  end
  s.subspec 'CertificateManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CertificateManager/*.{h,m}'
  end
  s.subspec 'ChromeManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ChromeManagement/*.{h,m}'
  end
  s.subspec 'ChromePolicy' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ChromePolicy/*.{h,m}'
  end
  s.subspec 'ChromeUXReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ChromeUXReport/*.{h,m}'
  end
  s.subspec 'CivicInfo' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CivicInfo/*.{h,m}'
  end
  s.subspec 'Classroom' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Classroom/*.{h,m}'
  end
  s.subspec 'CloudAsset' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudAsset/*.{h,m}'
  end
  s.subspec 'Cloudbilling' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Cloudbilling/*.{h,m}'
  end
  s.subspec 'CloudBillingBudget' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudBillingBudget/*.{h,m}'
  end
  s.subspec 'CloudBuild' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudBuild/*.{h,m}'
  end
  s.subspec 'Cloudchannel' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Cloudchannel/*.{h,m}'
  end
  s.subspec 'CloudComposer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudComposer/*.{h,m}'
  end
  s.subspec 'CloudDataplex' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDataplex/*.{h,m}'
  end
  s.subspec 'CloudDebugger' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDebugger/*.{h,m}'
  end
  s.subspec 'CloudDeploy' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDeploy/*.{h,m}'
  end
  s.subspec 'CloudDomains' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudDomains/*.{h,m}'
  end
  s.subspec 'Clouderrorreporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Clouderrorreporting/*.{h,m}'
  end
  s.subspec 'CloudFilestore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudFilestore/*.{h,m}'
  end
  s.subspec 'CloudFunctions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudFunctions/*.{h,m}'
  end
  s.subspec 'CloudHealthcare' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudHealthcare/*.{h,m}'
  end
  s.subspec 'CloudIAP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudIAP/*.{h,m}'
  end
  s.subspec 'CloudIdentity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudIdentity/*.{h,m}'
  end
  s.subspec 'CloudIot' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudIot/*.{h,m}'
  end
  s.subspec 'CloudKMS' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudKMS/*.{h,m}'
  end
  s.subspec 'CloudLifeSciences' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudLifeSciences/*.{h,m}'
  end
  s.subspec 'CloudMachineLearningEngine' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudMachineLearningEngine/*.{h,m}'
  end
  s.subspec 'CloudMemorystoreforMemcached' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudMemorystoreforMemcached/*.{h,m}'
  end
  s.subspec 'CloudNaturalLanguage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudNaturalLanguage/*.{h,m}'
  end
  s.subspec 'CloudOSLogin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudOSLogin/*.{h,m}'
  end
  s.subspec 'CloudProfiler' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudProfiler/*.{h,m}'
  end
  s.subspec 'CloudRedis' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRedis/*.{h,m}'
  end
  s.subspec 'CloudResourceManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudResourceManager/*.{h,m}'
  end
  s.subspec 'CloudRetail' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRetail/*.{h,m}'
  end
  s.subspec 'CloudRun' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRun/*.{h,m}'
  end
  s.subspec 'CloudRuntimeConfig' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudRuntimeConfig/*.{h,m}'
  end
  s.subspec 'CloudScheduler' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudScheduler/*.{h,m}'
  end
  s.subspec 'CloudSearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSearch/*.{h,m}'
  end
  s.subspec 'CloudSecurityToken' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSecurityToken/*.{h,m}'
  end
  s.subspec 'CloudShell' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudShell/*.{h,m}'
  end
  s.subspec 'CloudSourceRepositories' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSourceRepositories/*.{h,m}'
  end
  s.subspec 'CloudSupport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudSupport/*.{h,m}'
  end
  s.subspec 'CloudTalentSolution' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudTalentSolution/*.{h,m}'
  end
  s.subspec 'CloudTasks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudTasks/*.{h,m}'
  end
  s.subspec 'CloudTrace' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudTrace/*.{h,m}'
  end
  s.subspec 'CloudVideoIntelligence' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CloudVideoIntelligence/*.{h,m}'
  end
  s.subspec 'Compute' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Compute/*.{h,m}'
  end
  s.subspec 'Connectors' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Connectors/*.{h,m}'
  end
  s.subspec 'Contactcenterinsights' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Contactcenterinsights/*.{h,m}'
  end
  s.subspec 'Container' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Container/*.{h,m}'
  end
  s.subspec 'ContainerAnalysis' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ContainerAnalysis/*.{h,m}'
  end
  s.subspec 'CustomSearchAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/CustomSearchAPI/*.{h,m}'
  end
  s.subspec 'DatabaseMigrationService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DatabaseMigrationService/*.{h,m}'
  end
  s.subspec 'DataCatalog' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataCatalog/*.{h,m}'
  end
  s.subspec 'Dataflow' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dataflow/*.{h,m}'
  end
  s.subspec 'DataFusion' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataFusion/*.{h,m}'
  end
  s.subspec 'DataLabeling' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataLabeling/*.{h,m}'
  end
  s.subspec 'Datapipelines' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Datapipelines/*.{h,m}'
  end
  s.subspec 'Dataproc' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dataproc/*.{h,m}'
  end
  s.subspec 'DataprocMetastore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataprocMetastore/*.{h,m}'
  end
  s.subspec 'Datastore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Datastore/*.{h,m}'
  end
  s.subspec 'Datastream' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Datastream/*.{h,m}'
  end
  s.subspec 'DataTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DataTransfer/*.{h,m}'
  end
  s.subspec 'DeploymentManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DeploymentManager/*.{h,m}'
  end
  s.subspec 'Dfareporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dfareporting/*.{h,m}'
  end
  s.subspec 'Dialogflow' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dialogflow/*.{h,m}'
  end
  s.subspec 'DigitalAssetLinks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DigitalAssetLinks/*.{h,m}'
  end
  s.subspec 'Directory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Directory/*.{h,m}'
  end
  s.subspec 'Discovery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Discovery/*.{h,m}'
  end
  s.subspec 'DisplayVideo' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DisplayVideo/*.{h,m}'
  end
  s.subspec 'DLP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DLP/*.{h,m}'
  end
  s.subspec 'Dns' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Dns/*.{h,m}'
  end
  s.subspec 'Docs' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Docs/*.{h,m}'
  end
  s.subspec 'Document' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Document/*.{h,m}'
  end
  s.subspec 'DomainsRDAP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DomainsRDAP/*.{h,m}'
  end
  s.subspec 'DoubleClickBidManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DoubleClickBidManager/*.{h,m}'
  end
  s.subspec 'Doubleclicksearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Doubleclicksearch/*.{h,m}'
  end
  s.subspec 'Drive' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Drive/*.{h,m}'
  end
  s.subspec 'DriveActivity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/DriveActivity/*.{h,m}'
  end
  s.subspec 'Essentialcontacts' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Essentialcontacts/*.{h,m}'
  end
  s.subspec 'Eventarc' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Eventarc/*.{h,m}'
  end
  s.subspec 'FactCheckTools' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FactCheckTools/*.{h,m}'
  end
  s.subspec 'Fcmdata' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Fcmdata/*.{h,m}'
  end
  s.subspec 'Firebaseappcheck' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Firebaseappcheck/*.{h,m}'
  end
  s.subspec 'FirebaseCloudMessaging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseCloudMessaging/*.{h,m}'
  end
  s.subspec 'FirebaseDynamicLinks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseDynamicLinks/*.{h,m}'
  end
  s.subspec 'FirebaseHosting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseHosting/*.{h,m}'
  end
  s.subspec 'FirebaseManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseManagement/*.{h,m}'
  end
  s.subspec 'FirebaseML' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseML/*.{h,m}'
  end
  s.subspec 'FirebaseRealtimeDatabase' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseRealtimeDatabase/*.{h,m}'
  end
  s.subspec 'FirebaseRules' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/FirebaseRules/*.{h,m}'
  end
  s.subspec 'Firebasestorage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Firebasestorage/*.{h,m}'
  end
  s.subspec 'Firestore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Firestore/*.{h,m}'
  end
  s.subspec 'Fitness' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Fitness/*.{h,m}'
  end
  s.subspec 'Forms' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Forms/*.{h,m}'
  end
  s.subspec 'Games' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Games/*.{h,m}'
  end
  s.subspec 'GamesConfiguration' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GamesConfiguration/*.{h,m}'
  end
  s.subspec 'GameServices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GameServices/*.{h,m}'
  end
  s.subspec 'GamesManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GamesManagement/*.{h,m}'
  end
  s.subspec 'Genomics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Genomics/*.{h,m}'
  end
  s.subspec 'GKEHub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GKEHub/*.{h,m}'
  end
  s.subspec 'Gmail' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Gmail/*.{h,m}'
  end
  s.subspec 'GoogleAnalyticsAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GoogleAnalyticsAdmin/*.{h,m}'
  end
  s.subspec 'GroupsMigration' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GroupsMigration/*.{h,m}'
  end
  s.subspec 'GroupsSettings' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/GroupsSettings/*.{h,m}'
  end
  s.subspec 'HangoutsChat' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/HangoutsChat/*.{h,m}'
  end
  s.subspec 'HomeGraphService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/HomeGraphService/*.{h,m}'
  end
  s.subspec 'Iam' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Iam/*.{h,m}'
  end
  s.subspec 'IAMCredentials' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/IAMCredentials/*.{h,m}'
  end
  s.subspec 'Ideahub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Ideahub/*.{h,m}'
  end
  s.subspec 'IdentityToolkit' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/IdentityToolkit/*.{h,m}'
  end
  s.subspec 'IDS' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/IDS/*.{h,m}'
  end
  s.subspec 'Indexing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Indexing/*.{h,m}'
  end
  s.subspec 'Keep' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Keep/*.{h,m}'
  end
  s.subspec 'Kgsearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Kgsearch/*.{h,m}'
  end
  s.subspec 'Libraryagent' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Libraryagent/*.{h,m}'
  end
  s.subspec 'Licensing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Licensing/*.{h,m}'
  end
  s.subspec 'Localservices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Localservices/*.{h,m}'
  end
  s.subspec 'Logging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Logging/*.{h,m}'
  end
  s.subspec 'ManagedServiceforMicrosoftActiveDirectoryConsumerAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ManagedServiceforMicrosoftActiveDirectoryConsumerAPI/*.{h,m}'
  end
  s.subspec 'ManufacturerCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ManufacturerCenter/*.{h,m}'
  end
  s.subspec 'Monitoring' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Monitoring/*.{h,m}'
  end
  s.subspec 'MyBusinessAccountManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessAccountManagement/*.{h,m}'
  end
  s.subspec 'MyBusinessBusinessCalls' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessBusinessCalls/*.{h,m}'
  end
  s.subspec 'MyBusinessBusinessInformation' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessBusinessInformation/*.{h,m}'
  end
  s.subspec 'MyBusinessLodging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessLodging/*.{h,m}'
  end
  s.subspec 'MyBusinessNotificationSettings' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessNotificationSettings/*.{h,m}'
  end
  s.subspec 'MyBusinessPlaceActions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessPlaceActions/*.{h,m}'
  end
  s.subspec 'MyBusinessQA' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessQA/*.{h,m}'
  end
  s.subspec 'MyBusinessVerifications' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/MyBusinessVerifications/*.{h,m}'
  end
  s.subspec 'Networkconnectivity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Networkconnectivity/*.{h,m}'
  end
  s.subspec 'NetworkManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/NetworkManagement/*.{h,m}'
  end
  s.subspec 'NetworkSecurity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/NetworkSecurity/*.{h,m}'
  end
  s.subspec 'NetworkServices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/NetworkServices/*.{h,m}'
  end
  s.subspec 'Oauth2' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Oauth2/*.{h,m}'
  end
  s.subspec 'OnDemandScanning' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/OnDemandScanning/*.{h,m}'
  end
  s.subspec 'OrgPolicyAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/OrgPolicyAPI/*.{h,m}'
  end
  s.subspec 'OSConfig' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/OSConfig/*.{h,m}'
  end
  s.subspec 'PagespeedInsights' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PagespeedInsights/*.{h,m}'
  end
  s.subspec 'PaymentsResellerSubscription' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PaymentsResellerSubscription/*.{h,m}'
  end
  s.subspec 'PeopleService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PeopleService/*.{h,m}'
  end
  s.subspec 'Playcustomapp' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Playcustomapp/*.{h,m}'
  end
  s.subspec 'Playdeveloperreporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Playdeveloperreporting/*.{h,m}'
  end
  s.subspec 'PlayIntegrity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PlayIntegrity/*.{h,m}'
  end
  s.subspec 'PolicyAnalyzer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolicyAnalyzer/*.{h,m}'
  end
  s.subspec 'PolicySimulator' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolicySimulator/*.{h,m}'
  end
  s.subspec 'PolicyTroubleshooter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolicyTroubleshooter/*.{h,m}'
  end
  s.subspec 'PolyService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PolyService/*.{h,m}'
  end
  s.subspec 'PostmasterTools' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PostmasterTools/*.{h,m}'
  end
  s.subspec 'Pubsub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Pubsub/*.{h,m}'
  end
  s.subspec 'PubsubLite' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/PubsubLite/*.{h,m}'
  end
  s.subspec 'RealTimeBidding' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/RealTimeBidding/*.{h,m}'
  end
  s.subspec 'RecaptchaEnterprise' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/RecaptchaEnterprise/*.{h,m}'
  end
  s.subspec 'RecommendationsAI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/RecommendationsAI/*.{h,m}'
  end
  s.subspec 'Recommender' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Recommender/*.{h,m}'
  end
  s.subspec 'Reports' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Reports/*.{h,m}'
  end
  s.subspec 'Reseller' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Reseller/*.{h,m}'
  end
  s.subspec 'ResourceSettings' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ResourceSettings/*.{h,m}'
  end
  s.subspec 'Safebrowsing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Safebrowsing/*.{h,m}'
  end
  s.subspec 'SASPortal' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SASPortal/*.{h,m}'
  end
  s.subspec 'Script' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Script/*.{h,m}'
  end
  s.subspec 'SearchConsole' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SearchConsole/*.{h,m}'
  end
  s.subspec 'SecretManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SecretManager/*.{h,m}'
  end
  s.subspec 'SecurityCommandCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SecurityCommandCenter/*.{h,m}'
  end
  s.subspec 'ServiceConsumerManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceConsumerManagement/*.{h,m}'
  end
  s.subspec 'ServiceControl' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceControl/*.{h,m}'
  end
  s.subspec 'ServiceDirectory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceDirectory/*.{h,m}'
  end
  s.subspec 'ServiceManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceManagement/*.{h,m}'
  end
  s.subspec 'ServiceNetworking' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceNetworking/*.{h,m}'
  end
  s.subspec 'ServiceUsage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ServiceUsage/*.{h,m}'
  end
  s.subspec 'Sheets' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Sheets/*.{h,m}'
  end
  s.subspec 'ShoppingContent' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ShoppingContent/*.{h,m}'
  end
  s.subspec 'SiteVerification' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SiteVerification/*.{h,m}'
  end
  s.subspec 'Slides' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Slides/*.{h,m}'
  end
  s.subspec 'SmartDeviceManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SmartDeviceManagement/*.{h,m}'
  end
  s.subspec 'Spanner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Spanner/*.{h,m}'
  end
  s.subspec 'Speech' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Speech/*.{h,m}'
  end
  s.subspec 'SQLAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/SQLAdmin/*.{h,m}'
  end
  s.subspec 'Storage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Storage/*.{h,m}'
  end
  s.subspec 'StorageTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/StorageTransfer/*.{h,m}'
  end
  s.subspec 'StreetViewPublish' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/StreetViewPublish/*.{h,m}'
  end
  s.subspec 'TagManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/TagManager/*.{h,m}'
  end
  s.subspec 'Tasks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Tasks/*.{h,m}'
  end
  s.subspec 'Testing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Testing/*.{h,m}'
  end
  s.subspec 'Texttospeech' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Texttospeech/*.{h,m}'
  end
  s.subspec 'ToolResults' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/ToolResults/*.{h,m}'
  end
  s.subspec 'TPU' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/TPU/*.{h,m}'
  end
  s.subspec 'TrafficDirectorService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/TrafficDirectorService/*.{h,m}'
  end
  s.subspec 'Transcoder' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Transcoder/*.{h,m}'
  end
  s.subspec 'Translate' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Translate/*.{h,m}'
  end
  s.subspec 'Vault' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Vault/*.{h,m}'
  end
  s.subspec 'Verifiedaccess' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Verifiedaccess/*.{h,m}'
  end
  s.subspec 'VersionHistory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/VersionHistory/*.{h,m}'
  end
  s.subspec 'Vision' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Vision/*.{h,m}'
  end
  s.subspec 'VMMigrationService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/VMMigrationService/*.{h,m}'
  end
  s.subspec 'Webfonts' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Webfonts/*.{h,m}'
  end
  s.subspec 'WebRisk' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/WebRisk/*.{h,m}'
  end
  s.subspec 'WebSecurityScanner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/WebSecurityScanner/*.{h,m}'
  end
  s.subspec 'WorkflowExecutions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/WorkflowExecutions/*.{h,m}'
  end
  s.subspec 'Workflows' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/Workflows/*.{h,m}'
  end
  s.subspec 'YouTube' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/YouTube/*.{h,m}'
  end
  s.subspec 'YouTubeAnalytics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/YouTubeAnalytics/*.{h,m}'
  end
  s.subspec 'YouTubeReporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Sources/GeneratedServices/YouTubeReporting/*.{h,m}'
  end
end
