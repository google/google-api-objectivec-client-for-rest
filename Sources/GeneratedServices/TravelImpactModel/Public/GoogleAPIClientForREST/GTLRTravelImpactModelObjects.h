// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Travel Impact Model API (travelimpactmodel/v1)
// Description:
//   Travel Impact Model API lets you query travel carbon emission estimates.
// Documentation:
//   https://developers.google.com/travel/impact-model

#import <GoogleAPIClientForREST/GTLRObject.h>

#if GTLR_RUNTIME_VERSION != 3000
#error This file was generated by a different version of ServiceGenerator which is incompatible with this GTLR library source.
#endif

@class GTLRTravelImpactModel_Date;
@class GTLRTravelImpactModel_EasaLabelMetadata;
@class GTLRTravelImpactModel_EmissionsGramsPerPax;
@class GTLRTravelImpactModel_Flight;
@class GTLRTravelImpactModel_FlightWithEmissions;
@class GTLRTravelImpactModel_Market;
@class GTLRTravelImpactModel_ModelVersion;
@class GTLRTravelImpactModel_TypicalFlightEmissions;

// Generated comments include content from the discovery document; avoid them
// causing warnings since clang's checks are some what arbitrary.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

NS_ASSUME_NONNULL_BEGIN

// ----------------------------------------------------------------------------
// Constants - For some of the classes' properties below.

// ----------------------------------------------------------------------------
// GTLRTravelImpactModel_FlightWithEmissions.contrailsImpactBucket

/**
 *  The contrails impact is comparable to the total CO2e emissions.
 *
 *  Value: "CONTRAILS_IMPACT_MODERATE"
 */
FOUNDATION_EXTERN NSString * const kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactModerate;
/**
 *  The contrails impact is negligible compared to the total CO2e emissions.
 *
 *  Value: "CONTRAILS_IMPACT_NEGLIGIBLE"
 */
FOUNDATION_EXTERN NSString * const kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactNegligible;
/**
 *  The contrails impact is higher than the total CO2e emissions impact.
 *
 *  Value: "CONTRAILS_IMPACT_SEVERE"
 */
FOUNDATION_EXTERN NSString * const kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactSevere;
/**
 *  The contrails impact is unspecified.
 *
 *  Value: "CONTRAILS_IMPACT_UNSPECIFIED"
 */
FOUNDATION_EXTERN NSString * const kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactUnspecified;

// ----------------------------------------------------------------------------
// GTLRTravelImpactModel_FlightWithEmissions.source

/**
 *  The emissions data is from the EASA environmental labels.
 *
 *  Value: "EASA"
 */
FOUNDATION_EXTERN NSString * const kGTLRTravelImpactModel_FlightWithEmissions_Source_Easa;
/**
 *  The source of the emissions data is unspecified.
 *
 *  Value: "SOURCE_UNSPECIFIED"
 */
FOUNDATION_EXTERN NSString * const kGTLRTravelImpactModel_FlightWithEmissions_Source_SourceUnspecified;
/**
 *  The emissions data is from the Travel Impact Model.
 *
 *  Value: "TIM"
 */
FOUNDATION_EXTERN NSString * const kGTLRTravelImpactModel_FlightWithEmissions_Source_Tim;

/**
 *  Input definition for the ComputeFlightEmissions request.
 */
@interface GTLRTravelImpactModel_ComputeFlightEmissionsRequest : GTLRObject

/** Required. Direct flights to return emission estimates for. */
@property(nonatomic, strong, nullable) NSArray<GTLRTravelImpactModel_Flight *> *flights;

@end


/**
 *  Output definition for the ComputeFlightEmissions response.
 */
@interface GTLRTravelImpactModel_ComputeFlightEmissionsResponse : GTLRObject

/** List of flight legs with emission estimates. */
@property(nonatomic, strong, nullable) NSArray<GTLRTravelImpactModel_FlightWithEmissions *> *flightEmissions;

/**
 *  The model version under which emission estimates for all flights in this
 *  response were computed.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_ModelVersion *modelVersion;

@end


/**
 *  A list of pair of airports (markets) to request the typical emissions for.
 */
@interface GTLRTravelImpactModel_ComputeTypicalFlightEmissionsRequest : GTLRObject

/**
 *  Required. Request the typical flight emissions estimates for this market
 *  pair. A maximum of 1000 markets can be requested.
 */
@property(nonatomic, strong, nullable) NSArray<GTLRTravelImpactModel_Market *> *markets;

