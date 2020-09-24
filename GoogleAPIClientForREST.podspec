Pod::Spec.new do |s|
  s.name         = 'GoogleAPIClientForREST'
  s.version      = '1.4.3'
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

      This version can be used with iOS ≥ 7.0, OS X ≥ 10.9, tvOS ≥ 9.0, watchOS ≥ 2.0.
                   DESC

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  # Require at least 1.1.7 of the SessionFetcher for some changes in that
  # project's headers.
  s.dependency 'GTMSessionFetcher', '>= 1.1.7'

  s.subspec 'Core' do |sp|
    sp.source_files = 'Source/GTLRDefines.h',
                      'Source/Objects/*.{h,m}',
                      'Source/Utilities/*.{h,m}'
  end
  s.default_subspec = 'Core'

  # subspecs for all the services.
  s.subspec 'AbusiveExperienceReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AbusiveExperienceReport/*.{h,m}'
  end
  s.subspec 'Acceleratedmobilepageurl' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Acceleratedmobilepageurl/*.{h,m}'
  end
  s.subspec 'AccessApproval' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AccessApproval/*.{h,m}'
  end
  s.subspec 'AccessContextManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AccessContextManager/*.{h,m}'
  end
  s.subspec 'AdExchangeBuyer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdExchangeBuyer/*.{h,m}'
  end
  s.subspec 'AdExchangeBuyerII' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdExchangeBuyerII/*.{h,m}'
  end
  s.subspec 'AdExperienceReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdExperienceReport/*.{h,m}'
  end
  s.subspec 'AdMob' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdMob/*.{h,m}'
  end
  s.subspec 'AdSense' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdSense/*.{h,m}'
  end
  s.subspec 'AdSenseHost' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AdSenseHost/*.{h,m}'
  end
  s.subspec 'AlertCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AlertCenter/*.{h,m}'
  end
  s.subspec 'Analytics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Analytics/*.{h,m}'
  end
  s.subspec 'AnalyticsData' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AnalyticsData/*.{h,m}'
  end
  s.subspec 'AnalyticsReporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AnalyticsReporting/*.{h,m}'
  end
  s.subspec 'AndroidEnterprise' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AndroidEnterprise/*.{h,m}'
  end
  s.subspec 'AndroidManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AndroidManagement/*.{h,m}'
  end
  s.subspec 'AndroidProvisioningPartner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AndroidProvisioningPartner/*.{h,m}'
  end
  s.subspec 'AndroidPublisher' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/AndroidPublisher/*.{h,m}'
  end
  s.subspec 'Apigee' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Apigee/*.{h,m}'
  end
  s.subspec 'Appengine' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Appengine/*.{h,m}'
  end
  s.subspec 'Appsactivity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Appsactivity/*.{h,m}'
  end
  s.subspec 'ArtifactRegistry' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ArtifactRegistry/*.{h,m}'
  end
  s.subspec 'Assuredworkloads' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Assuredworkloads/*.{h,m}'
  end
  s.subspec 'BigQueryConnectionService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/BigQueryConnectionService/*.{h,m}'
  end
  s.subspec 'BigQueryDataTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/BigQueryDataTransfer/*.{h,m}'
  end
  s.subspec 'BigQueryReservation' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/BigQueryReservation/*.{h,m}'
  end
  s.subspec 'Bigquery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Bigquery/*.{h,m}'
  end
  s.subspec 'BigtableAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/BigtableAdmin/*.{h,m}'
  end
  s.subspec 'BinaryAuthorization' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/BinaryAuthorization/*.{h,m}'
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
  s.subspec 'ChromeUXReport' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ChromeUXReport/*.{h,m}'
  end
  s.subspec 'CivicInfo' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CivicInfo/*.{h,m}'
  end
  s.subspec 'Classroom' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Classroom/*.{h,m}'
  end
  s.subspec 'CloudAsset' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudAsset/*.{h,m}'
  end
  s.subspec 'CloudBillingBudget' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudBillingBudget/*.{h,m}'
  end
  s.subspec 'CloudBuild' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudBuild/*.{h,m}'
  end
  s.subspec 'CloudComposer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudComposer/*.{h,m}'
  end
  s.subspec 'CloudDebugger' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudDebugger/*.{h,m}'
  end
  s.subspec 'CloudFilestore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudFilestore/*.{h,m}'
  end
  s.subspec 'CloudFunctions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudFunctions/*.{h,m}'
  end
  s.subspec 'CloudHealthcare' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudHealthcare/*.{h,m}'
  end
  s.subspec 'CloudIAP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudIAP/*.{h,m}'
  end
  s.subspec 'CloudIdentity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudIdentity/*.{h,m}'
  end
  s.subspec 'CloudIot' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudIot/*.{h,m}'
  end
  s.subspec 'CloudKMS' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudKMS/*.{h,m}'
  end
  s.subspec 'CloudLifeSciences' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudLifeSciences/*.{h,m}'
  end
  s.subspec 'CloudMachineLearningEngine' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudMachineLearningEngine/*.{h,m}'
  end
  s.subspec 'CloudMemorystoreforMemcached' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudMemorystoreforMemcached/*.{h,m}'
  end
  s.subspec 'CloudNaturalLanguage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudNaturalLanguage/*.{h,m}'
  end
  s.subspec 'CloudOSLogin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudOSLogin/*.{h,m}'
  end
  s.subspec 'CloudProfiler' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudProfiler/*.{h,m}'
  end
  s.subspec 'CloudRedis' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudRedis/*.{h,m}'
  end
  s.subspec 'CloudResourceManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudResourceManager/*.{h,m}'
  end
  s.subspec 'CloudRun' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudRun/*.{h,m}'
  end
  s.subspec 'CloudRuntimeConfig' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudRuntimeConfig/*.{h,m}'
  end
  s.subspec 'CloudScheduler' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudScheduler/*.{h,m}'
  end
  s.subspec 'CloudSearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudSearch/*.{h,m}'
  end
  s.subspec 'CloudSecurityToken' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudSecurityToken/*.{h,m}'
  end
  s.subspec 'CloudShell' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudShell/*.{h,m}'
  end
  s.subspec 'CloudSourceRepositories' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudSourceRepositories/*.{h,m}'
  end
  s.subspec 'CloudTalentSolution' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudTalentSolution/*.{h,m}'
  end
  s.subspec 'CloudTasks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudTasks/*.{h,m}'
  end
  s.subspec 'CloudTrace' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudTrace/*.{h,m}'
  end
  s.subspec 'CloudVideoIntelligence' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CloudVideoIntelligence/*.{h,m}'
  end
  s.subspec 'Cloudbilling' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Cloudbilling/*.{h,m}'
  end
  s.subspec 'Clouderrorreporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Clouderrorreporting/*.{h,m}'
  end
  s.subspec 'Compute' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Compute/*.{h,m}'
  end
  s.subspec 'Container' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Container/*.{h,m}'
  end
  s.subspec 'ContainerAnalysis' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ContainerAnalysis/*.{h,m}'
  end
  s.subspec 'CustomSearchAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/CustomSearchAPI/*.{h,m}'
  end
  s.subspec 'DLP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DLP/*.{h,m}'
  end
  s.subspec 'DataCatalog' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DataCatalog/*.{h,m}'
  end
  s.subspec 'DataFusion' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DataFusion/*.{h,m}'
  end
  s.subspec 'DataTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DataTransfer/*.{h,m}'
  end
  s.subspec 'Dataflow' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Dataflow/*.{h,m}'
  end
  s.subspec 'Dataproc' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Dataproc/*.{h,m}'
  end
  s.subspec 'Datastore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Datastore/*.{h,m}'
  end
  s.subspec 'DeploymentManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DeploymentManager/*.{h,m}'
  end
  s.subspec 'Dfareporting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Dfareporting/*.{h,m}'
  end
  s.subspec 'Dialogflow' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Dialogflow/*.{h,m}'
  end
  s.subspec 'DigitalAssetLinks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DigitalAssetLinks/*.{h,m}'
  end
  s.subspec 'Directory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Directory/*.{h,m}'
  end
  s.subspec 'Discovery' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Discovery/*.{h,m}'
  end
  s.subspec 'DisplayVideo' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DisplayVideo/*.{h,m}'
  end
  s.subspec 'Dns' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Dns/*.{h,m}'
  end
  s.subspec 'Docs' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Docs/*.{h,m}'
  end
  s.subspec 'Document' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Document/*.{h,m}'
  end
  s.subspec 'DomainsRDAP' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DomainsRDAP/*.{h,m}'
  end
  s.subspec 'DoubleClickBidManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DoubleClickBidManager/*.{h,m}'
  end
  s.subspec 'Doubleclicksearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Doubleclicksearch/*.{h,m}'
  end
  s.subspec 'Drive' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Drive/*.{h,m}'
  end
  s.subspec 'DriveActivity' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/DriveActivity/*.{h,m}'
  end
  s.subspec 'FactCheckTools' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/FactCheckTools/*.{h,m}'
  end
  s.subspec 'FirebaseCloudMessaging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/FirebaseCloudMessaging/*.{h,m}'
  end
  s.subspec 'FirebaseDynamicLinks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/FirebaseDynamicLinks/*.{h,m}'
  end
  s.subspec 'FirebaseHosting' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/FirebaseHosting/*.{h,m}'
  end
  s.subspec 'FirebaseML' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/FirebaseML/*.{h,m}'
  end
  s.subspec 'FirebaseManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/FirebaseManagement/*.{h,m}'
  end
  s.subspec 'FirebaseRules' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/FirebaseRules/*.{h,m}'
  end
  s.subspec 'Firestore' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Firestore/*.{h,m}'
  end
  s.subspec 'Fitness' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Fitness/*.{h,m}'
  end
  s.subspec 'GameServices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/GameServices/*.{h,m}'
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
  s.subspec 'Genomics' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Genomics/*.{h,m}'
  end
  s.subspec 'Gmail' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Gmail/*.{h,m}'
  end
  s.subspec 'GroupsMigration' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/GroupsMigration/*.{h,m}'
  end
  s.subspec 'GroupsSettings' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/GroupsSettings/*.{h,m}'
  end
  s.subspec 'HangoutsChat' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/HangoutsChat/*.{h,m}'
  end
  s.subspec 'HomeGraphService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/HomeGraphService/*.{h,m}'
  end
  s.subspec 'IAMCredentials' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/IAMCredentials/*.{h,m}'
  end
  s.subspec 'Iam' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Iam/*.{h,m}'
  end
  s.subspec 'IdentityToolkit' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/IdentityToolkit/*.{h,m}'
  end
  s.subspec 'Indexing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Indexing/*.{h,m}'
  end
  s.subspec 'Kgsearch' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Kgsearch/*.{h,m}'
  end
  s.subspec 'Libraryagent' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Libraryagent/*.{h,m}'
  end
  s.subspec 'Licensing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Licensing/*.{h,m}'
  end
  s.subspec 'Localservices' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Localservices/*.{h,m}'
  end
  s.subspec 'Logging' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Logging/*.{h,m}'
  end
  s.subspec 'ManagedServiceforMicrosoftActiveDirectoryConsumerAPI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ManagedServiceforMicrosoftActiveDirectoryConsumerAPI/*.{h,m}'
  end
  s.subspec 'ManufacturerCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ManufacturerCenter/*.{h,m}'
  end
  s.subspec 'Monitoring' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Monitoring/*.{h,m}'
  end
  s.subspec 'NetworkManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/NetworkManagement/*.{h,m}'
  end
  s.subspec 'PagespeedInsights' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PagespeedInsights/*.{h,m}'
  end
  s.subspec 'PeopleService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PeopleService/*.{h,m}'
  end
  s.subspec 'PlayableLocations' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PlayableLocations/*.{h,m}'
  end
  s.subspec 'Playcustomapp' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Playcustomapp/*.{h,m}'
  end
  s.subspec 'PolicyTroubleshooter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PolicyTroubleshooter/*.{h,m}'
  end
  s.subspec 'PolyService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PolyService/*.{h,m}'
  end
  s.subspec 'PostmasterTools' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PostmasterTools/*.{h,m}'
  end
  s.subspec 'Pubsub' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Pubsub/*.{h,m}'
  end
  s.subspec 'PubsubLite' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/PubsubLite/*.{h,m}'
  end
  s.subspec 'RealTimeBidding' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/RealTimeBidding/*.{h,m}'
  end
  s.subspec 'RecommendationsAI' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/RecommendationsAI/*.{h,m}'
  end
  s.subspec 'Recommender' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Recommender/*.{h,m}'
  end
  s.subspec 'RemoteBuildExecution' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/RemoteBuildExecution/*.{h,m}'
  end
  s.subspec 'Reports' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Reports/*.{h,m}'
  end
  s.subspec 'Reseller' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Reseller/*.{h,m}'
  end
  s.subspec 'SASPortal' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SASPortal/*.{h,m}'
  end
  s.subspec 'SQLAdmin' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SQLAdmin/*.{h,m}'
  end
  s.subspec 'Safebrowsing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Safebrowsing/*.{h,m}'
  end
  s.subspec 'Script' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Script/*.{h,m}'
  end
  s.subspec 'SearchConsole' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SearchConsole/*.{h,m}'
  end
  s.subspec 'SecretManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SecretManager/*.{h,m}'
  end
  s.subspec 'SecurityCommandCenter' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SecurityCommandCenter/*.{h,m}'
  end
  s.subspec 'SemanticTile' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SemanticTile/*.{h,m}'
  end
  s.subspec 'ServiceConsumerManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ServiceConsumerManagement/*.{h,m}'
  end
  s.subspec 'ServiceControl' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ServiceControl/*.{h,m}'
  end
  s.subspec 'ServiceDirectory' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ServiceDirectory/*.{h,m}'
  end
  s.subspec 'ServiceManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ServiceManagement/*.{h,m}'
  end
  s.subspec 'ServiceNetworking' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ServiceNetworking/*.{h,m}'
  end
  s.subspec 'ServiceUsage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ServiceUsage/*.{h,m}'
  end
  s.subspec 'Sheets' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Sheets/*.{h,m}'
  end
  s.subspec 'ShoppingContent' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ShoppingContent/*.{h,m}'
  end
  s.subspec 'SiteVerification' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SiteVerification/*.{h,m}'
  end
  s.subspec 'Slides' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Slides/*.{h,m}'
  end
  s.subspec 'SmartDeviceManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SmartDeviceManagement/*.{h,m}'
  end
  s.subspec 'Spanner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Spanner/*.{h,m}'
  end
  s.subspec 'Speech' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Speech/*.{h,m}'
  end
  s.subspec 'Storage' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Storage/*.{h,m}'
  end
  s.subspec 'StorageTransfer' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/StorageTransfer/*.{h,m}'
  end
  s.subspec 'StreetViewPublish' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/StreetViewPublish/*.{h,m}'
  end
  s.subspec 'SystemsManagement' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/SystemsManagement/*.{h,m}'
  end
  s.subspec 'TPU' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/TPU/*.{h,m}'
  end
  s.subspec 'TagManager' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/TagManager/*.{h,m}'
  end
  s.subspec 'Tasks' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Tasks/*.{h,m}'
  end
  s.subspec 'Testing' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Testing/*.{h,m}'
  end
  s.subspec 'Texttospeech' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Texttospeech/*.{h,m}'
  end
  s.subspec 'ToolResults' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/ToolResults/*.{h,m}'
  end
  s.subspec 'TrafficDirectorService' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/TrafficDirectorService/*.{h,m}'
  end
  s.subspec 'Translate' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Translate/*.{h,m}'
  end
  s.subspec 'Vault' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Vault/*.{h,m}'
  end
  s.subspec 'Verifiedaccess' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Verifiedaccess/*.{h,m}'
  end
  s.subspec 'Vision' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Vision/*.{h,m}'
  end
  s.subspec 'WebSecurityScanner' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/WebSecurityScanner/*.{h,m}'
  end
  s.subspec 'Webfonts' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Webfonts/*.{h,m}'
  end
  s.subspec 'Webmasters' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Webmasters/*.{h,m}'
  end
  s.subspec 'WorkflowExecutions' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/WorkflowExecutions/*.{h,m}'
  end
  s.subspec 'Workflows' do |sp|
    sp.dependency 'GoogleAPIClientForREST/Core'
    sp.source_files = 'Source/GeneratedServices/Workflows/*.{h,m}'
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
