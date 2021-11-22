// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "GoogleAPIClientForREST",
    products: [
        // The main library, only thing you need to use your own services.
        .library(
            name: "GoogleAPIClientForRESTCore",
            targets: ["GoogleAPIClientForRESTCore"]
        ),
        // Products for all the Services.
        .library(
            name: "GoogleAPIClientForREST_AbusiveExperienceReport",
            targets: ["GoogleAPIClientForREST_AbusiveExperienceReport"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Acceleratedmobilepageurl",
            targets: ["GoogleAPIClientForREST_Acceleratedmobilepageurl"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AccessApproval",
            targets: ["GoogleAPIClientForREST_AccessApproval"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AccessContextManager",
            targets: ["GoogleAPIClientForREST_AccessContextManager"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AdExchangeBuyer",
            targets: ["GoogleAPIClientForREST_AdExchangeBuyer"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AdExchangeBuyerII",
            targets: ["GoogleAPIClientForREST_AdExchangeBuyerII"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AdExperienceReport",
            targets: ["GoogleAPIClientForREST_AdExperienceReport"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AdMob",
            targets: ["GoogleAPIClientForREST_AdMob"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Adsense",
            targets: ["GoogleAPIClientForREST_Adsense"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AdSenseHost",
            targets: ["GoogleAPIClientForREST_AdSenseHost"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AIPlatformNotebooks",
            targets: ["GoogleAPIClientForREST_AIPlatformNotebooks"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AlertCenter",
            targets: ["GoogleAPIClientForREST_AlertCenter"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Analytics",
            targets: ["GoogleAPIClientForREST_Analytics"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AnalyticsData",
            targets: ["GoogleAPIClientForREST_AnalyticsData"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AnalyticsReporting",
            targets: ["GoogleAPIClientForREST_AnalyticsReporting"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AndroidEnterprise",
            targets: ["GoogleAPIClientForREST_AndroidEnterprise"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AndroidManagement",
            targets: ["GoogleAPIClientForREST_AndroidManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AndroidProvisioningPartner",
            targets: ["GoogleAPIClientForREST_AndroidProvisioningPartner"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AndroidPublisher",
            targets: ["GoogleAPIClientForREST_AndroidPublisher"]
        ),
        .library(
            name: "GoogleAPIClientForREST_APIGateway",
            targets: ["GoogleAPIClientForREST_APIGateway"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Apigee",
            targets: ["GoogleAPIClientForREST_Apigee"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ApiKeysService",
            targets: ["GoogleAPIClientForREST_ApiKeysService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Appengine",
            targets: ["GoogleAPIClientForREST_Appengine"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Area120Tables",
            targets: ["GoogleAPIClientForREST_Area120Tables"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ArtifactRegistry",
            targets: ["GoogleAPIClientForREST_ArtifactRegistry"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Assuredworkloads",
            targets: ["GoogleAPIClientForREST_Assuredworkloads"]
        ),
        .library(
            name: "GoogleAPIClientForREST_AuthorizedBuyersMarketplace",
            targets: ["GoogleAPIClientForREST_AuthorizedBuyersMarketplace"]
        ),
        .library(
            name: "GoogleAPIClientForREST_BareMetalSolution",
            targets: ["GoogleAPIClientForREST_BareMetalSolution"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Bigquery",
            targets: ["GoogleAPIClientForREST_Bigquery"]
        ),
        .library(
            name: "GoogleAPIClientForREST_BigQueryConnectionService",
            targets: ["GoogleAPIClientForREST_BigQueryConnectionService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_BigQueryDataTransfer",
            targets: ["GoogleAPIClientForREST_BigQueryDataTransfer"]
        ),
        .library(
            name: "GoogleAPIClientForREST_BigQueryReservation",
            targets: ["GoogleAPIClientForREST_BigQueryReservation"]
        ),
        .library(
            name: "GoogleAPIClientForREST_BigtableAdmin",
            targets: ["GoogleAPIClientForREST_BigtableAdmin"]
        ),
        .library(
            name: "GoogleAPIClientForREST_BinaryAuthorization",
            targets: ["GoogleAPIClientForREST_BinaryAuthorization"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Blogger",
            targets: ["GoogleAPIClientForREST_Blogger"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Books",
            targets: ["GoogleAPIClientForREST_Books"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Calendar",
            targets: ["GoogleAPIClientForREST_Calendar"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CertificateAuthorityService",
            targets: ["GoogleAPIClientForREST_CertificateAuthorityService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ChromeManagement",
            targets: ["GoogleAPIClientForREST_ChromeManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ChromePolicy",
            targets: ["GoogleAPIClientForREST_ChromePolicy"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ChromeUXReport",
            targets: ["GoogleAPIClientForREST_ChromeUXReport"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CivicInfo",
            targets: ["GoogleAPIClientForREST_CivicInfo"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Classroom",
            targets: ["GoogleAPIClientForREST_Classroom"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudAsset",
            targets: ["GoogleAPIClientForREST_CloudAsset"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Cloudbilling",
            targets: ["GoogleAPIClientForREST_Cloudbilling"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudBillingBudget",
            targets: ["GoogleAPIClientForREST_CloudBillingBudget"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudBuild",
            targets: ["GoogleAPIClientForREST_CloudBuild"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Cloudchannel",
            targets: ["GoogleAPIClientForREST_Cloudchannel"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudComposer",
            targets: ["GoogleAPIClientForREST_CloudComposer"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudDebugger",
            targets: ["GoogleAPIClientForREST_CloudDebugger"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudDeploy",
            targets: ["GoogleAPIClientForREST_CloudDeploy"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudDomains",
            targets: ["GoogleAPIClientForREST_CloudDomains"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Clouderrorreporting",
            targets: ["GoogleAPIClientForREST_Clouderrorreporting"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudFilestore",
            targets: ["GoogleAPIClientForREST_CloudFilestore"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudFunctions",
            targets: ["GoogleAPIClientForREST_CloudFunctions"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudHealthcare",
            targets: ["GoogleAPIClientForREST_CloudHealthcare"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudIAP",
            targets: ["GoogleAPIClientForREST_CloudIAP"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudIdentity",
            targets: ["GoogleAPIClientForREST_CloudIdentity"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudIot",
            targets: ["GoogleAPIClientForREST_CloudIot"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudKMS",
            targets: ["GoogleAPIClientForREST_CloudKMS"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudLifeSciences",
            targets: ["GoogleAPIClientForREST_CloudLifeSciences"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudMachineLearningEngine",
            targets: ["GoogleAPIClientForREST_CloudMachineLearningEngine"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudMemorystoreforMemcached",
            targets: ["GoogleAPIClientForREST_CloudMemorystoreforMemcached"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudNaturalLanguage",
            targets: ["GoogleAPIClientForREST_CloudNaturalLanguage"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudOSLogin",
            targets: ["GoogleAPIClientForREST_CloudOSLogin"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudProfiler",
            targets: ["GoogleAPIClientForREST_CloudProfiler"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudRedis",
            targets: ["GoogleAPIClientForREST_CloudRedis"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudResourceManager",
            targets: ["GoogleAPIClientForREST_CloudResourceManager"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudRetail",
            targets: ["GoogleAPIClientForREST_CloudRetail"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudRun",
            targets: ["GoogleAPIClientForREST_CloudRun"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudRuntimeConfig",
            targets: ["GoogleAPIClientForREST_CloudRuntimeConfig"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudScheduler",
            targets: ["GoogleAPIClientForREST_CloudScheduler"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudSearch",
            targets: ["GoogleAPIClientForREST_CloudSearch"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudSecurityToken",
            targets: ["GoogleAPIClientForREST_CloudSecurityToken"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudShell",
            targets: ["GoogleAPIClientForREST_CloudShell"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudSourceRepositories",
            targets: ["GoogleAPIClientForREST_CloudSourceRepositories"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudSupport",
            targets: ["GoogleAPIClientForREST_CloudSupport"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudTalentSolution",
            targets: ["GoogleAPIClientForREST_CloudTalentSolution"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudTasks",
            targets: ["GoogleAPIClientForREST_CloudTasks"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudTrace",
            targets: ["GoogleAPIClientForREST_CloudTrace"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CloudVideoIntelligence",
            targets: ["GoogleAPIClientForREST_CloudVideoIntelligence"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Compute",
            targets: ["GoogleAPIClientForREST_Compute"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Connectors",
            targets: ["GoogleAPIClientForREST_Connectors"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Contactcenterinsights",
            targets: ["GoogleAPIClientForREST_Contactcenterinsights"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Container",
            targets: ["GoogleAPIClientForREST_Container"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ContainerAnalysis",
            targets: ["GoogleAPIClientForREST_ContainerAnalysis"]
        ),
        .library(
            name: "GoogleAPIClientForREST_CustomSearchAPI",
            targets: ["GoogleAPIClientForREST_CustomSearchAPI"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DatabaseMigrationService",
            targets: ["GoogleAPIClientForREST_DatabaseMigrationService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DataCatalog",
            targets: ["GoogleAPIClientForREST_DataCatalog"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Dataflow",
            targets: ["GoogleAPIClientForREST_Dataflow"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DataFusion",
            targets: ["GoogleAPIClientForREST_DataFusion"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DataLabeling",
            targets: ["GoogleAPIClientForREST_DataLabeling"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Datapipelines",
            targets: ["GoogleAPIClientForREST_Datapipelines"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Dataproc",
            targets: ["GoogleAPIClientForREST_Dataproc"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DataprocMetastore",
            targets: ["GoogleAPIClientForREST_DataprocMetastore"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Datastore",
            targets: ["GoogleAPIClientForREST_Datastore"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Datastream",
            targets: ["GoogleAPIClientForREST_Datastream"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DataTransfer",
            targets: ["GoogleAPIClientForREST_DataTransfer"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DeploymentManager",
            targets: ["GoogleAPIClientForREST_DeploymentManager"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Dfareporting",
            targets: ["GoogleAPIClientForREST_Dfareporting"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Dialogflow",
            targets: ["GoogleAPIClientForREST_Dialogflow"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DigitalAssetLinks",
            targets: ["GoogleAPIClientForREST_DigitalAssetLinks"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Directory",
            targets: ["GoogleAPIClientForREST_Directory"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Discovery",
            targets: ["GoogleAPIClientForREST_Discovery"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DisplayVideo",
            targets: ["GoogleAPIClientForREST_DisplayVideo"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DLP",
            targets: ["GoogleAPIClientForREST_DLP"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Dns",
            targets: ["GoogleAPIClientForREST_Dns"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Docs",
            targets: ["GoogleAPIClientForREST_Docs"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Document",
            targets: ["GoogleAPIClientForREST_Document"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DomainsRDAP",
            targets: ["GoogleAPIClientForREST_DomainsRDAP"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DoubleClickBidManager",
            targets: ["GoogleAPIClientForREST_DoubleClickBidManager"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Doubleclicksearch",
            targets: ["GoogleAPIClientForREST_Doubleclicksearch"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Drive",
            targets: ["GoogleAPIClientForREST_Drive"]
        ),
        .library(
            name: "GoogleAPIClientForREST_DriveActivity",
            targets: ["GoogleAPIClientForREST_DriveActivity"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Essentialcontacts",
            targets: ["GoogleAPIClientForREST_Essentialcontacts"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Eventarc",
            targets: ["GoogleAPIClientForREST_Eventarc"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FactCheckTools",
            targets: ["GoogleAPIClientForREST_FactCheckTools"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Fcmdata",
            targets: ["GoogleAPIClientForREST_Fcmdata"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Firebaseappcheck",
            targets: ["GoogleAPIClientForREST_Firebaseappcheck"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FirebaseCloudMessaging",
            targets: ["GoogleAPIClientForREST_FirebaseCloudMessaging"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FirebaseDynamicLinks",
            targets: ["GoogleAPIClientForREST_FirebaseDynamicLinks"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FirebaseHosting",
            targets: ["GoogleAPIClientForREST_FirebaseHosting"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FirebaseManagement",
            targets: ["GoogleAPIClientForREST_FirebaseManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FirebaseML",
            targets: ["GoogleAPIClientForREST_FirebaseML"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FirebaseRealtimeDatabase",
            targets: ["GoogleAPIClientForREST_FirebaseRealtimeDatabase"]
        ),
        .library(
            name: "GoogleAPIClientForREST_FirebaseRules",
            targets: ["GoogleAPIClientForREST_FirebaseRules"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Firebasestorage",
            targets: ["GoogleAPIClientForREST_Firebasestorage"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Firestore",
            targets: ["GoogleAPIClientForREST_Firestore"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Fitness",
            targets: ["GoogleAPIClientForREST_Fitness"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Games",
            targets: ["GoogleAPIClientForREST_Games"]
        ),
        .library(
            name: "GoogleAPIClientForREST_GamesConfiguration",
            targets: ["GoogleAPIClientForREST_GamesConfiguration"]
        ),
        .library(
            name: "GoogleAPIClientForREST_GameServices",
            targets: ["GoogleAPIClientForREST_GameServices"]
        ),
        .library(
            name: "GoogleAPIClientForREST_GamesManagement",
            targets: ["GoogleAPIClientForREST_GamesManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Genomics",
            targets: ["GoogleAPIClientForREST_Genomics"]
        ),
        .library(
            name: "GoogleAPIClientForREST_GKEHub",
            targets: ["GoogleAPIClientForREST_GKEHub"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Gmail",
            targets: ["GoogleAPIClientForREST_Gmail"]
        ),
        .library(
            name: "GoogleAPIClientForREST_GoogleAnalyticsAdmin",
            targets: ["GoogleAPIClientForREST_GoogleAnalyticsAdmin"]
        ),
        .library(
            name: "GoogleAPIClientForREST_GroupsMigration",
            targets: ["GoogleAPIClientForREST_GroupsMigration"]
        ),
        .library(
            name: "GoogleAPIClientForREST_GroupsSettings",
            targets: ["GoogleAPIClientForREST_GroupsSettings"]
        ),
        .library(
            name: "GoogleAPIClientForREST_HangoutsChat",
            targets: ["GoogleAPIClientForREST_HangoutsChat"]
        ),
        .library(
            name: "GoogleAPIClientForREST_HomeGraphService",
            targets: ["GoogleAPIClientForREST_HomeGraphService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Iam",
            targets: ["GoogleAPIClientForREST_Iam"]
        ),
        .library(
            name: "GoogleAPIClientForREST_IAMCredentials",
            targets: ["GoogleAPIClientForREST_IAMCredentials"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Ideahub",
            targets: ["GoogleAPIClientForREST_Ideahub"]
        ),
        .library(
            name: "GoogleAPIClientForREST_IdentityToolkit",
            targets: ["GoogleAPIClientForREST_IdentityToolkit"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Indexing",
            targets: ["GoogleAPIClientForREST_Indexing"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Keep",
            targets: ["GoogleAPIClientForREST_Keep"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Kgsearch",
            targets: ["GoogleAPIClientForREST_Kgsearch"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Libraryagent",
            targets: ["GoogleAPIClientForREST_Libraryagent"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Licensing",
            targets: ["GoogleAPIClientForREST_Licensing"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Localservices",
            targets: ["GoogleAPIClientForREST_Localservices"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Logging",
            targets: ["GoogleAPIClientForREST_Logging"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ManagedServiceforMicrosoftActiveDirectoryConsumerAPI",
            targets: ["GoogleAPIClientForREST_ManagedServiceforMicrosoftActiveDirectoryConsumerAPI"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ManufacturerCenter",
            targets: ["GoogleAPIClientForREST_ManufacturerCenter"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Monitoring",
            targets: ["GoogleAPIClientForREST_Monitoring"]
        ),
        .library(
            name: "GoogleAPIClientForREST_MyBusinessAccountManagement",
            targets: ["GoogleAPIClientForREST_MyBusinessAccountManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_MyBusinessBusinessInformation",
            targets: ["GoogleAPIClientForREST_MyBusinessBusinessInformation"]
        ),
        .library(
            name: "GoogleAPIClientForREST_MyBusinessLodging",
            targets: ["GoogleAPIClientForREST_MyBusinessLodging"]
        ),
        .library(
            name: "GoogleAPIClientForREST_MyBusinessNotificationSettings",
            targets: ["GoogleAPIClientForREST_MyBusinessNotificationSettings"]
        ),
        .library(
            name: "GoogleAPIClientForREST_MyBusinessPlaceActions",
            targets: ["GoogleAPIClientForREST_MyBusinessPlaceActions"]
        ),
        .library(
            name: "GoogleAPIClientForREST_MyBusinessVerifications",
            targets: ["GoogleAPIClientForREST_MyBusinessVerifications"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Networkconnectivity",
            targets: ["GoogleAPIClientForREST_Networkconnectivity"]
        ),
        .library(
            name: "GoogleAPIClientForREST_NetworkManagement",
            targets: ["GoogleAPIClientForREST_NetworkManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_NetworkSecurity",
            targets: ["GoogleAPIClientForREST_NetworkSecurity"]
        ),
        .library(
            name: "GoogleAPIClientForREST_NetworkServices",
            targets: ["GoogleAPIClientForREST_NetworkServices"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Oauth2",
            targets: ["GoogleAPIClientForREST_Oauth2"]
        ),
        .library(
            name: "GoogleAPIClientForREST_OnDemandScanning",
            targets: ["GoogleAPIClientForREST_OnDemandScanning"]
        ),
        .library(
            name: "GoogleAPIClientForREST_OrgPolicyAPI",
            targets: ["GoogleAPIClientForREST_OrgPolicyAPI"]
        ),
        .library(
            name: "GoogleAPIClientForREST_OSConfig",
            targets: ["GoogleAPIClientForREST_OSConfig"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PagespeedInsights",
            targets: ["GoogleAPIClientForREST_PagespeedInsights"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PaymentsResellerSubscription",
            targets: ["GoogleAPIClientForREST_PaymentsResellerSubscription"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PeopleService",
            targets: ["GoogleAPIClientForREST_PeopleService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PlayableLocations",
            targets: ["GoogleAPIClientForREST_PlayableLocations"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Playcustomapp",
            targets: ["GoogleAPIClientForREST_Playcustomapp"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PolicyAnalyzer",
            targets: ["GoogleAPIClientForREST_PolicyAnalyzer"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PolicySimulator",
            targets: ["GoogleAPIClientForREST_PolicySimulator"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PolicyTroubleshooter",
            targets: ["GoogleAPIClientForREST_PolicyTroubleshooter"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PolyService",
            targets: ["GoogleAPIClientForREST_PolyService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PostmasterTools",
            targets: ["GoogleAPIClientForREST_PostmasterTools"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Pubsub",
            targets: ["GoogleAPIClientForREST_Pubsub"]
        ),
        .library(
            name: "GoogleAPIClientForREST_PubsubLite",
            targets: ["GoogleAPIClientForREST_PubsubLite"]
        ),
        .library(
            name: "GoogleAPIClientForREST_RealTimeBidding",
            targets: ["GoogleAPIClientForREST_RealTimeBidding"]
        ),
        .library(
            name: "GoogleAPIClientForREST_RecaptchaEnterprise",
            targets: ["GoogleAPIClientForREST_RecaptchaEnterprise"]
        ),
        .library(
            name: "GoogleAPIClientForREST_RecommendationsAI",
            targets: ["GoogleAPIClientForREST_RecommendationsAI"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Recommender",
            targets: ["GoogleAPIClientForREST_Recommender"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Reports",
            targets: ["GoogleAPIClientForREST_Reports"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Reseller",
            targets: ["GoogleAPIClientForREST_Reseller"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ResourceSettings",
            targets: ["GoogleAPIClientForREST_ResourceSettings"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Safebrowsing",
            targets: ["GoogleAPIClientForREST_Safebrowsing"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SASPortal",
            targets: ["GoogleAPIClientForREST_SASPortal"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Script",
            targets: ["GoogleAPIClientForREST_Script"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SearchConsole",
            targets: ["GoogleAPIClientForREST_SearchConsole"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SecretManager",
            targets: ["GoogleAPIClientForREST_SecretManager"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SecurityCommandCenter",
            targets: ["GoogleAPIClientForREST_SecurityCommandCenter"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SemanticTile",
            targets: ["GoogleAPIClientForREST_SemanticTile"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ServiceConsumerManagement",
            targets: ["GoogleAPIClientForREST_ServiceConsumerManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ServiceControl",
            targets: ["GoogleAPIClientForREST_ServiceControl"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ServiceDirectory",
            targets: ["GoogleAPIClientForREST_ServiceDirectory"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ServiceManagement",
            targets: ["GoogleAPIClientForREST_ServiceManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ServiceNetworking",
            targets: ["GoogleAPIClientForREST_ServiceNetworking"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ServiceUsage",
            targets: ["GoogleAPIClientForREST_ServiceUsage"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Sheets",
            targets: ["GoogleAPIClientForREST_Sheets"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ShoppingContent",
            targets: ["GoogleAPIClientForREST_ShoppingContent"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SiteVerification",
            targets: ["GoogleAPIClientForREST_SiteVerification"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Slides",
            targets: ["GoogleAPIClientForREST_Slides"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SmartDeviceManagement",
            targets: ["GoogleAPIClientForREST_SmartDeviceManagement"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Spanner",
            targets: ["GoogleAPIClientForREST_Spanner"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Speech",
            targets: ["GoogleAPIClientForREST_Speech"]
        ),
        .library(
            name: "GoogleAPIClientForREST_SQLAdmin",
            targets: ["GoogleAPIClientForREST_SQLAdmin"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Storage",
            targets: ["GoogleAPIClientForREST_Storage"]
        ),
        .library(
            name: "GoogleAPIClientForREST_StorageTransfer",
            targets: ["GoogleAPIClientForREST_StorageTransfer"]
        ),
        .library(
            name: "GoogleAPIClientForREST_StreetViewPublish",
            targets: ["GoogleAPIClientForREST_StreetViewPublish"]
        ),
        .library(
            name: "GoogleAPIClientForREST_TagManager",
            targets: ["GoogleAPIClientForREST_TagManager"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Tasks",
            targets: ["GoogleAPIClientForREST_Tasks"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Testing",
            targets: ["GoogleAPIClientForREST_Testing"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Texttospeech",
            targets: ["GoogleAPIClientForREST_Texttospeech"]
        ),
        .library(
            name: "GoogleAPIClientForREST_ToolResults",
            targets: ["GoogleAPIClientForREST_ToolResults"]
        ),
        .library(
            name: "GoogleAPIClientForREST_TPU",
            targets: ["GoogleAPIClientForREST_TPU"]
        ),
        .library(
            name: "GoogleAPIClientForREST_TrafficDirectorService",
            targets: ["GoogleAPIClientForREST_TrafficDirectorService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Transcoder",
            targets: ["GoogleAPIClientForREST_Transcoder"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Translate",
            targets: ["GoogleAPIClientForREST_Translate"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Vault",
            targets: ["GoogleAPIClientForREST_Vault"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Verifiedaccess",
            targets: ["GoogleAPIClientForREST_Verifiedaccess"]
        ),
        .library(
            name: "GoogleAPIClientForREST_VersionHistory",
            targets: ["GoogleAPIClientForREST_VersionHistory"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Vision",
            targets: ["GoogleAPIClientForREST_Vision"]
        ),
        .library(
            name: "GoogleAPIClientForREST_VMMigrationService",
            targets: ["GoogleAPIClientForREST_VMMigrationService"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Webfonts",
            targets: ["GoogleAPIClientForREST_Webfonts"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Webmasters",
            targets: ["GoogleAPIClientForREST_Webmasters"]
        ),
        .library(
            name: "GoogleAPIClientForREST_WebRisk",
            targets: ["GoogleAPIClientForREST_WebRisk"]
        ),
        .library(
            name: "GoogleAPIClientForREST_WebSecurityScanner",
            targets: ["GoogleAPIClientForREST_WebSecurityScanner"]
        ),
        .library(
            name: "GoogleAPIClientForREST_WorkflowExecutions",
            targets: ["GoogleAPIClientForREST_WorkflowExecutions"]
        ),
        .library(
            name: "GoogleAPIClientForREST_Workflows",
            targets: ["GoogleAPIClientForREST_Workflows"]
        ),
        .library(
            name: "GoogleAPIClientForREST_YouTube",
            targets: ["GoogleAPIClientForREST_YouTube"]
        ),
        .library(
            name: "GoogleAPIClientForREST_YouTubeAnalytics",
            targets: ["GoogleAPIClientForREST_YouTubeAnalytics"]
        ),
        .library(
            name: "GoogleAPIClientForREST_YouTubeReporting",
            targets: ["GoogleAPIClientForREST_YouTubeReporting"]
        ),
        // End of products.
    ],
    dependencies: [
        .package(url: "https://github.com/google/gtm-session-fetcher.git", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "GoogleAPIClientForRESTCore",
            dependencies: [
                "GTMSessionFetcher"
            ],
            path: "Source",
            exclude: [
                "GeneratedServices",
                "Tests",
                "Tools"
            ],
            sources: [
                "Objects",
                "Utilities"
            ],
            publicHeadersPath: "SwiftPackage",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Objects"),
                .headerSearchPath("Utilities")
            ]
        ),
        .testTarget(
            name: "GoogleAPIClientForRESTTests",
            dependencies: [
                "GoogleAPIClientForRESTCore"
            ],
            path: "Source/Tests",
            exclude: [
                "CompiledTestNoARC.m"
            ],
            sources: [
                ".",
                "TestingSvc"
            ],
            cSettings: [
                .headerSearchPath("TestingSvc")
            ]
        ),
        // Targets for all the Services.
        .target(
            name: "GoogleAPIClientForREST_AbusiveExperienceReport",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AbusiveExperienceReport",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Acceleratedmobilepageurl",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Acceleratedmobilepageurl",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AccessApproval",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AccessApproval",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AccessContextManager",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AccessContextManager",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AdExchangeBuyer",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AdExchangeBuyer",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AdExchangeBuyerII",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AdExchangeBuyerII",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AdExperienceReport",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AdExperienceReport",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AdMob",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AdMob",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Adsense",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Adsense",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AdSenseHost",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AdSenseHost",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AIPlatformNotebooks",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AIPlatformNotebooks",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AlertCenter",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AlertCenter",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Analytics",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Analytics",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AnalyticsData",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AnalyticsData",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AnalyticsReporting",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AnalyticsReporting",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AndroidEnterprise",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AndroidEnterprise",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AndroidManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AndroidManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AndroidProvisioningPartner",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AndroidProvisioningPartner",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AndroidPublisher",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AndroidPublisher",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_APIGateway",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/APIGateway",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Apigee",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Apigee",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ApiKeysService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ApiKeysService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Appengine",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Appengine",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Area120Tables",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Area120Tables",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ArtifactRegistry",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ArtifactRegistry",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Assuredworkloads",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Assuredworkloads",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_AuthorizedBuyersMarketplace",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/AuthorizedBuyersMarketplace",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_BareMetalSolution",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/BareMetalSolution",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Bigquery",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Bigquery",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_BigQueryConnectionService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/BigQueryConnectionService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_BigQueryDataTransfer",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/BigQueryDataTransfer",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_BigQueryReservation",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/BigQueryReservation",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_BigtableAdmin",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/BigtableAdmin",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_BinaryAuthorization",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/BinaryAuthorization",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Blogger",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Blogger",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Books",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Books",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Calendar",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Calendar",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CertificateAuthorityService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CertificateAuthorityService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ChromeManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ChromeManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ChromePolicy",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ChromePolicy",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ChromeUXReport",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ChromeUXReport",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CivicInfo",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CivicInfo",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Classroom",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Classroom",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudAsset",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudAsset",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Cloudbilling",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Cloudbilling",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudBillingBudget",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudBillingBudget",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudBuild",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudBuild",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Cloudchannel",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Cloudchannel",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudComposer",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudComposer",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudDebugger",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudDebugger",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudDeploy",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudDeploy",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudDomains",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudDomains",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Clouderrorreporting",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Clouderrorreporting",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudFilestore",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudFilestore",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudFunctions",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudFunctions",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudHealthcare",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudHealthcare",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudIAP",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudIAP",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudIdentity",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudIdentity",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudIot",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudIot",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudKMS",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudKMS",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudLifeSciences",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudLifeSciences",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudMachineLearningEngine",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudMachineLearningEngine",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudMemorystoreforMemcached",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudMemorystoreforMemcached",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudNaturalLanguage",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudNaturalLanguage",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudOSLogin",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudOSLogin",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudProfiler",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudProfiler",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudRedis",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudRedis",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudResourceManager",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudResourceManager",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudRetail",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudRetail",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudRun",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudRun",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudRuntimeConfig",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudRuntimeConfig",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudScheduler",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudScheduler",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudSearch",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudSearch",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudSecurityToken",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudSecurityToken",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudShell",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudShell",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudSourceRepositories",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudSourceRepositories",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudSupport",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudSupport",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudTalentSolution",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudTalentSolution",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudTasks",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudTasks",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudTrace",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudTrace",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CloudVideoIntelligence",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CloudVideoIntelligence",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Compute",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Compute",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Connectors",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Connectors",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Contactcenterinsights",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Contactcenterinsights",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Container",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Container",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ContainerAnalysis",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ContainerAnalysis",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_CustomSearchAPI",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/CustomSearchAPI",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DatabaseMigrationService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DatabaseMigrationService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DataCatalog",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DataCatalog",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Dataflow",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Dataflow",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DataFusion",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DataFusion",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DataLabeling",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DataLabeling",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Datapipelines",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Datapipelines",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Dataproc",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Dataproc",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DataprocMetastore",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DataprocMetastore",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Datastore",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Datastore",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Datastream",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Datastream",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DataTransfer",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DataTransfer",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DeploymentManager",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DeploymentManager",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Dfareporting",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Dfareporting",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Dialogflow",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Dialogflow",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DigitalAssetLinks",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DigitalAssetLinks",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Directory",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Directory",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Discovery",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Discovery",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DisplayVideo",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DisplayVideo",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DLP",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DLP",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Dns",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Dns",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Docs",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Docs",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Document",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Document",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DomainsRDAP",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DomainsRDAP",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DoubleClickBidManager",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DoubleClickBidManager",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Doubleclicksearch",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Doubleclicksearch",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Drive",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Drive",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_DriveActivity",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/DriveActivity",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Essentialcontacts",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Essentialcontacts",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Eventarc",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Eventarc",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FactCheckTools",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FactCheckTools",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Fcmdata",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Fcmdata",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Firebaseappcheck",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Firebaseappcheck",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FirebaseCloudMessaging",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FirebaseCloudMessaging",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FirebaseDynamicLinks",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FirebaseDynamicLinks",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FirebaseHosting",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FirebaseHosting",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FirebaseManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FirebaseManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FirebaseML",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FirebaseML",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FirebaseRealtimeDatabase",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FirebaseRealtimeDatabase",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_FirebaseRules",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/FirebaseRules",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Firebasestorage",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Firebasestorage",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Firestore",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Firestore",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Fitness",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Fitness",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Games",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Games",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_GamesConfiguration",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/GamesConfiguration",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_GameServices",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/GameServices",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_GamesManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/GamesManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Genomics",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Genomics",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_GKEHub",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/GKEHub",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Gmail",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Gmail",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_GoogleAnalyticsAdmin",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/GoogleAnalyticsAdmin",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_GroupsMigration",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/GroupsMigration",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_GroupsSettings",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/GroupsSettings",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_HangoutsChat",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/HangoutsChat",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_HomeGraphService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/HomeGraphService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Iam",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Iam",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_IAMCredentials",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/IAMCredentials",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Ideahub",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Ideahub",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_IdentityToolkit",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/IdentityToolkit",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Indexing",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Indexing",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Keep",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Keep",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Kgsearch",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Kgsearch",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Libraryagent",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Libraryagent",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Licensing",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Licensing",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Localservices",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Localservices",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Logging",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Logging",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ManagedServiceforMicrosoftActiveDirectoryConsumerAPI",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ManagedServiceforMicrosoftActiveDirectoryConsumerAPI",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ManufacturerCenter",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ManufacturerCenter",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Monitoring",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Monitoring",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_MyBusinessAccountManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/MyBusinessAccountManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_MyBusinessBusinessInformation",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/MyBusinessBusinessInformation",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_MyBusinessLodging",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/MyBusinessLodging",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_MyBusinessNotificationSettings",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/MyBusinessNotificationSettings",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_MyBusinessPlaceActions",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/MyBusinessPlaceActions",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_MyBusinessVerifications",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/MyBusinessVerifications",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Networkconnectivity",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Networkconnectivity",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_NetworkManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/NetworkManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_NetworkSecurity",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/NetworkSecurity",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_NetworkServices",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/NetworkServices",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Oauth2",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Oauth2",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_OnDemandScanning",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/OnDemandScanning",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_OrgPolicyAPI",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/OrgPolicyAPI",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_OSConfig",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/OSConfig",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PagespeedInsights",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PagespeedInsights",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PaymentsResellerSubscription",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PaymentsResellerSubscription",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PeopleService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PeopleService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PlayableLocations",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PlayableLocations",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Playcustomapp",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Playcustomapp",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PolicyAnalyzer",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PolicyAnalyzer",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PolicySimulator",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PolicySimulator",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PolicyTroubleshooter",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PolicyTroubleshooter",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PolyService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PolyService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PostmasterTools",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PostmasterTools",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Pubsub",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Pubsub",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_PubsubLite",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/PubsubLite",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_RealTimeBidding",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/RealTimeBidding",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_RecaptchaEnterprise",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/RecaptchaEnterprise",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_RecommendationsAI",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/RecommendationsAI",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Recommender",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Recommender",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Reports",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Reports",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Reseller",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Reseller",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ResourceSettings",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ResourceSettings",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Safebrowsing",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Safebrowsing",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SASPortal",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SASPortal",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Script",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Script",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SearchConsole",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SearchConsole",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SecretManager",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SecretManager",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SecurityCommandCenter",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SecurityCommandCenter",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SemanticTile",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SemanticTile",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ServiceConsumerManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ServiceConsumerManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ServiceControl",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ServiceControl",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ServiceDirectory",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ServiceDirectory",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ServiceManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ServiceManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ServiceNetworking",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ServiceNetworking",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ServiceUsage",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ServiceUsage",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Sheets",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Sheets",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ShoppingContent",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ShoppingContent",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SiteVerification",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SiteVerification",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Slides",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Slides",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SmartDeviceManagement",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SmartDeviceManagement",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Spanner",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Spanner",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Speech",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Speech",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_SQLAdmin",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/SQLAdmin",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Storage",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Storage",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_StorageTransfer",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/StorageTransfer",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_StreetViewPublish",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/StreetViewPublish",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_TagManager",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/TagManager",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Tasks",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Tasks",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Testing",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Testing",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Texttospeech",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Texttospeech",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_ToolResults",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/ToolResults",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_TPU",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/TPU",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_TrafficDirectorService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/TrafficDirectorService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Transcoder",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Transcoder",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Translate",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Translate",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Vault",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Vault",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Verifiedaccess",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Verifiedaccess",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_VersionHistory",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/VersionHistory",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Vision",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Vision",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_VMMigrationService",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/VMMigrationService",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Webfonts",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Webfonts",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Webmasters",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Webmasters",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_WebRisk",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/WebRisk",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_WebSecurityScanner",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/WebSecurityScanner",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_WorkflowExecutions",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/WorkflowExecutions",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_Workflows",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/Workflows",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_YouTube",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/YouTube",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_YouTubeAnalytics",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/YouTubeAnalytics",
            publicHeadersPath: "."
        ),
        .target(
            name: "GoogleAPIClientForREST_YouTubeReporting",
            dependencies: ["GoogleAPIClientForRESTCore"],
            path: "Source/GeneratedServices/YouTubeReporting",
            publicHeadersPath: "."
        ),
        // End of targets.
    ]
)