@end


/**
 *  The response includes the emissions but also the model version.
 */
@interface GTLRTravelImpactModel_ComputeTypicalFlightEmissionsResponse : GTLRObject

/**
 *  The model version under which typical flight emission estimates for all
 *  flights in this response were computed.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_ModelVersion *modelVersion;

/** Market's Typical Flight Emissions requested. */
@property(nonatomic, strong, nullable) NSArray<GTLRTravelImpactModel_TypicalFlightEmissions *> *typicalFlightEmissions;

@end


/**
 *  Represents a whole or partial calendar date, such as a birthday. The time of
 *  day and time zone are either specified elsewhere or are insignificant. The
 *  date is relative to the Gregorian Calendar. This can represent one of the
 *  following: * A full date, with non-zero year, month, and day values. * A
 *  month and day, with a zero year (for example, an anniversary). * A year on
 *  its own, with a zero month and a zero day. * A year and month, with a zero
 *  day (for example, a credit card expiration date). Related types: *
 *  google.type.TimeOfDay * google.type.DateTime * google.protobuf.Timestamp
 */
@interface GTLRTravelImpactModel_Date : GTLRObject

/**
 *  Day of a month. Must be from 1 to 31 and valid for the year and month, or 0
 *  to specify a year by itself or a year and month where the day isn't
 *  significant.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *day;

/**
 *  Month of a year. Must be from 1 to 12, or 0 to specify a year without a
 *  month and day.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *month;

/**
 *  Year of the date. Must be from 1 to 9999, or 0 to specify a date without a
 *  year.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *year;

@end


/**
 *  Metadata about the EASA Flight Emissions Label.
 */
@interface GTLRTravelImpactModel_EasaLabelMetadata : GTLRObject

/**
 *  The date when the label expires. The label can be displayed until the end of
 *  this date.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_Date *labelExpiryDate;

/** The date when the label was issued. */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_Date *labelIssueDate;

/** Version of the label. */
@property(nonatomic, copy, nullable) NSString *labelVersion;

/**
 *  Sustainable Aviation Fuel (SAF) emissions discount percentage applied to the
 *  label. It is a percentage as a decimal. The values are in the interval
 *  [0,1]. For example, 0.0021 means 0.21%. This discount and reduction in
 *  emissions are reported by the EASA label but they are not included in the
 *  CO2e estimates distributed by this API.
 *
 *  Uses NSNumber of doubleValue.
 */
@property(nonatomic, strong, nullable) NSNumber *safDiscountPercentage;

@end


/**
 *  Grouped emissions per seating class results.
 */
@interface GTLRTravelImpactModel_EmissionsGramsPerPax : GTLRObject

/**
 *  Emissions for one passenger in business class in grams. This field is always
 *  computed and populated, regardless of whether the aircraft has business
 *  class seats or not.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *business;

/**
 *  Emissions for one passenger in economy class in grams. This field is always
 *  computed and populated, regardless of whether the aircraft has economy class
 *  seats or not.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *economy;

/**
 *  Emissions for one passenger in first class in grams. This field is always
 *  computed and populated, regardless of whether the aircraft has first class
 *  seats or not.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *first;

/**
 *  Emissions for one passenger in premium economy class in grams. This field is
 *  always computed and populated, regardless of whether the aircraft has
 *  premium economy class seats or not.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *premiumEconomy;

@end


/**
 *  All details related to a single request item for a direct flight emission
 *  estimates.
 */
@interface GTLRTravelImpactModel_Flight : GTLRObject

/**
 *  Required. Date of the flight in the time zone of the origin airport. Must be
 *  a date in the present or future.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_Date *departureDate;

/** Required. IATA airport code for flight destination, e.g. "JFK". */
@property(nonatomic, copy, nullable) NSString *destination;

/**
 *  Required. Flight number, e.g. 324.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *flightNumber;

/** Required. IATA carrier code, e.g. "AA". */
@property(nonatomic, copy, nullable) NSString *operatingCarrierCode;

/** Required. IATA airport code for flight origin, e.g. "LHR". */
@property(nonatomic, copy, nullable) NSString *origin;

@end


/**
 *  Direct flight with emission estimates.
 */
@interface GTLRTravelImpactModel_FlightWithEmissions : GTLRObject

