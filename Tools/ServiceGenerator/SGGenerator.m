/* Copyright (c) 2011 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <GoogleAPIClientForREST/GTLRUtilities.h>

#import "SGGenerator.h"
#import "SGUtils.h"

static NSString *kProjectPrefix         = @"GTLR";
static NSString *kServiceBaseClass      = @"GTLRService";
static NSString *kQueryBaseClass        = @"GTLRQuery";
static NSString *kBaseObjectClass       = @"GTLRObject";
static NSString *kCollectionObjectClass = @"GTLRCollectionObject";
static NSString *kResultArrayClass      = @"GTLRResultArray";
static NSString *kExternPrefix          = @"FOUNDATION_EXTERN";

static NSString *kFatalGeneration = @"FatalGeneration";

static NSString *kWrappedMethodKey                = @"wrappedMethod";
static NSString *kWrappedSchemaKey                = @"wrappedSchema";
static NSString *kWrappedResourceKey              = @"wrappedResource";
static NSString *kNameKey                         = @"name";
static NSString *kObjCNameKey                     = @"objcName";
static NSString *kForcedNameCommentKey            = @"forcedNameComment";
static NSString *kCapObjCNameKey                  = @"capObjCName";
static NSString *kAllResourcesKey                 = @"allResources";
static NSString *kAllMethodsKey                   = @"allMethods";
static NSString *kHasDeprecatedMethodKey          = @"hasDeprecatedMethodKey";
static NSString *kQueryEnumsMapKey                = @"queryEnumsMap";
static NSString *kObjectEnumsMapKey               = @"objectEnumsMap";
static NSString *kAllSchemasKey                   = @"allSchemas";
static NSString *kSortedParametersKey             = @"sortedParameters";
static NSString *kSortedParametersWithRequestKey  = @"sortedParametersWithRequest";
static NSString *kTopLevelObjectSchemasKey        = @"topLevelObjectSchemas";
static NSString *kChildObjectSchemasKey           = @"childSchemas";
static NSString *kResolvedSchemaKey               = @"resolvedSchema";
static NSString *kSchemaObjCClassNameKey          = @"schemaObjCClassName";
static NSString *kWrappedGeneratorKey             = @"wrappedGenerator";
static NSString *kReturnsSchemaParameterKey       = @"returnsSchema";
static NSString *kAllMethodObjectParametersKey    = @"allMethodObjectParameters";
static NSString *kAllMethodObjectParameterRefsKey = @"allMethodObjectParameterRefs";
static NSString *kCleanedRootURLStringKey         = @"cleanedRootURLString";
static NSString *kResumableUploadPathKey          = @"resumableUploadPath";
static NSString *kSimpleUploadPathKey             = @"simpleUploadPath";
static NSString *kResumableUploadPathOverrideKey  = @"resumableUploadPathOverride";
static NSString *kSimpleUploadPathOverrideKey     = @"simpleUploadPathOverride";
static NSString *kIsItemsSchemaKey                = @"isItemsSchema";
static NSString *kCommonQueryParamsKey            = @"commonQueryParam";
static NSString *kCommonPrettyPrintQueryParamsKey = @"commonPrettyPrintQueryParams";
static NSString *kEnumMapKey                      = @"enumMap";


static NSString *kSuppressDocumentationWarningsBegin =
  @"// Generated comments include content from the discovery document; avoid them\n"
  @"// causing warnings since clang's checks are some what arbitrary.\n"
  @"#pragma clang diagnostic push\n"
  @"#pragma clang diagnostic ignored \"-Wdocumentation\"\n";
static NSString *kSuppressDocumentationWarningsEnd =
  @"#pragma clang diagnostic pop\n";

// Discovery doesn't provide a message (just a boolean), simple annotation is
// all that is possible.
static NSString *kDeprecatedSuffix = @" GTLR_DEPRECATED";
static NSString *kDeprecatedWithNewline = @"GTLR_DEPRECATED\n";

typedef enum {
  kGenerateInterface = 1,
  kGenerateImplementation
} GeneratorMode;

typedef enum {
  kOAuth2ScopeNamingModeShortURL,
  kOAuth2ScopeNamingModeFullURL,
  kOAuth2ScopeNamingModeUseEverything,
} OAuth2ScopeNamingMode;

// This is added so it can be called on Methods, Parameters, and Schema.
@interface GTLRObject (SGGeneratorAdditions)
@property(readonly) NSString *sg_errorReportingName;
@property(readonly) SGGenerator *sg_generator;

- (void)sg_setProperty:(id)obj forKey:(NSString *)key;
- (id)sg_propertyForKey:(NSString *)key;
+ (NSArray *)sg_acceptedUnknowns;
@end

@interface GTLRDiscovery_RestDescription (SGGeneratorAdditions)
@property(readonly) NSArray *sg_allMethods;
@property(readonly) BOOL sg_hasDeprecatedMethod;
@property(readonly) NSDictionary *sg_queryEnumsMap;
@property(readonly) NSDictionary *sg_objectEnumsMap;
@property(readonly) NSArray *sg_allSchemas;
@property(readonly) NSArray *sg_topLevelObjectSchemas;
@property(readonly) NSArray *sg_allMethodObjectParameterReferences;
@property(readonly) NSString *sg_resumableUploadPath;
@property(readonly) NSString *sg_simpleUploadPath;

- (NSString *)sg_cleanedRootURLString;
- (void)sg_calculateMediaPaths;
@end

@interface GTLRDiscovery_JsonSchema (SGGeneratorAdditions)
@property(readonly) NSString *sg_name;
@property(readonly) NSString *sg_objcName;
@property(readonly) NSString *sg_capObjCName;
@property(readonly) NSString *sg_forceNameComment;
@property(readonly) GTLRDiscovery_RestMethod *sg_method;
@property(readonly, getter=sg_isParameter) BOOL sg_parameter;
@property(readonly) GTLRDiscovery_JsonSchema *sg_parentSchema;
@property(readonly) NSString *sg_fullSchemaName;
@property(readonly) NSString *sg_objcClassName;
@property(readonly) NSArray *sg_childObjectSchemas;
@property(readonly) GTLRDiscovery_JsonSchema *sg_resolvedSchema;
@property(readonly) NSString *sg_kindToRegister;
@property(readonly) BOOL sg_isLikelyInvalidUseOfKind;
@property(readonly) NSString *sg_formattedRange;
@property(readonly) NSString *sg_formattedDefault;
@property(readonly) NSString *sg_rangeAndDefaultDescription;

- (NSString *)sg_collectionItemsKey:(BOOL *)outSupportsPagination;

- (GTLRDiscovery_JsonSchema *)sg_itemsSchemaResolving:(BOOL)resolving
                                                depth:(NSInteger *)depth;

- (NSString *)sg_constantNamed:(NSString *)name;

- (void)sg_getObjectParamObjCType:(NSString **)objcType
                        asPointer:(BOOL *)asPointer
            objcPropertySemantics:(NSString **)objcPropertySemantics
                          comment:(NSString **)comment;

- (void)sg_getQueryParamObjCType:(NSString **)objcType
                       asPointer:(BOOL *)asPointer
           objcPropertySemantics:(NSString **)objcPropertySemantics
                         comment:(NSString **)comment
                  itemsClassName:(NSString **)itemsClassName;
@end

@interface GTLRDiscovery_RestResource (SGGeneratorAdditions)
@property(readonly) NSString *sg_name;
@end

@interface GTLRDiscovery_RestMethod (SGGeneratorAdditions)
@property(readonly) NSString *sg_name;
@property(readonly) NSArray *sg_sortedParameters;
@property(readonly) NSArray *sg_sortedParametersWithRequest;
@property(readonly) NSString *sg_resumableUploadPathOverride;
@property(readonly) NSString *sg_simpleUploadPathOverride;
@end

@interface GTLRDiscovery_RestMethod_Request (SGGeneratorAdditions)
@property(readonly) GTLRDiscovery_JsonSchema *sg_resolvedSchema;
@end

@interface GTLRDiscovery_RestMethod_Response (SGGeneratorAdditions)
@property(readonly) GTLRDiscovery_JsonSchema *sg_resolvedSchema;
@end

@interface SGGenerator ()
@property(strong) NSMutableArray *warnings;
@property(strong) NSMutableArray *infos;
@end

// Helper to get the objects of a dictionary out in a sorted order.
static NSArray *DictionaryObjectsSortedByKeys(NSDictionary *dict) {
  NSArray *allKeys = dict.allKeys;
  NSArray *sortedKeys =
    [allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  NSArray *result = [dict objectsForKeys:sortedKeys
                          notFoundMarker:[NSNull null]];
  return result;
}

static NSString *ConstantName(NSString *grouping, NSString *name) {
  // Some constants are things like "@self", so remove the "@" for the name
  // we generated.
  if ([name hasPrefix:@"@"]) {
    name = [name substringFromIndex:1];
  }

  // Some services use enum values that are all caps. These end up looking
  // pretty bad, so if the name is all caps, we downcase it and hope that
  // ends up better.
  if ([name isEqual:[name uppercaseString]]) {
    name = [name lowercaseString];
  }

  NSString *formattedName = [SGUtils objcName:name shouldCapitalize:YES];
  NSString *result =
    [NSString stringWithFormat:@"k%@%@", grouping, formattedName];
  return result;
}

@interface GTLRObject (Internal)
+ (NSArray<NSString *> *)allDeclaredProperties;
@end

static void ValidateAcceptedUnknowns(Class objClass) {
  static NSMutableSet *alreadyChecked;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    alreadyChecked = [NSMutableSet set];
  });
  @synchronized(alreadyChecked) {
    if ([alreadyChecked containsObject:objClass]) {
      return;
    }
    [alreadyChecked addObject:objClass];
  }

  NSArray *acceptedUnknowns = [objClass sg_acceptedUnknowns];
  if ([acceptedUnknowns count] == 0) {
    return;
  }

  Class additionalPropClass = [objClass classForAdditionalProperties];
  if (additionalPropClass == nil) {
    NSArray<NSString *> *allProps = [objClass allDeclaredProperties];
    for (NSString *name in acceptedUnknowns) {
      if ([allProps containsObject:name]) {
        NSLog(@"ERROR: %@ has %@ listed as an acceptedUnknown, but it is known.",
              objClass, name);
      }
    }
  } else {
    NSLog(@"ERROR: %@ uses additionalProperties as %@, but it has sg_acceptedUnknowns of %@.",
          objClass, additionalPropClass, acceptedUnknowns);
  }
}

static void CheckForUnknownJSON(GTLRObject *obj, NSArray *keyPath,
                                SGGeneratorMessageHandler messageHandler) {
  Class objClass = [obj class];
  ValidateAcceptedUnknowns(objClass);

  // If the class doesn't expect unknowns, report them.
  Class additionalPropClass = [objClass classForAdditionalProperties];
  if (additionalPropClass == Nil) {
    NSArray *apiUnknowns = [obj additionalJSONKeys];

    // The OP servers have added a few keys that aren't documented, this
    // support allows some of them to be stripped from the audit report
    // since they are noise.
    NSArray *acceptedUnknowns = [objClass sg_acceptedUnknowns];
    if (acceptedUnknowns.count) {
      NSMutableArray *worker = [apiUnknowns mutableCopy];
      [worker removeObjectsInArray:acceptedUnknowns];
      apiUnknowns = worker.count ? worker : nil;
    }

    if (apiUnknowns != nil) {
      apiUnknowns = [apiUnknowns sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
      NSString *keyPathStr =
          (keyPath.count == 0) ? @"<root>" : [keyPath componentsJoinedByString:@"."];
      NSString *info =
        [NSString stringWithFormat:@"Unexpected JSON %s under %@: %@",
         (apiUnknowns.count > 1 ? "keys" : "key"),
         keyPathStr,
         [apiUnknowns componentsJoinedByString:@", "]];
      messageHandler(kSGGeneratorHandlerMessageInfo, info);
    }
  }

  // Recurse through all the known properties.
  NSArray<NSString *> *allProps = [objClass allDeclaredProperties];
  allProps = [allProps sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  for (NSString *key in allProps) {
    id value = [obj valueForKey:key];
    if ([value isKindOfClass:[GTLRObject class]]) {
      NSArray *subKeyPath = [keyPath arrayByAddingObject:key];
      CheckForUnknownJSON(value, subKeyPath, messageHandler);
    }
  }

  // If the class *does* expect unknown objects, recurse through them.
  if ([additionalPropClass isSubclassOfClass:[GTLRObject class]]) {
    NSArray<NSString *> *apiUnknowns = [obj additionalJSONKeys];
    apiUnknowns = [apiUnknowns sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString *key in apiUnknowns) {
      id value = [obj additionalPropertyForName:key];
      if ([value isKindOfClass:[GTLRObject class]]) {
        NSArray *subKeyPath = [keyPath arrayByAddingObject:key];
        CheckForUnknownJSON(value, subKeyPath, messageHandler);
      } else {
        NSString *warning =
          [NSString stringWithFormat:
           @"Additional JSON under %@.%@: wasn't of a GTLRObject: %@",
           [keyPath componentsJoinedByString:@"."], key,
           [value class]];
        messageHandler(kSGGeneratorHandlerMessageWarning, warning);
      }
    }
  }
}

@implementation SGGenerator {
  NSString *_formattedName;
  NSPredicate *_notRetainedPredicate;
  NSPredicate *_useCustomerGetterPredicate;

  OAuth2ScopeNamingMode authScopeNamingMode;
}

@synthesize api = _api,
            options = _options,
            verboseLevel = _verboseLevel,
            importPrefix = _importPrefix,
            publicHeadersSubDir = _publicHeadersSubDir;

@synthesize warnings = _warnings,
            infos = _infos;

+ (instancetype)generatorForApi:(GTLRDiscovery_RestDescription *)api
                        options:(SGGeneratorOptions)options
                   verboseLevel:(NSUInteger)verboseLevel
          formattedNameOverride:(NSString *)formattedNameOverride
                   importPrefix:(NSString *)importPrefix
            publicHeadersSubDir:(NSString *)publicHeadersSubDir {
  return [[self alloc] initWithApi:api
                           options:options
                      verboseLevel:verboseLevel
             formattedNameOverride:formattedNameOverride
                      importPrefix:importPrefix
               publicHeadersSubDir:publicHeadersSubDir];
}

- (instancetype)initWithApi:(GTLRDiscovery_RestDescription *)api
                    options:(SGGeneratorOptions)options
               verboseLevel:(NSUInteger)verboseLevel
      formattedNameOverride:(NSString *)formattedNameOverride
               importPrefix:(NSString *)importPrefix
        publicHeadersSubDir:(NSString *)publicHeadersSubDir {
  self = [super init];
  if (self != nil) {
    NSAssert(!(((options & kSGGeneratorOptionImportPrefixIsFramework) != 0) &&
               ((options & kSGGeneratorOptionImportPrefixIsModular) != 0)),
             @"Internal error, can't set both.");
    _api = api;
    _options = options;
    _verboseLevel = verboseLevel;
    _formattedName = [formattedNameOverride copy];
    _importPrefix = [importPrefix copy];
    _publicHeadersSubDir = [publicHeadersSubDir copy];
    if (api) {
      NSValue *generatorAsValue = [NSValue valueWithNonretainedObject:self];
      [self.api sg_setProperty:generatorAsValue forKey:kWrappedGeneratorKey];

      // Anything that starts "new", "copy", or "mutableCopy" (and maybe continues
      // with a capital letter) can trip up a clang warning about not following
      // normal cocoa naming conventions, match them and add the directive
      // to tell the compiler what model to enforce.
      _notRetainedPredicate =
        [NSPredicate predicateWithFormat:@"SELF matches %@",
         @"^(new|copy|mutableCopy)([A-Z].*)?"];

      // Anything that starts "init" (and maybe continues with a capital letter or
      // underscore) can trip up clang (as of Xcode 5's ARC support) into thinking
      // it is a init method and thus should return a object of the same type as
      // the class the method is on. This can be avoid by adding a custom getter
      // to tweak the actual method name.
      _useCustomerGetterPredicate =
        [NSPredicate predicateWithFormat:@"SELF matches %@",
         @"^(init)([A-Z_].*)?"];

      // The discovery document is odd in that the names of things are the
      // keys in the dictionary, so the dict that is the item doesn't actually
      // have its name.  So run through the tree setting up the name as
      // a property so we have it.  While we're at it, also give resources
      // pointers to their parents.
      [self adornSchemas:self.api.schemas parentSchema:nil];
      [self adornResources:self.api.resources parentResource:nil];
      [self adornMethods:self.api.methods parentResource:nil];

      // Adorn the top level parameters.
      for (NSString *paramName in self.api.parameters.additionalProperties) {
        GTLRDiscovery_JsonSchema *parameter =
          [self.api.parameters.additionalProperties objectForKey:paramName];
        [self adornSchema:parameter name:paramName parentSchema:nil];
        [parameter sg_setProperty:[NSValue valueWithNonretainedObject:nil]
                           forKey:kWrappedMethodKey];
      }

    } else {
      self = nil;
    }
  }
  return self;
}

#pragma mark - Public methods

- (NSDictionary *)generateFilesWithHandler:(SGGeneratorMessageHandler)messageHandler {
  if (!messageHandler) return nil;

  if (![self preflightChecks:messageHandler]) {
    return nil;
  }

  // That's all the preflighting we can do. Any errors from here out are
  // thrown as NSExceptions.

  [self determineOAuth2ScopesNamingMode];

  [self.api sg_calculateMediaPaths];

  // Cause the objectEnumsMap to get calculated (and cached).
  (void)self.api.sg_objectEnumsMap;

  // Generate all the files...

  NSString *serviceHeader = self.serviceHeader;
  NSString *serviceSource = self.serviceSource;
  NSString *serviceFileNameBase = self.objcServiceClassName;

  NSString *queryHeader = self.queryHeader;
  NSString *querySource = self.querySource;
  NSString *queryFileNameBase = self.objcQueryBaseClassName;

  NSString *objectsHeader = self.objectsHeader;
  NSString *objectsSource = self.objectsSource;
  NSString *objectsFileNameBase = self.objcObjectsBaseFileName;

  NSString *umbrellaHeader = [self umbrellaHeader];
  NSString *umbrellaHeaderBaseFileName = self.umbrellaHeaderBaseFileName;

  NSString *headersDir = @"";
  if (self.publicHeadersSubDir) {
    headersDir = [NSString stringWithFormat:@"Public/%@/", self.publicHeadersSubDir];
  }

  NSDictionary *result = @{
    [headersDir stringByAppendingPathComponent:[umbrellaHeaderBaseFileName stringByAppendingPathExtension:@"h"]] : umbrellaHeader,
    [headersDir stringByAppendingPathComponent:[serviceFileNameBase stringByAppendingPathExtension:@"h"]] : serviceHeader,
    [serviceFileNameBase stringByAppendingPathExtension:@"m"] : serviceSource,
    [headersDir stringByAppendingPathComponent:[queryFileNameBase stringByAppendingPathExtension:@"h"]] : queryHeader,
    [queryFileNameBase stringByAppendingPathExtension:@"m"] : querySource,
    [headersDir stringByAppendingPathComponent:[objectsFileNameBase stringByAppendingPathExtension:@"h"]] : objectsHeader,
    [objectsFileNameBase stringByAppendingPathExtension:@"m"] : objectsSource,
  };

  // Report any infos/warnings added during generation.
  for (NSString *infoString in self.infos) {
    messageHandler(kSGGeneratorHandlerMessageInfo, infoString);
  }
  for (NSString *warningString in self.warnings) {
    messageHandler(kSGGeneratorHandlerMessageWarning, warningString);
  }

  return result;
}

- (BOOL)allowRootURLOverrides {
  BOOL result = (_options & kSGGeneratorOptionAllowRootOverride) != 0;
  return result;
}

- (BOOL)auditJSON {
  BOOL result = (_options & kSGGeneratorOptionAuditJSON) != 0;
  return result;
}

- (NSString *)formattedAPIName {
  if (_formattedName == nil) {
    NSString *canonicalName = self.api.canonicalName;
    if (canonicalName.length > 0) {
      // If there was a canonical name, remove the spaces and run it through
      // the sg_objcName cleanup just to make sure there aren't any invalid
      // characters.
      NSString *worker =
        [canonicalName stringByReplacingOccurrencesOfString:@" "
                                                 withString:@""];
      _formattedName = [SGUtils objcName:worker
                        shouldCapitalize:YES
                      allowLeadingDigits:YES];
      if (self.verboseLevel) {
        NSString *msg;
        if ([self.api.canonicalName isEqual:_formattedName]) {
          msg = [NSString stringWithFormat:@"Using canonical name: %@",
                 _formattedName];
        } else {
          msg = [NSString stringWithFormat:@"Using canonical name: \"%@\" -> %@",
                 self.api.canonicalName, _formattedName];
        }
        [self addInfo:msg];
      }
    }
    NSString *apiName = self.api.name;
    BOOL shouldGuessName = (_options & kSGGeneratorOptionAllowGuessFormattedName) != 0;
    // If there wasn't a canonicalName and the name was all lowercase, see if
    // we can guess a good name from the title.
    if (shouldGuessName &&
        (_formattedName == nil) &&
        ([apiName isEqual:[apiName lowercaseString]])) {
      NSString *title = self.api.title;
      if (title.length > 0) {
        // Drop a leading "Google" and/or trailing "API".
        NSArray<NSString *> *parts = [title componentsSeparatedByString:@" "];
        if ([[[parts firstObject] lowercaseString] isEqual:@"google"]) {
          parts = [parts subarrayWithRange:NSMakeRange(1, parts.count - 1)];
        }
        if ([[[parts lastObject] lowercaseString] isEqual:@"api"]) {
          parts = [parts subarrayWithRange:NSMakeRange(0, parts.count - 1)];
        } else if ([[[parts lastObject] lowercaseString] isEqual:@"apis"]) {
          parts = [parts subarrayWithRange:NSMakeRange(0, parts.count - 1)];
        }
        // If there was >1 part left, and glueing them all together as lowercase
        // matches the api name, then use them as the guessed name.
        if (parts.count > 1) {
          NSString *rejoined = [parts componentsJoinedByString:@""];
          if ([[rejoined lowercaseString] isEqual:apiName]) {
            _formattedName = [SGUtils objcName:rejoined
                              shouldCapitalize:YES
                            allowLeadingDigits:YES];
            NSString *msg =
              [NSString stringWithFormat:@"Guessed formatted name '%@' from API title '%@'",
                                         _formattedName, title];
            [self addInfo:msg];
          }
        }
      }
    }
    if (_formattedName == nil) {
      _formattedName = [SGUtils objcName:apiName shouldCapitalize:YES];
    }
  }
  return _formattedName;
}

#pragma mark - Init helpers

- (void)adornMethods:(GTLRObject *)methods
      parentResource:(GTLRDiscovery_RestResource *)parentResource {
  NSValue *generatorAsValue = [NSValue valueWithNonretainedObject:self];
  NSValue *parentResourceAsValue = [NSValue valueWithNonretainedObject:parentResource];

  // methods can be GTLRDiscovery_RestDescriptionMethods or
  // GTLRDiscovery_RestResourceMethods.

  // Spin over the methods
  for (NSString *methodName in methods.additionalProperties) {
    GTLRDiscovery_RestMethod *method =
      [methods.additionalProperties objectForKey:methodName];

    [method sg_setProperty:methodName forKey:kNameKey];
    [method sg_setProperty:generatorAsValue forKey:kWrappedGeneratorKey];
    if (parentResource) {
      [method sg_setProperty:parentResourceAsValue forKey:kWrappedResourceKey];
    }

    NSString *methodID = method.identifier;
    [method.response sg_setProperty:generatorAsValue forKey:kWrappedGeneratorKey];
    [method.response sg_setProperty:[methodID stringByAppendingString:@"-Response"]
                             forKey:kNameKey];
    [method.response.sg_resolvedSchema sg_setProperty:@YES
                                               forKey:kReturnsSchemaParameterKey];

    [method.request sg_setProperty:[methodID stringByAppendingString:@"-Request"]
                            forKey:kNameKey];
    [method.request sg_setProperty:generatorAsValue forKey:kWrappedGeneratorKey];

    // Spin over the parameters
    for (NSString *paramName in method.parameters.additionalProperties) {
      GTLRDiscovery_JsonSchema *parameter =
        [method.parameters.additionalProperties objectForKey:paramName];

      [self adornSchema:parameter name:paramName parentSchema:nil];
      [parameter sg_setProperty:[NSValue valueWithNonretainedObject:method]
                         forKey:kWrappedMethodKey];

      NSString *paramLocation = parameter.location;
      if (![parameter.location isEqual:@"query"]
          && ![parameter.location isEqual:@"path"]) {
        NSString *warning =
            [NSString stringWithFormat:@"Method %@ param '%@', wasn't a path or query param (%@), treating as query.",
             method.identifier, parameter.sg_name, paramLocation];
        [self addWarning:warning];
      }

    } // Parameters Loop
  } // Methods Loop
}

- (void)adornResource:(GTLRDiscovery_RestResource *)resource
                 name:(NSString *)resourceName
       parentResource:(GTLRDiscovery_RestResource *)parentResource {
  if (resource == nil) return;

  [resource sg_setProperty:resourceName forKey:kNameKey];
  [resource sg_setProperty:[NSValue valueWithNonretainedObject:parentResource]
                    forKey:kWrappedResourceKey];
  [resource sg_setProperty:[NSValue valueWithNonretainedObject:self]
                    forKey:kWrappedGeneratorKey];

  // Sub-resources.
  [self adornResources:resource.resources parentResource:resource];

  // Methods.
  [self adornMethods:resource.methods parentResource:resource];
}

- (void)adornResources:(GTLRObject *)resources
        parentResource:(GTLRDiscovery_RestResource *)parentResource {

  // Schemas could be GTLRDiscovery_RestDescriptionResources or
  // GTLRDiscovery_RestResourceResources.
  for (NSString *resourceName in resources.additionalProperties) {
    GTLRDiscovery_RestResource *resource =
        [resources.additionalProperties objectForKey:resourceName];
    [self adornResource:resource
                   name:resourceName
         parentResource:parentResource];
  }
}

- (void)adornSchema:(GTLRDiscovery_JsonSchema *)schema
               name:(NSString *)schemaName
       parentSchema:(GTLRDiscovery_JsonSchema *)parentSchema {
  if (schema == nil) return;

  [schema sg_setProperty:schemaName forKey:kNameKey];
  [schema sg_setProperty:[NSValue valueWithNonretainedObject:parentSchema]
               forKey:kWrappedSchemaKey];
  [schema sg_setProperty:[NSValue valueWithNonretainedObject:self]
               forKey:kWrappedGeneratorKey];

  [self adornSchemas:schema.properties parentSchema:schema];
  [self adornSchema:schema.items name:@"item" parentSchema:schema];
  [schema.items sg_setProperty:@YES forKey:kIsItemsSchemaKey];

  // If the this schema's name ends in 's', drop it and use it for the
  // name of the subschema.  If the schema had properties, add "additions"
  // to the name to try to make them distinct.
  NSString *worker = schema.sg_name;
  if ([worker hasSuffix:@"s"]) {
    worker = [worker substringToIndex:worker.length - 1];
  }
  if (schema.properties.additionalProperties.count != 0) {
    worker = [worker stringByAppendingString:@"Additions"];
  }

  [self adornSchema:schema.additionalPropertiesProperty
               name:worker
       parentSchema:schema];
}

- (void)adornSchemas:(GTLRObject *)schemas
        parentSchema:(GTLRDiscovery_JsonSchema *)parentSchema {

  // Schemas could be GTLRDiscovery_RestDescriptionSchemas or
  // GTLRDiscovery_JsonSchemaProperties.
  for (NSString *schemaName in schemas.additionalProperties) {
    GTLRDiscovery_JsonSchema *schema =
      [schemas.additionalProperties objectForKey:schemaName];
    [self adornSchema:schema
                 name:schemaName
         parentSchema:parentSchema];
  }
}

#pragma mark - Internal methods

- (BOOL)preflightChecks:(SGGeneratorMessageHandler)messageHandler {
  // Preflight as much as possible so multiple errors can be reported before
  // giving up.

  BOOL allGood = YES;

  if (self.auditJSON) {
    CheckForUnknownJSON(self.api, @[], messageHandler);
  }

  // Check each method...
  for (GTLRDiscovery_RestMethod *method in self.api.sg_allMethods) {
    // ...for media properties that don't line up or aren't what we expect.
    GTLRDiscovery_RestMethod_MediaUpload *mediaUpload = method.mediaUpload;
    BOOL supportsMediaUpload = method.supportsMediaUpload.boolValue;
    BOOL supportsMediaDownload = method.supportsMediaDownload.boolValue;
    BOOL useMediaDownloadService = method.useMediaDownloadService.boolValue;
    if (mediaUpload && !supportsMediaUpload) {
      NSString *str =
        [NSString stringWithFormat:
         @"Method '%@' has mediaUpload info, but supportsMediaUpload is false.",
         method.identifier];
      messageHandler(kSGGeneratorHandlerMessageError, str);
      allGood = NO;
    }
    if (!mediaUpload && supportsMediaUpload) {
      NSString *str =
        [NSString stringWithFormat:
         @"Method '%@' has supportsMediaUpload as true, but no mediaUpload info.",
         method.identifier];
      messageHandler(kSGGeneratorHandlerMessageError, str);
      allGood = NO;
    }
    if (supportsMediaUpload &&
        (mediaUpload.protocols.resumable.path.length == 0)) {
      NSString *str =
        [NSString stringWithFormat:
         @"Method '%@' supports media upload, but doesn't seem to support resumable."
         @" It will be up to the developer to use the right upload method.",
         method.identifier];
      messageHandler(kSGGeneratorHandlerMessageWarning, str);
    }
    GTLRDiscovery_RestMethod_MediaUpload_Protocols_Simple *mediaProtocolSimple =
        mediaUpload.protocols.simple;
    if (supportsMediaUpload &&
        (mediaProtocolSimple.path.length == 0)) {
      NSString *str =
        [NSString stringWithFormat:
         @"Method '%@' supports media upload, but doesn't seem to support simple."
         @" It will be up to the developer to use the right upload method.",
         method.identifier];
      messageHandler(kSGGeneratorHandlerMessageWarning, str);
    }
    if (!supportsMediaDownload && useMediaDownloadService) {
      NSString *str =
        [NSString stringWithFormat:
         @"Method '%@' has supportsMediaDownload as false, but"
         @" useMediaDownloadService as true; what does that mean?",
         method.identifier];
      messageHandler(kSGGeneratorHandlerMessageError, str);
      allGood = NO;
    }

    // ...for entries on parameterOrder that aren't actually parameters on the
    // method.
    NSMutableArray *unknownParams =
      [NSMutableArray arrayWithArray:method.parameterOrder];
    NSArray *allParamNames = [method.parameters.additionalProperties allKeys];
    [unknownParams removeObjectsInArray:allParamNames];
    if (unknownParams.count != 0) {
      NSString *errStr =
        [NSString stringWithFormat:@"Method '%@' has a parameterOrder which includes unknown parameter(s): %@",
         method.identifier, [unknownParams componentsJoinedByString:@", "]];
      messageHandler(kSGGeneratorHandlerMessageError, errStr);
      allGood = NO;
    }
  }  // for (method in self.api.sg_allMethods)

  // Check the toplevel parameters to be sure they are query params (all we
  // expect).
  for (NSString *paramName in self.api.parameters.additionalProperties) {
    GTLRDiscovery_JsonSchema *parameter =
      [self.api.parameters.additionalProperties objectForKey:paramName];
    NSString *paramLocation = parameter.location;
    if (![parameter.location isEqual:@"query"]) {
      NSString *warning =
        [NSString stringWithFormat:@"Common param '%@', wasn't a query param (%@), treating as query.",
         parameter.sg_name, paramLocation];
      messageHandler(kSGGeneratorHandlerMessageWarning, warning);
    }
  } // Parameters Loop

  // Report any features that the generator/library don't currently expect
  // ("dataWrapper" is the only currently know/expected value).
  NSMutableArray *apiFeatures = [self.api.features mutableCopy];
  [apiFeatures removeObject:@"dataWrapper"];
  if (apiFeatures.count > 0) {
    NSString *warning =
      [NSString stringWithFormat:@"Discovery includes unknown feature(s): '%@'",
       [apiFeatures componentsJoinedByString:@"', '"]];
    messageHandler(kSGGeneratorHandlerMessageWarning, warning);
  }

  // https://developers.google.com/discovery/v1/reference/apis#resource (as of
  // July 8, 2016) documents the labels with:
  //   Labels for the status of this API. Valid values include
  //   limited_availability or deprecated.
  // So the label could just be included in the -generatedInfo block, but it
  // isn't clear how useful they really are. A lot of apis currently seem to
  // include "limited_availability"; but their docs don't say anything about
  // them really being limited. So to avoid general "noise" from useless labels
  // we filter out the ones that seem useless, and generate warnings for
  // anything that isn't expected to call it out to the person generating the
  // api.
  NSMutableArray *apiLabels = [self.api.labels mutableCopy];
  [apiLabels removeObject:@"limited_availability"];
  // "labs" isn't documented, but also seems useless when looking at the docs
  // for apis with them.
  [apiLabels removeObject:@"labs"];
  if (apiLabels.count > 0) {
    // TODO(tvl): If some api does include "deprecated", it likely makes sense
    // to drop it from here and instead generally report it and tag the source
    // in some way (#warning and/or mark it on the objects from the api).
    NSString *warning =
        [NSString stringWithFormat:@"Discovery includes unknown label(s): '%@'",
            [apiLabels componentsJoinedByString:@"', '"]];
    messageHandler(kSGGeneratorHandlerMessageWarning, warning);
  }

  // Check for class name collisions.
  NSMutableArray *worker = [self.api.sg_topLevelObjectSchemas mutableCopy];
  for (GTLRDiscovery_JsonSchema *schema in self.api.sg_topLevelObjectSchemas) {
    NSArray *kids = schema.sg_childObjectSchemas;
    if (kids.count) {
      [worker addObjectsFromArray:kids];
    }
  }
  NSMutableDictionary *nameToSchema = [[NSMutableDictionary alloc] init];
  for (GTLRDiscovery_JsonSchema *schema in worker) {
    NSString *objcClassName = schema.sg_objcClassName;
    GTLRDiscovery_JsonSchema *previousSchema = [nameToSchema objectForKey:objcClassName];
    if (previousSchema) {
      // Report the previous first as it likely is higher in the chain
      // (especially if it was top level).
      NSString *errStr =
        [NSString stringWithFormat:@"Collision over the class name '%@' (schemas '%@' and '%@')",
         objcClassName,
         previousSchema.sg_fullSchemaName, schema.sg_fullSchemaName];
      messageHandler(kSGGeneratorHandlerMessageError, errStr);
      allGood = NO;
    } else {
      [nameToSchema setObject:schema forKey:objcClassName];
    }
  }

  return allGood;
}

- (void)determineOAuth2ScopesNamingMode {
  GTLRDiscovery_RestDescription_Auth_Oauth2_Scopes *oauth2scopes = self.api.auth.oauth2.scopes;

  OAuth2ScopeNamingMode modes[] = {
    kOAuth2ScopeNamingModeShortURL,
    kOAuth2ScopeNamingModeFullURL,
    kOAuth2ScopeNamingModeUseEverything
  };
  int count = sizeof(modes) / sizeof(modes[0]);

  for (int i = 0; i < count; ++i) {
    authScopeNamingMode = modes[i];

    NSMutableSet *names = [NSMutableSet set];
    for (NSString *scope in oauth2scopes.additionalJSONKeys) {
      [names addObject:[self authorizationScopeToConstant:scope]];
    }

    if (names.count == oauth2scopes.additionalJSONKeys.count) {
      // No collisions, we're good.
      return;
    }
  }

  [NSException raise:kFatalGeneration
              format:@"Cannot generated unique names out of the OAuth2 Scopes for this API."];
}

- (NSString *)objcServiceClassName {
  NSString *result = [NSString stringWithFormat:@"%@%@Service",
                      kProjectPrefix, self.formattedAPIName];
  return result;
}

- (NSString *)objcQueryBaseClassName {
  NSString *result = [NSString stringWithFormat:@"%@%@Query",
                      kProjectPrefix, self.formattedAPIName];
  return result;
}

- (NSString *)objcObjectsBaseFileName {
  NSString *result = [NSString stringWithFormat:@"%@%@Objects",
                      kProjectPrefix, self.formattedAPIName];
  return result;
}

- (NSString *)umbrellaHeaderBaseFileName {
  NSString *result = [NSString stringWithFormat:@"%@%@",
                      kProjectPrefix, self.formattedAPIName];
  return result;
}

- (NSString *)headerVersionCheck {
  NSMutableString *result = [NSMutableString string];

  [result appendFormat:@"#if GTLR_RUNTIME_VERSION != %d\n", (int)GTLR_RUNTIME_VERSION];
  [result appendFormat:@"#error This file was generated by a different version of ServiceGenerator which is incompatible with this %@ library source.\n",
   kProjectPrefix];
  [result appendString:@"#endif\n"];

  return result;
}

// Generates the service class header body.
- (NSString *)serviceHeader {
  NSMutableArray *parts = [NSMutableArray array];

  [parts addObject:[self generatedInfo]];

  NSString *importServiceBase = [self frameworkImport:kServiceBaseClass];
  [parts addObject:importServiceBase];

  NSString *versionCheck = [self headerVersionCheck];
  [parts addObject:versionCheck];

  [parts addObject:kSuppressDocumentationWarningsBegin];

  [parts addObject:@"NS_ASSUME_NONNULL_BEGIN\n"];

  NSArray *scopesConstants =
    [self oauth2ScopesConstantsBlocksForMode:kGenerateInterface];
  if (scopesConstants) {
    [parts addObjectsFromArray:scopesConstants];

    NSMutableString *classHeader = [NSMutableString string];
    [classHeader appendString:@"// ----------------------------------------------------------------------------\n"];
    [classHeader appendFormat:@"//   %@\n", self.objcServiceClassName];
    [classHeader appendString:@"//\n"];
    [parts addObject:classHeader];
  }

  SGHeaderDoc *hd = [[SGHeaderDoc alloc] init];
  [hd appendFormat:@"Service for executing %@ queries.", self.api.title];
  NSString *serviceDescription = self.api.descriptionProperty;
  if (serviceDescription.length > 0) {
    [hd appendBlankLine];
    [hd append:serviceDescription];
  }
  NSMutableString *interfaceDecl = [NSMutableString string];
  [interfaceDecl appendString:hd.string];
  [interfaceDecl appendFormat:@"@interface %@ : %@\n", self.objcServiceClassName, kServiceBaseClass];
  [parts addObject:interfaceDecl];

  // No custom methods, it just overrides base methods.  Include a usage
  // message.
  [parts addObject:@"// No new methods\n"];
  NSMutableString *usageStr = [NSMutableString string];
  NSString *usagePreamble =
    [NSString stringWithFormat:
     @"Clients should create a standard query with any of the class methods in "
     @"%@.h.  The query can the be sent with %@'s execute methods,",
     self.objcQueryBaseClassName, kServiceBaseClass];
  [usageStr sg_appendWrappedLinesFromString:usagePreamble linePrefix:@"// "];
  NSString *kUsageRest =
    @"//\n"
    @"//   - (GTLRServiceTicket *)executeQuery:(GTLRQuery *)query\n"
    @"//                     completionHandler:(void (^)(GTLRServiceTicket *ticket,\n"
    @"//                                                 id object, NSError *error))handler;\n"
    @"// or\n"
    @"//   - (GTLRServiceTicket *)executeQuery:(GTLRQuery *)query\n"
    @"//                              delegate:(id)delegate\n"
    @"//                     didFinishSelector:(SEL)finishedSelector;\n"
    @"//\n"
    @"// where finishedSelector has a signature of:\n"
    @"//\n"
    @"//   - (void)serviceTicket:(GTLRServiceTicket *)ticket\n"
    @"//      finishedWithObject:(id)object\n"
    @"//                   error:(NSError *)error;\n"
    @"//\n"
    @"// The object passed to the completion handler or delegate method\n"
    @"// is a subclass of GTLRObject, determined by the query method executed.\n";
  [usageStr appendString:kUsageRest];
  [parts addObject:usageStr];

  [parts addObject:@"@end\n"];

  [parts addObject:@"NS_ASSUME_NONNULL_END\n"];

  [parts addObject:kSuppressDocumentationWarningsEnd];

  return [parts componentsJoinedByString:@"\n"];
}

// Generates the service class source body.
- (NSString *)serviceSource {
  NSMutableArray *parts = [NSMutableArray array];

  [parts addObject:[self generatedInfo]];

  [parts addObject:[self implementationHeaderImport:self.umbrellaHeaderBaseFileName]];

  NSArray *scopesConstants =
    [self oauth2ScopesConstantsBlocksForMode:kGenerateImplementation];
  if (scopesConstants) {
    [parts addObjectsFromArray:scopesConstants];

    NSMutableString *classHeader = [NSMutableString string];
    [classHeader appendString:@"// ----------------------------------------------------------------------------\n"];
    [classHeader appendFormat:@"//   %@\n", self.objcServiceClassName];
    [classHeader appendString:@"//\n"];
    [parts addObject:classHeader];
}

  NSString *interfaceDecl = [NSString stringWithFormat:@"@implementation %@\n",
                             self.objcServiceClassName];
  [parts addObject:interfaceDecl];

  NSString *rootURLString = [self.api sg_cleanedRootURLString];
  NSString *servicePath = self.api.servicePath;
  NSString *batchPath = self.api.batchPath;

  // Ensure some of these end with slashes and don't start with slashes since
  // they all get concatenated together. There is also a fixup in
  // -generateQueryClassesForMode:.
  if ((rootURLString.length > 0) && ![rootURLString hasSuffix:@"/"]) {
    rootURLString = [rootURLString stringByAppendingString:@"/"];
    [self addWarning:@"API 'rootUrl' didn't end in '/', adding it."];
  }
  while ([servicePath hasPrefix:@"/"]) {
    servicePath = [servicePath substringFromIndex:1];
    [self addWarning:@"API 'servicePath' started with '/', removing it."];
  }
  if ((servicePath.length > 0) && ![servicePath hasSuffix:@"/"]) {
    servicePath = [servicePath stringByAppendingString:@"/"];
    [self addWarning:@"API 'servicePath' didn't end in '/', adding it."];
  }
  while ([batchPath hasPrefix:@"/"]) {
    [self addWarning:@"API 'batchPath' started with '/', removing it."];
    batchPath = [batchPath substringFromIndex:1];
  }

  NSString *resumableUploadPath = self.api.sg_resumableUploadPath;
  NSString *simpleUploadPath = self.api.sg_simpleUploadPath;

  // Provide -init to set the default values.
  NSMutableString *initMethod = [NSMutableString string];
  [initMethod appendString:@"- (instancetype)init {\n"];
  [initMethod appendString:@"  self = [super init];\n"];
  [initMethod appendString:@"  if (self) {\n"];
  if ((rootURLString.length > 0) || (servicePath.length > 0) ||
      (resumableUploadPath.length > 0) || (simpleUploadPath.length > 0) ||
      (batchPath.length > 0)) {
    [initMethod appendString:@"    // From discovery.\n"];
    if (rootURLString.length) {
      [initMethod appendFormat:@"    self.rootURLString = @\"%@\";\n", rootURLString];
    }
    if (servicePath.length) {
      [initMethod appendFormat:@"    self.servicePath = @\"%@\";\n", servicePath];
    }
    if (resumableUploadPath.length) {
      [initMethod appendFormat:@"    self.resumableUploadPath = @\"%@\";\n", resumableUploadPath];
    }
    if (simpleUploadPath.length) {
      [initMethod appendFormat:@"    self.simpleUploadPath = @\"%@\";\n", simpleUploadPath];
    }
    if (batchPath.length) {
      [initMethod appendFormat:@"    self.batchPath = @\"%@\";\n", batchPath];
    }
  }
  NSArray *prettyPrintParams = [self apiPrettyPrintQueryParamNames];
  if (prettyPrintParams.count > 0) {
    [initMethod appendFormat:@"    self.prettyPrintQueryParameterNames = @[ @\"%@\" ];\n",
     [prettyPrintParams componentsJoinedByString:@"\", @\""]];
  }
  if ([self.api.features containsObject:@"dataWrapper"]) {
    [initMethod appendString:@"\n"];
    [initMethod appendString:@"    // This service uses the 'data' wrapper on results.\n"];
    [initMethod appendString:@"    self.dataWrapperRequired = YES;\n"];
  }
  [initMethod appendString:@"  }\n"];
  [initMethod appendString:@"  return self;\n"];
  [initMethod appendString:@"}\n"];
  [parts addObject:initMethod];

  // Build up the kind mappings.
  NSMutableDictionary *kindMap = [NSMutableDictionary dictionary];
  NSMutableDictionary *overloadedKindMap = [NSMutableDictionary dictionary];
  for (GTLRDiscovery_JsonSchema *schema in self.api.sg_allSchemas) {
    NSString *kindToRegister = schema.sg_kindToRegister;
    if (!kindToRegister) continue;

    // Some services end up with >1 class using the same kind string. So there
    // is no way to make a registry for that.
    GTLRDiscovery_JsonSchema *otherSchema = [kindMap objectForKey:kindToRegister];
    if (otherSchema) {
      NSMutableArray *worker = [overloadedKindMap objectForKey:kindToRegister];
      if (!worker) {
        worker = [NSMutableArray arrayWithObject:otherSchema];
        [overloadedKindMap setObject:worker forKey:kindToRegister];
      }
      [worker addObject:schema];
      continue;
    }
    [kindMap setObject:schema forKey:kindToRegister];
  }
  if (kindMap.count) {
    NSMutableString *kindMappingsMethod = [NSMutableString string];
    if (kindMap.count == overloadedKindMap.count) {
      NSString *rawComment =
        @"Not generating a +kindMappings method to register the kind strings"
        @" because they are not unique per class.";
      [kindMappingsMethod sg_appendWrappedLinesFromString:rawComment
                                               linePrefix:@"// "];

      NSArray *sortedKinds =
        [overloadedKindMap.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
      for (NSString *kind in sortedKinds) {
        NSArray *overloadedSchema = [overloadedKindMap objectForKey:kind];
        NSArray *classNames = [overloadedSchema valueForKey:@"sg_objcClassName"];
        NSArray *sortedClassNames =
          [classNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [kindMappingsMethod appendFormat:@"    //   \"%@\"\n", kind];
        for (NSString *className in sortedClassNames) {
          [kindMappingsMethod appendFormat:@"    //     %@\n", className];
        }
      }
    } else {
      [kindMappingsMethod appendString:@"+ (NSDictionary<NSString *, Class> *)kindStringToClassMap {\n"];
      [kindMappingsMethod appendString:@"  return @{\n"];
      NSArray *schemaSortedByKind = DictionaryObjectsSortedByKeys(kindMap);
      for (GTLRDiscovery_JsonSchema *schema in schemaSortedByKind) {
        NSString *kind = schema.sg_kindToRegister;
        if ([overloadedKindMap objectForKey:kind] == nil) {
          [kindMappingsMethod appendFormat:@"    @\"%@\" : [%@ class],\n", kind, schema.sg_objcClassName];
        } else {
          NSArray *overloadedSchema = [overloadedKindMap objectForKey:kind];
          NSArray *classNames = [overloadedSchema valueForKey:@"sg_objcClassName"];
          NSArray *sortedClassNames =
            [classNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
          [kindMappingsMethod appendFormat:@"    // Skipping \"%@\", was used on multiple classes:\n", kind];
          for (NSString *className in sortedClassNames) {
            [kindMappingsMethod appendFormat:@"    //     %@\n", className];
          }

          NSArray *schemaNames = [overloadedSchema valueForKey:@"sg_fullSchemaName"];
          NSString *warning =
            [NSString stringWithFormat:@"Won't add the kind '%@' to the kind registry: it is used on multiple schema: %@",
             kind, [schemaNames componentsJoinedByString:@", "]];
          [self addWarning:warning];
        }
      }
      [kindMappingsMethod appendString:@"  };\n"];
      [kindMappingsMethod appendString:@"}\n"];

    }
    if (kindMappingsMethod.length > 0) {
      [parts addObject:kindMappingsMethod];
    }
  }

  [parts addObject:@"@end\n"];

  return [parts componentsJoinedByString:@"\n"];
}

// Generates the service's query header body.
- (NSString *)queryHeader {
  NSMutableArray *parts = [NSMutableArray array];

  [parts addObject:[self generatedInfo]];

  NSString *importQueryBase = [self frameworkImport:kQueryBaseClass];
  [parts addObject:importQueryBase];

  NSString *versionCheck = [self headerVersionCheck];
  [parts addObject:versionCheck];

  // See if any types from the Objects file are needed for the Query signatures.
  if (self.api.sg_allMethodObjectParameterReferences.count > 0) {
    NSString *objectsImport =
      [NSMutableString stringWithFormat:@"#import \"%@.h\"\n",
       self.objcObjectsBaseFileName];
    [parts addObject:objectsImport];
  }

  [parts addObject:kSuppressDocumentationWarningsBegin];

  [parts addObject:@"NS_ASSUME_NONNULL_BEGIN\n"];

  NSString *commentExtra = @"For some of the query classes' properties below.";
  NSArray *blocks = [self constantsBlocksForMode:kGenerateInterface
                                        enumsMap:self.api.sg_queryEnumsMap
                                    commentExtra:commentExtra];
  if (blocks) {
    [parts addObjectsFromArray:blocks];

    NSMutableString *header = [NSMutableString string];
    [header appendString:@"// ----------------------------------------------------------------------------\n"];
    [header appendString:@"// Query Classes\n"];
    [header appendString:@"//\n"];
    [parts addObject:header];
  }

  NSString *queryClassStr = [self generateQueryClassesForMode:kGenerateInterface];
  [parts addObject:queryClassStr];

  [parts addObject:@"NS_ASSUME_NONNULL_END\n"];

  [parts addObject:kSuppressDocumentationWarningsEnd];

  return [parts componentsJoinedByString:@"\n"];
}

// Generates the service's query header body.
- (NSString *)querySource {
  NSMutableArray *parts = [NSMutableArray array];

  [parts addObject:[self generatedInfo]];

  [parts addObject:[self implementationHeaderImport:self.objcQueryBaseClassName]];

  // If the header didn't need to import the Objects header for some parameters,
  // then it needs to be imported for the classes for expectedObjectType.
  if (self.api.sg_allMethodObjectParameterReferences.count == 0) {
    for (GTLRDiscovery_RestMethod *method in self.api.sg_allMethods) {
      GTLRDiscovery_JsonSchema *returnsSchema = method.response.sg_resolvedSchema;
      if (returnsSchema) {
        [parts addObject:[self implementationHeaderImport:self.objcObjectsBaseFileName]];
        break;
      }
    }
  }

  NSArray *blocks = [self constantsBlocksForMode:kGenerateImplementation
                                        enumsMap:self.api.sg_queryEnumsMap
                                    commentExtra:nil];
  if (blocks) {
    [parts addObjectsFromArray:blocks];

    NSMutableString *header = [NSMutableString string];
    [header appendString:@"// ----------------------------------------------------------------------------\n"];
    [header appendString:@"// Query Classes\n"];
    [header appendString:@"//\n"];
    [parts addObject:header];
  }

  BOOL hasDeprecatedMethod = self.api.sg_hasDeprecatedMethod;
  if (hasDeprecatedMethod) {
    [parts addObject:
     @"#pragma clang diagnostic push\n"
     @"#pragma clang diagnostic ignored \"-Wdeprecated-implementations\"\n"];
  }

  NSString *queryClassStr = [self generateQueryClassesForMode:kGenerateImplementation];
  [parts addObject:queryClassStr];

  if (hasDeprecatedMethod) {
    [parts addObject:@"#pragma clang diagnostic pop\n"];
  }

  return [parts componentsJoinedByString:@"\n"];
}

- (NSString *)objectsHeader {
  NSMutableArray *parts = [NSMutableArray array];

  [parts addObject:[self generatedInfo]];

  NSString *importObjectBase = [self frameworkImport:kBaseObjectClass];
  [parts addObject:importObjectBase];

  NSString *versionCheck = [self headerVersionCheck];
  [parts addObject:versionCheck];

  // Forward-declare the classes needed by the schemas so they can reference
  // each other (i.e.-tree structures, etc.)
  NSMutableSet *allNeededClasses = [NSMutableSet set];
  for (GTLRDiscovery_JsonSchema *schema in self.api.sg_topLevelObjectSchemas) {
    NSSet *neededClasses = [self neededClassesForSchema:schema];
    [allNeededClasses unionSet:neededClasses];
    for (GTLRDiscovery_JsonSchema *subSchema in schema.sg_childObjectSchemas) {
      neededClasses = [self neededClassesForSchema:subSchema];
      [allNeededClasses unionSet:neededClasses];
    }
  }
  if (allNeededClasses.count > 0) {
    NSArray *sortedAllNeededClasses =
      [[allNeededClasses allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *subParts = [NSMutableArray array];
    for (NSString *className in sortedAllNeededClasses) {
      NSString *aLine = [NSString stringWithFormat:@"@class %@;\n", className];
      [subParts addObject:aLine];
    }
    [parts addObject:[subParts componentsJoinedByString:@""]];
  }

  [parts addObject:kSuppressDocumentationWarningsBegin];

  [parts addObject:@"NS_ASSUME_NONNULL_BEGIN\n"];

  NSString *commentExtra = @"For some of the classes' properties below.";
  NSArray *blocks = [self constantsBlocksForMode:kGenerateInterface
                                        enumsMap:self.api.sg_objectEnumsMap
                                    commentExtra:commentExtra];
  if (blocks) {
    [parts addObjectsFromArray:blocks];
  }

  NSMutableArray *classParts = [NSMutableArray array];

  for (GTLRDiscovery_JsonSchema *schema in self.api.sg_topLevelObjectSchemas) {
    // Main schema.
    NSString *objectClassStr = [self generateObjectClassForSchema:schema
                                                          forMode:kGenerateInterface];
    [classParts addObject:objectClassStr];

    // Child schema.
    for (GTLRDiscovery_JsonSchema *subSchema in schema.sg_childObjectSchemas) {
      NSString *subObjectClassStr = [self generateObjectClassForSchema:subSchema
                                                               forMode:kGenerateInterface];
      [classParts addObject:subObjectClassStr];
    }
  }

  // Two blank lines between classes.
  [parts addObject:[classParts componentsJoinedByString:@"\n\n"]];

  [parts addObject:@"NS_ASSUME_NONNULL_END\n"];

  [parts addObject:kSuppressDocumentationWarningsEnd];

  return [parts componentsJoinedByString:@"\n"];
}

- (NSString *)objectsSource {
  NSMutableArray *parts = [NSMutableArray array];

  [parts addObject:[self generatedInfo]];

  [parts addObject:[self implementationHeaderImport:self.objcObjectsBaseFileName]];

  NSArray *blocks = [self constantsBlocksForMode:kGenerateImplementation
                                        enumsMap:self.api.sg_objectEnumsMap
                                    commentExtra:nil];
  if (blocks) {
    [parts addObjectsFromArray:blocks];
  }

  NSMutableArray *classParts = [NSMutableArray array];
  for (GTLRDiscovery_JsonSchema *schema in self.api.sg_topLevelObjectSchemas) {
    NSString *objectClassStr = [self generateObjectClassForSchema:schema
                                                          forMode:kGenerateImplementation];
    [classParts addObject:objectClassStr];
    for (GTLRDiscovery_JsonSchema *subSchema in schema.sg_childObjectSchemas) {
      NSString *subObjectClassStr = [self generateObjectClassForSchema:subSchema
                                                               forMode:kGenerateImplementation];
      [classParts addObject:subObjectClassStr];
    }
  }

  // Two blank lines between classes.
  [parts addObject:[classParts componentsJoinedByString:@"\n\n"]];

  return [parts componentsJoinedByString:@"\n"];
}

- (NSString *)umbrellaHeader {
  NSMutableArray *parts = [NSMutableArray array];

  [parts addObject:[self generatedInfo]];

  NSMutableString *apiImports = [NSMutableString string];
  [apiImports appendFormat:@"#import \"%@.h\"\n", self.objcObjectsBaseFileName];
  [apiImports appendFormat:@"#import \"%@.h\"\n", self.objcQueryBaseClassName];
  [apiImports appendFormat:@"#import \"%@.h\"\n", self.objcServiceClassName];
  [parts addObject:apiImports];

  NSString *result = [parts componentsJoinedByString:@"\n"];
  return result;
}

// Generates the summary info for any file off this service.
- (NSString *)generatedInfo {
  NSMutableArray *generatedInfo = [NSMutableArray array];

  [generatedInfo addObject:@"// NOTE: This file was generated by the ServiceGenerator.\n"];
  [generatedInfo addObject:@"\n"];
  [generatedInfo addObject:@"// ----------------------------------------------------------------------------\n"];
  [generatedInfo addObject:@"// API:\n"];
  NSString *serviceLine = nil;
  if (self.api.title.length > 0) {
    serviceLine = [NSString stringWithFormat:@"//   %@ (%@/%@)\n",
                   self.api.title,
                   self.api.name,
                   self.api.version];
  } else {
    serviceLine = [NSString stringWithFormat:@"//   %@/%@\n",
                   self.api.name,
                   self.api.version];
  }
  [generatedInfo addObject:serviceLine];

  NSString *serviceDescription = self.api.descriptionProperty;
  if (serviceDescription.length > 0) {
    [generatedInfo addObject:@"// Description:\n"];
    [generatedInfo sg_addStringOfWrappedLinesFromString:serviceDescription
                                             linePrefix:@"//   "];
  }
  NSString *serviceDocsLink = self.api.documentationLink;
  if (serviceDocsLink.length > 0) {
    [generatedInfo addObject:@"// Documentation:\n"];
    NSString *linkLine =
      [NSString stringWithFormat:@"//   %@\n", serviceDocsLink];
    [generatedInfo addObject:linkLine];
  }

  NSString *result = [generatedInfo componentsJoinedByString:@""];
  return result;
}

// Append "_param" to any name used as a local variable when generating the
// query method implementation to avoid duplication variables.
static NSString *MappedParamImplName(NSString *name) {
  NSString *result = name;

  if ([name isEqual:@"object"] ||
      [name isEqual:@"pathURITemplate"] ||
      [name isEqual:@"pathParams"] ||
      [name isEqual:@"query"] ||
      [name isEqual:@"uploadParameters"]) {
    result = [name stringByAppendingString:@"_param"];
  }

  return result;
}

// Append "_param" to any name used as a parameter when generating the
// query method interface to avoid duplication variables.
static NSString *MappedParamInterfaceName(NSString *name, BOOL takesObject, BOOL takesUploadParams) {
  NSString *result = name;

  if ((takesObject && [name isEqual:@"object"]) ||
      (takesUploadParams && [name isEqual:@"uploadParameters"])) {
    result = [name stringByAppendingString:@"_param"];
  }

  return result;
}

- (NSString *)generateQueryPropertyBlock:(NSArray *)paramSchema
                                    mode:(GeneratorMode)mode {
  NSMutableArray *parts = [NSMutableArray array];

  if (mode == kGenerateInterface) {
    for (GTLRDiscovery_JsonSchema *param in paramSchema) {
      // Blank line between properties.
      if (parts.count > 0) {
        [parts addObject:@"\n"];
      }

      SGHeaderDoc *hd = [[SGHeaderDoc alloc] initWithAutoOneLine:YES];
      NSString *paramObjCName = param.sg_objcName;

      [hd append:param.descriptionProperty];
      if (hd.isEmpty) {
        // If there was no description, queue the name for any other comments.
        [hd queueAppend:paramObjCName];
      }

      // We don't use the enumMap because we merged common keys there, here we
      // we want the specific values for this parameter (and their specific
      // descriptions).
      NSArray *enumProperty = param.enumProperty;
      if (enumProperty.count > 0) {
        [hd appendBlankLine];
        [hd append:@"Likely values:"];
        NSArray *enumDescriptions = param.enumDescriptions;
        for (NSUInteger i = 0; i < enumProperty.count; ++i) {
          NSString *value = enumProperty[i];
          NSString *desc = (i < enumDescriptions.count ? enumDescriptions[i] : nil);
          NSString *name = [param sg_constantNamed:value];
          if (desc.length > 0) {
            [hd appendArg:name
                   format:@"%@ (Value: \"%@\")", desc, value];
          } else {
            [hd appendArg:name
                   format:@"Value \"%@\"", value];
          }
        }
      }

      NSString *paramRange = param.sg_formattedRange;
      NSString *paramDefault = param.sg_formattedDefault;
      BOOL hasRange = (paramRange.length > 0);
      BOOL hasDefault = (paramDefault.length > 0);
      if (hasRange || hasDefault) {
        [hd appendBlankLine];
        if (hasRange && hasDefault) {
          [hd appendNoteFormat:@"If not set, the documented server-side default will be %@ (from the range %@).",
           paramDefault, paramRange];
        } else if (hasRange) {
          [hd appendNoteFormat:@"The documented range is %@.", paramRange];
        } else if (hasDefault) {
          [hd appendNoteFormat:@"If not set, the documented server-side default will be %@.",
           paramDefault];
        }
      }

      // If the ObjC name of a parameter was forced, include any comment
      // about that in the header with the @property declaration.
      NSString *forceObjCNameComment = param.sg_forceNameComment;
      if (forceObjCNameComment.length > 0) {
        [hd appendBlankLine];
        [hd append:forceObjCNameComment];
      }

      NSString *objcType = nil, *objcPropertySemantics = nil;
      NSString *comment = nil;
      BOOL asPtr = NO;
      [param sg_getQueryParamObjCType:&objcType
                            asPointer:&asPtr
                objcPropertySemantics:&objcPropertySemantics
                              comment:&comment
                       itemsClassName:NULL];
      if (comment.length > 0) {
        [hd appendBlankLine];
        [hd append:comment];
      }
      NSString *extraAttributes = @"";
      if (asPtr || [objcType isEqual:@"id"]) {
        extraAttributes =
          [extraAttributes stringByAppendingFormat:@", nullable"];
      }
      if ([_useCustomerGetterPredicate evaluateWithObject:paramObjCName]) {
        extraAttributes =
          [extraAttributes stringByAppendingFormat:@", getter=valueOf_%@", paramObjCName];
      }
      NSString *maybeDeprecated = param.deprecated.boolValue ? kDeprecatedSuffix : @"";
      NSString *clangDirective = @"";
      if ((asPtr || [objcType isEqual:@"id"])
          && [_notRetainedPredicate evaluateWithObject:paramObjCName]) {
        clangDirective = @" NS_RETURNS_NOT_RETAINED";
      }
      NSString *propertyLine = [NSString stringWithFormat:@"@property(nonatomic, %@%@) %@%@%@%@%@;\n",
                                  objcPropertySemantics, extraAttributes, objcType,
                                (asPtr ? @" *" : @" "),
                                paramObjCName,
                                maybeDeprecated,
                                clangDirective];
      if (hd.hasText) {
        [parts addObject:hd.string];
      }
      [parts addObject:propertyLine];
    }  // for (param in paramSchema)

  } else {
    if (paramSchema.count > 0) {
      NSArray *paramsObjCNames = [paramSchema valueForKey:@"sg_objcName"];
      NSString *asLines = [SGUtils stringOfLinesFromStrings:paramsObjCNames
                                            firstLinePrefix:@"@dynamic "
                                           extraLinesPrefix:@"         "
                                                linesSuffix:@","
                                             lastLineSuffix:@";"
                                              elementJoiner:@", "];
      [parts addObject:asLines];
    }
  }

  if (mode == kGenerateImplementation) {

    // Keep a mapping for ObjC names to "wire" names for parameters that
    // had invalid characters.
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    for (GTLRDiscovery_JsonSchema *param in paramSchema) {
      if (![param.sg_name isEqual:param.sg_objcName]) {
        [pairs setObject:param.sg_name forKey:param.sg_objcName];
      }
    }
    if (pairs.count != 0) {
      NSString *methodImpl = [SGUtils classMapForMethodNamed:@"parameterNameMap"
                                                       pairs:pairs
                                                 quoteValues:YES
                                                valueTypeStr:@"NSString *"];
      [parts addObject:@"\n"];
      [parts addObject:methodImpl];
    }

    // For all repeated parameters, provide a mapping to the default class
    // contained within the array.
    [pairs removeAllObjects];
    for (GTLRDiscovery_JsonSchema *param in paramSchema) {
      // TODO: see the note in buildParameterLists: about how there could
      // be arrays that don't make it into the uniqueParameters list.
      if (param.repeated || [param.type isEqual:@"array"]) {
        NSString *objcType = nil;
        NSString *itemsClassName = nil;
        [param sg_getQueryParamObjCType:&objcType
                              asPointer:NULL
                  objcPropertySemantics:NULL
                                comment:NULL
                         itemsClassName:&itemsClassName];
        if ([itemsClassName isEqual:@"id"]) {
          itemsClassName = @"NSObject";
        }
        NSString *getClassStr =
          [NSString stringWithFormat:@"[%@ class]", itemsClassName];
        [pairs setObject:getClassStr forKey:param.sg_name];
      }
    }
    if (pairs.count != 0) {
      NSString *methodImpl = [SGUtils classMapForMethodNamed:@"arrayPropertyToClassMap"
                                                       pairs:pairs
                                                 quoteValues:NO
                                                valueTypeStr:@"Class"];
      [parts addObject:@"\n"];
      [parts addObject:methodImpl];
    }

  }

  return [parts componentsJoinedByString:@""];
}

- (NSString *)objcQueryClassName:(GTLRDiscovery_RestMethod *)method {
  NSMutableArray *segments = [NSMutableArray array];
  // Add the resources infront of the name.
  NSString *formatted =
      [SGUtils objcName:method.sg_name shouldCapitalize:YES];
  [segments addObject:formatted];
  GTLRDiscovery_RestResource *resource =
      [[method sg_propertyForKey:kWrappedResourceKey] nonretainedObjectValue];
  while (resource != nil) {
    formatted = [SGUtils objcName:resource.sg_name shouldCapitalize:YES];
    [segments insertObject:formatted atIndex:0];
    resource =
        [[resource sg_propertyForKey:kWrappedResourceKey] nonretainedObjectValue];
  }
  NSString *result = [NSString stringWithFormat:@"%@%@Query_%@",
                      kProjectPrefix, self.formattedAPIName,
                      [segments componentsJoinedByString:@""]];
  return result;
}

- (NSArray *)queryCommonParams {
  NSArray *result = [self.api sg_propertyForKey:kCommonQueryParamsKey];
  if (result) {
    return result;
  }

  // Common parameters are listed at the service level; they apply to all
  // methods.  However, there are some that come back from discovery that
  // don't make sense at the method level for the GTLR library, so we filter
  // those out.
  NSArray *commonParamsToSkip = @[
    @"$.xgafv",         // Controls the error format (v1/v2). GTLR handles error
                        // parsing/processing, shouldn't be needed.
    @"access_token",    // GTLR handles OAuth at the service level.
    @"alt",             // GTLR only supports JSON
    @"bearer_token",    // GTLR handles OAuth at the service level.
    @"callback",        // JSONP, not needed for a native code client library.
    @"key",             // GTLR handles the API key on the service, per method
                        //   isn't need in the ObjectiveC use case.
    @"oauth_token",     // GTLR handles OAuth at the service level.
    @"pp",              // Alternative name for "prettyPrint".
    @"prettyPrint",     // No needed, GTLR Logging pretty prints.
    @"uploadType",      // Legacy field; upload media type.
    @"upload_protocol", // Upload protocol for media, isn't needed with the
                        //   built in media upload support.
    @"upload_type",     // Legacy field; upload media type.
    @"userIp",          // Not needed for client software, only needed for
                        // servers making request on behalf of lots of users.
    @"quotaUser",       // Another form of userIp.
  ];

  NSArray *allCommonParams =
      DictionaryObjectsSortedByKeys(self.api.parameters.additionalProperties);
  NSMutableArray *commonParams = [NSMutableArray array];
  for (GTLRDiscovery_JsonSchema *param in allCommonParams) {
    if ([commonParamsToSkip containsObject:param.sg_name]) {
      continue;
    }
    if (![param.location isEqual:@"query"]) {
      NSString *warning =
        [NSString stringWithFormat:@"Skipping common parameter '%@', it isn't a 'query' parameter (%@).",
         param.sg_name, param.location];
      [self addWarning:warning];
      continue;
    }
    [commonParams addObject:param];
  }

  result = commonParams;
  [self.api sg_setProperty:result forKey:kCommonQueryParamsKey];
  return result;
}

- (NSArray *)apiPrettyPrintQueryParamNames {
  NSArray *result = [self.api sg_propertyForKey:kCommonPrettyPrintQueryParamsKey];
  if (result) {
    return result;
  }

  NSMutableArray *worker = [NSMutableArray array];

  // The two values used by most Google services.
  NSArray *candidateNames = @[ @"prettyPrint", @"pp" ];

  for (NSString *candidateName in candidateNames) {
    GTLRDiscovery_JsonSchema *param =
      [self.api.parameters additionalPropertyForName:candidateName];
    if (!param) continue;
    if ([param.type isEqual:@"boolean"] &&
        [param.location isEqual:@"query"]) {
      [worker addObject:param.sg_name];
    } else {
      NSString *warning =
        [NSString stringWithFormat:@"Common parameter '%@' does not appear to be a \"pretty print\" parameter (type='%@', location='%@').",
         param.sg_name, param.type, param.location];
      [self addWarning:warning];
    }
  }

  result = worker;
  [self.api sg_setProperty:result forKey:kCommonPrettyPrintQueryParamsKey];
  return result;
}

// Generates the actual interface/implementation of a query classes for the
// given service resource.
- (NSString *)generateQueryClassesForMode:(GeneratorMode)mode {
  NSMutableArray *parts = [NSMutableArray array];

  NSString *atBlock;
  if (mode == kGenerateInterface) {
    SGHeaderDoc *hd = [[SGHeaderDoc alloc] init];
    // api.title tends to look a little odd here because it includes "API" a
    // lot of the time.
    NSString *apiName = self.api.canonicalName;
    if (apiName.length == 0) {
      apiName = self.formattedAPIName;
    }
    [hd appendFormat:@"Parent class for other %@ query classes.", apiName];
    NSMutableString *builder = [NSMutableString string];
    [builder appendString:hd.string];
    [builder appendFormat:@"@interface %@ : %@\n", self.objcQueryBaseClassName, kQueryBaseClass];
    atBlock = builder;
  } else {
    atBlock = [NSString stringWithFormat:@"@implementation %@\n",
               self.objcQueryBaseClassName];
  }
  [parts addObject:atBlock];

  NSArray *commonParams = [self queryCommonParams];
  NSString *paramsBlock = [self generateQueryPropertyBlock:commonParams
                                                      mode:mode];
  if (paramsBlock.length) {
    [parts addObject:paramsBlock];
  }

  // Close the base query.
  [parts addObject:@"@end\n"];

  // Loop over all the query methods.
  for (GTLRDiscovery_RestMethod *method in self.api.sg_allMethods) {
    BOOL supportsMediaUpload = method.supportsMediaUpload.boolValue;
    BOOL supportsMediaDownload = method.supportsMediaDownload.boolValue;
    GTLRDiscovery_JsonSchema *returnsSchema = method.response.sg_resolvedSchema;

    NSString *queryClassName = [self objcQueryClassName:method];

    if (mode == kGenerateInterface) {
      SGHeaderDoc *classHDoc = [[SGHeaderDoc alloc] init];
      [classHDoc append:method.descriptionProperty];
      if (classHDoc.isEmpty) {
        // If there was no description, fall back to the class name.
        [classHDoc append:queryClassName];
      }

      [classHDoc appendBlankLine];
      [classHDoc appendUnwrappedFormat:@"Method: %@", method.identifier];

      NSArray *authScopes = method.scopes;
      if (authScopes.count > 0) {
        [classHDoc appendBlankLine];
        [classHDoc append:@"Authorization scope(s):"];
        NSMutableArray *scopeConstants =
          [NSMutableArray arrayWithCapacity:authScopes.count];
        for (NSString *scope in authScopes) {
          NSString *scopeConstant = [self authorizationScopeToConstant:scope];
          [scopeConstants addObject:scopeConstant];
        }
        NSArray *sortedConstants =
          [scopeConstants sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        for (NSString *scopeConstant in sortedConstants) {
          [classHDoc appendUnwrappedFormat:@"  %@ %@", classHDoc.atC, scopeConstant];
        }
      }

      atBlock = [NSString stringWithFormat:@"%@%@@interface %@ : %@\n",
                 classHDoc.string,
                 (method.deprecated.boolValue ? kDeprecatedWithNewline : @""),
                 queryClassName,
                 self.objcQueryBaseClassName];
    } else {
      atBlock = [NSString stringWithFormat:@"@implementation %@\n", queryClassName];
    }
    [parts addObject:atBlock];

    NSArray *methodParameters = DictionaryObjectsSortedByKeys(method.parameters.additionalProperties);
    paramsBlock = [self generateQueryPropertyBlock:methodParameters
                                              mode:mode];
    if (paramsBlock.length) {
      [parts addObject:paramsBlock];
    }

    SGHeaderDoc *methodHDoc = nil;
    SGHeaderDoc *downloadMethodHDoc = nil;
    if (mode == kGenerateInterface) {
      methodHDoc = [[SGHeaderDoc alloc] init];

      if (returnsSchema) {
        [methodHDoc appendFormat:@"Fetches a %@ %@.",
         methodHDoc.atC, returnsSchema.sg_objcClassName];
      } else {
        [methodHDoc append:
         @"Upon successful completion, the callback's object and error"
         @" parameters will be nil. This query does not fetch an object."];
      }
      if (method.descriptionProperty.length > 0) {
        [methodHDoc appendBlankLine];
        [methodHDoc append:method.descriptionProperty];
      }

      if (supportsMediaDownload) {
        downloadMethodHDoc = [[SGHeaderDoc alloc] init];
        [downloadMethodHDoc appendFormat:
         @"Fetches the requested resource data as a %@ GTLRDataObject.",
         downloadMethodHDoc.atC];
        if (method.descriptionProperty.length > 0) {
          [downloadMethodHDoc appendBlankLine];
          [downloadMethodHDoc append:method.descriptionProperty];
        }
        methodHDoc.shadow = downloadMethodHDoc;
      }
    }

    NSMutableString *methodStr = [NSMutableString string];
    NSMutableString *downloadMethodStr;
    if (supportsMediaDownload) {
      downloadMethodStr = [NSMutableString string];

      // When generating the interface, if the method is marked as supporting
      // media download, but there is no return schema; then it means that there
      // is no "non media" version to just fetch metadata. So drop string used
      // to build the method. The go through all the following code that would
      // generate the interface. This hides the method from the public interface
      // but still lets us generate the method so the ForMedia impl can call it.
      if ((mode == kGenerateInterface) && !returnsSchema) {
        methodStr = nil;
      }
    }

    NSString *initialLine = @"+ (instancetype)query";
    [methodStr appendString:initialLine];
    NSUInteger nameWidth = initialLine.length;
    NSString *downloadInitialLine = @"+ (instancetype)queryForMedia";
    [downloadMethodStr appendString:downloadInitialLine];
    NSUInteger downloadNameWidth = downloadInitialLine.length;
    BOOL needsWith = YES;

    BOOL doesQueryTakeObject = (method.request != nil);
    if (doesQueryTakeObject) {
      GTLRDiscovery_JsonSchema *requestSchema = method.request.sg_resolvedSchema;
      [methodStr appendFormat:@"WithObject:(%@ *)object",
                              requestSchema.sg_objcClassName];
      [downloadMethodStr appendFormat:@"WithObject:(%@ *)object",
                                      requestSchema.sg_objcClassName];
      nameWidth += 10; // 'WithObject'
      downloadNameWidth += 10;
      needsWith = NO;
      [methodHDoc appendBlankLine];
      [methodHDoc appendParam:@"object"
                       format:@"The %@ %@ to include in the query.",
                              methodHDoc.atC, requestSchema.sg_objcClassName];
    }

    BOOL hasPageTokenParam = NO;

    // Add any required parameters.
    BOOL hasRequiredParams = NO;
    for (GTLRDiscovery_JsonSchema *param in method.sg_sortedParameters) {
      NSString *name = param.sg_objcName;
      if ([name isEqual:@"pageToken"]) {
        hasPageTokenParam = YES;
      }
      if (!param.required.boolValue) {
        continue;
      }
      if (param.deprecated.boolValue) {
        NSString *msg =
            [NSString stringWithFormat:@"Method %@ has required param '%@' that is also deprecated, no way to annotate that.",
             method.identifier, param.sg_name];
        [self addInfo:msg];
      }
      hasRequiredParams = YES;
      NSString *objcType = nil;
      BOOL asPtr = NO;
      [param sg_getQueryParamObjCType:&objcType
                            asPointer:&asPtr
                objcPropertySemantics:NULL
                              comment:NULL
                       itemsClassName:NULL];
      if (needsWith) {
        [methodHDoc appendBlankLine];
        NSString *capitalizeObjCName = param.sg_capObjCName;
        [methodStr appendFormat:@"With%@:(%@%@)%@",
         capitalizeObjCName, objcType, (asPtr ? @" *" : @""),
         (mode == kGenerateInterface
          ? MappedParamInterfaceName(name, doesQueryTakeObject, supportsMediaUpload)
          : MappedParamImplName(name))];
        [downloadMethodStr appendFormat:@"With%@:(%@%@)%@",
         capitalizeObjCName, objcType, (asPtr ? @" *" : @""),
         (mode == kGenerateInterface
          ? MappedParamInterfaceName(name, doesQueryTakeObject, supportsMediaUpload)
          : MappedParamImplName(name))];
        nameWidth += 4 + capitalizeObjCName.length; // 'With%@'
        downloadNameWidth += 4 + capitalizeObjCName.length;
        needsWith = NO;
      } else {
        // nameWidth is how much space should be used for the name to align
        // the colons.  If this parameter name is longer than that, it
        // doesn't get aligned.
        [methodStr appendFormat:@"\n%*s:(%@%@)%@",
         (int)nameWidth, name.UTF8String, objcType,
         (asPtr ? @" *" : @""),
         (mode == kGenerateInterface
          ? MappedParamInterfaceName(name, doesQueryTakeObject, supportsMediaUpload)
          : MappedParamImplName(name))];
        [downloadMethodStr appendFormat:@"\n%*s:(%@%@)%@",
         (int)downloadNameWidth, name.UTF8String, objcType,
         (asPtr ? @" *" : @""),
         (mode == kGenerateInterface
          ? MappedParamInterfaceName(name, doesQueryTakeObject, supportsMediaUpload)
          : MappedParamImplName(name))];
      }

      NSString *paramDesc = param.descriptionProperty;
      NSString *paramRangeDesc = param.sg_rangeAndDefaultDescription;
      if (paramRangeDesc.length > 0) {
        if (paramDesc.length > 0) {
          paramDesc =
            [NSString stringWithFormat:@"%@ (%@)", paramDesc, paramRangeDesc];
        } else {
          paramDesc = paramRangeDesc;
        }
      }
      // If no description, just list the type.
      if (paramDesc.length == 0) {
        paramDesc = objcType;
      }
      [methodHDoc appendParam:MappedParamInterfaceName(name, doesQueryTakeObject, supportsMediaUpload)
                       string:paramDesc];

    }  // for (param in method.sg_sortedParameters)

    // Loop back through adding info about the enums for to the descriptions.
    if (hasRequiredParams) {
      for (GTLRDiscovery_JsonSchema *param in method.sg_sortedParameters) {
        if (!param.required.boolValue) {
          continue;
        }

        NSArray *enumProperty = param.enumProperty;
        if (enumProperty.count == 0) {
          continue;
        }

        // We don't use the enumMap because we merged common keys there, here we
        // we want the specific values for this parameter (and their specific
        // descriptions).
        [methodHDoc appendBlankLine];
        [methodHDoc appendFormat:@"Likely values for %@ %@:", methodHDoc.atC, param.sg_objcName];
        NSArray *enumDescriptions = param.enumDescriptions;
        for (NSUInteger i = 0; i < enumProperty.count; ++i) {
          NSString *value = enumProperty[i];
          NSString *desc = (i < enumDescriptions.count ? enumDescriptions[i] : nil);
          NSString *name = [param sg_constantNamed:value];
          if (desc.length > 0) {
            [methodHDoc appendArg:name
                           format:@"%@ (Value: \"%@\")", desc, value];
          } else {
            [methodHDoc appendArg:name
                           format:@"Value \"%@\"", value];
          }
        }
      }  // for (param in method.sg_sortedParameters)
    }  // hasRequiredParams

    if (supportsMediaUpload) {
      NSString *extraAttributes = @"";
      if (mode == kGenerateInterface) {
        extraAttributes = @"nullable ";
      }
      if (needsWith) {
        [methodHDoc appendBlankLine];
        NSString *str =
          [NSString stringWithFormat:@"WithUploadParameters:(%@GTLRUploadParameters *)uploadParameters",
           extraAttributes];
        [methodStr appendString:str];
        [downloadMethodStr appendString:str];
      } else {
        [methodStr appendFormat:@"\n%*s:(%@GTLRUploadParameters *)uploadParameters",
         (int)nameWidth, "uploadParameters", extraAttributes];
        [downloadMethodStr appendFormat:@"\n%*s:(%@GTLRUploadParameters *)uploadParameters",
         (int)downloadNameWidth, "uploadParameters", extraAttributes];
      }

      NSMutableString *paramDesc = [NSMutableString string];
      [paramDesc appendString:@"The media to include in this query."];
      GTLRDiscovery_RestMethod_MediaUpload *mediaUpload = method.mediaUpload;
      if (mediaUpload.maxSize) {
        [paramDesc appendFormat:@" Maximum size %@.", mediaUpload.maxSize];
      }
      if (mediaUpload.accept.count > 0) {
        [paramDesc appendFormat:@" Accepted MIME %@: %@",
         (mediaUpload.accept.count == 1 ? @"type" : @"types"),
         [mediaUpload.accept componentsJoinedByString:@", "]];
      }
      [methodHDoc appendParam:@"uploadParameters" string:paramDesc];
    }

    [methodHDoc appendBlankLine];
    [methodHDoc appendReturns:queryClassName];

    // downloadMethodHDoc no longer needs to shadow as it doesn't need any
    // paging info.
    methodHDoc.shadow = nil;

    if (returnsSchema && hasPageTokenParam) {
      BOOL supportsPagination = NO;
      NSString *resultCollectionItemsKey =
        [returnsSchema sg_collectionItemsKey:&supportsPagination];
      if ((resultCollectionItemsKey.length > 0) && supportsPagination) {
        [methodHDoc appendBlankLine];
        [methodHDoc appendNoteFormat:
         @"Automatic pagination will be done when %@ shouldFetchNextPages is"
         @" enabled. See %@ shouldFetchNextPages on %@ %@ for more"
         @" information.",
         methodHDoc.atC, methodHDoc.atC, methodHDoc.atC, kServiceBaseClass];
      }
    }

    if (mode == kGenerateInterface) {
      // End the line.
      [methodStr appendString:@";\n"];
      [downloadMethodStr appendString:@";\n"];

      if (methodHDoc.hasText) {
        [methodStr insertString:methodHDoc.string atIndex:0];
      }

      if (downloadMethodHDoc.hasText) {
        [downloadMethodStr insertString:downloadMethodHDoc.string atIndex:0];
      }
    } else {
      NSAssert(methodStr,
               @"implementation generation shouldn't swap out methodStr");

      // End the line.
      [methodStr appendString:@" {\n"];

      // Fill in the function.

      // Make sure all required params are provided.
      if (doesQueryTakeObject || hasRequiredParams) {
        NSMutableArray *paramChecks = [NSMutableArray array];
        NSMutableArray *assertLines = [NSMutableArray array];

        if (doesQueryTakeObject) {
          [paramChecks addObject:@"object == nil"];
          [assertLines addObject:@"    NSAssert(object != nil, @\"Got a nil object\");\n"];
        }

        // At this point we used to loop over the requiredParams and make sure
        // repeated ones didn't get empty arrays and that string parameters
        // weren't empty strings.  But the server will return errors for
        // missing/invalid things, so we dropped all client side checks and
        // just let the server enforce everything.

        if (paramChecks.count > 1) {
          // If we'll have a list of checks, put parens on each so they are
          // slightly more readable.
          paramChecks = (NSMutableArray*)[SGUtils wrapStrings:paramChecks
                                                       prefix:@"("
                                                       suffix:@")"];
        }

        if (paramChecks.count > 0) {
          // Now build the multiline "if (..) {"
          NSString *paramCheckStr = [SGUtils stringOfLinesFromStrings:paramChecks
                                                      firstLinePrefix:@"  if ("
                                                     extraLinesPrefix:@"      "
                                                          linesSuffix:@" ||"
                                                       lastLineSuffix:@") {"
                                                        elementJoiner:@" || "];
          [methodStr appendString:paramCheckStr];

          if (assertLines.count) {
            [methodStr appendString:@"#if defined(DEBUG) && DEBUG\n"];
            [methodStr appendString:[assertLines componentsJoinedByString:@""]];
            [methodStr appendString:@"#endif\n"];
          }

          [methodStr appendString:@"    return nil;\n"];
          [methodStr appendString:@"  }\n"];
        }
      }

      // All query parameters get added to the end of the url, but path
      // parameters don't, so runtime needs to know which are path so they
      // don't get auto appended.
      NSMutableArray *pathParamNames = [NSMutableArray array];
      for (GTLRDiscovery_JsonSchema *param in methodParameters) {
        if ([param.location isEqual:@"path"]) {
          [pathParamNames addObject:param.sg_name];
        }
      }

      NSString *httpMethod = method.httpMethod;
      if ([httpMethod caseInsensitiveCompare:@"GET"] != NSOrderedSame) {
        httpMethod = [NSString stringWithFormat:@"@\"%@\"", httpMethod];
      } else {
        httpMethod = @"nil";
      }

      NSString *pathParamsValue;
      if (pathParamNames.count != 0) {
        if (pathParamNames.count == 1) {
          [methodStr appendFormat:@"  NSArray *pathParams = @[ @\"%@\" ];\n",
           pathParamNames[0]];
        } else {
          [methodStr appendString:@"  NSArray *pathParams = @[\n"];
          NSString *pathParamsNamesAsLines = [SGUtils stringOfLinesFromStrings:pathParamNames
                                                               firstLinePrefix:@"    @\""
                                                              extraLinesPrefix:@"    @\""
                                                                   linesSuffix:@"\","
                                                                lastLineSuffix:@"\""
                                                                 elementJoiner:@"\", @\""];
          [methodStr appendString:pathParamsNamesAsLines];
          [methodStr appendString:@"  ];\n"];
        }
        pathParamsValue = @"pathParams";
      } else {
        pathParamsValue = @"nil";
      }

      // Ensure the path doesn't start with a slash so it will work when
      // combined with other parts. There is also fixup in -serviceSource for
      // other items.
      NSString *methodPath = method.path;
      while ([methodPath hasPrefix:@"/"]) {
        methodPath = [methodPath substringFromIndex:1];
        NSString *msg =
          [NSString stringWithFormat:@"Method '%@' had a 'path' that started with '/', removing it.",
           method.identifier];
        [self addWarning:msg];
      }

      [methodStr appendFormat:@"  NSString *pathURITemplate = @\"%@\";\n", methodPath];
      [methodStr appendFormat:@"  %@ *query =\n", [self objcQueryClassName:method]];
      [methodStr appendString:@"    [[self alloc] initWithPathURITemplate:pathURITemplate\n"];
      [methodStr appendFormat:@"                               HTTPMethod:%@\n", httpMethod];
      [methodStr appendFormat:@"                       pathParameterNames:%@];\n", pathParamsValue];

      if (doesQueryTakeObject) {
        [methodStr appendString:@"  query.bodyObject = object;\n"];
      }

      // Handle required params.
      if (hasRequiredParams) {
        for (GTLRDiscovery_JsonSchema *param in method.sg_sortedParameters) {
          if (param.required.boolValue) {
            NSString *name = param.sg_objcName;
            NSString *nameAsValue = MappedParamImplName(name);
            [methodStr appendFormat:@"  query.%@ = %@;\n", name, nameAsValue];
          }
        }
      }

      if (supportsMediaUpload) {
        [methodStr appendString:@"  query.uploadParameters = uploadParameters;\n"];
        NSString *resumableUploadPathOverride = method.sg_resumableUploadPathOverride;
        if (resumableUploadPathOverride.length > 0) {
          [methodStr appendFormat:@"  query.resumableUploadPathURITemplateOverride = \"%@\";\n",
           resumableUploadPathOverride];
        }
        NSString *simpleUploadPathOverride = method.sg_simpleUploadPathOverride;
        if (simpleUploadPathOverride.length > 0) {
          [methodStr appendFormat:@"  query.simpleUploadPathURITemplateOverride = \"%@\";\n",
           simpleUploadPathOverride];
        }
      }

      if (returnsSchema) {
        [methodStr appendFormat:@"  query.expectedObjectClass = [%@ class];\n",
         returnsSchema.sg_objcClassName];
      }

      [methodStr appendFormat:@"  query.loggingName = @\"%@\";\n", method.identifier];
      [methodStr appendString:@"  return query;\n}\n"];
    }

    if (methodStr) {
      [parts addObject:methodStr];
    }

    if ((mode == kGenerateImplementation) && (downloadMethodStr.length > 0)) {
      [downloadMethodStr appendString:@" {\n"];
      [downloadMethodStr appendFormat:@"  %@ *query =\n", [self objcQueryClassName:method]];

      NSString *firstLine = @"    [self query";
      [downloadMethodStr appendString:firstLine];
      nameWidth = firstLine.length;
      needsWith =  YES;

      if (doesQueryTakeObject) {
        [downloadMethodStr appendString:@"WithObject:object"];
        nameWidth += 10; // 'WithObject'
        needsWith = NO;
      }

      if (hasRequiredParams) {
        for (GTLRDiscovery_JsonSchema *param in method.sg_sortedParameters) {
          if (!param.required.boolValue) continue;
          if (needsWith) {
            NSString *capitalizeObjCName = param.sg_capObjCName;
            [downloadMethodStr appendFormat:@"With%@:%@",
             capitalizeObjCName, MappedParamImplName(param.sg_objcName)];
            nameWidth += 4 + capitalizeObjCName.length; // 'With%@'
            needsWith = NO;
          } else {
            NSString *name = param.sg_objcName;
            [downloadMethodStr appendFormat:@"\n%*s:%@",
             (int)nameWidth, name.UTF8String, MappedParamImplName(name)];
          }
        }
      }

      if (supportsMediaUpload) {
        if (needsWith) {
          NSString *str = @"WithUploadParameters:uploadParameters";
          [downloadMethodStr appendString:str];
        } else {
          [downloadMethodStr appendFormat:@"\n%*s:uploadParameters",
           (int)nameWidth, "uploadParameters"];
        }
      }
      [downloadMethodStr appendString:@"];\n"];

      [downloadMethodStr appendString:@"  query.downloadAsDataObjectType = @\"media\";\n"];
      if (method.useMediaDownloadService.boolValue) {
        [downloadMethodStr appendString:@"  query.useMediaDownloadService = YES;\n"];
      }
      [downloadMethodStr appendFormat:@"  query.loggingName = @\"Download %@\";\n", method.identifier];
      [downloadMethodStr appendString:@"  return query;\n}\n"];
    }

    if (downloadMethodStr.length > 0) {
      [parts addObject:downloadMethodStr];
    }

    [parts addObject:@"@end\n"];
  }

  return [parts componentsJoinedByString:@"\n"];
}

- (NSSet *)neededClassesForSchema:(GTLRDiscovery_JsonSchema *)schema {
  NSMutableSet *result = [NSMutableSet set];

  // Any class can have properties that reference another class, this collects
  // the classes needed by the class generated from this schema.

  NSMutableArray *allProperties = [NSMutableArray array];

  NSArray *properties = DictionaryObjectsSortedByKeys(schema.properties.additionalProperties);
  if (properties.count > 0) {
    [allProperties addObjectsFromArray:properties];
  }
  GTLRDiscovery_JsonSchema *property = schema.additionalPropertiesProperty;
  if (property != nil) {
    [allProperties addObject:property];
  }
  property = [schema sg_itemsSchemaResolving:YES depth:NULL];
  if (property != nil) {
    [allProperties addObject:property];
  }

  for (property in allProperties) {
    GTLRDiscovery_JsonSchema *resolvedProperty = property.sg_resolvedSchema;
    if ([resolvedProperty.type isEqual:@"object"]) {
      NSString *className = resolvedProperty.sg_objcClassName;
      [result addObject:className];
    } else if ([resolvedProperty.type isEqual:@"array"]) {
      GTLRDiscovery_JsonSchema *itemProperty =
          [resolvedProperty sg_itemsSchemaResolving:YES depth:NULL];
      if ([itemProperty.type isEqual:@"object"]) {
        NSString *className = itemProperty.sg_objcClassName;
        [result addObject:className];
      }
    }
  }

  return result;
}

- (NSString *)generateObjectClassForSchema:(GTLRDiscovery_JsonSchema *)schema
                                   forMode:(GeneratorMode)mode {
  NSMutableArray *parts = [NSMutableArray array];
  NSMutableArray *methodParts = [NSMutableArray array];

  NSString *schemaClassName = schema.sg_objcClassName;
  BOOL collectionSupportsPagination = NO;
  NSString *collectionItemsKey =
    [schema sg_collectionItemsKey:&collectionSupportsPagination];
  BOOL isCollectionClass = (collectionItemsKey.length > 0);
  // NOTE: This was needed for some AppEngine services in the old library,
  // but it nothing seems to need in when REST based. Keeping it and
  // GTLRResultArray just in case.
  BOOL isTopLevelArrayResult = (([schema sg_propertyForKey:kReturnsSchemaParameterKey] != nil)
                                && [schema.type isEqual:@"array"]);

  GTLRDiscovery_JsonSchema *additionalProperties = schema.additionalPropertiesProperty.sg_resolvedSchema;
  BOOL additionalPropsIsArray = NO;
  if ([additionalProperties.type isEqual:@"array"]) {
    // Pull the type from the items in the array instead.
    additionalProperties = [additionalProperties sg_itemsSchemaResolving:YES depth:NULL];
    additionalPropsIsArray = YES;
  }

  if (mode == kGenerateInterface) {
    SGHeaderDoc *hd = [[SGHeaderDoc alloc] init];
    [hd append:schema.descriptionProperty];
    if (hd.isEmpty) {
      // If there was no description, just add the class name for lack of
      // anything better.
      [hd append:schemaClassName];
    }

    if (isCollectionClass || isTopLevelArrayResult) {
      NSMutableString *collectionNote =
        [NSMutableString stringWithFormat:
         @"This class supports NSFastEnumeration and indexed subscripting "
         @"over its \"%@\" property.",
         (isTopLevelArrayResult ? @"items" : collectionItemsKey)];
      if (isCollectionClass && collectionSupportsPagination) {
        [collectionNote appendFormat:
         @" If returned as the result of a query, it should support automatic "
         @"pagination (when %@ shouldFetchNextPages is enabled).",
         hd.atC];
      }
      [hd appendBlankLine];
      [hd appendNote:collectionNote];
    }

    if (additionalProperties != nil) {
      NSString *objcType = nil;
      NSString *comment = nil;
      [additionalProperties sg_getObjectParamObjCType:&objcType
                                            asPointer:NULL
                                objcPropertySemantics:NULL
                                              comment:&comment];
      if ([objcType isEqual:@"id"]) {
        objcType = @"any valid JSON type";
        // Drop the comment since it will be basically the same.
        comment = nil;
      }
      if (comment == nil) {
        comment = @"";
      } else {
        comment = [NSString stringWithFormat:@" (%@)", comment];
      }
      [hd appendBlankLine];
      [hd appendNoteFormat:
       @"This class is documented as having more properties of %@%@%@. Use %@"
       @" -additionalJSONKeys and %@ -additionalPropertyForName: to get the"
       @" list of properties and then fetch them; or %@ -additionalProperties"
       @" to fetch them all at once.",
       (additionalPropsIsArray ? @"NSArrays of " : @""), objcType, comment,
       hd.atC, hd.atC, hd.atC];
    }

    [parts addObject:hd.string];
  } else {
    NSMutableString *classHeader = [NSMutableString string];
    [classHeader appendString:@"// ----------------------------------------------------------------------------\n"];
    [classHeader appendString:@"//\n"];
    [classHeader appendFormat:@"//   %@\n", schemaClassName];
    [classHeader appendString:@"//\n"];
    [classHeader appendString:@"\n"];

    [parts addObject:classHeader];
  }

  NSString *atBlock;
  if (mode == kGenerateInterface) {
    NSString *baseClass = kBaseObjectClass;
    if (isCollectionClass) {
      baseClass = kCollectionObjectClass;
    } else if (isTopLevelArrayResult) {
      baseClass = kResultArrayClass;
    }
    atBlock = [NSString stringWithFormat:@"@interface %@ : %@\n",
               schemaClassName, baseClass];
  } else {
    atBlock = [NSString stringWithFormat:@"@implementation %@\n",
               schemaClassName];
  }
  [parts addObject:atBlock];

  // For the rare cases where a method returns an array directly, generate a
  // special result object that just has -items to get the contents of the
  // array.  The rest of the logic after this block is basically a no-op as
  // there are no properties on this schema.
  if (isTopLevelArrayResult) {
    if (mode == kGenerateInterface) {
      NSString *objcType = nil, *objcPropertySemantics = nil, *comment = nil;
      BOOL asPtr = NO;
      [schema sg_getObjectParamObjCType:&objcType
                              asPointer:&asPtr
                  objcPropertySemantics:&objcPropertySemantics
                                comment:&comment];
      if (comment == nil) {
        comment = @"";
      } else {
        comment = [@"  // " stringByAppendingString:comment];
      }
      NSString *propertyLine = [NSString stringWithFormat:@"@property(nonatomic, %@, readonly) %@%@%@;%@\n",
                                objcPropertySemantics, objcType,
                                (asPtr ? @" *" : @" "),
                                @"items", comment];
      [parts addObject:propertyLine];
    } else {
      GTLRDiscovery_JsonSchema *itemProperty =
        [schema sg_itemsSchemaResolving:YES depth:NULL];
      NSString *objcType = nil;
      if (itemProperty == nil) {
        objcType = @"id";
      } else {
        [itemProperty sg_getObjectParamObjCType:&objcType
                                      asPointer:NULL
                          objcPropertySemantics:NULL
                                        comment:NULL];
      }
      if ([objcType isEqual:@"id"]) {
        objcType = @"NSObject";
      }
      NSMutableString *itemsMethod = [NSMutableString string];
      [itemsMethod appendString:@"- (NSArray *)items {\n"];
      [itemsMethod appendFormat:@"  return [self itemsWithItemClass:[%@ class]];\n",
                                objcType];
      [itemsMethod appendString:@"}\n"];
      [methodParts addObject:itemsMethod];
    }
  }

  NSArray *properties = DictionaryObjectsSortedByKeys(schema.properties.additionalProperties);
  if (properties.count) {
    // Write out the property support (GTLRObject will fill them in at runtime).
    if (mode == kGenerateInterface) {
      // Put a blank line around any property that gets comments to make them
      // a little more readable.
      NSMutableArray *subParts = [NSMutableArray array];
      [subParts addObject:@"\n"];
      BOOL lastLineWasBlank = YES;
      for (GTLRDiscovery_JsonSchema *property in properties) {
        SGHeaderDoc *hd = [[SGHeaderDoc alloc] initWithAutoOneLine:YES];

        NSString *propertyObjCName = property.sg_objcName;

        NSString *propertyDescription = property.descriptionProperty;
        if (propertyDescription.length > 0) {
          [hd append:propertyDescription];
        } else {
          // If there was no comment, use the name as an initial comment before
          // any other information.
          [hd queueAppend:propertyObjCName];
        }

        NSDictionary *enumMap = [property sg_propertyForKey:kEnumMapKey];
        if (enumMap) {
          [hd appendBlankLine];
          [hd append:@"Likely values:"];
          NSArray *constantsNames =
            [enumMap.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
          for (NSString *name in constantsNames) {
            NSArray *pair = [enumMap objectForKey:name];
            NSString *value = [pair objectAtIndex:0];
            NSString *desc = [pair objectAtIndex:1];
            if (desc.length > 0) {
              [hd appendArg:name
                     format:@"%@ (Value: \"%@\")", desc, value];
            } else {
              [hd appendArg:name
                     format:@"Value \"%@\"", value];
            }
          }
        }

        if (isCollectionClass && [collectionItemsKey isEqual:propertyObjCName]) {
          [hd appendBlankLine];
          [hd appendNote:
           @"This property is used to support NSFastEnumeration and indexed"
           @" subscripting on this class."];
        }

        // If the ObjC name of a parameter was forced, include any comment
        // about that in the header with the @property declaration.
        NSString *forceObjCNameComment = property.sg_forceNameComment;
        if (forceObjCNameComment != nil) {
          [hd appendBlankLine];
          [hd append:forceObjCNameComment];
        }

        NSString *objcType = nil, *objcPropertySemantics = nil, *comment = nil;
        BOOL asPtr = NO;
        [property sg_getObjectParamObjCType:&objcType
                                  asPointer:&asPtr
                      objcPropertySemantics:&objcPropertySemantics
                                    comment:&comment];
        if (comment.length > 0) {
          [hd appendBlankLine];
          [hd append:comment];
        }
        NSString *extraAttributes = @"";
        if (asPtr || [objcType isEqual:@"id"]) {
          extraAttributes =
            [extraAttributes stringByAppendingFormat:@", nullable"];
        }
        if ([_useCustomerGetterPredicate evaluateWithObject:propertyObjCName]) {
          extraAttributes =
            [extraAttributes stringByAppendingFormat:@", getter=valueOf_%@", propertyObjCName];
        }
        NSString *clangDirective = @"";
        if ([_notRetainedPredicate evaluateWithObject:propertyObjCName]) {
          clangDirective = @" NS_RETURNS_NOT_RETAINED";
        }
        NSString *propertyLine = [NSString stringWithFormat:@"@property(nonatomic, %@%@) %@%@%@%@;\n",
                                  objcPropertySemantics, extraAttributes, objcType,
                                  (asPtr ? @" *" : @" "),
                                  propertyObjCName, clangDirective];

        if (hd.hasText) {
          if (!lastLineWasBlank) {
            [subParts addObject:@"\n"];
          }
          [subParts addObject:hd.string];
        }
        [subParts addObject:propertyLine];
        if (hd.hasText) {
          [subParts addObject:@"\n"];
          lastLineWasBlank = YES;
        } else {
          lastLineWasBlank = NO;
        }
      }  // for (property in properties)
      if (!lastLineWasBlank) {
        [subParts addObject:@"\n"];
      }
      [parts addObject:[subParts componentsJoinedByString:@""]];
    } else {
      NSArray *propertiesObjCNames = [properties valueForKey:@"sg_objcName"];
      NSString *asLines = [SGUtils stringOfLinesFromStrings:propertiesObjCNames
                                            firstLinePrefix:@"@dynamic "
                                           extraLinesPrefix:@"         "
                                                linesSuffix:@","
                                             lastLineSuffix:@";"
                                              elementJoiner:@", "];
      [parts addObject:asLines];
    }
  }  // if (properties.count)

  if (properties.count && (mode == kGenerateImplementation)) {
    // Keep a mapping for ObjC names to "wire" names for parameters that
    // had invalid characters.
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    for (GTLRDiscovery_JsonSchema *property in properties) {
      if (![property.sg_name isEqual:property.sg_objcName]) {
        [pairs setObject:property.sg_name forKey:property.sg_objcName];
      }
    }
    if (pairs.count != 0) {
      NSString *methodImpl = [SGUtils classMapForMethodNamed:@"propertyToJSONKeyMap"
                                                       pairs:pairs
                                                 quoteValues:YES
                                                valueTypeStr:@"NSString *"];
      [methodParts addObject:methodImpl];
    }

    // For all array properties, provide a mapping to the default class
    // contained within the array.
    pairs = [NSMutableDictionary dictionary];
    for (GTLRDiscovery_JsonSchema *property in properties) {
      GTLRDiscovery_JsonSchema *resolvedProperty = property.sg_resolvedSchema;
      if ([resolvedProperty.type isEqual:@"array"]) {
        GTLRDiscovery_JsonSchema *itemProperty =
            [resolvedProperty sg_itemsSchemaResolving:YES depth:NULL];
        NSString *objcType = nil;
        if (itemProperty == nil) {
          // A warning is already printed when the header was generated.
          objcType = @"id";
        } else {
          [itemProperty sg_getObjectParamObjCType:&objcType
                                        asPointer:NULL
                            objcPropertySemantics:NULL
                                          comment:NULL];
        }
        if ([objcType isEqual:@"id"]) {
          objcType = @"NSObject";
        }
        NSString *getClassStr =
          [NSString stringWithFormat:@"[%@ class]", objcType];
        [pairs setObject:getClassStr forKey:property.sg_name];
      }
    }
    if (pairs.count != 0) {
      NSString *methodImpl = [SGUtils classMapForMethodNamed:@"arrayPropertyToClassMap"
                                                       pairs:pairs
                                                 quoteValues:NO
                                                valueTypeStr:@"Class"];
      [methodParts addObject:methodImpl];
    }

    if (schema.sg_isLikelyInvalidUseOfKind) {
      NSString *blockKindMethod =
          @"+ (BOOL)isKindValidForClassRegistry {\n"
          @"  // This class has a \"kind\" property that doesn't appear to be usable to\n"
          @"  // determine what type of object was encoded in the JSON.\n"
          @"  return NO;\n"
          @"}\n";
      [methodParts addObject:blockKindMethod];
    }
  }

  if ((mode == kGenerateImplementation) && isCollectionClass) {
    NSString *defaultCollectionItemsKey = [GTLRCollectionObject collectionItemsKey];
    if (![collectionItemsKey isEqual:defaultCollectionItemsKey]) {
      NSMutableString *collectionItemsKeyMethod = [NSMutableString string];
      [collectionItemsKeyMethod appendString:@"+ (NSString *)collectionItemsKey {\n"];
      [collectionItemsKeyMethod appendFormat:@"  return @\"%@\";\n", collectionItemsKey];
      [collectionItemsKeyMethod appendString:@"}\n"];

      [methodParts addObject:collectionItemsKeyMethod];
    }
  }

  if ((additionalProperties != nil) && (mode == kGenerateImplementation)) {
    // Provide the class to hint object creation during parsing.
    NSString *objcType = nil;
    [additionalProperties sg_getObjectParamObjCType:&objcType
                                          asPointer:NULL
                              objcPropertySemantics:NULL
                                            comment:NULL];

    if ([objcType isEqual:@"id"]) {
      objcType = @"NSObject";
    }

    NSMutableString *method = [NSMutableString string];
    [method appendString:@"+ (Class)classForAdditionalProperties {\n"];
    [method appendFormat:@"  return [%@ class];\n", objcType];
    [method appendString:@"}\n"];
    [methodParts addObject:method];
  }

  if (methodParts.count) {
    NSString *methodsBlock =
      [NSString stringWithFormat:@"\n%@\n",
       [methodParts componentsJoinedByString:@"\n"]];
    [parts addObject:methodsBlock];
  }

  // Close it up.
  [parts addObject:@"@end\n"];

  return [parts componentsJoinedByString:@""];
}

- (NSArray *)oauth2ScopesConstantsBlocksForMode:(GeneratorMode)mode {
  GTLRDiscovery_RestDescription_Auth_Oauth2_Scopes *oauth2scopes = self.api.auth.oauth2.scopes;
  if (!oauth2scopes) {
    return nil;
  }

  NSMutableDictionary *authScopesMap = [NSMutableDictionary dictionary];
  for (NSString *scope in oauth2scopes.additionalJSONKeys) {
    NSString *key = [self authorizationScopeToConstant:scope];
    [authScopesMap setObject:scope forKey:key];
  }

  NSMutableString *header = [NSMutableString string];
  [header appendString:@"// ----------------------------------------------------------------------------\n"];
  if (authScopesMap.count > 1) {
    [header appendString:@"// Authorization scopes\n"];
  } else {
    [header appendString:@"// Authorization scope\n"];
  }

  NSMutableArray *subParts = [NSMutableArray array];

  NSArray *sortedNames =
    [authScopesMap.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  NSNumber *maxLenNum = [sortedNames valueForKeyPath:@"@max.length"];
  NSUInteger maxLen = maxLenNum.unsignedIntegerValue;
  if (maxLen > 45) maxLen = 45;

  for (__strong NSString *name in sortedNames) {
    NSString *scope = [authScopesMap objectForKey:name];
    NSString *aScope;
    if (mode == kGenerateInterface) {
      SGHeaderDoc *hd = [[SGHeaderDoc alloc] initWithAutoOneLine:YES];

      GTLRDiscovery_RestDescription_Auth_Oauth2_Scopes_Scope *scopeInfo =
        [oauth2scopes additionalPropertyForName:scope];
      if (scopeInfo.descriptionProperty.length > 0) {
        [hd appendFormat:@"Authorization scope: %@",
         scopeInfo.descriptionProperty];
        [hd appendBlankLine];
        [hd appendUnwrappedFormat:@"Value \"%@\"", scope];
      } else {
        [hd appendUnwrappedFormat:@"Authorization scope: \"%@\"", scope];
      }
      [subParts addObject:hd.string];
      aScope =
        [NSString stringWithFormat:@"%@ NSString * const %@;\n",
         kExternPrefix, name];
    } else {
      aScope =
        [NSString stringWithFormat:@"NSString * const %-*s = @\"%@\";\n",
         (int)maxLen, name.UTF8String, scope];
    }

    [subParts addObject:aScope];
  }
  NSString *body = [subParts componentsJoinedByString:@""];
  return @[ header, body ];
}

- (NSArray *)constantsBlocksForMode:(GeneratorMode)mode
                           enumsMap:(NSDictionary *)enumsMap
                       commentExtra:(NSString *)commentExtra {
  if (enumsMap.count == 0) {
    return nil;
  }

  NSMutableArray *result = [NSMutableArray array];

  NSMutableString *header = [NSMutableString string];
  [header appendString:@"// ----------------------------------------------------------------------------\n"];
  if (commentExtra.length > 0) {
    [header appendFormat:@"// Constants - %@\n", commentExtra];
  } else {
    [header appendString:@"// Constants\n"];
  }
  [result addObject:header];

  NSArray *constantsGroups =
    [enumsMap.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

  NSMutableArray *subParts = [NSMutableArray array];
  for (NSString *constantsGroup in constantsGroups) {
    NSDictionary *enumGroup = [enumsMap objectForKey:constantsGroup];

    NSString *commentLine = [NSString stringWithFormat:@"// %@\n", constantsGroup];
    if (mode == kGenerateInterface) {
      [subParts addObject:@"// ----------------------------------------------------------------------------\n"];
      [subParts addObject:commentLine];
      [subParts addObject:@"\n"];
    } else {
      [subParts addObject:commentLine];
    }

    NSArray *names =
      [enumGroup.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSNumber *maxLenNum = [names valueForKeyPath:@"@max.length"];
    NSUInteger maxLen = maxLenNum.unsignedIntegerValue;
    if (maxLen > 45) maxLen = 45;

    for (__strong NSString *name in names) {
      NSArray *tuple = [enumGroup objectForKey:name];
      NSString *value = tuple[0];
      NSString *desc = tuple[1];
      NSString *line;
      if (mode == kGenerateInterface) {
        SGHeaderDoc *hd = [[SGHeaderDoc alloc] initWithAutoOneLine:YES];
        [hd append:desc];
        if (hd.hasText) {
          [hd appendBlankLine];
        }
        [hd appendUnwrappedFormat:@"Value: \"%@\"", value];
        [subParts addObject:hd.string];
        BOOL deprecated = tuple.count == 3 ? [tuple[2] boolValue] : NO;
        NSString *maybeDeprecated = deprecated ? kDeprecatedSuffix : @"";
        line = [NSString stringWithFormat:@"%@ NSString * const %@%@;\n",
                kExternPrefix, name, maybeDeprecated];
      } else {
        line = [NSString stringWithFormat:@"NSString * const %-*s = @\"%@\";\n",
                (int)maxLen, name.UTF8String, value];
      }

      [subParts addObject:line];
    }

    [result addObject:[subParts componentsJoinedByString:@""]];
    [subParts removeAllObjects];
  }

  return result;
}


// Generates a constant name out of the scope by using the leaf of the scope
// string and the service name.
- (NSString *)authorizationScopeToConstant:(NSString *)scope {
  NSString *result = nil;

  NSString *prefix = [NSString stringWithFormat:@"k%@AuthScope%@",
                      kProjectPrefix, self.formattedAPIName];

  if (authScopeNamingMode == kOAuth2ScopeNamingModeUseEverything) {
    NSString *formattedScopeName =
      [SGUtils objcName:scope shouldCapitalize:YES allowLeadingDigits:YES];
    result = [prefix stringByAppendingString:formattedScopeName];
    return result;
  }

  NSString *scopeName;

  static NSString *kCommonGoogleAuthPrefix = @"https://www.googleapis.com/auth/";
  static NSString *kPrefixHTTPS = @"https://";
  static NSString *kPrefixHTTP = @"http://";

  if ([scope hasPrefix:kCommonGoogleAuthPrefix]) {
    // It has the common Google auth prefix, remove that, and use the rest.
    scopeName = [scope substringFromIndex:kCommonGoogleAuthPrefix.length];
  } else {

    NSString *worker = scope;
    if ([worker hasPrefix:kPrefixHTTPS]) {
      worker = [worker substringFromIndex:kPrefixHTTPS.length];
    } else if ([worker hasPrefix:kPrefixHTTP]) {
      worker = [worker substringFromIndex:kPrefixHTTP.length];
    }

    NSRange firstSlash = [worker rangeOfString:@"/"];
    if (firstSlash.location == NSNotFound) {
      // No slashes, just use what we started with.
      scopeName = scope;
    } else if (NSMaxRange(firstSlash) == worker.length) {
      // Ended with a slash. There are some scopes that are just simple host
      // urls (https://mail.google.com/). Just use that then.
      scopeName = [worker substringToIndex:firstSlash.location];
    } else {
      // Seems to have been an url, so we assume the hostnames don't matter.
      if (authScopeNamingMode == kOAuth2ScopeNamingModeFullURL) {
        // Use the remainder of the url.
        scopeName = [worker substringFromIndex:NSMaxRange(firstSlash)];
      } else if (authScopeNamingMode == kOAuth2ScopeNamingModeShortURL) {
        // Use the last item of the url (shorter names).
        NSRange lastSlash = [worker rangeOfString:@"/" options:NSBackwardsSearch];
        // No need to check for NSNotFound, worst case this finds the same slash
        // that was found for firstSlash.
        scopeName = [worker substringFromIndex:NSMaxRange(lastSlash)];
      } else {
        [NSException raise:kFatalGeneration
                    format:@"Internal error generating OAuth2 Scope names."];
      }
    }
  }

  NSString *lowerScopeName = [scopeName lowercaseString];
  NSString *lowerApiName = [self.api.name lowercaseString];
  if ([lowerScopeName isEqual:lowerApiName]) {
    // Leaf was just service name, nothing to add to the scope constant.
    result = prefix;
  } else {
    lowerApiName = [lowerApiName stringByAppendingString:@"."];
    if ([lowerScopeName hasPrefix:lowerApiName]) {
      // Starts with "ServiceName.", drop that and use the rest.
      scopeName = [scopeName substringFromIndex:lowerApiName.length];
    }
    // This gets a prefix, so leading numbers are fine.
    NSString *formattedScopeName =
      [SGUtils objcName:scopeName shouldCapitalize:YES allowLeadingDigits:YES];
    result = [prefix stringByAppendingString:formattedScopeName];
  }

  return result;
}

// An import for a generated header from an implementation file.
- (NSString *)implementationHeaderImport:(NSString *)headerName {
  if (self.publicHeadersSubDir) {
    return [NSString stringWithFormat:@"#import <%@/%@.h>\n", self.publicHeadersSubDir, headerName];
  } else {
    return [NSString stringWithFormat:@"#import \"%@.h\"\n", headerName];
  }
}

// An import directive for a header from the GTLR framework.
- (NSString *)frameworkImport:(NSString *)headerName {
  if (self.importPrefix) {
    if ((_options & kSGGeneratorOptionImportPrefixIsFramework) != 0) {
      return [NSString stringWithFormat:@"#import <%@/%@.h>\n", self.importPrefix, headerName];
    }
    if ((_options & kSGGeneratorOptionImportPrefixIsModular) != 0) {
      return [NSString stringWithFormat:@"@import %@;\n", self.importPrefix];
    }
    return [NSString stringWithFormat:@"#import \"%@/%@.h\"\n", self.importPrefix, headerName];
  }

  // Default to the 2.0 import with fallback to a SwiftPM check, and then
  // finally the old bare import. Keeping the old CPP gates to also allow
  // forcing of things.
  NSMutableString *result = [NSMutableString string];
  [result appendFormat:@"#if __has_include(<GoogleAPIClientForREST/%@.h>) || GTLR_BUILT_AS_FRAMEWORK\n", headerName];
  [result appendFormat:@"  #import <GoogleAPIClientForREST/%@.h>\n", headerName];
  [result appendString:@"#elif SWIFT_PACKAGE || GTLR_USE_MODULAR_IMPORT\n"];
  [result appendString:@"  @import GoogleAPIClientForRESTCore;\n"];
  [result appendString:@"#else\n"];
  [result appendFormat:@"  #import \"%@.h\"\n", headerName];
  [result appendString:@"#endif\n"];
  return result;
}

- (void)addWarning:(NSString *)warningString {
  NSMutableArray *warnings = self.warnings;
  if (!warnings) {
    warnings = [NSMutableArray array];
    self.warnings = warnings;
  }
  if (![warnings containsObject:warningString]) {
    [warnings addObject:warningString];
  }
}

- (void)addInfo:(NSString *)infoString {
  NSMutableArray *infos = self.infos;
  if (!infos) {
    infos = [NSMutableArray array];
    self.infos = infos;
  }
  if (![infos containsObject:infoString]) {
    [infos addObject:infoString];
  }
}

@end

@implementation GTLRObject (SGGeneratorAdditions)

- (NSString *)sg_errorReportingName {
  NSString *result = [self sg_propertyForKey:kNameKey];
  return result;
}

- (SGGenerator *)sg_generator {
  SGGenerator *result =
      [[self sg_propertyForKey:kWrappedGeneratorKey] nonretainedObjectValue];
  NSAssert(result != nil,
           @"attempt to use generator when it wasn't set for object: %@",
           self);
  return result;
}

- (void)sg_setProperty:(id)obj forKey:(NSString *)key {
  NSMutableDictionary *worker = [self.userProperties mutableCopy];
  if (obj == nil) {
    // caller passed in nil, so delete the property
    [worker removeObjectForKey:key];
  } else {
    if (worker == nil) {
      worker = [NSMutableDictionary dictionary];
    }
    [worker setObject:obj forKey:key];
  }
  self.userProperties = worker;
}

- (id)sg_propertyForKey:(NSString *)key {
  return [self.userProperties objectForKey:key];
}

+ (NSArray *)sg_acceptedUnknowns {
  return nil;
}

@end

@implementation GTLRDiscovery_RestDescription (SGGeneratorAdditions)

// Builds a list of all the resources (and subresources) on the service
- (NSArray *)sg_allResources {
  NSArray *result = [self sg_propertyForKey:kAllResourcesKey];
  if (result == nil) {
    NSMutableArray *worker = [NSMutableArray array];
    NSArray *resources = self.resources.additionalProperties.allValues;
    if (resources.count > 0) {
      [worker addObjectsFromArray:resources];
    }
    NSUInteger idx = 0;
    while (idx < worker.count) {
      GTLRDiscovery_RestResource *res = [worker objectAtIndex:idx];
      NSArray *subResources = res.resources.additionalProperties.allValues;
      if (subResources.count > 0) {
        [worker addObjectsFromArray:subResources];
      }
      ++idx;
    }

    result = [NSArray arrayWithArray:worker];
    [self sg_setProperty:result forKey:kAllResourcesKey];
  }
  return result;
}

// Methods sorted by their ObjC query name.
- (NSArray *)sg_allMethods {
  NSArray *result = [self sg_propertyForKey:kAllMethodsKey];
  if (result == nil) {
    NSMutableDictionary *allMethodsDict = [NSMutableDictionary dictionary];
    // Methods on the service
    NSArray *allUnorderedMethods = self.methods.additionalProperties.allValues;
    for (GTLRDiscovery_RestMethod *method in allUnorderedMethods) {
      [allMethodsDict setObject:method
                         forKey:[self.sg_generator objcQueryClassName:method]];
    }
    // Methods on resources (and sub resources)
    for (GTLRDiscovery_RestResource *resource in self.sg_allResources) {
      for (GTLRDiscovery_RestMethod *method in resource.methods.additionalProperties.allValues) {
        [allMethodsDict setObject:method
                           forKey:[self.sg_generator objcQueryClassName:method]];
      }
    }
    // Return them sorted for stable iteration.
    result = DictionaryObjectsSortedByKeys(allMethodsDict);
    [self sg_setProperty:result forKey:kAllMethodsKey];
  }
  return result;
}

- (BOOL)sg_hasDeprecatedMethod {
  NSNumber *result = [self sg_propertyForKey:kHasDeprecatedMethodKey];
  if (result == nil) {
    result = @NO;
    for (GTLRDiscovery_RestMethod *method in self.sg_allMethods) {
      if (method.deprecated.boolValue) {
        result = @YES;
        break;
      }
    }

    [self sg_setProperty:result forKey:kHasDeprecatedMethodKey];
  }
  return [result boolValue];
}

// Returns a dictionary keyed by the "grouping" where the objects are the
// values keyed by the constant name. i.e. --
//   { 'scope': {
//       'kGTLRServiceScopeSpam': [ '@spam', @'description', @YES ],
//       'kGTLRServiceScopeBlah': [ '@blah', @'description', @NO ]
//      }
//   }
- (NSDictionary *)sg_queryEnumsMap {
  // Note: We currently ignore any enums defined on the top level properties
  // for the service (self.api.parameters). If support is added for those, it
  // needs to filter the enums the same way -queryCommonParams filters, so enums
  // aren't provided for parameters that aren't present.

  NSDictionary *result = [self sg_propertyForKey:kQueryEnumsMapKey];
  if (result != nil) {
    return result;
  }

  NSMutableDictionary *worker = [NSMutableDictionary dictionary];

  // Values from query parameters
  for (GTLRDiscovery_RestMethod *method in self.sg_allMethods) {
    NSArray *methodParameters = DictionaryObjectsSortedByKeys(method.parameters.additionalProperties);
    for (GTLRDiscovery_JsonSchema *param in methodParameters) {
      NSArray *enumProperty = param.enumProperty;
      if (enumProperty.count == 0) continue;

      // Only expecting strings at this point.
      if (![param.type isEqual:@"string"]) {
        [NSException raise:kFatalGeneration
                    format:@"Collecting enum values, '%@' on method '%@' is type %@ (instead of string)",
         param.sg_name, param.sg_method.sg_name, param.type];
      }

      // Merge in these values
      NSMutableDictionary *groupMap = [worker objectForKey:param.sg_objcName];
      if (groupMap == nil) {
        groupMap = [NSMutableDictionary dictionary];
        [worker setObject:groupMap forKey:param.sg_objcName];
      }
      NSArray *enumDescriptions = param.enumDescriptions;
      NSArray *enumDeprecateds = param.enumDeprecated;
      for (NSUInteger i = 0; i < enumProperty.count; ++i) {
        NSString *enumValue = enumProperty[i];
        NSString *enumDescription = (i < enumDescriptions.count ? enumDescriptions[i] : @"");
        NSNumber *enumDeprecated = (i < enumDeprecateds.count ? enumDeprecateds[i] : @NO);
        NSString *constName = [param sg_constantNamed:enumValue];
        NSArray *previousValue = [groupMap objectForKey:constName];
        if (previousValue) {
          NSString *prevDescription = previousValue[1];
          BOOL descMatches = [prevDescription isEqual:enumDescription];
          NSNumber *prevDeprecated = previousValue[2];
          BOOL deprecatedMatches = [prevDeprecated isEqual:enumDeprecated];
          if (!descMatches || !deprecatedMatches) {
            // If the deprecations don't match, clear that so it won't get
            // annotated.
            if (!deprecatedMatches) {
              NSString *msg =
                  [NSString stringWithFormat:@"Collecting enum values, '%@' on method '%@' has value '%@' with a different deprecation status than on other methods, can't annotated it.",
                   param.sg_name, param.sg_method.sg_name, enumValue];
              enumDeprecated = @NO;
              [self.sg_generator addInfo:msg];
            }
            // If the descriptions don't match, clear it out so the constant
            // won't get a comment (the comment on specific usages will still
            // have a comment).
            [groupMap setObject:@[ enumValue,
                                   (descMatches ? enumDescription : @""),
                                   enumDeprecated ]
                         forKey:constName];
          }
        } else {
          [groupMap setObject:@[ enumValue, enumDescription, enumDeprecated ]
                       forKey:constName];
        }
      }
    }
  }

  result = worker;
  [self sg_setProperty:result forKey:kQueryEnumsMapKey];
  return result;
}

// Returns a dictionary keyed by the "grouping" where the objects are the
// values keyed by the constant name. i.e. --
//   { 'scope': {
//       'kGTLRServiceScopeSpam': [ '@spam', 'description' ],
//       'kGTLRServiceScopeBlah': [ '@blah', 'description' ]
//      }
//   }
- (NSDictionary *)sg_objectEnumsMap {
  NSDictionary *result = [self sg_propertyForKey:kObjectEnumsMapKey];
  if (result != nil) {
    return result;
  }

  NSMutableDictionary *worker = [NSMutableDictionary dictionary];

  // Values from query parameters
  for (GTLRDiscovery_JsonSchema *schema in self.sg_allSchemas) {
    NSArray *enumProperty = schema.enumProperty;
    if (enumProperty.count == 0) continue;

    // Only expecting strings at this point.
    if (![schema.type isEqual:@"string"]) {
      [NSException raise:kFatalGeneration
                  format:@"Collecting enum values, '%@'is type %@ (instead of string)",
       schema.sg_fullSchemaName, schema.type];
    }

    // We want to group it by the property/field the thing is hung on. The
    // catch is arrays (of arrays)*, we don't want to use the "item" schema
    // so need to walk up and find the right parent schema.
    //   schema - has the enum
    //   parentScheme - will be where to scope it
    //   propertySchema - will be what to group it as
    GTLRDiscovery_JsonSchema *parentSchema = schema.sg_parentSchema;
    GTLRDiscovery_JsonSchema *propertySchema = schema;
    while ([[propertySchema sg_propertyForKey:kIsItemsSchemaKey] boolValue]) {
      propertySchema = parentSchema;
      parentSchema = parentSchema.sg_parentSchema;
    }
    NSString *groupBase = parentSchema.sg_objcClassName;
    NSString *groupLeafCap = propertySchema.sg_capObjCName;
    NSString *groupLeaf = propertySchema.sg_objcName;
    if (parentSchema == nil || propertySchema == nil) {
      // If we failed to find parent schemas to make the grouping, use
      // [service] [schema].  This happens when something has a root schema
      // that is just the string type, and the reference it from other
      // places.
      groupBase =
        [NSString stringWithFormat:@"%@%@",
         kProjectPrefix, self.sg_generator.formattedAPIName];
      groupLeafCap = schema.sg_capObjCName;
      groupLeaf = schema.sg_objcName;
    }
    NSString *groupName =
      [NSString stringWithFormat:@"%@.%@", groupBase, groupLeaf];
    if ([worker objectForKey:groupName]) {
      [NSException raise:kFatalGeneration
                  format:@"Collecting enum values, %@ needed group name '%@', but it is already in use.",
       schema.sg_fullSchemaName, groupName];
    }
    NSString *groupPrefix =
      [NSString stringWithFormat:@"%@_%@_", groupBase, groupLeafCap];
    NSMutableDictionary *groupMap = [NSMutableDictionary dictionary];
    [worker setObject:groupMap forKey:groupName];
    NSArray *enumDescriptions = schema.enumDescriptions;
    for (NSUInteger i = 0; i < enumProperty.count; ++i) {
      NSString *enumValue = enumProperty[i];
      NSString *enumDescription = (i < enumDescriptions.count ? enumDescriptions[i] : @"");
      NSString *constName = ConstantName(groupPrefix, enumValue);
      [groupMap setObject:@[ enumValue, enumDescription ]
                   forKey:constName];
    }
    [schema sg_setProperty:groupMap forKey:kEnumMapKey];
  }

  result = worker;
  [self sg_setProperty:result forKey:kObjectEnumsMapKey];
  return result;
}

- (NSArray *)sg_allSchemas {
  NSArray *result = [self sg_propertyForKey:kAllSchemasKey];
  if (result == nil) {

    // Make sure the id's match the keys they are under for the top level.
    // Have to skip over a top level that is purely a references for mapping
    // method request/returns schema to real schema.

    for (NSString *name in self.schemas.additionalProperties) {
      GTLRDiscovery_JsonSchema *schema =
        [self.schemas.additionalProperties objectForKey:name];
      if (schema.xRef.length == 0) {
        if (![name isEqual:schema.identifier]) {
          [NSException raise:kFatalGeneration
                      format:@"Looking at allSchema, mismatch between id and name: '%@' vs '%@'",
                            name, schema.identifier];
        }
      }
    }

    // We don't have to crawl the tree to find all of the schema, but they can be
    // nested.

    NSMutableArray *worker = [NSMutableArray array];
    NSArray *schemas = DictionaryObjectsSortedByKeys(self.schemas.additionalProperties);
    if (schemas.count > 0) {
      [worker addObjectsFromArray:schemas];
    }
    NSUInteger idx = 0;
    while (idx < worker.count) {
      GTLRDiscovery_JsonSchema *schema = [worker objectAtIndex:idx];
      NSArray *subSchemas = DictionaryObjectsSortedByKeys(schema.properties.additionalProperties);
      if (subSchemas.count > 0) {
        [worker addObjectsFromArray:subSchemas];
      }
      GTLRDiscovery_JsonSchema *itemsSchema = schema.items;
      if (itemsSchema) {
        [worker addObject:itemsSchema];
      }
      GTLRDiscovery_JsonSchema *additionalPropsSchema = schema.additionalPropertiesProperty;
      if (additionalPropsSchema) {
        [worker addObject:additionalPropsSchema];
      }
      ++idx;
    }

    result = [NSArray arrayWithArray:worker];
    [self sg_setProperty:result forKey:kAllSchemasKey];
  }
  return result;
}

- (NSArray *)sg_topLevelObjectSchemas {
  NSArray *result = [self sg_propertyForKey:kTopLevelObjectSchemasKey];
  if (result == nil) {

    // NOTE: We want this list in a stable order, but we can't simply sort the
    // keys and then iterate because when we turn them into class names we
    // sometimes have to strip prefixes (service names, etc.).  Instead we
    // sort by the objc class name after collecting them.

    NSMutableDictionary *worker = [NSMutableDictionary dictionary];
    for (GTLRDiscovery_JsonSchema *schema in self.schemas.additionalProperties.allValues) {
      NSString *schemaType = schema.type;
      if ([schemaType isEqual:@"object"]) {
        [worker setObject:schema forKey:schema.sg_objcClassName];
      } else if ([schemaType isEqual:@"array"]) {
        // If an array is a return result, need to generate a stub object to
        // use.
        if ([schema sg_propertyForKey:kReturnsSchemaParameterKey] != nil) {
          [worker setObject:schema forKey:schema.sg_objcClassName];
        }
        // Don't resolve items, should end on an object or a ref (no type).
        GTLRDiscovery_JsonSchema *itemsSchema =
            [schema sg_itemsSchemaResolving:NO depth:NULL];
        if ([itemsSchema.type isEqual:@"object"]) {
          [worker setObject:itemsSchema forKey:itemsSchema.sg_objcClassName];
        }
      }
    }

    result = DictionaryObjectsSortedByKeys(worker);
    [self sg_setProperty:result forKey:kTopLevelObjectSchemasKey];
  }
  return result;
}

// These are resolved schema references in the method parameters (refs or
// inline).
- (NSArray *)sg_allMethodObjectParameterReferences {
  NSArray *result = [self sg_propertyForKey:kAllMethodObjectParameterRefsKey];
  if (result == nil) {
    NSMutableArray *worker = [NSMutableArray array];

    for (GTLRDiscovery_RestMethod *method in self.sg_allMethods) {
      for (GTLRDiscovery_JsonSchema *param in method.sg_sortedParametersWithRequest) {
        GTLRDiscovery_JsonSchema *resolvedParam = param.sg_resolvedSchema;
        NSString *schemaType = resolvedParam.type;
        if ([schemaType isEqual:@"object"]) {
          [worker addObject:resolvedParam];
        } else if ([schemaType isEqual:@"array"]) {
          GTLRDiscovery_JsonSchema *paramItems =
            [resolvedParam sg_itemsSchemaResolving:YES depth:NULL];
          if ([paramItems.type isEqual:@"object"]) {
            [worker addObject:paramItems];
          }
        }
      }
    }

    result = [NSArray arrayWithArray:worker];
    [self sg_setProperty:result forKey:kAllMethodObjectParameterRefsKey];
  }
  return result;
}

- (NSString *)sg_cleanedRootURLString {
  NSString *result = [self sg_propertyForKey:kCleanedRootURLStringKey];
  if (result == nil) {
    SGGenerator *generator = self.sg_generator;

    NSString *rootUrlString = self.rootUrl;
    if (rootUrlString.length > 0) {
      if (generator.allowRootURLOverrides
          && [rootUrlString hasSuffix:@".sandbox.google.com/"]) {
        NSString *str =
          [NSString stringWithFormat:@"API rootUrl (%@) seems to be a Google test system, overriding with googleapis, use --rootURLOverrides NO to disable.",
           rootUrlString];
        [generator addInfo:str];
        rootUrlString = @"https://www.googleapis.com/";
      }
    } else {
      [generator addWarning:@"API didn't have a rootUrl."];
    }
    result = rootUrlString;
    [self sg_setProperty:result forKey:kCleanedRootURLStringKey];
  }
  return result;
}

- (NSString *)sg_resumableUploadPath {
  // sg_calculateMediaPaths fills this in.
  NSString *result = [self sg_propertyForKey:kResumableUploadPathKey];
  return result;
}

- (NSString *)sg_simpleUploadPath {
  // sg_calculateMediaPaths fills this in.
  NSString *result = [self sg_propertyForKey:kSimpleUploadPathKey];
  return result;
}

- (void)sg_calculateMediaPath:(NSString *)name
                      keyPath:(NSString *)keyPath
                   apiPathKey:(NSString *)apiPathKey
            methodOverrideKey:(NSString *)methodOverrideKey {
  NSString *servicePath = self.servicePath ?: @"";

  NSMutableArray *worker = [NSMutableArray array];
  NSMutableArray *methodsNeedingOverride = [NSMutableArray array];
  NSCountedSet *prefixes = [NSCountedSet set];

  for (GTLRDiscovery_RestMethod *method in self.sg_allMethods) {
    if (!method.supportsMediaUpload.boolValue) continue;

    NSString *mediaPath = [method valueForKeyPath:keyPath];
    NSString *expectedSuffix = [servicePath stringByAppendingString:method.path];
    if (![mediaPath hasSuffix:expectedSuffix]) {
      [methodsNeedingOverride addObject:method];
      continue;
    }

    [worker addObject:method];

    NSUInteger prefixLen = mediaPath.length - expectedSuffix.length;
    NSString *prefix = [mediaPath substringToIndex:prefixLen];
    [prefixes addObject:prefix];
  }

  if (prefixes.count > 1) {
    NSString *msg =
      [NSString stringWithFormat:@"There was more than one prefix in use for %@ media uploads.",
       name];
    [self.sg_generator addInfo:msg];
  }

  NSString *commonPrefix = @"";
  NSUInteger commonPrefixCount = 0;
  for (NSString *prefix in prefixes) {
    NSUInteger count = [prefixes countForObject:prefix];
    if (count > commonPrefixCount) {
      commonPrefix = prefix;
      commonPrefixCount = count;
    }
  }

  for (GTLRDiscovery_RestMethod *method in worker) {
    NSString *mediaPath = [method valueForKeyPath:keyPath];
    if (![mediaPath hasPrefix:commonPrefix]) {
      [methodsNeedingOverride addObject:method];
    }
  }

  for (GTLRDiscovery_RestMethod *method in methodsNeedingOverride) {
    NSString *path = [method valueForKeyPath:keyPath];
    while ([path hasPrefix:@"/"]) {
      path = [path substringFromIndex:1];
      NSString *msg =
        [NSString stringWithFormat:@"Method '%@' needs a %@ media path override, it started with '/', removing it.",
         method.sg_name, name];
      [self.sg_generator addWarning:msg];
    }
    [method sg_setProperty:path forKey:methodOverrideKey];
  }

  while ([commonPrefix hasPrefix:@"/"]) {
    // Drop the leading slash, but don't print anything out as it seems to
    // be the common case.
    commonPrefix = [commonPrefix substringFromIndex:1];
  }

  [self sg_setProperty:commonPrefix forKey:apiPathKey];
}

- (void)sg_calculateMediaPaths {
  NSAssert([self sg_propertyForKey:kResumableUploadPathKey] == nil,
           @"Called twice?");
  NSAssert([self sg_propertyForKey:kSimpleUploadPathKey] == nil,
           @"Called twice?");

  [self sg_calculateMediaPath:@"resumable"
                      keyPath:@"mediaUpload.protocols.resumable.path"
                   apiPathKey:kResumableUploadPathKey
            methodOverrideKey:kResumableUploadPathOverrideKey];

  [self sg_calculateMediaPath:@"simple"
                      keyPath:@"mediaUpload.protocols.simple.path"
                   apiPathKey:kSimpleUploadPathKey
            methodOverrideKey:kSimpleUploadPathOverrideKey];
}

+ (NSArray *)sg_acceptedUnknowns {
  return @[ @"fullyEncodeReservedExpansion", @"mtlsRootUrl" ];
}

@end

@implementation GTLRDiscovery_JsonSchema (SGGeneratorAdditions)

- (NSString *)sg_name {
  NSString *result = [self sg_propertyForKey:kNameKey];
  return result;
}

// Helper that logs if the given class has any property-like methods (method
// taking no argument) against an expected list of reserved words. That way
// the list can be trusted for checking for naming collisions when generating
// classes based on the given class.
static void CheckReservedList(Class aClass,
                              NSArray *reservedList,
                              BOOL skipPrefixed,
                              NSArray *allowedExceptions) {
  NSArray *namesFromRuntime =
      [SGUtils publicNoArgSelectorsForClass:aClass skipPrefixed:skipPrefixed];
  for (NSString *name in namesFromRuntime) {
    if ([reservedList containsObject:name]) {
      // Was listed!
    } else if ([allowedExceptions containsObject:name]) {
      // Was an allowed exception.
    } else {
      NSLog(@"WARNING: The reserved word list for %@ seems to be missing: %@",
            aClass, name);
    }
  }

  for (NSString *name in reservedList) {
    if (![namesFromRuntime containsObject:name]) {
      NSLog(@"WARNING: The reserved word list for %@ has something not found in the runtime: %@",
            aClass, name);
    }
  }
}

typedef enum {
  kTypeQuery,
  kTypeObject,
} EQueryOrObject;

static NSDictionary *OverrideMap(EQueryOrObject queryOrObject,
                                 NSDictionary **outCommentMap) {
  static NSDictionary *objectReserved = nil;
  static NSDictionary *objectReservedComments = nil;
  static NSDictionary *queryReserved = nil;
  static NSDictionary *queryReservedComments = nil;
  if (objectReserved == nil) {
    NSArray *langReserved = @[
    // Objective C "keywords" that aren't in C/C++
    // From http://stackoverflow.com/questions/1873630/reserved-keywords-in-objective-c
      @"id",
      @"super",
      @"in",
      @"out",
      @"inout",
      @"bycopy",
      @"byref",
      @"oneway",
      @"self",
      @"nil",
      // C/C++ keywords (Incl C++ 0x11)
      // From http://en.cppreference.com/w/cpp/keywords
      @"and",
      @"alignas",
      @"alignof",
      @"asm",
      @"auto",
      @"bitand",
      @"bitor",
      @"bool",
      @"break",
      @"case",
      @"catch",
      @"char",
      @"compl",
      @"const",
      @"constexpr",
      @"continue",
      @"decltype",
      @"default",
      @"delete",
      @"double",
      @"else",
      @"enum",
      @"explicit",
      @"export",
      @"extern ",
      @"false",
      @"float",
      @"for",
      @"friend",
      @"goto",
      @"if",
      @"inline",
      @"int",
      @"long",
      @"mutable",
      @"namespace",
      @"new",
      @"noexcept",
      @"not",
      @"nullptr",
      @"operator",
      @"or",
      @"private",
      @"protected",
      @"public",
      @"register",
      @"return",
      @"short",
      @"signed",
      @"sizeof",
      @"static",
      @"struct",
      @"switch",
      @"template",
      @"this",
      @"throw",
      @"true",
      @"try",
      @"typedef",
      @"typeid",
      @"typename",
      @"union",
      @"unsigned",
      @"using",
      @"virtual",
      @"void",
      @"volatile",
      @"while",
      @"xor",
      // C99 keywords
      // From http://publib.boulder.ibm.com/infocenter/lnxpcomp/v8v101/index.jsp?topic=%2Fcom.ibm.xlcpp8l.doc%2Flanguage%2Fref%2Fkeyw.htm
      @"restrict",
    ];
    // NSObject methods
    NSArray *nsobjectReserved = @[
      @"attributeKeys",
      @"autoContentAccessingProxy",
      @"autorelease",
      @"class",
      @"classCode",
      @"classDescription",
      @"classForArchiver",
      @"classForCoder",
      @"classForKeyedArchiver",
      @"classForPortCoder",
      @"className",
      @"copy",
      @"dealloc",
      @"debugDescription",
      @"description",
      @"finalize",
      @"hash",
      @"init",
      @"isProxy",
      @"mutableCopy",
      @"release",
      @"retain",
      @"retainCount",
      @"self",
      @"scriptingProperties",
      @"superclass",
      @"toManyRelationshipKeys",
      @"toOneRelationshipKeys",
      @"zone",
      // These doesn't seem to be listed in Apple's docs, but are found in the
      // OS X runtime, so play it safe and block them also.
      @"allowsWeakReference",
      @"allPropertyKeys",
      @"clearProperties",
      @"entityName",
      @"finishObserving",
      @"flushKeyBindings",
      @"isFault",
      @"objectSpecifier",
      @"observationInfo",
      @"retainWeakReference",
      // -------------------- New as of High Sierra --------------------
      @"CAMLType",
      // -------------------- New as of Mojave --------------------
      // None
      // -------------------- New as of Catalina --------------------
      @"supportsBSXPCSecureCoding",
      // -------------------- New as of Big Sur --------------------
      // This seems to have been removed in Ventura: @"toPBCodable",
      // This seems to have been removed in Ventura: @"CKDescription",
      // This seems to have been removed in Ventura: @"CKPropertiesDescription",
      // This seems to have been removed in Monterey: @"CKStatusReport",
      // This seems to have been removed in Ventura: @"CKSingleLineDescription",
      // This seems to have been removed in Ventura: @"CKExpandedDescription",
      // This seems to have been removed in Ventura: @"CKHashedDescription",
      @"NSRepresentation",
      // This seems to have been removed in Ventura: @"boolValueSafe",
      // This seems to have been removed in Ventura: @"int64ValueSafe",
      // This seems to have been removed in Ventura: @"doubleValueSafe",
      // This seems to have been removed in Ventura: @"stringValueSafe",
      // This seems to have been removed in Ventura: @"utf8ValueSafe",
      @"supportsRBSXPCSecureCoding",
      @"RBSIsXPCObject",
      @"NSRepresentation",
      // -------------------- New as of Monterey --------------------
      // This seems to have been removed in Ventura: @"CKRedactedDescription",
      // This seems to have been removed in Ventura: @"CKUnredactedDescription",
      // -------------------- New as of Ventura --------------------
      // None
    ];
    // GTLRObject methods
    NSArray *gtlrObjectReserved = @[
      @"additionalJSONKeys",
      @"additionalProperties",
      @"fieldsDescription",
      @"JSON",
      @"JSONDescription",
      @"JSONString",
      @"objectClassResolver",
      @"userProperties",
    ];
    // GTLRQuery methods
    NSArray *gtlrQueryReserved = @[
      @"additionalHTTPHeaders",
      @"additionalURLQueryParameters",
      @"bodyObject",
      @"completionBlock",
      @"downloadAsDataObjectType",
      @"executionParameters",
      @"expectedObjectClass",
      @"hasExecutionParameters",
      @"httpMethod",
      @"invalidateQuery",
      @"isBatchQuery",
      @"isQueryInvalid",
      @"JSON",
      @"loggingName",
      @"objectClassResolver",
      @"pathParameterNames",
      @"pathURITemplate",
      @"requestID",
      @"resumableUploadPathURITemplateOverride",
      @"shouldSkipAuthorization",
      @"simpleUploadPathURITemplateOverride",
      @"uploadParameters",
      @"useMediaDownloadService",
    ];

    // ------------------------------------------------------------------------
    // Check our reserved word lists against the runtime.
    CheckReservedList([NSObject class], nsobjectReserved, YES, nil);

    // Skip anything on NSObject when checking GTLRQuery and GTLRObject.
    NSArray<NSString *> *nsobjectExceptions =
        [SGUtils publicNoArgSelectorsForClass:[NSObject class]
                                 skipPrefixed:NO];

    CheckReservedList([GTLRQuery class], gtlrQueryReserved, NO, nsobjectExceptions);
    // SGGenerator has a category on GTLRObject, so they aren't in the
    // reserved list, add them to the exception list.
    NSArray<NSString *> *gtlrobjectExceptions =
      [nsobjectExceptions arrayByAddingObjectsFromArray:@[
        @"sg_generator", @"sg_errorReportingName",
      ]];
    CheckReservedList([GTLRObject class], gtlrObjectReserved, NO, gtlrobjectExceptions);
    // ------------------------------------------------------------------------

    NSMutableDictionary *builderMappings = [NSMutableDictionary dictionary];
    NSMutableDictionary *builderComments = [NSMutableDictionary dictionary];

    // Add in the common mappings first. Language gets added second so things
    // like 'self' use the message about the language vs. NSObject's method.
    for (NSString *word in nsobjectReserved) {
      NSString *reason =
        [NSString stringWithFormat:@"Remapped to '%@Property' to avoid NSObject's '%@'.",
         word, word];
      [builderMappings setObject:[word stringByAppendingString:@"Property"]
                          forKey:word];
      [builderComments setObject:reason forKey:word];
    }
    for (NSString *word in langReserved) {
      NSString *reason =
      [NSString stringWithFormat:@"Remapped to '%@Property' to avoid language reserved word '%@'.",
       word, word];
      [builderMappings setObject:[word stringByAppendingString:@"Property"]
                          forKey:word];
      [builderComments setObject:reason forKey:word];
    }
    // Map etag to be nicer, but it doesn't need any reason in the comments.
    [builderMappings setObject:@"ETag" forKey:@"etag"];
    // We remap "id" to identifier, so we also have to remap "identifier".
    [builderMappings setObject:@"identifier" forKey:@"id"];
    [builderMappings setObject:@"identifierProperty" forKey:@"identifier"];
    [builderComments setObject:@"identifier property maps to 'id' in JSON (to avoid Objective C's 'id')."
                        forKey:@"id"];
    [builderComments setObject:@"identifierProperty property maps to 'identifier' in the JSON ('identifier' is reserved for remapping 'id')."
                        forKey:@"identifier"];

    // Now make a second set of builders for adding the things reserved on
    // Query vs. Object.
    NSMutableDictionary *builderMappings2 =
      [NSMutableDictionary dictionaryWithDictionary:builderMappings];
    NSMutableDictionary *builderComments2 =
      [NSMutableDictionary dictionaryWithDictionary:builderComments];

    // GTLRObject specific
    for (NSString *word in gtlrObjectReserved) {
      NSString *reason =
        [NSString stringWithFormat:@"Remapped to '%@Property' to avoid GTLRObject's '%@'.",
         word, word];
      [builderMappings setObject:[word stringByAppendingString:@"Property"]
                          forKey:word];
      [builderComments setObject:reason forKey:word];
    }

    // GTLRQuery specific
    for (NSString *word in gtlrQueryReserved) {
      NSString *reason =
        [NSString stringWithFormat:@"Remapped to '%@Property' to avoid GTLRQuery's '%@'.",
         word, word];
      [builderMappings2 setObject:[word stringByAppendingString:@"Property"]
                           forKey:word];
      [builderComments2 setObject:reason forKey:word];
    }

    objectReserved = [builderMappings copy];
    objectReservedComments = [builderComments copy];
    queryReserved = [builderMappings2 copy];
    queryReservedComments = [builderComments2 copy];
  }

  NSDictionary *result;
  NSDictionary *comments;
  switch (queryOrObject) {
    case kTypeQuery:
      result = queryReserved;
      comments = queryReservedComments;
      break;

    case kTypeObject:
      result = objectReserved;
      comments = objectReservedComments;
      break;
  }
  if (outCommentMap) *outCommentMap = comments;
  return result;
}

static NSString *OverrideName(NSString *name, EQueryOrObject queryOrObject,
                              NSString **outComment) {
  NSDictionary *comments = nil;
  NSDictionary *map = OverrideMap(queryOrObject, &comments);
  NSString *result = [map objectForKey:name];
  if (result && outComment) {
    *outComment = [comments objectForKey:name];
  }
  // No override. Return the name to simplify the flow for callers.
  if (result == nil) result = name;
  return result;
}

- (NSString *)sg_objcName {
  NSString *result = [self sg_propertyForKey:kObjCNameKey];
  if (result == nil) {
    result = [SGUtils objcName:self.sg_name shouldCapitalize:NO];
    NSString *comment = nil;
    result = OverrideName(result,
                          ( self.sg_parameter ? kTypeQuery : kTypeObject ),
                          &comment);
    [self sg_setProperty:result forKey:kObjCNameKey];
    if (comment) {
      [self sg_setProperty:comment forKey:kForcedNameCommentKey];
    }
  }
  return result;
}

- (NSString *)sg_forceNameComment {
  // Call objcName to make sure the value is set.
  (void)self.sg_objcName;
  NSString *result = [self sg_propertyForKey:kForcedNameCommentKey];
  return result;
}

// Helper to get the capitalized Objective-C form of the name.
- (NSString *)sg_capObjCName {
  NSString *result = [self sg_propertyForKey:kCapObjCNameKey];
  if (result == nil) {
    // We just use objcName and then capitalize the first letter. This way
    // all name overrides/checks are handled in one place.
    result = self.sg_objcName;
    result = [[[result substringToIndex:1] uppercaseString] stringByAppendingString:[result substringFromIndex:1]];
    [self sg_setProperty:result forKey:kCapObjCNameKey];
  }
  return result;
}

- (GTLRDiscovery_RestMethod *)sg_method {
  GTLRDiscovery_RestMethod *result =
    [[self sg_propertyForKey:kWrappedMethodKey] nonretainedObjectValue];
  return result;
}

- (BOOL)sg_isParameter {
  // Only valid on the top most schema, simply check if the method is set.
  BOOL result = (self.sg_method != nil);
  return result;
}

- (NSString *)sg_errorReportingName {
  return self.sg_fullSchemaName;
}

- (GTLRDiscovery_JsonSchema *)sg_parentSchema {
  GTLRDiscovery_JsonSchema *result =
      [[self sg_propertyForKey:kWrappedSchemaKey] nonretainedObjectValue];
  return result;
}

- (NSArray *)sg_fullSchemaPath:(BOOL)formatted
                foldArrayItems:(BOOL)foldArrayItems {
  NSMutableArray *builder = [NSMutableArray array];

  SGGenerator *generator = self.sg_generator;
  BOOL wasArray = NO;
  GTLRDiscovery_JsonSchema *walker = self;
  while (walker != nil) {
    NSString *name = walker.sg_name;
    GTLRDiscovery_JsonSchema *parent = walker.sg_parentSchema;
    BOOL isArray = [parent.type isEqual:@"array"];

    // Should it be formatted or not?
    if (formatted) {
      // The top level schema (no parent) can have poor names when they also
      // don't have a 'kind' for the server to go off of.  For this case, we
      // try to fix up some of the common bad things.
      if ((parent == nil) &&
          !walker.sg_parameter &&
          (walker.sg_kindToRegister == nil)) {

        NSString *initialName = name;

        // Use a loop so the order of things doesn't matter.  One correction per
        // cycle of the loop.
        while (1) {
          // Use lowercase so things only have to be checked in one case.
          NSString *lowerName = [name lowercaseString];
          NSUInteger nameLen = name.length;

          // We used to do some fixup for trailing version numbers (with and
          // without the '.' in the number), but that appears to no longer
          // be needed and as some apis have evolved they actually have real
          // reasons to have "V2" at the end of their scheme names.

          // Trailing 'json'
          if ([lowerName hasSuffix:@"json"] && nameLen != 4) {
            name = [name substringToIndex:nameLen - 4];
            continue;
          }

          // Service name on type (we add it ourselves).
          NSString *apiName = [generator.formattedAPIName lowercaseString];
          if ([lowerName hasPrefix:apiName] && nameLen != apiName.length) {
            name = [name substringFromIndex:apiName.length];
            continue;
          }

          // Nothing changed, out of here...
          break;
        }

        if ((generator.verboseLevel > 1) && (initialName != name)) {
          // Yes, we might do this more than once, but addWarning dedupes for
          // us.
          NSString *infoStr =
            [NSString stringWithFormat:@"schema '%@' has a poor name and no 'kind', using '%@'.",
             walker.sg_name, name];
          [generator addInfo:infoStr];
        }
      }

      // Format the name.
      name = [SGUtils objcName:name shouldCapitalize:YES];
    }

    // foldArrayItems allows the class names to avoid ending up like
    // "...ItemItem" for arrays of arrays.  This ends up with only one
    // instance of "Item" being there.
    if (foldArrayItems && wasArray && isArray) {
      [builder removeObjectAtIndex:0];
    }

    // Now it is usable...
    [builder insertObject:name atIndex:0];

    // If this is a parameter, its name is just the name on the method and
    // that might not result in something unique.  So we have to pull the
    // actual method name in also to help make sure it is unique.
    if ((parent == nil) && walker.sg_parameter) {
      // NOTE: This is leftover/kept from the RPC implementation. None of the
      // public apis seem to fall into this case any more when using REST.
      [generator addWarning:
         @"Trying to generate a class name for a schema that appears to be on a query method."
         @" This is an untested code path.  Please let us know about your hitting it."];
      NSArray *nameParts =
        [walker.sg_method.identifier componentsSeparatedByString:@"."];
      if (nameParts.count < 2) {
        [NSException raise:kFatalGeneration
                    format:@"Got a method.identifier (%@) with fewer than two segments",
         walker.sg_method.sg_name];
      }
      // Drop the service name.
      nameParts = [nameParts subarrayWithRange:NSMakeRange(1, nameParts.count - 1)];
      NSUInteger insertIndex = 0;
      for (__strong NSString *namePart in nameParts) {
        if (formatted) {
          namePart = [SGUtils objcName:namePart shouldCapitalize:YES];
        }
        [builder insertObject:namePart atIndex:insertIndex++];
      }
    }

    // Up to the parent
    walker = parent;
    wasArray = isArray;
  }

  return builder;
}

- (NSString *)sg_fullSchemaName {
  NSArray *parts = [self sg_fullSchemaPath:NO foldArrayItems:NO];
  NSString *result = [parts componentsJoinedByString:@"."];
  return result;
}

- (NSString *)sg_objcClassName {
  // Always use the resolved schema so we get real names.
  GTLRDiscovery_JsonSchema *resolvedSchema = self.sg_resolvedSchema;

  NSString *result = [resolvedSchema sg_propertyForKey:kSchemaObjCClassNameKey];
  if (result == nil) {
    NSArray *parts = [resolvedSchema sg_fullSchemaPath:YES foldArrayItems:YES];
    NSString *fullName = [parts componentsJoinedByString:@"_"];

    result = [NSString stringWithFormat:@"%@%@_%@",
              kProjectPrefix, self.sg_generator.formattedAPIName, fullName];

    [resolvedSchema sg_setProperty:result forKey:kSchemaObjCClassNameKey];
  }
  return result;
}

- (NSArray *)sg_childObjectSchemas {
  NSArray *result = [self sg_propertyForKey:kChildObjectSchemasKey];
  if (result == nil) {

    NSMutableArray *worker = [NSMutableArray array];

    [worker addObject:self];
    NSUInteger idx = 0;
    while (idx < worker.count) {
      // properties...
      GTLRDiscovery_JsonSchema *schema = [worker objectAtIndex:idx];

      // All of the properties that are objects or an array of objects count.

      NSArray *schemas = DictionaryObjectsSortedByKeys(schema.properties.additionalProperties);
      for (GTLRDiscovery_JsonSchema *subSchema in schemas) {
        if ([subSchema.type isEqual:@"object"]) {
          [worker addObject:subSchema];
        } else if ([subSchema.type isEqual:@"array"]) {
          GTLRDiscovery_JsonSchema *itemsSchema =
              [subSchema sg_itemsSchemaResolving:NO depth:NULL];
          if ([itemsSchema.type isEqual:@"object"]) {
            [worker addObject:itemsSchema];
          }
        }
      }

      // If the additonalProperties are objects or arrays of objects, they count.

      GTLRDiscovery_JsonSchema *additionalPropsSchema = schema.additionalPropertiesProperty;
      if ([additionalPropsSchema.type isEqual:@"object"]) {
        [worker addObject:additionalPropsSchema];
      } else if ([additionalPropsSchema.type isEqual:@"array"]) {
        GTLRDiscovery_JsonSchema *itemsSchema =
            [additionalPropsSchema sg_itemsSchemaResolving:NO depth:NULL];
        if ([itemsSchema.type isEqual:@"object"]) {
          [worker addObject:itemsSchema];
        }
      }
      ++idx;
    }

    // Drop self (added at the start) in getting the result.
    result = [worker subarrayWithRange:NSMakeRange(1, worker.count - 1)];
    [self sg_setProperty:result forKey:kChildObjectSchemasKey];
  }
  return result;
}

// Helper to resolve any $ref to the real schema definition.
- (GTLRDiscovery_JsonSchema *)sg_resolvedSchema {
  GTLRDiscovery_JsonSchema *result = [self sg_propertyForKey:kResolvedSchemaKey];
  if (result == nil) {
    GTLRDiscovery_RestDescription *api = self.sg_generator.api;
    result = self;
    NSString *schemaReference;
    while ((schemaReference = result.xRef) != nil) {
      GTLRDiscovery_JsonSchema *schema =
        [api.schemas.additionalProperties objectForKey:schemaReference];
      if (schema != nil) {
        result = schema;
      } else {
        [NSException raise:kFatalGeneration
                    format:@"Resolving schema '%@', referenced an undefined schema '%@'",
                           self.sg_fullSchemaName, schemaReference];

      }
    }

    [self sg_setProperty:result forKey:kResolvedSchemaKey];
  }
  return result;
}

// Helper to see if the object has has a single array containing objects to
// support making it a collection.
- (NSString *)sg_collectionItemsKey:(BOOL *)outSupportsPagination {
  // If it has an "items" we use that first no matter what".
  GTLRDiscovery_JsonSchema *itemsProperty =
    [self.properties additionalPropertyForName:@"items"];
  if ([itemsProperty.type isEqual:@"array"]) {
    GTLRDiscovery_JsonSchema *itemsSchema =
      [itemsProperty sg_itemsSchemaResolving:YES depth:NULL];
    if ([itemsSchema.type isEqual:@"object"]) {
      if (outSupportsPagination) {
        NSArray *allPropertyNames =
          [self.properties.additionalProperties.allValues valueForKey:@"sg_objcName"];
        *outSupportsPagination = [allPropertyNames containsObject:@"nextPageToken"];
      }
      return itemsProperty.sg_objcName;
    }
  }

  // Otherwise, if it has a nextPageToken and a single array of GTLObjects
  // then we make a collection out of it.
  GTLRDiscovery_JsonSchema *arrayProp;
  BOOL hasNextPageToken = NO;
  for (GTLRDiscovery_JsonSchema *property in self.properties.additionalProperties.allValues) {
    if ([property.sg_objcName isEqual:@"nextPageToken"]) {
      hasNextPageToken = YES;
    }

    if (![property.type isEqual:@"array"]) {
      continue;
    }

    GTLRDiscovery_JsonSchema *propItem =
      [property sg_itemsSchemaResolving:YES depth:NULL];
    if (![propItem.type isEqual:@"object"]) {
      continue;
    }

    // Found a second one, can't support collection.
    if (arrayProp != nil) {
      return nil;
    }

    arrayProp = property;
  }
  if (hasNextPageToken) {
    if (outSupportsPagination) *outSupportsPagination = YES;
    return arrayProp.sg_objcName;
  }
  return nil;
}

// Helper to extract the "kind" that this schema should be registered with.
- (NSString *)sg_kindToRegister {
  NSString *result = nil;

  // Pull the kind schema, and check that it is the right type and has a
  // value.
  GTLRDiscovery_JsonSchema *property =
    [self.properties additionalPropertyForName:@"kind"];
  if ([property.type isEqual:@"string"] &&
      property.defaultProperty.length > 0) {
    result = property.defaultProperty;
  }
  return result;
}

- (BOOL)sg_isLikelyInvalidUseOfKind {
  BOOL result = NO;

  GTLRDiscovery_JsonSchema *property =
    [self.properties additionalPropertyForName:@"kind"];
  if ([property.type isEqual:@"string"] &&
      property.defaultProperty.length == 0) {
    // Has a 'kind', but no default, odds are it is misusing the attribute.
    result = YES;
  }

  return result;
}

// Helper to format the parameter min/max into a range string.
- (NSString *)sg_formattedRange {
  NSString *paramMin = self.minimum;
  NSString *paramMax = self.maximum;
  if (paramMin.length > 0 && paramMax.length > 0) {
    // We don't worry about min/max being reversed or equal. Hopefully (like
    // everything else) the discovery information makes sense...
    return [NSString stringWithFormat:@"%@..%@", paramMin, paramMax];
  }
  return nil;
}

// Helper to format the parameter default into the constant name or a quoted
// value.
- (NSString *)sg_formattedDefault {
  NSString *paramDefault = self.defaultProperty;
  if (paramDefault.length > 0) {
    // If there is a default, handle the enums by showing the enum constant
    // name instead of the raw value.
    NSArray *enumValues = self.enumProperty;
    if (enumValues.count > 0) {
      // Hopefully if there is an enum, it has the default value so there
      // is a constant for it. But in case it doesn't, just quote the value.
      if ([enumValues containsObject:paramDefault]) {
        paramDefault = [self sg_constantNamed:paramDefault];
      } else {
        paramDefault = [NSString stringWithFormat:@"\"%@\"", paramDefault];
      }
    }
  }
  return paramDefault;
}

// Helper to generate a comment about the range and/or default value for
// the parameter.
- (NSString *)sg_rangeAndDefaultDescription {
  NSString *result = nil;

  NSString *paramRange = self.sg_formattedRange;
  NSString *paramDefault = self.sg_formattedDefault;

  BOOL hasRange = (paramRange.length > 0);
  BOOL hasDefault = (paramDefault.length > 0);

  if (hasRange && hasDefault) {
    result = [NSString stringWithFormat:@"Range %@, default %@",
              paramRange, paramDefault];
  } else if (hasRange) {
    result = [NSString stringWithFormat:@"Range %@", paramRange];
  } else if (hasDefault) {
    result = [NSString stringWithFormat:@"Default %@", paramDefault];
  }

  return result;
}

// Fetching the item's schema even if it is nested (array inside of array...),
// resolving controls if it also resolves the schema references along the way.
- (GTLRDiscovery_JsonSchema *)sg_itemsSchemaResolving:(BOOL)resolving
                                                depth:(NSInteger *)depth {
  GTLRDiscovery_JsonSchema *worker = self;
  NSInteger counter = 0;

  do {
    ++counter;
    worker = worker.items;
    if (resolving) {
      worker = worker.sg_resolvedSchema;
    }
  } while ([worker.type isEqual:@"array"]);

  if (depth) {
    *depth = counter;
  }
  return worker;
}

- (NSString *)sg_constantNamed:(NSString *)name {
  NSString *group = [NSString stringWithFormat:@"%@%@%@",
                     kProjectPrefix,
                     self.sg_generator.formattedAPIName,
                     self.sg_capObjCName];
  NSString *result = ConstantName(group, name);
  return result;
}

#pragma mark Mapping from Schema to object/query parameters

typedef struct {
  __unsafe_unretained NSString *objcType;
  BOOL                          asPointer;
  __unsafe_unretained NSString *objcPropertySemantics;
  __unsafe_unretained NSString *comment;
} SGTypeInfo;

typedef struct {
  __unsafe_unretained NSString   *type;
  __unsafe_unretained NSString   *format;
  SGTypeInfo                      objectTypeInfo;  // When it has to be a pointer.
  SGTypeInfo                      podTypeInfo;  // When it can be a plain old data type.
} SGTypeFormatMapping;

// Special marker for objcType to fetch the class from the "item" instead of
// the hardcoded value.
#define kUseItemsClass @"ITEMS_CLASS"

static SGTypeFormatMapping kObjectParameterMappings[] = {
  // http://code.google.com/apis/discovery/v1/reference.html#type-and-format-summary
  { @"any", nil,             { @"id", NO, @"strong", @"Can be any valid JSON type." },
                             { @"id", NO, @"strong", @"Can be any valid JSON type." } },

  { @"array", nil,           { @"NSArray", YES, @"strong", nil },
                             { @"NSArray", YES, @"strong", nil } },

  { @"boolean", nil,         { @"NSNumber", YES, @"strong", @"Uses NSNumber of boolValue." },
                             { @"BOOL", NO, @"assign", nil } },

  { @"integer", @"int32",    { @"NSNumber", YES, @"strong", @"Uses NSNumber of intValue." },
                             { @"NSInteger", NO, @"assign", nil } },
  { @"integer", @"uint32",   { @"NSNumber", YES, @"strong", @"Uses NSNumber of unsignedIntValue." },
                             { @"NSUInteger", NO, @"assign", nil } },

  { @"number", @"double",    { @"NSNumber", YES, @"strong", @"Uses NSNumber of doubleValue." },
                             { @"double", NO, @"assign", nil } },
  { @"number", @"float",     { @"NSNumber", YES, @"strong", @"Uses NSNumber of floatValue." },
                             { @"float", NO, @"assign", nil } },

  { @"object", nil,          { kUseItemsClass, YES, @"strong", nil },
                             { kUseItemsClass, YES, @"strong", nil } },

  { @"string", @"byte",      { @"NSString", YES, @"copy", @"Contains encoded binary data; GTLRBase64 can encode/decode (probably web-safe format)." },
                             { @"NSString", YES, @"copy", @"Contains encoded binary data; GTLRBase64 can encode/decode (probably web-safe format)." } },
  { @"string", @"date",      { @"GTLRDateTime", YES, @"strong", @"Date only (yyyy-mm-dd)."},
                             { @"GTLRDateTime", YES, @"strong", @"Date only (yyyy-mm-dd)."} },
  { @"string", @"date-time", { @"GTLRDateTime", YES, @"strong", nil },
                             { @"GTLRDateTime", YES, @"strong", nil }},
  { @"string", @"int64",     { @"NSNumber", YES, @"strong", @"Uses NSNumber of longLongValue." },
                             { @"long long", NO, @"assign", nil } },
  { @"string", @"uint64",    { @"NSNumber", YES, @"strong", @"Uses NSNumber of unsignedLongLongValue." },
                             { @"unsigned long long", NO, @"assign", nil } },
  { @"string", nil,          { @"NSString", YES, @"copy", nil },
                             { @"NSString", YES, @"copy", nil } },
  // This should be the same as "date-time".
  { @"string", @"google-datetime", { @"GTLRDateTime", YES, @"strong", nil },
                                   { @"GTLRDateTime", YES, @"strong", nil }},
  // Bridging https://github.com/google/protobuf/blob/master/src/google/protobuf/duration.proto
  // Uses a custom wrapper so folks don't have to worry about the "s" on the end
  // and because it is easy to end up with floating point issues if one isn't
  // careful.
  { @"string", @"google-duration", { @"GTLRDuration", YES, @"strong", nil },
                                   { @"GTLRDuration", YES, @"strong", nil } },
  // Bridging https://github.com/google/protobuf/blob/master/src/google/protobuf/field_mask.proto
  // Make it a plain string with a comment about format.
  { @"string", @"google-fieldmask", { @"NSString", YES, @"copy", @"String format is a comma-separated list of fields." },
                                    { @"NSString", YES, @"copy", @"String format is a comma-separated list of fields." } },
};

static SGTypeInfo *LookupTypeInfo(NSString *typeString,
                                  NSString *formatString,
                                  BOOL asObject) {
  // Find the match in the table
  for (uint32_t idx = 0; idx < ARRAY_COUNT(kObjectParameterMappings); ++idx) {
    if ([typeString isEqual:kObjectParameterMappings[idx].type] &&
        GTLR_AreEqualOrBothNil(kObjectParameterMappings[idx].format, formatString)) {
      if (asObject) {
        return &(kObjectParameterMappings[idx].objectTypeInfo);
      } else {
        return &(kObjectParameterMappings[idx].podTypeInfo);
      }
    }
  }

  return nil;
}

- (void)sg_getObjectParamObjCType:(NSString **)objcType
                        asPointer:(BOOL *)asPointer
            objcPropertySemantics:(NSString **)objcPropertySemantics
                          comment:(NSString **)comment {
  // NOTE: Here we are creating data objects.  Objects need to support values
  // being unset.  That means we need to wrap ints, bools, etc. in NSNumber so
  // nil can mean unset.

  // Resolve the schema to get real types let everything else uses
  // the references to get local names.
  GTLRDiscovery_JsonSchema *resolvedSchema = self.sg_resolvedSchema;

  NSString *schemaType = resolvedSchema.type;
  NSString *schemaFormat = resolvedSchema.format;

  NSAssert(resolvedSchema.repeated == nil,
           @"Object scheme should use 'type' of 'array' and not 'repeated' : true");

  // Look it up...
  SGTypeInfo *typeInfo = LookupTypeInfo(schemaType, schemaFormat, YES);
  if (typeInfo == nil) {
    [NSException raise:kFatalGeneration
                format:@"Looking at schema '%@', found a type/format pair of '%@/%@', and don't how to map that to Objective-C",
     resolvedSchema.sg_fullSchemaName, schemaType, schemaFormat];
  }

  if ([typeInfo->objcType isEqual:kUseItemsClass]) {
    *objcType = resolvedSchema.sg_objcClassName;
  } else {
    *objcType = typeInfo->objcType;
  }

  if (asPointer) *asPointer = typeInfo->asPointer;
  if (objcPropertySemantics) *objcPropertySemantics = typeInfo->objcPropertySemantics;
  if (comment) *comment = typeInfo->comment;

  if ([schemaType isEqual:@"array"]) {
    NSInteger depth = 0;
    GTLRDiscovery_JsonSchema *itemsSchema =
        [resolvedSchema sg_itemsSchemaResolving:YES depth:&depth];
    NSString *itemsObjCType = nil, *itemsComment = nil;
    if (itemsSchema == nil) {
      itemsObjCType = @"id";
      NSString *msg =
        [NSString stringWithFormat:@"Schema %@ is array but lacks items, assuming \"any\".",
                                   [self sg_fullSchemaName]];
      [self.sg_generator addWarning:msg];
    } else {
      [itemsSchema sg_getObjectParamObjCType:&itemsObjCType
                                   asPointer:NULL
                       objcPropertySemantics:NULL
                                     comment:&itemsComment];
    }
    if (comment && (itemsComment.length > 0)) {
      *comment = itemsComment;
    }
    if ([itemsObjCType isEqual:@"id"]) {
      // objcType is already "NSArray", and there's no need for a generic
      // since it can hold anything.
    } else {
      *objcType = [NSString stringWithFormat:@"NSArray<%@ *>", itemsObjCType];
      if ((itemsComment.length > 0) && comment) {
        *comment = itemsComment;
      }
    }
    while (--depth > 0) {
      *objcType = [NSString stringWithFormat:@"NSArray<%@ *>", *objcType];
    }
  }
}

- (void)sg_getQueryParamObjCType:(NSString **)objcType
                       asPointer:(BOOL *)asPointer
           objcPropertySemantics:(NSString **)objcPropertySemantics
                         comment:(NSString **)comment
                  itemsClassName:(NSString **)itemsClassName {

  // NOTE: This is on Parameters, meaning we're query objects.  Since we get
  // default values and we don't need to communicate the "removal" of some
  // property, we can use raw NSInteger, BOOL, etc. for the values.

  // Resolve the schema to get real types. Let everything else use
  // the references to get local names.
  GTLRDiscovery_JsonSchema *resolvedSchema = self.sg_resolvedSchema;

  NSString *paramType = resolvedSchema.type;
  NSString *paramFormat = resolvedSchema.format;

  // Repeating means it's an array.  But when schemas are inlined, it could
  // also be type 'array'.  So pick them off, and figure out the type/format
  // to look up for the items within the array.
  if (resolvedSchema.repeated || [paramType isEqual:@"array"]) {

    if (asPointer) *asPointer = YES;
    if (objcPropertySemantics) *objcPropertySemantics = @"strong";

    NSInteger depth = 1;
    GTLRDiscovery_JsonSchema *itemsSchema = resolvedSchema;

    if ([paramType isEqual:@"array"]) {
      // type 'array' means pull the info off the item (like objects).
      itemsSchema = [resolvedSchema sg_itemsSchemaResolving:YES depth:&depth];
      if (itemsSchema == nil) {
        paramType = @"any";
        paramFormat = nil;
        SGGenerator *generator = self.sg_generator;
        NSString *msg =
          [NSString stringWithFormat:@"Schema %@ is array but lacks items, assuming \"any\".",
                                     [self sg_fullSchemaName]];
        [generator addWarning:msg];
      } else {
        paramType = itemsSchema.type;
        paramFormat = itemsSchema.format;
      }
    }

    // Look up the item info.
    SGTypeInfo *typeInfo = LookupTypeInfo(paramType, paramFormat, YES);
    if (typeInfo == nil) {
      [NSException raise:kFatalGeneration
                  format:@"Looking at parameter '%@:%@', found a repeating type/format pair of '%@/%@', and don't how to map that to Objective-C",
       self.sg_method.sg_name, self.sg_name, paramType, paramFormat];
    }

    NSString *localItemsClassName = typeInfo->objcType;
    if ([localItemsClassName isEqual:kUseItemsClass]) {
      if (resolvedSchema == itemsSchema) {
        [NSException raise:kFatalGeneration
                    format:@"Looking at parameter '%@:%@', found a repeating object, currently can't generate class names for those correctly.",
         self.sg_method.sg_name, self.sg_name];
      }
      localItemsClassName = itemsSchema.sg_objcClassName;
    }

    if (itemsClassName) *itemsClassName = localItemsClassName;
    if (comment && (typeInfo->comment.length > 0)) {
      *comment = typeInfo->comment;
    }

    if ([localItemsClassName isEqual:@"id"]) {
      // Accepts anything, no need for generics.
      *objcType = @"NSArray";
    } else {
      *objcType = [NSString stringWithFormat:@"NSArray<%@ *>", localItemsClassName];
    }
    while (--depth > 0) {
      *objcType = [NSString stringWithFormat:@"NSArray<%@ *>", *objcType];
    }

  } else {

    // Look it up
    SGTypeInfo *typeInfo = LookupTypeInfo(paramType, paramFormat, NO);
    if (typeInfo == nil) {
      [NSException raise:kFatalGeneration
                  format:@"Looking at parameter '%@:%@', found a type/format pair of '%@/%@', and don't how to map that to Objective-C",
       self.sg_method.sg_name, self.sg_name, paramType, paramFormat];
    }

    if ([typeInfo->objcType isEqual:kUseItemsClass]) {
      *objcType = resolvedSchema.sg_objcClassName;
    } else {
      *objcType = typeInfo->objcType;
    }

    if (asPointer) *asPointer = typeInfo->asPointer;
    if (objcPropertySemantics) *objcPropertySemantics = typeInfo->objcPropertySemantics;
    if (comment) *comment = typeInfo->comment;
    if (itemsClassName) *itemsClassName = nil;

  }

}

@end

@implementation GTLRDiscovery_RestResource (SGGeneratorAdditions)

- (NSString *)sg_name {
  NSString *result = [self sg_propertyForKey:kNameKey];
  return result;
}

@end

@implementation GTLRDiscovery_RestMethod (SGGeneratorAdditions)

- (NSString *)sg_name {
  NSString *result = [self sg_propertyForKey:kNameKey];
  return result;
}

// Sorted by parameterOrder first, and then alphabetical for the rest. This
// list without the "request".
- (NSArray *)sg_sortedParameters {
  NSArray *result = [self sg_propertyForKey:kSortedParametersKey];
  if (result == nil) {
    // sg_sortedParametersWithRequest will calculate and save the value.
    (void)self.sg_sortedParametersWithRequest;
    result = [self sg_propertyForKey:kSortedParametersKey];
  }
  return result;
}

// Sorted by parameterOrder first, and then alphabetical for the rest. This
// adds the "request" value into the list.
- (NSArray *)sg_sortedParametersWithRequest {
  NSArray *result = [self sg_propertyForKey:kSortedParametersWithRequestKey];
  if (result == nil) {
    NSDictionary *paramsDict = self.parameters.additionalProperties;
    NSArray *allKeys = paramsDict.allKeys;

    NSArray *paramOrder = self.parameterOrder;
    NSMutableArray *remainingKeys = [NSMutableArray arrayWithArray:allKeys];
    if (paramOrder.count > 0) {
      [remainingKeys removeObjectsInArray:paramOrder];
    }
    [remainingKeys sortUsingSelector:@selector(caseInsensitiveCompare:)];

    NSArray *allOrderedKeys;
    if (paramOrder.count > 0) {
      allOrderedKeys = [paramOrder arrayByAddingObjectsFromArray:remainingKeys];
    } else {
      allOrderedKeys = remainingKeys;
    }

    // Calculate the value for sortedParameters and save it.
    NSArray *sortedParameters = [paramsDict objectsForKeys:allOrderedKeys
                                            notFoundMarker:[NSNull null]];
    [self sg_setProperty:sortedParameters forKey:kSortedParametersKey];

    // Calculate the result and save it.
    if (self.request != nil) {
      NSMutableArray *worker = [NSMutableArray arrayWithArray:sortedParameters];
      [worker insertObject:self.request
                   atIndex:0];
      result = [NSArray arrayWithArray:worker];
    } else {
      result = sortedParameters;
    }
    [self sg_setProperty:result forKey:kSortedParametersWithRequestKey];
  }
  return result;
}

- (NSString *)sg_resumableUploadPathOverride {
  // Set in sg_calculateMediaPaths.
  NSString *result = [self sg_propertyForKey:kResumableUploadPathOverrideKey];
  return result;
}

- (NSString *)sg_simpleUploadPathOverride {
  // Set in sg_calculateMediaPaths.
  NSString *result = [self sg_propertyForKey:kSimpleUploadPathOverrideKey];
  return result;
}

@end

@implementation GTLRDiscovery_RestMethod_Request (SGGeneratorAdditions)

- (GTLRDiscovery_JsonSchema *)sg_resolvedSchema {
  // These aren't real schema, so look up their references (and resolve them).
  GTLRDiscovery_JsonSchema *result = [self sg_propertyForKey:kResolvedSchemaKey];
  if (result == nil) {
    if (self.xRef) {
      GTLRDiscovery_JsonSchema *schema =
        [self.sg_generator.api.schemas.additionalProperties objectForKey:self.xRef];
      if (schema != nil) {
        result = schema.sg_resolvedSchema;
      } else {
        [NSException raise:kFatalGeneration
                    format:@"Resolving request schema '%@', referenced an undefined schema '%@'",
         [self sg_propertyForKey:kNameKey], self.xRef];
      }
    } else {
      [NSException raise:kFatalGeneration
                  format:@"Resolving request schema '%@', there was no value for '$ref':\n%@",
       [self sg_propertyForKey:kNameKey], self.JSON];
    }

    [self sg_setProperty:result forKey:kResolvedSchemaKey];
  }
  return result;
}

@end

@implementation GTLRDiscovery_RestMethod_Response (SGGeneratorAdditions)

- (GTLRDiscovery_JsonSchema *)sg_resolvedSchema {
  // These aren't real schema, so look up their references (and resolve them).
  GTLRDiscovery_JsonSchema *result = [self sg_propertyForKey:kResolvedSchemaKey];
  if (result == nil) {
    if (self.xRef) {
      GTLRDiscovery_JsonSchema *schema =
        [self.sg_generator.api.schemas.additionalProperties objectForKey:self.xRef];
      if (schema != nil) {
        result = schema.sg_resolvedSchema;
      } else {
        [NSException raise:kFatalGeneration
                    format:@"Resolving response schema '%@', referenced an undefined schema '%@'",
         [self sg_propertyForKey:kNameKey], self.xRef];
      }
    } else {
      [NSException raise:kFatalGeneration
                  format:@"Resolving response schema '%@', there was no value for '$ref':\n%@",
       [self sg_propertyForKey:kNameKey], self.JSON];
    }

    [self sg_setProperty:result forKey:kResolvedSchemaKey];
  }
  return result;
}

@end
