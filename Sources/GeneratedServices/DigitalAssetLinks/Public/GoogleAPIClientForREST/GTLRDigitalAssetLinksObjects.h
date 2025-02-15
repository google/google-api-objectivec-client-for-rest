// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Digital Asset Links API (digitalassetlinks/v1)
// Description:
//   Discovers relationships between online assets such as websites or mobile
//   apps.
// Documentation:
//   https://developers.google.com/digital-asset-links/

#import <GoogleAPIClientForREST/GTLRObject.h>

#if GTLR_RUNTIME_VERSION != 3000
#error This file was generated by a different version of ServiceGenerator which is incompatible with this GTLR library source.
#endif

@class GTLRDigitalAssetLinks_AndroidAppAsset;
@class GTLRDigitalAssetLinks_Asset;
@class GTLRDigitalAssetLinks_CertificateInfo;
@class GTLRDigitalAssetLinks_Statement;
@class GTLRDigitalAssetLinks_WebAsset;

// Generated comments include content from the discovery document; avoid them
// causing warnings since clang's checks are some what arbitrary.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

NS_ASSUME_NONNULL_BEGIN

// ----------------------------------------------------------------------------
// Constants - For some of the classes' properties below.

// ----------------------------------------------------------------------------
// GTLRDigitalAssetLinks_CheckResponse.errorCode

/**
 *  Invalid HTTPS certificate .
 *
 *  Value: "ERROR_CODE_FAILED_SSL_VALIDATION"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeFailedSslValidation;
/**
 *  Too many includes (maybe a loop).
 *
 *  Value: "ERROR_CODE_FETCH_BUDGET_EXHAUSTED"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeFetchBudgetExhausted;
/**
 *  Unable to fetch the asset links data.
 *
 *  Value: "ERROR_CODE_FETCH_ERROR"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeFetchError;
/**
 *  Unable to parse query.
 *
 *  Value: "ERROR_CODE_INVALID_QUERY"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeInvalidQuery;
/**
 *  JSON content is malformed.
 *
 *  Value: "ERROR_CODE_MALFORMED_CONTENT"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeMalformedContent;
/**
 *  Can't parse HTTP response.
 *
 *  Value: "ERROR_CODE_MALFORMED_HTTP_RESPONSE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeMalformedHttpResponse;
/**
 *  HTTP redirects (e.g, 301) are not allowed.
 *
 *  Value: "ERROR_CODE_REDIRECT"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeRedirect;
/**
 *  A secure asset includes an insecure asset (security downgrade).
 *
 *  Value: "ERROR_CODE_SECURE_ASSET_INCLUDES_INSECURE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeSecureAssetIncludesInsecure;
/**
 *  Asset links data exceeds maximum size.
 *
 *  Value: "ERROR_CODE_TOO_LARGE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeTooLarge;
/**
 *  Default value, otherwise unused.
 *
 *  Value: "ERROR_CODE_UNSPECIFIED"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeUnspecified;
/**
 *  HTTP Content-type should be application/json.
 *
 *  Value: "ERROR_CODE_WRONG_CONTENT_TYPE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_CheckResponse_ErrorCode_ErrorCodeWrongContentType;

// ----------------------------------------------------------------------------
// GTLRDigitalAssetLinks_ListResponse.errorCode

/**
 *  Invalid HTTPS certificate .
 *
 *  Value: "ERROR_CODE_FAILED_SSL_VALIDATION"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeFailedSslValidation;
/**
 *  Too many includes (maybe a loop).
 *
 *  Value: "ERROR_CODE_FETCH_BUDGET_EXHAUSTED"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeFetchBudgetExhausted;
/**
 *  Unable to fetch the asset links data.
 *
 *  Value: "ERROR_CODE_FETCH_ERROR"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeFetchError;
/**
 *  Unable to parse query.
 *
 *  Value: "ERROR_CODE_INVALID_QUERY"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeInvalidQuery;
/**
 *  JSON content is malformed.
 *
 *  Value: "ERROR_CODE_MALFORMED_CONTENT"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeMalformedContent;
/**
 *  Can't parse HTTP response.
 *
 *  Value: "ERROR_CODE_MALFORMED_HTTP_RESPONSE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeMalformedHttpResponse;
/**
 *  HTTP redirects (e.g, 301) are not allowed.
 *
 *  Value: "ERROR_CODE_REDIRECT"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeRedirect;
/**
 *  A secure asset includes an insecure asset (security downgrade).
 *
 *  Value: "ERROR_CODE_SECURE_ASSET_INCLUDES_INSECURE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeSecureAssetIncludesInsecure;
/**
 *  Asset links data exceeds maximum size.
 *
 *  Value: "ERROR_CODE_TOO_LARGE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeTooLarge;
/**
 *  Default value, otherwise unused.
 *
 *  Value: "ERROR_CODE_UNSPECIFIED"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeUnspecified;
/**
 *  HTTP Content-type should be application/json.
 *
 *  Value: "ERROR_CODE_WRONG_CONTENT_TYPE"
 */