/**
 *  Optional. The significance of contrails warming impact compared to the total
 *  CO2e emissions impact.
 *
 *  Likely values:
 *    @arg @c kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactModerate
 *        The contrails impact is comparable to the total CO2e emissions.
 *        (Value: "CONTRAILS_IMPACT_MODERATE")
 *    @arg @c kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactNegligible
 *        The contrails impact is negligible compared to the total CO2e
 *        emissions. (Value: "CONTRAILS_IMPACT_NEGLIGIBLE")
 *    @arg @c kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactSevere
 *        The contrails impact is higher than the total CO2e emissions impact.
 *        (Value: "CONTRAILS_IMPACT_SEVERE")
 *    @arg @c kGTLRTravelImpactModel_FlightWithEmissions_ContrailsImpactBucket_ContrailsImpactUnspecified
 *        The contrails impact is unspecified. (Value:
 *        "CONTRAILS_IMPACT_UNSPECIFIED")
 */
@property(nonatomic, copy, nullable) NSString *contrailsImpactBucket;

/**
 *  Optional. Metadata about the EASA Flight Emissions Label. Only set when the
 *  emissions data source is EASA.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_EasaLabelMetadata *easaLabelMetadata;

/**
 *  Optional. Per-passenger emission estimate numbers. Will not be present if
 *  emissions could not be computed. For the list of reasons why emissions could
 *  not be computed, see ComputeFlightEmissions.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_EmissionsGramsPerPax *emissionsGramsPerPax;

/**
 *  Required. Matches the flight identifiers in the request. Note: all IATA
 *  codes are capitalized.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_Flight *flight;

/**
 *  Optional. The source of the emissions data.
 *
 *  Likely values:
 *    @arg @c kGTLRTravelImpactModel_FlightWithEmissions_Source_Easa The
 *        emissions data is from the EASA environmental labels. (Value: "EASA")
 *    @arg @c kGTLRTravelImpactModel_FlightWithEmissions_Source_SourceUnspecified
 *        The source of the emissions data is unspecified. (Value:
 *        "SOURCE_UNSPECIFIED")
 *    @arg @c kGTLRTravelImpactModel_FlightWithEmissions_Source_Tim The
 *        emissions data is from the Travel Impact Model. (Value: "TIM")
 */
@property(nonatomic, copy, nullable) NSString *source;

@end


/**
 *  A pair of airports.
 */
@interface GTLRTravelImpactModel_Market : GTLRObject

/** Required. IATA airport code for flight destination, e.g. "JFK". */
@property(nonatomic, copy, nullable) NSString *destination;

/** Required. IATA airport code for flight origin, e.g. "LHR". */
@property(nonatomic, copy, nullable) NSString *origin;

@end


/**
 *  Travel Impact Model version. For more information about the model versioning
 *  see [GitHub](https://github.com/google/travel-impact-model/#versioning).
 */
@interface GTLRTravelImpactModel_ModelVersion : GTLRObject

/**
 *  Dated versions: Model datasets are recreated with refreshed input data but
 *  no change to the algorithms regularly.
 */
@property(nonatomic, copy, nullable) NSString *dated;

/**
 *  Major versions: Major changes to methodology (e.g. adding new data sources
 *  to the model that lead to major output changes). Such changes will be
 *  infrequent and announced well in advance. Might involve API version changes,
 *  which will respect [Google Cloud API
 *  guidelines](https://cloud.google.com/endpoints/docs/openapi/versioning-an-api#backwards-incompatible)
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *major;

/**
 *  Minor versions: Changes to the model that, while being consistent across
 *  schema versions, change the model parameters or implementation.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *minor;

/**
 *  Patch versions: Implementation changes meant to address bugs or inaccuracies
 *  in the model implementation.
 *
 *  Uses NSNumber of intValue.
 */
@property(nonatomic, strong, nullable) NSNumber *patch;

@end


/**
 *  Typical flight emission estimates for a certain market
 */
@interface GTLRTravelImpactModel_TypicalFlightEmissions : GTLRObject

/**
 *  Optional. Typical flight emissions per passenger for requested market. Will
 *  not be present if a typical emissions could not be computed. For the list of
 *  reasons why typical flight emissions could not be computed, see
 *  [GitHub](https://github.com/google/travel-impact-model/blob/main/projects/typical_flight_emissions.md#step-7-validate-dataset).
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_EmissionsGramsPerPax *emissionsGramsPerPax;

/**
 *  Required. Matches the flight identifiers in the request. Note: all IATA
 *  codes are capitalized.
 */
@property(nonatomic, strong, nullable) GTLRTravelImpactModel_Market *market;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