FOUNDATION_EXTERN NSString * const kGTLRDigitalAssetLinks_ListResponse_ErrorCode_ErrorCodeWrongContentType;

/**
 *  Describes an android app asset.
 */
@interface GTLRDigitalAssetLinks_AndroidAppAsset : GTLRObject

/**
 *  Because there is no global enforcement of package name uniqueness, we also
 *  require a signing certificate, which in combination with the package name
 *  uniquely identifies an app. Some apps' signing keys are rotated, so they may
 *  be signed by different keys over time. We treat these as distinct assets,
 *  since we use (package name, cert) as the unique ID. This should not normally
 *  pose any problems as both versions of the app will make the same or similar
 *  statements. Other assets making statements about the app will have to be
 *  updated when a key is rotated, however. (Note that the syntaxes for
 *  publishing and querying for statements contain syntactic sugar to easily let
 *  you specify apps that are known by multiple certificates.) REQUIRED
 */
@property(nonatomic, strong, nullable) GTLRDigitalAssetLinks_CertificateInfo *certificate;

/**
 *  Android App assets are naturally identified by their Java package name. For
 *  example, the Google Maps app uses the package name
 *  `com.google.android.apps.maps`. REQUIRED
 */
@property(nonatomic, copy, nullable) NSString *packageName;

@end


/**
 *  Uniquely identifies an asset. A digital asset is an identifiable and
 *  addressable online entity that typically provides some service or content.
 *  Examples of assets are websites, Android apps, Twitter feeds, and Plus
 *  Pages.
 */
@interface GTLRDigitalAssetLinks_Asset : GTLRObject

/** Set if this is an Android App asset. */
@property(nonatomic, strong, nullable) GTLRDigitalAssetLinks_AndroidAppAsset *androidApp;

/** Set if this is a web asset. */
@property(nonatomic, strong, nullable) GTLRDigitalAssetLinks_WebAsset *web;

@end


/**
 *  Describes an X509 certificate.
 */
@interface GTLRDigitalAssetLinks_CertificateInfo : GTLRObject

/**
 *  The uppercase SHA-265 fingerprint of the certificate. From the PEM
 *  certificate, it can be acquired like this: $ keytool -printcert -file
 *  $CERTFILE | grep SHA256: SHA256:
 *  14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83: \\
 *  42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5 or like this: $ openssl x509 -in
 *  $CERTFILE -noout -fingerprint -sha256 SHA256
 *  Fingerprint=14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64: \\
 *  16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5 In this example, the
 *  contents of this field would be `14:6D:E9:83:C5:73:
 *  06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:
 *  44:E5`. If these tools are not available to you, you can convert the PEM
 *  certificate into the DER format, compute the SHA-256 hash of that string and
 *  represent the result as a hexstring (that is, uppercase hexadecimal
 *  representations of each octet, separated by colons).
 */
@property(nonatomic, copy, nullable) NSString *sha256Fingerprint;

@end


/**
 *  Response message for the CheckAssetLinks call.
 */
@interface GTLRDigitalAssetLinks_CheckResponse : GTLRObject

/**
 *  Human-readable message containing information intended to help end users
 *  understand, reproduce and debug the result. The message will be in English
 *  and we are currently not planning to offer any translations. Please note
 *  that no guarantees are made about the contents or format of this string. Any
 *  aspect of it may be subject to change without notice. You should not attempt
 *  to programmatically parse this data. For programmatic access, use the
 *  error_code field below.
 */
@property(nonatomic, copy, nullable) NSString *debugString;

/** Error codes that describe the result of the Check operation. */
@property(nonatomic, strong, nullable) NSArray<NSString *> *errorCode;

/**
 *  Set to true if the assets specified in the request are linked by the
 *  relation specified in the request.
 *
 *  Uses NSNumber of boolValue.
 */
@property(nonatomic, strong, nullable) NSNumber *linked;

/**
 *  From serving time, how much longer the response should be considered valid
 *  barring further updates. REQUIRED
 */
@property(nonatomic, strong, nullable) GTLRDuration *maxAge;

@end


/**
 *  Response message for the List call.
 */
@interface GTLRDigitalAssetLinks_ListResponse : GTLRObject

/**
 *  Human-readable message containing information intended to help end users
 *  understand, reproduce and debug the result. The message will be in English
 *  and we are currently not planning to offer any translations. Please note
 *  that no guarantees are made about the contents or format of this string. Any
 *  aspect of it may be subject to change without notice. You should not attempt
 *  to programmatically parse this data. For programmatic access, use the
 *  error_code field below.
 */
@property(nonatomic, copy, nullable) NSString *debugString;

/** Error codes that describe the result of the List operation. */
@property(nonatomic, strong, nullable) NSArray<NSString *> *errorCode;

/**
 *  From serving time, how much longer the response should be considered valid
 *  barring further updates. REQUIRED
 */
@property(nonatomic, strong, nullable) GTLRDuration *maxAge;

/** A list of all the matching statements that have been found. */
@property(nonatomic, strong, nullable) NSArray<GTLRDigitalAssetLinks_Statement *> *statements;

@end


/**
 *  Describes a reliable statement that has been made about the relationship
 *  between a source asset and a target asset. Statements are always made by the
 *  source asset, either directly or by delegating to a statement list that is
 *  stored elsewhere. For more detailed definitions of statements and assets,
 *  please refer to our [API documentation landing
 *  page](/digital-asset-links/v1/getting-started).
 */
@interface GTLRDigitalAssetLinks_Statement : GTLRObject

/**
 *  The relation identifies the use of the statement as intended by the source
 *  asset's owner (that is, the person or entity who issued the statement).
 *  Every complete statement has a relation. We identify relations with strings
 *  of the format `/`, where `` must be one of a set of pre-defined purpose
 *  categories, and `` is a free-form lowercase alphanumeric string that
 *  describes the specific use case of the statement. Refer to [our API
 *  documentation](/digital-asset-links/v1/relation-strings) for the current
 *  list of supported relations. Example:
 *  `delegate_permission/common.handle_all_urls` REQUIRED
 */
@property(nonatomic, copy, nullable) NSString *relation;

/** Every statement has a source asset. REQUIRED */
@property(nonatomic, strong, nullable) GTLRDigitalAssetLinks_Asset *source;

/** Every statement has a target asset. REQUIRED */
@property(nonatomic, strong, nullable) GTLRDigitalAssetLinks_Asset *target;

@end


/**
 *  Describes a web asset.
 */
@interface GTLRDigitalAssetLinks_WebAsset : GTLRObject

/**
 *  Web assets are identified by a URL that contains only the scheme, hostname
 *  and port parts. The format is http[s]://[:] Hostnames must be fully
 *  qualified: they must end in a single period ("`.`"). Only the schemes "http"
 *  and "https" are currently allowed. Port numbers are given as a decimal
 *  number, and they must be omitted if the standard port numbers are used: 80
 *  for http and 443 for https. We call this limited URL the "site". All URLs
 *  that share the same scheme, hostname and port are considered to be a part of
 *  the site and thus belong to the web asset. Example: the asset with the site
 *  `https://www.google.com` contains all these URLs: *
 *  `https://www.google.com/` * `https://www.google.com:443/` *
 *  `https://www.google.com/foo` * `https://www.google.com/foo?bar` *
 *  `https://www.google.com/foo#bar` * `https://user\@password:www.google.com/`
 *  But it does not contain these URLs: * `http://www.google.com/` (wrong
 *  scheme) * `https://google.com/` (hostname does not match) *
 *  `https://www.google.com:444/` (port does not match) REQUIRED
 */
@property(nonatomic, copy, nullable) NSString *site;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
