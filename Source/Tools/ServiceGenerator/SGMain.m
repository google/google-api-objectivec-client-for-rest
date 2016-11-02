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

#if !__has_feature(objc_arc)
#error "This file needs to be compiled with ARC enabled."
#endif

#ifndef STRIP_GTM_FETCH_LOGGING
 #error Logging should always be enabled so the --httpLogDir option will work.
#endif
#if STRIP_GTM_FETCH_LOGGING
 #error Logging should always be enabled so the --httpLogDir option will work.
#endif

// This tool attempts to generate as much as possible for services from the
// Google APIs Discovery Service documents.

#import <Foundation/Foundation.h>
#include <getopt.h>
#include <libgen.h>
#include <mach-o/dyld.h>
#include <unistd.h>

#import "GTLRDiscovery.h"
#import "GTMSessionFetcherLogging.h"

#import "SGGenerator.h"
#import "SGUtils.h"


typedef struct {
  const char *arg;
  const char *desc; // Gets wrapped when printed
} ArgInfo;

static ArgInfo requiredFlags[] = {
  { "--outputDir PATH",
      "The destination directory for writing the generated files."
  },
};

static ArgInfo optionalFlags[] = {
  { "--discoveryRootURL URL",
    "Instead of discovery's default base URL, use the specified base URL as"
    " the location to send the requests.  This is useful for running against a"
    " custom or prerelease server."
  },
  { "--gtlrFrameworkName NAME",
    "Will generate sources that include GTLR's headers as if they are in a"
    " framework with the given name.  If you are using GTLR via CocoaPods,"
    " you'll likely want to pass \"GoogleApiClientForRest\" as the value for"
    " this."
  },
  { "--apiLogDir DIR",
    "Write out a file into DIR for each JSON API description processed.  These"
    " can be useful for reporting bugs if generation fails with an error."
  },
  { "--httpLogDir PATH",
    "Turn on the HTTP fetcher logging and set it to write to PATH.  This"
    " can be useful for diagnosing errors on discovery fetches."
  },
  { "--generatePreferred",
    "Causes the list of services to be collected, and all preferred"
    " services to be generated."
  },
  {
    "--httpHeader NAME:VALUE",
    "Causes the given NAME/VALUE pair to be added as an HTTP header on *all*"
    " HTTP requests made by the generator.  Can be used repeatedly to"
    " provide additional header pairs."
  },
  {
    "--formattedName [SERVICE[:VERSION]=]NAME",
    "Allows for overriding of service name in files, classes, etc. with NAME."
    " When only generating one service, the argument can just be NAME.  If"
    " generating more that one, SERVICE[:VERSION]= are used to say what service"
    " (and potentially specific version) a given override applies too.  Can be"
    " used repeatedly to provide several overrides when generating a multiple"
    " services in a single run."
  },
  { "--addServiceNameDir yes|no  Default: no",
    "Causes the generator to add a directory with the service name"
    " in the outputDir for the files. This is useful for generating"
    " multiple services."
  },
  { "--removeUnknownFiles yes|no  Default: no",
    "By default, the generator will report unknown files in the"
    " output directory, as commonly happens when classes go away"
    " in a new API version. This option causes the generator to also"
    " remove the unknown files."
  },
  { "--rootURLOverrides yes|no  Default: yes",
    "Causes any API root URL for a Google sandbox server to be replaced with"
    " the googleapis.com root instead."
  },
  {
    "--useLegacyObjectClassNames yes|no  Default: no",
    "Causes the generated names for object classes to not use underscores to"
    " provide scoping of nested classes. This can result in naming collisions."
  },
  { "--messageFilter PATH",
    "A json file containing the the expected messages that should be suppressed"
    " during generation. The content is a dictionary with keys 'INFO' and "
    " 'WARNING'; their values are lists of string with the message to filter"
    " away (exactly as it is reported during a run). Error message can not be"
    " filtered away."
  },
  { "--auditJSON",
    "Causes the API's JSON to get audited for anything that isn't expected"
    " according to the discovery document."
  },
  { "--guessFormattedNames",
    "If the API lacks a canonicalName, try guessing a formatted name from the"
    " API's title. NOTE: If the API later adds a canonicalName, it might not"
    " match the guessed name, causing changes in generated symbols, so using"
    "this option comes with some risk."
  },
  { "--verbose",
    "Generate more verbose output.  Can be used more than once."
  },
  { "--brief",
    "Drops some of the common output to be less noisy."
  },
};


static ArgInfo positionalArgs[] = {
  { "service:version",
      "The description of the given [service]/[version] pair is fetched and"
      " the files for it are generated.  When using --generatePreferred,"
      " version can be '-' to skip generating the named service. If the version"
      " starts with '-' (i.e. - '-v1'), it will only skip that specific"
      " version of the named service."},
  { "http[s]://url/to/rest_description_json",
      "A URL to download containing the description of a service to"
      " generate." },
  { "path/to/rest_description.json",
      "The path to a text file containing the description of a service to"
      " generate." },
};

// Tool Exit codes:
//   0: Success
//  0x: Error during setup (args, etc.)
//  1x: Error in the data fetch
//  2x: Error while generating
//  3x: Error while writing out results

// Strings for plain/colored output.
static const char kERROR_Plain[]     = "ERROR:";
static const char kERROR_Colored[]   = "\033[1;31mERROR:\033[0m"; // bold+red
static const char kWARNING_Plain[]   = "WARNING:";
static const char kWARNING_Colored[] = "\033[1;35mWARNING:\033[0m"; // bold+magenta
static const char kINFO_Plain[]      = "INFO:";
static const char kINFO_Colored[]    = "\033[1;33mINFO:\033[0m"; // bold+yellow
static const char kEmBegin_COLORED[] = "\033[1m"; // bold
static const char kEmEnd_COLORED[]   = "\033[0m";

// Constants, updated in main, to get basic or color support.
static const char *kERROR            = kERROR_Plain;
static const char *kWARNING          = kWARNING_Plain;
static const char *kINFO             = kINFO_Plain;
static const char *kEmBegin          = "";
static const char *kEmEnd            = "";

static NSString *kGlobalFormattedNameKey = @"__*__";
static NSString *kGlobalLegacyNamesKey = @"__*__";

typedef enum {
  SGMain_ParseArgs,
  SGMain_Directory,
  SGMain_Describe,
  SGMain_Wait,
  SGMain_Generate,
  SGMain_WriteFiles,
  SGMain_Done
} SGMainState;

@interface SGMain : NSObject

@property(assign) int argc;
@property(assign) char * const *argv;

- (instancetype)initWithArgc:(int)argc argv:(char * const *)argv;
- (int)run;

@end

@interface SGMain ()

@property(copy) NSString *appName;
@property(copy) NSString *outputDir;
@property(copy) NSString *discoveryRootURLString;
@property(copy) NSString *gtlrFrameworkName;
@property(copy) NSString *apiLogDir;
@property(copy) NSString *httpLogDir;
@property(copy) NSString *messageFilterPath;
@property(strong) NSMutableDictionary *messageFilters;
@property(assign) BOOL generatePreferred;
@property(assign) BOOL addServiceNameDir;
@property(assign) BOOL removeUnknownFiles;
@property(assign) BOOL rootURLOverrides;
@property(assign) BOOL auditJSON;
@property(assign) BOOL guessFormattedNames;
@property(assign) BOOL briefOutput;
@property(assign) NSUInteger verboseLevel;
@property(strong) NSMutableDictionary *additionalHTTPHeaders;
@property(strong) NSMutableDictionary *formattedNames;
@property(strong) NSMutableSet *apisUsingLegacyObjectNaming;

@property(strong) GTLRDiscoveryService *discoveryService;
@property(strong) NSMutableArray *apisToFetch;
@property(strong) NSMutableSet *apisToSkip;
@property(strong) NSMutableArray *collectedApis;
@property(strong) NSMutableDictionary *generatedData;

@property(assign) int numberOfActiveNetworkActions;
@property(assign) SGMainState state;
@property(assign) SGMainState postWaitState;
@property(assign) int status;
@property(assign) BOOL printedError;
@property(assign) BOOL didPrintUsage;

// "print*" goes to stdout, "report*" goes to stderr. In brief mode, the
// section/subsection is only printed in something else does get printed.
- (void)printSection:(NSString *)str;
- (void)printSubsection:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)print:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)printBold:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
// Print only when not in brief mode.
- (void)maybePrint:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

- (void)reportPrefixed:(NSString *)prefix
                  info:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
- (void)reportWarning:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)reportPrefixed:(NSString *)prefix
               warning:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
- (void)reportError:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end

// Compares two files allowing differences for the year.
static BOOL HaveFileStringsChanged(NSString *oldFile, NSString *newFile) {
  // If they are difference sizes, then clearly they are different.
  if (oldFile.length != newFile.length) {
    return YES;
  }

  // Exact match?  Yes-done.
  if ([oldFile isEqual:newFile]) {
    return NO;
  }

  return YES;
}

@implementation SGMain {
  NSString *_queuedOutputSection;
  NSString *_queuedOutputSubSection;
}

@synthesize argc = _argc,
            argv = _argv;

@synthesize appName = _appName,
            outputDir = _outputDir,
            discoveryRootURLString = _discoveryRootURLString,
            gtlrFrameworkName = _gtlrFrameworkName,
            apiLogDir = _apiLogDir,
            httpLogDir = _httpLogDir,
            messageFilterPath = _messageFilterPath,
            messageFilters = _messageFilters,
            generatePreferred = _generatePreferred,
            addServiceNameDir = _addServiceNameDir,
            removeUnknownFiles = _removeUnknownFiles,
            rootURLOverrides = _rootURLOverrides,
            auditJSON = _auditJSON,
            guessFormattedNames = _guessFormattedNames,
            verboseLevel = _verboseLevel,
            briefOutput = _briefOutput,
            additionalHTTPHeaders = _additionalHTTPHeaders,
            formattedNames = _formattedNames,
            apisUsingLegacyObjectNaming = _apisUsingLegacyObjectNaming,
            discoveryService = _discoveryService,
            numberOfActiveNetworkActions = _numberOfActiveNetworkActions,
            apisToFetch = _apisToFetch,
            apisToSkip = _apisToSkip,
            collectedApis = _collectedApis,
            generatedData = _generatedData,
            state = _state,
            postWaitState = _postWaitState,
            status = _status,
            printedError = _printedError,
            didPrintUsage = _didPrintUsage;

- (instancetype)initWithArgc:(int)argc argv:(char * const *)argv {
  self = [super init];
  if (self != nil) {
    _argc = argc;
    _argv = argv;
    _appName = [[NSString alloc] initWithUTF8String:basename(self.argv[0])];
    _additionalHTTPHeaders = [[NSMutableDictionary alloc] init];
    _formattedNames = [[NSMutableDictionary alloc] init];
    _apisUsingLegacyObjectNaming = [[NSMutableSet alloc] init];
    _apisToFetch = [[NSMutableArray alloc] init];
    _apisToSkip = [[NSMutableSet alloc] init];
    _collectedApis = [[NSMutableArray alloc] init];
    _generatedData = [[NSMutableDictionary alloc] init];
    _rootURLOverrides = YES;

    _discoveryService = [[GTLRDiscoveryService alloc] init];
    _discoveryService.allowInsecureQueries = YES;

    // We aren't bundled, so add a good UA.
    _discoveryService.userAgent = @"com.google.ServiceGeneratorREST";
  }
  return self;
}

- (int)run {

  while (self.state != SGMain_Done) {
    @autoreleasepool {
      switch (self.state) {
        case SGMain_ParseArgs:
          [self stateParseArgs];
          break;
        case SGMain_Directory:
          [self stateDirectory];
          break;
        case SGMain_Describe:
          [self stateDescribe];
          break;
        case SGMain_Wait:
          [self stateWait];
          break;
        case SGMain_Generate:
          [self stateGenerate];
          break;
        case SGMain_WriteFiles:
          [self stateWriteFiles];
          break;
        case SGMain_Done:
          break;
      }
    }
  }

  return self.status;
}

- (void)printUsage:(FILE *)outputFile brief:(BOOL)brief {
  NSMutableString *builder = [self.appName mutableCopy];
  for (uint32_t idx = 0; idx < ARRAY_COUNT(requiredFlags); ++idx) {
    ArgInfo *info = &requiredFlags[idx];
    [builder appendFormat:@" %s", info->arg];
  }
  [builder appendFormat:@" [FLAGS] [ARGS]"];

  fprintf(outputFile, "\nUsage: %s\n", builder.UTF8String);
  fprintf(outputFile, "\n");

  if (brief) {
    fprintf(outputFile, "Use --help to see the full help.\n");
  } else {
    fprintf(outputFile, "  Required Flags:\n\n");
    for (uint32_t idx = 0; idx < ARRAY_COUNT(requiredFlags); ++idx) {
      ArgInfo *info = &requiredFlags[idx];

      NSString *wrapped = [SGUtils stringOfLinesFromString:@(info->desc)
                                                linePrefix:@"        "];
      fprintf(outputFile, "    %s\n", info->arg);
      fprintf(outputFile, "%s\n", wrapped.UTF8String);
    }

    fprintf(outputFile, "  Optional Flags:\n\n");
    for (uint32_t idx = 0; idx < ARRAY_COUNT(optionalFlags); ++idx) {
      ArgInfo *info = &optionalFlags[idx];

      NSString *wrapped = [SGUtils stringOfLinesFromString:@(info->desc)
                                                linePrefix:@"        "];
      fprintf(outputFile, "    %s\n", info->arg);
      fprintf(outputFile, "%s\n", wrapped.UTF8String);
    }

    fprintf(outputFile, "  Arguments:\n\n");
    NSString *comment = @"Multiple arguments can be given on the command line.";
    NSString *wrappedComment = [SGUtils stringOfLinesFromString:comment
                                                     linePrefix:@"    "];
    fprintf(outputFile, "%s\n", wrappedComment.UTF8String);
    for (uint32_t idx = 0; idx < ARRAY_COUNT(positionalArgs); ++idx) {
      ArgInfo *info = &positionalArgs[idx];

      NSString *wrapped = [SGUtils stringOfLinesFromString:@(info->desc)
                                                linePrefix:@"        "];
      fprintf(outputFile, "    %s\n", info->arg);
      fprintf(outputFile, "%s\n", wrapped.UTF8String);
    }
  }

  self.didPrintUsage = YES;
  self.status = 2;
  self.state = SGMain_Done;
}

- (void)maybeLogAPI:(GTLRDiscovery_RestDescription *)api {
  if (self.apiLogDir == nil) return;

  NSString *fileName = [NSString stringWithFormat:@"%@_%@.json",
                        api.name, api.version];
  NSString *filePath = [self.apiLogDir stringByAppendingPathComponent:fileName];
  NSError *writeErr = nil;
  if (![api.JSONString writeToFile:filePath
                        atomically:YES
                          encoding:NSUTF8StringEncoding
                             error:&writeErr]) {
    [self reportWarning:@"Failed to write api file at '%@'. Error: %@",
     fileName, writeErr];
  }
}

- (void)reportMessage:(NSString *)message
                 type:(SGGeneratorHandlerMessageType)msgType
               leader:(NSString *)leader {
  const char *typeStr;
  NSString *filterKey;
  switch (msgType) {
    case kSGGeneratorHandlerMessageError:
      typeStr = kERROR;
      filterKey = nil;
      self.printedError = YES;
      break;

    case kSGGeneratorHandlerMessageWarning:
      typeStr = kWARNING;
      filterKey = @"WARNING";
      break;

    case kSGGeneratorHandlerMessageInfo:
      typeStr = kINFO;
      filterKey = @"INFO";
      break;
  }

  if (filterKey) {
    NSMutableArray *filterMessageList = self.messageFilters[filterKey];
    NSUInteger idx = [filterMessageList indexOfObject:message];
    if (filterMessageList && (idx != NSNotFound)) {
      [filterMessageList removeObjectAtIndex:idx];
      // Out of here to not print the message.
      return;
    }
  }

  [self flushOutputSections];

  if (leader == nil) leader = @"";
  NSMutableString *wrappedIndent = [@"\n  " mutableCopy];
  for (NSUInteger x = 0; x < leader.length; ++x) {
    [wrappedIndent appendString:@" "];
  }
  message = [message stringByReplacingOccurrencesOfString:@"\n"
                                               withString:wrappedIndent];

  fprintf(stderr, "%s%s %s\n", leader.UTF8String, typeStr, message.UTF8String);
}

- (void)flushOutputSections {
  if (_queuedOutputSection.length) {
    printf("%s:\n", _queuedOutputSection.UTF8String);
    _queuedOutputSection = nil;
  }
  if (_queuedOutputSubSection.length) {
    printf("%s\n", _queuedOutputSubSection.UTF8String);
    _queuedOutputSubSection = nil;
  }
}

- (void)printSection:(NSString *)str {
  _queuedOutputSection = [str copy];
  _queuedOutputSubSection = nil;

  // If not brief, flush it now to print.
  if (!self.briefOutput) {
    [self flushOutputSections];
  }
}

- (void)printSubsection:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  _queuedOutputSubSection = [[NSString alloc] initWithFormat:format arguments:args];
  va_end(args);

  // If not brief, flush it now to print.
  if (!self.briefOutput) {
    [self flushOutputSections];
  }
}

- (void)maybePrint:(NSString *)format, ... {
  if (self.briefOutput) {
    return;
  }
  va_list args;
  va_start(args, format);

  [self flushOutputSections];

  NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
  printf("%s\n", message.UTF8String);

  va_end(args);
}

- (void)print:(NSString *)format, ...{
  va_list args;
  va_start(args, format);

  [self flushOutputSections];

  NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
  printf("%s\n", message.UTF8String);

  va_end(args);
}

- (void)printBold:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  [self flushOutputSections];

  NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
  printf("%s%s%s\n", kEmBegin, message.UTF8String, kEmEnd);

  va_end(args);
}

- (void)reportPrefixed:(NSString *)prefix info:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
  [self reportMessage:message type:kSGGeneratorHandlerMessageInfo leader:prefix];

  va_end(args);
}

- (void)reportWarning:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
  [self reportMessage:message type:kSGGeneratorHandlerMessageWarning leader:nil];

  va_end(args);
}

- (void)reportPrefixed:(NSString *)prefix warning:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
  [self reportMessage:message type:kSGGeneratorHandlerMessageWarning leader:prefix];

  va_end(args);
}

- (void)reportError:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
  [self reportMessage:message type:kSGGeneratorHandlerMessageError leader:nil];

  va_end(args);
}

- (BOOL)collectAPIFromURL:(NSURL *)url
            reportingName:(NSString *)reportingName
           reportProgress:(BOOL)reportProgress {
  if (reportProgress) {
    [self maybePrint:@" + Fetching %@", reportingName];
  }

  GTMSessionFetcherService *fetcherService = self.discoveryService.fetcherService;
  GTMSessionFetcher *fetcher = [fetcherService fetcherWithURL:url];
  fetcher.comment = [@"Fetching: " stringByAppendingString:reportingName];
  fetcher.allowLocalhostRequest = YES;
  fetcher.allowedInsecureSchemes = @[ @"file", @"http" ];
  NSString *requestUserAgent = self.discoveryService.requestUserAgent;
  [fetcher setRequestValue:requestUserAgent forHTTPHeaderField:@"User-Agent"];
  if (!url.fileURL) {
    [self.additionalHTTPHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                                    NSString *value,
                                                                    BOOL *stop) {
      [fetcher setRequestValue:value forHTTPHeaderField:key];
    }];
  }

  self.numberOfActiveNetworkActions += 1;
  [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *fetchError) {
    self.numberOfActiveNetworkActions -= 1;

    NSDictionary *responseHeaders = fetcher.responseHeaders;
    NSString *responseContentType = [responseHeaders objectForKey:@"Content-Type"];
    BOOL bodyHasJSON = ((url.fileURL ||  // Assume file urls are json.
                         [responseContentType hasPrefix:@"application/json"]) &&
                        (data.length > 0));

    NSError *parseErr = nil;
    NSMutableDictionary *json = nil;
    if (bodyHasJSON) {
      json =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingMutableContainers
                                          error:&parseErr];
    }

    if (fetchError) {
      NSError *reportError = fetchError;
      if (json) {
        NSMutableDictionary *errorJSON = [json valueForKey:@"error"];
        if (errorJSON) {
          GTLRErrorObject *errorObject = [GTLRErrorObject objectWithJSON:errorJSON];
          reportError = [errorObject foundationError];
        }
      }
      [self reportError:@"Failed to fetch the api description %@, error: %@",
       reportingName, reportError];
      if (parseErr) {
        [self reportError:@"(reply was JSON, but it failed to parse: %@)", parseErr];
      }
      self.state = SGMain_Done;
      return;
    }

    if (parseErr != nil) {
      [self reportError:@"Failed to parse the api description %@, error: %@",
       reportingName, parseErr];
      self.state = SGMain_Done;
      return;
    }

    if (json == nil) {
      // At this point, the data wasn't typed as json and there were no other errors, give up.
      [self reportError:@"Response didn't appear to be JSON."];
      self.state = SGMain_Done;
      return;
    }

    // Don't use a default class, a valid description will have a 'kind' to
    // create the right thing.
    GTLRDiscovery_RestDescription *api = (GTLRDiscovery_RestDescription *)
      [GTLRObject objectForJSON:json
                   defaultClass:nil
            objectClassResolver:_discoveryService.objectClassResolver];

    if (![api isKindOfClass:[GTLRDiscovery_RestDescription class]]) {
      [self reportError:@"The api description doesn't appear to be a discovery REST description"];
      self.state = SGMain_Done;
      return;
    }

    [self.collectedApis addObject:api];
    if (![url isFileURL]) {
      [self maybeLogAPI:api];
    }
    if (reportProgress) {
      [self maybePrint:@" +-- Loaded: %@:%@", api.name, api.version];
    }
  }];
  return YES;
}

- (BOOL)parseFormattedNameArg:(NSString *)arg {
  NSRange range = [arg rangeOfString:@"="];
  if (range.location == NSNotFound) {
    // No service qualifier, this is a global.
    if (self.formattedNames.count > 0) {
      [self reportError:@"Using --formattedName more than once, all uses must have SERVICE= qualifier: %@",
       arg];
      return NO;
    }
    [self.formattedNames setObject:arg
                            forKey:kGlobalFormattedNameKey];
    return YES;
  } else {
    NSString *existingGlobalName =
        [self.formattedNames objectForKey:kGlobalFormattedNameKey];
    if ((existingGlobalName != nil)) {
      [self reportError:@"Using --formattedName more than once, all uses must have SERVICE= qualifier: %@",
       existingGlobalName];
      return NO;
    }
    NSString *key = [arg substringToIndex:range.location];
    NSString *value = [arg substringFromIndex:range.location + 1];
    [self.formattedNames setObject:value forKey:key];
    return YES;
  }
}

- (void)parseLegacyNamingArg:(NSString *)arg {
  // The arg is documented as "yes|no", but we support a list of services to
  // handle --generatePreferred and keeping a set of things in the old mode.
  if (([arg caseInsensitiveCompare:@"y"] == NSOrderedSame) ||
      ([arg caseInsensitiveCompare:@"yes"] == NSOrderedSame)) {
    [self.apisUsingLegacyObjectNaming addObject:kGlobalLegacyNamesKey];
  } else if (([arg caseInsensitiveCompare:@"n"] == NSOrderedSame) ||
             ([arg caseInsensitiveCompare:@"no"] == NSOrderedSame)) {
    // Nothing to store this is the default.
  } else {
    // Split on comma, and store them off.
    for (NSString *apiName in [arg componentsSeparatedByString:@","]) {
      if (apiName.length) {
        [self.apisUsingLegacyObjectNaming addObject:apiName];
      }
    }
  }
}

- (void)stateParseArgs {
  int generatePreferred = 0;
  int auditJSON = 0;
  int guessFormattedNames = 0;
  int showUsage = 0;
  int briefOutput = 0;

  struct option longopts[] = {
    { "outputDir",           required_argument, NULL,                 'o' },
    { "discoveryRootURL",    required_argument, NULL,                 'd' },
    { "gtlrFrameworkName",   required_argument, NULL,                 'n' },
    { "apiLogDir",           required_argument, NULL,                 'a' },
    { "httpLogDir",          required_argument, NULL,                 'h' },
    { "generatePreferred",   no_argument,       &generatePreferred,   1 },
    { "httpHeader",          required_argument, NULL,                 'w' },
    { "formattedName",       required_argument, NULL,                 't' },
    { "addServiceNameDir",   required_argument, NULL,                 'x' },
    { "removeUnknownFiles",  required_argument, NULL,                 'y' },
    { "rootURLOverrides",    required_argument, NULL,                 'u' },
    { "useLegacyObjectClassNames", required_argument, NULL,           'z' },
    { "messageFilter",       required_argument, NULL,                 'f' },
    { "auditJSON",           no_argument,       &auditJSON,           1 },
    { "guessFormattedNames", no_argument,       &guessFormattedNames, 1 },
    { "verbose",             no_argument,       NULL,                 'v' },
    { "brief",               no_argument,       &briefOutput,         1 },
    { "help",                no_argument,       &showUsage,           1 },
    { NULL,                  0,                 NULL,                 0 }
  };

  int ch;
  while ((ch = getopt_long(self.argc, self.argv, "v", longopts, NULL)) != -1) {
    switch (ch) {
      case 'o':
        self.outputDir = @(optarg);
        break;
      case 'd':
        self.discoveryRootURLString = @(optarg);
        break;
      case 'n':
        self.gtlrFrameworkName = @(optarg);
        break;
      case 'a':
        self.apiLogDir = @(optarg);
        break;
      case 'h':
        self.httpLogDir = @(optarg);
        break;
      case 'f':
        self.messageFilterPath = @(optarg);
        break;
      case 'v':
        self.verboseLevel += 1;
        break;
      case 't':
        if (![self parseFormattedNameArg:@(optarg)]) {
          [self printUsage:stderr brief:NO];
          return;
        }
        break;
      case 'w': {
        NSString *asString = @(optarg);
        NSRange range = [asString rangeOfString:@":"];
        if (range.location == NSNotFound) {
          [self reportError:@"Invalid httpHeader argument: %s.", optarg];
          [self printUsage:stderr brief:NO];
          return;
        }
        NSString *key = [asString substringToIndex:range.location];
        NSString *value = [asString substringFromIndex:range.location + 1];
        [self.additionalHTTPHeaders setObject:value forKey:key];
      }
        break;
      case 'x':
        self.addServiceNameDir = [SGUtils boolFromArg:optarg];
        break;
      case 'y':
        self.removeUnknownFiles = [SGUtils boolFromArg:optarg];
        break;
      case 'u':
        self.rootURLOverrides = [SGUtils boolFromArg:optarg];
        break;
      case 'z':
        [self parseLegacyNamingArg:@(optarg)];
        break;
      case 0:
        // Was a flag, nothing to do.
        break;
      case ':':
        // Missing argument
      case '?':
        // Unknown argument
      default:
        [self printUsage:stderr brief:NO];
        return;
    }
  }
  self.argc -= optind;
  self.argv += optind;

  self.generatePreferred = generatePreferred;
  self.auditJSON = auditJSON;
  self.guessFormattedNames = guessFormattedNames;
  self.briefOutput = briefOutput;

  if (showUsage) {
    [self printUsage:stdout brief:NO];
    // No error, they asked for usage.
    self.status = 0;
    return;
  }

  if ([self.formattedNames objectForKey:kGlobalFormattedNameKey]) {
    if (self.generatePreferred) {
      [self reportError:
       @"Can't use --formattedName with --generatePreferred, unless the --formattedName argument includes a service qualifier."];
      [self printUsage:stderr brief:NO];
      return;
    }
    if (self.argc > 1) {
      [self reportError:
       @"When generating more than one service, you can't use --formattedName without the argument including a service qualifier."];
      [self printUsage:stderr brief:NO];
      return;
    }
  }

  BOOL missingRequiredArg = NO;
  if (self.outputDir.length == 0) {
    [self reportError:@"An output directory (--outputDir) is required."];
    missingRequiredArg = YES;
  }
  if ((self.argc == 0) && !self.generatePreferred) {
    [self reportError:@"No argument(s) saying what to do."];
    missingRequiredArg = YES;
  }
  if (missingRequiredArg) {
    [self printUsage:stderr brief:YES];
    return;
  }

  // Make sure it is a full path for reporting.
  self.outputDir = [SGUtils fullPathWithPath:self.outputDir];

  // If we got empty, flip it to no value.
  if (self.discoveryRootURLString.length == 0) {
    self.discoveryRootURLString = nil;
  } else if (![self.discoveryRootURLString hasSuffix:@"/"]) {
    // Make sure it ends in '/'.
    self.discoveryRootURLString =
        [self.discoveryRootURLString stringByAppendingString:@"/"];
  }

  if (self.gtlrFrameworkName.length == 0) {
    self.gtlrFrameworkName = nil;
  }

  // Make sure output dir exists.
  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL isDir = NO;
  if (![fm fileExistsAtPath:self.outputDir isDirectory:&isDir]) {
    // Doesn't exist, make it.
    NSError *err = nil;
    if (![SGUtils createDir:self.outputDir error:&err]) {
      [self reportError:@"Failed to make output directory, '%@'",
       [self.outputDir stringByAbbreviatingWithTildeInPath]];
      self.status = 3;
      self.state = SGMain_Done;
      return;
    }
  } else if (!isDir) {
    // It is a file, not a directory?!
    [self reportError:@"Output directory is actually a file, '%@'",
     [self.outputDir stringByAbbreviatingWithTildeInPath]];
    self.status = 4;
    self.state = SGMain_Done;
    return;
  }

  if (self.discoveryRootURLString) {
    self.discoveryService.rootURLString = self.discoveryRootURLString;
  }

  if (self.additionalHTTPHeaders.count) {
    self.discoveryService.additionalHTTPHeaders = self.additionalHTTPHeaders;
  }

  [self printSection:@"Generation Settings"];

  [self maybePrint:@"  Output Directory: %@", [self.outputDir stringByAbbreviatingWithTildeInPath]];
  [self maybePrint:@"  Discovery Root URL: %@", self.discoveryService.rootURLString];

  // If an api log dir was provided, make sure it exists and use it.
  if (self.apiLogDir.length > 0) {
    self.apiLogDir = [SGUtils fullPathWithPath:self.apiLogDir];
    NSString *shortApiLogDir = [self.apiLogDir stringByAbbreviatingWithTildeInPath];
    NSError *err = nil;
    if ([SGUtils createDir:self.apiLogDir error:&err]) {
      [self maybePrint:@"  Api Log Dir: %@", shortApiLogDir];
    } else {
      self.apiLogDir = nil;
      [self reportError:@"Failed to create api log dir (%@). NSError: %@",
       shortApiLogDir, err];
    }
  }

  // If a http log dir was provided, make sure it exists, and turn on the
  // fetcher's logging support.
  if (self.httpLogDir.length > 0) {
    self.httpLogDir = [SGUtils fullPathWithPath:self.httpLogDir];
    NSString *shortHTTPLogDir = [self.httpLogDir stringByAbbreviatingWithTildeInPath];
    NSError *err = nil;
    if ([SGUtils createDir:self.httpLogDir error:&err]) {
      [GTMSessionFetcher setLoggingEnabled:YES];
      [GTMSessionFetcher setLoggingDirectory:self.httpLogDir];
      [self maybePrint:@"  HTTPFetcher Log Dir: %@", shortHTTPLogDir];
    } else {
      [self reportError:@"Failed to create HTTPFetcher log dir (%@). NSError: %@",
       shortHTTPLogDir, err];
    }
  }

  if (self.generatePreferred) {
    [self maybePrint:@"  Generate Preferred Services: YES"];
  }

  // Print any additional headers.
  NSDictionary *additionalHTTPHeaders = self.discoveryService.additionalHTTPHeaders;
  if (additionalHTTPHeaders.count) {
    [self maybePrint:@"  Additional HTTP Headers:"];
    for (NSString *key in additionalHTTPHeaders) {
      NSString *val = [additionalHTTPHeaders objectForKey:key];
      [self maybePrint:@"   + %@: %@", key, val];
    }
  }

  // Print the flags.
  [self maybePrint:@"  Flags:"];
  [self maybePrint:@"   + Use service name directory: %s", [SGUtils strFromBool:self.addServiceNameDir]];
  [self maybePrint:@"   + Remove unknown files: %s", [SGUtils strFromBool:self.removeUnknownFiles]];
  [self maybePrint:@"   + Allow rootURL overrides: %s", [SGUtils strFromBool:self.rootURLOverrides]];

  if (self.messageFilterPath.length > 0) {
    NSString *shortFilterPath = [self.messageFilterPath stringByAbbreviatingWithTildeInPath];
    NSError *readError;
    NSData *data = [NSData dataWithContentsOfFile:self.messageFilterPath
                                          options:0
                                            error:&readError];
    if (data == nil) {
      [self reportError:@"Failed to load the message filter %@, error: %@",
       shortFilterPath, readError];
    } else {
      NSError *parseErr;
      id parsedObj = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:&parseErr];
      if (parseErr) {
        [self reportError:@"Failed to parse the message filter file (%@), error: %@",
         shortFilterPath, parseErr];
      } else if (![parsedObj isKindOfClass:[NSDictionary class]]) {
        [self reportError:@"Failed to parse the message filter file (%@), didn't contain a dictionary: %@",
         shortFilterPath, [parsedObj class]];
      } else {
        self.messageFilters = parsedObj;
        [self maybePrint:@"  Message Filter: %@", shortFilterPath];
      }
    }
  }

  NSMutableArray *urlStringsToFetch = [NSMutableArray array];
  NSMutableArray *filesToLoad = [NSMutableArray array];

  // Process the args.
  self.state = SGMain_Generate;
  for (int i = 0; i < self.argc ; ++i) {
    NSString *arg = @(self.argv[i]);
    NSArray *splitArg = [arg componentsSeparatedByString:@":"];

    if ([arg hasPrefix:@"http://"] || [arg hasPrefix:@"https://"]) {

      // Treat it as an url and load it.
      [urlStringsToFetch addObject:arg];

    } else if (splitArg.count == 2) {

      // Treat it as a service:version pair.
      NSString *apiName = [splitArg objectAtIndex:0];
      NSString *version = [splitArg objectAtIndex:1];
      if ([version isEqual:@"-"]) {
        [self.apisToSkip addObject:apiName];
      } else if ([version hasPrefix:@"-"]) {
        version = [version substringFromIndex:1];
        NSString *apiVersion =
            [NSString stringWithFormat:@"%@:%@", apiName, version];
        [self.apisToSkip addObject:apiVersion];
      } else {
        NSArray *pair = @[ apiName, version ];
        [self.apisToFetch addObject:pair];
      }
      self.state = SGMain_Describe;

    } else {

      // Treat it as a path and load it.
      NSString *fullPath = [SGUtils fullPathWithPath:arg];
      [filesToLoad addObject:fullPath];

    }
  }

  if (urlStringsToFetch.count > 0) {
    [self printSection:@"Loading API URLs(s)"];
    for (NSString *urlString in urlStringsToFetch) {
      NSURL *asURL = [NSURL URLWithString:urlString];
      if (asURL == nil) {
        [self reportError:@"Failed to make an url out of %@", urlString];
        self.state = SGMain_Done;
        return;
      }
      if ([self collectAPIFromURL:asURL reportingName:urlString reportProgress:YES]) {
        if (self.state != SGMain_Wait) {
          self.postWaitState = self.state;
          self.state = SGMain_Wait;
        }
      } else {
        return;
      }
    }
  }

  if (filesToLoad.count > 0) {
    [self printSection:@"Loading API File(s)"];
    for (NSString *fullPath in filesToLoad) {
      NSString *shortPath = [fullPath stringByAbbreviatingWithTildeInPath];
      NSURL *asURL = [NSURL fileURLWithPath:fullPath];
      if ([self collectAPIFromURL:asURL reportingName:shortPath reportProgress:YES]) {
        if (self.state != SGMain_Wait) {
          self.postWaitState = self.state;
          self.state = SGMain_Wait;
        }
      } else {
        return;
      }
    }
  }

  if (self.generatePreferred) {
    // Go into directory mode to kick things off (any directly listed
    // services in the args will happen on the generate state).
    self.state = SGMain_Directory;
  }

}

- (void)stateDirectory {
  [self printSection:@"Requesting API Directory"];

  // Fetch the directory list.
  GTLRDiscoveryQuery_ApisList *listingQuery = [GTLRDiscoveryQuery_ApisList query];
  listingQuery.preferred = YES;
  [self maybePrint:@" + Preferred only"];
  [self.discoveryService executeQuery:listingQuery
                      completionHandler:^(GTLRServiceTicket *ticket, id object, NSError *error) {

      self.numberOfActiveNetworkActions -= 1;
      if (error) {
        [self reportError:@"Failed to fetch discovery listing, error: %@", error];
        self.status = 11;
        self.state = SGMain_Done;
      } else {
        GTLRDiscovery_DirectoryList *apiList = (GTLRDiscovery_DirectoryList *)object;
        if (self.apiLogDir != nil) {
          NSString *filePath = [self.apiLogDir stringByAppendingPathComponent:@"DirectoryList.json"];
          NSError *writeErr = nil;
          if (![apiList.JSONString writeToFile:filePath
                                    atomically:YES
                                      encoding:NSUTF8StringEncoding
                                         error:&writeErr]) {
            [self reportWarning:@"Failed to write directory list file at '%@'. Error: %@",
             filePath, writeErr];
          }
        }
        // Collect the server version pairs to describe.
        NSMutableSet *apisLeftToSkip = [self.apisToSkip mutableCopy];
        NSArray *sortedAPIItems = [apiList.items sortedArrayUsingComparator:
          ^NSComparisonResult(GTLRDiscovery_DirectoryListItemsItem *api1,
                              GTLRDiscovery_DirectoryListItemsItem *api2) {
            return [api1.name caseInsensitiveCompare:api2.name];
          }];

        for (GTLRDiscovery_DirectoryListItemsItem *listItem in sortedAPIItems) {
          NSString *apiName = listItem.name;
          NSString *apiVersion =
              [NSString stringWithFormat:@"%@:%@", apiName, listItem.version];
          if ([self.apisToSkip containsObject:apiVersion]) {
            [self reportPrefixed:@" - "
                            info:@"Discovery included '%@:%@', but skipping as requested.",
             apiName, listItem.version];
            [apisLeftToSkip removeObject:apiVersion];
          } else if ([self.apisToSkip containsObject:apiName]) {
            [self reportPrefixed:@" - "
                            info:@"Discovery included '%@:%@', but skipping as requested.",
             apiName, listItem.version];
            [apisLeftToSkip removeObject:apiName];
          } else if ([listItem.discoveryRestUrl containsString:@"/$discovery/"]) {
            // The URL can have a arguments (for version, etc), so parse it to
            // get at the path only.
            NSURL *discoveryRestURL = [NSURL URLWithString:listItem.discoveryRestUrl];
            if ([discoveryRestURL.path hasSuffix:@"/rest"]) {
              NSArray *tuple = @[ apiName, listItem.version, listItem.discoveryRestUrl ];
              [self.apisToFetch addObject:tuple];
            } else {
              [self reportPrefixed:@" - "
                           warning:@"Skipping '%@:%@', the discovery link appears to be some other format: %@",
               apiName, listItem.version, listItem.discoveryRestUrl];
            }
          } else {
            // NOTE: Could have skipped the "/$discovery/" check and just used
            // discoveryRestUrl in all cases, but by using the getRest method we
            // can use a batch query to cut down on how long it takes to get all
            // the documents.
            NSArray *tuple = @[ apiName, listItem.version ];
            [self.apisToFetch addObject:tuple];
          }
        }
        // Report anything that was supposed to be skipped but was missing.
        NSArray *skipsNotFound =
          [[apisLeftToSkip allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        for (NSString *apiName in skipsNotFound) {
          [self reportPrefixed:@" - "
                       warning:@"Discovery did NOT include '%@', but you indicated it should be skipped.", apiName];
        }
      }
    }];
  self.numberOfActiveNetworkActions += 1;

  self.state = SGMain_Wait;
  self.postWaitState = SGMain_Describe;
}

- (void)stateDescribe {
  [self printSection:@"Requesting API(s)"];

  GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];

  // Stable order for the requests.
  NSArray *orderedTuples =
    [self.apisToFetch sortedArrayUsingComparator:
       ^NSComparisonResult(NSArray *tuple1, NSArray *tuple2) {
         NSComparisonResult result =
           [[tuple1 objectAtIndex:0] compare:[tuple2 objectAtIndex:0]];
         if (result == NSOrderedSame) {
           result = [[tuple1 objectAtIndex:1] compare:[tuple2 objectAtIndex:1]];
         }
         return result;
       }];

  // Create the queries.
  for (NSArray *tuple in orderedTuples) {
    NSString *serviceName = [tuple objectAtIndex:0];
    NSString *serviceVersion = [tuple objectAtIndex:1];
    [self printSubsection:@" + %@(%@)", serviceName, serviceVersion];
    if (tuple.count == 3) {
      NSString *discoveryRestURLString = [tuple objectAtIndex:2];
      NSURL *discoveryRestURL = [NSURL URLWithString:discoveryRestURLString];
      if (discoveryRestURL == nil) {
        [self reportError:@"Failed to make an url out of %@", discoveryRestURLString];
        self.state = SGMain_Done;
        return;
      } else {
        NSString *reportingName =
          [NSString stringWithFormat:@"%@:%@ (%@)",
           serviceName, serviceVersion, discoveryRestURLString];
        if ([self collectAPIFromURL:discoveryRestURL reportingName:reportingName reportProgress:NO]) {
          // We'll go into wait state beow.
        } else {
          // -collectAPIFromURL:reportingName: can't really fail to start the fetch.
          self.state = SGMain_Done;
          return;
        }
      }
    } else {
      GTLRDiscoveryQuery_ApisGetRest *query =
        [GTLRDiscoveryQuery_ApisGetRest queryWithApi:serviceName
                                            version:serviceVersion];
      query.completionBlock = ^(GTLRServiceTicket *ticket, id object, NSError *error) {
        if (error) {
          GTLRErrorObject *errObj = [GTLRErrorObject underlyingObjectForError:error];
          // If we got back a structured error object, then the query failed, so
          // report it.  If we don't get a structured error, it's likely a
          // networking error failing the whole batch, so don't report it here,
          // but do that on the batch completion handler.
          if (errObj) {
            [self reportError:@"Failed to fetch a discovery document for '%@(%@)', error: %@",
             serviceName, serviceVersion, errObj];
            self.status = 13;
            self.state = SGMain_Done;
          }
        } else {
          GTLRDiscovery_RestDescription *api = (GTLRDiscovery_RestDescription *)object;
          [self.collectedApis addObject:api];
          // If logging the API files, do it now so a fetch failure doesn't
          // prevent the other ones from being logged.
          [self maybeLogAPI:api];
        }
      };
      [batchQuery addQuery:query];
    }
  }  // for(tuple in orderedTuples)

  if (batchQuery.queries.count > 0) {
    // Send in the batch.
    [self.discoveryService executeQuery:batchQuery
                      completionHandler:^(GTLRServiceTicket *ticket, id object, NSError *error) {
        self.numberOfActiveNetworkActions -= 1;
        // Per query handling is done above. The exception is if there is an error
        // here, it's probably a network error, so report it globally here.  Per
        // query failures (within the batch) were handled above (they show up
        // in the BatchResult, not as the error argument.)
        if (error) {
          [self reportError:@"Failed to fetch discovery documents, error: %@", error];
          self.status = 12;
          self.state = SGMain_Done;
        }
      }];
    self.numberOfActiveNetworkActions += 1;
  }

  self.state = SGMain_Wait;
  self.postWaitState = SGMain_Generate;
}

- (void)stateWait {
  // Wait for all active network actions to finish.
  NSDate* giveUpDate = [NSDate dateWithTimeIntervalSinceNow:30.0];
  while (self.numberOfActiveNetworkActions > 0 && [giveUpDate timeIntervalSinceNow] > 0) {
    @autoreleasepool {
      NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
      [[NSRunLoop currentRunLoop] runUntilDate:stopDate];
    }
  }

  if (self.numberOfActiveNetworkActions > 0) {
    self.status = 3;
    self.state = SGMain_Done;
    [self reportError:@"Timed out waiting for the server to come back."];
  } else if (self.state == SGMain_Wait) {
    // State is only updated if it was still on Wait, otherwse, someone else
    // updated the state already.
    self.state = self.postWaitState;
  }
}

- (void)stateGenerate {

  // Now process discovery documents.

  [self printSection:@"Generating"];

  // Set the state to next be write files. This way, an error below will clear
  // the state.
  self.state = SGMain_WriteFiles;

  // Stable order for compares.
  NSArray *orderedAPIs =
    [self.collectedApis sortedArrayUsingComparator:
       ^NSComparisonResult(GTLRDiscovery_RestDescription *api1,
                           GTLRDiscovery_RestDescription *api2) {
         return [api1.name caseInsensitiveCompare:api2.name];
       }];

  for (GTLRDiscovery_RestDescription *api in orderedAPIs) {
    @autoreleasepool {

      [self printSubsection:@" + %@(%@)", api.name, api.version];
      @try {
        // Apply any name override.
        NSString *formattedNameOverride = nil;
        NSString *apiVersion =
            [NSString stringWithFormat:@"%@:%@", api.name, api.version];
        formattedNameOverride = [self.formattedNames objectForKey:apiVersion];
        if (formattedNameOverride == nil) {
          formattedNameOverride = [self.formattedNames objectForKey:api.name];
        }
        if (formattedNameOverride == nil) {
          formattedNameOverride =
              [self.formattedNames objectForKey:kGlobalFormattedNameKey];
        }
        if (formattedNameOverride.length > 0) {
          [self reportPrefixed:@" "
                          info:@"With name override: %@", formattedNameOverride];
        }
        SGGeneratorOptions options = 0;
        if (self.rootURLOverrides) {
          options |= kSGGeneratorOptionAllowRootOverride;
        }
        if (self.auditJSON) {
          options |= kSGGeneratorOptionAuditJSON;
        }
        if (self.guessFormattedNames) {
          options |= kSGGeneratorOptionAllowGuessFormattedName;
        }
        if ([self.apisUsingLegacyObjectNaming containsObject:kGlobalLegacyNamesKey] ||
            [self.apisUsingLegacyObjectNaming containsObject:api.name] ||
            [self.apisUsingLegacyObjectNaming containsObject:apiVersion]) {
          options |= kSGGeneratorOptionLegacyObjectNaming;
        }

        SGGenerator *aGenerator = [SGGenerator generatorForApi:api
                                                       options:options
                                                  verboseLevel:self.verboseLevel
                                         formattedNameOverride:formattedNameOverride
                                              useFrameworkName:self.gtlrFrameworkName];

        NSDictionary *generatedFiles =
          [aGenerator generateFilesWithHandler:^(SGGeneratorHandlerMessageType msgType,
                                                 NSString *message) {
            NSString *leader =
              (msgType == kSGGeneratorHandlerMessageError ? @"" : @"    ");
            [self reportMessage:message type:msgType leader:leader];
          }];
        if (generatedFiles) {
          if ([self.generatedData objectForKey:aGenerator.formattedAPIName] != nil) {
            [self reportError:@"Two APIs trying to use the same formatted name of %@, nothing will be written out.",
             aGenerator.formattedAPIName];
            if (self.status == 0) {
              self.status = 24;
            }
            self.state = SGMain_Done;
          } else {
            [self.generatedData setObject:generatedFiles
                                   forKey:aGenerator.formattedAPIName];
          }
        } else {
          // If we didn't get any generated files, we should have gotten an error
          // callback also. But just to be safe, force out state.
          if (self.status == 0) {
            self.status = 23;
          }
          self.state = SGMain_Done;
        }
      }
      @catch (NSException * e) {
        [self reportError:@"Failure, exception: %@", e];
        self.status = 22;
        self.state = SGMain_Done;
        break;
      }
    }
  }
}

- (void)stateWriteFiles {
  [self printSection:@"Writing"];

  NSFileManager *fm = [NSFileManager defaultManager];

  BOOL didWriteAFile = NO;
  NSMutableSet *allFilesInDirs = [NSMutableSet set];
  NSMutableSet *allFilesGenerated = [NSMutableSet set];

  NSArray *allKeys = self.generatedData.allKeys;
  NSArray *sortedKeys =
    [allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

  for (NSString *dirName in sortedKeys) {
    NSDictionary *filesDict = [self.generatedData objectForKey:dirName];

    NSString *dirToWriteTo = self.outputDir;

    if (self.addServiceNameDir) {
      // Make the subdirectory for the service.
      dirToWriteTo = [dirToWriteTo stringByAppendingPathComponent:dirName];
    }

    // In case any subdirectories off outputDir were needed, make sure they all
    // exist.
    NSError *err = nil;
    if (![SGUtils createDir:dirToWriteTo error:&err]) {
      [self reportError:@"Failed to make the service directory in the output dir. error: %@", err];
      self.status = 31;
      self.state = SGMain_Done;
      return;
    }

    // Write out the files (sort the names so .h/.m pairs get written together)
    NSArray *sortedNames =
      [filesDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString *name in sortedNames) {
      NSString *body = [filesDict objectForKey:name];

      NSString *fullPath = [dirToWriteTo stringByAppendingPathComponent:name];
      [allFilesGenerated addObject:fullPath];
      NSString *existingFile = [NSString stringWithContentsOfFile:fullPath
                                                         encoding:NSUTF8StringEncoding
                                                            error:NULL];
      if (HaveFileStringsChanged(existingFile, body)) {
        NSError *writeErr = nil;
        if (![body writeToFile:fullPath
                    atomically:YES
                      encoding:NSUTF8StringEncoding
                         error:&writeErr]) {
          [self reportError:@"Failed to write output file '%@'. Error: %@",
           fullPath, writeErr];
          self.status = 32;
          self.state = SGMain_Done;
          return;
        }
        NSString *pathLeaf =
          [fullPath substringFromIndex:self.outputDir.length + 1];
        [self printBold:@" + %@ (%lu bytes)%s",
                        pathLeaf,
                        (unsigned long)body.length,
                        (existingFile == nil ? " - NEW" : "")];
        didWriteAFile = YES;
      }
    }

    // Collect the list of files there to report unknown files.
    NSError *listErr = nil;
    NSArray *fileNamesOnDisk = [fm contentsOfDirectoryAtPath:dirToWriteTo
                                                       error:&listErr];
    if (listErr != nil) {
      [self reportWarning:@"Failed to list output directory '%@'. Error: %@",
       dirToWriteTo, listErr];
    }
    for (NSString *fileName in fileNamesOnDisk) {
      NSString *fullPath = [dirToWriteTo stringByAppendingPathComponent:fileName];
      [allFilesInDirs addObject:fullPath];
    }
  }

  // Now the unknown files in the output dir(s).
  [allFilesInDirs minusSet:allFilesGenerated];
  NSArray *sortedUnknownFiles =
    [[allFilesInDirs allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  for (NSString *fullPath in sortedUnknownFiles) {
    if (self.removeUnknownFiles) {
      NSError *removeErr = nil;
      if ([fm removeItemAtPath:fullPath error:&removeErr]) {
        [self printBold:@" + %@ - REMOVED",
                        [fullPath substringFromIndex:self.outputDir.length + 1]];
        didWriteAFile = YES;
      } else {
        [self reportWarning:@"Failed to remove stale output file '%@'. Error: %@",
         fullPath, removeErr];
      }
    } else {
      [self reportPrefixed:@" "
                   warning:@"'%@' was in the output dir, and wasn't needed during generation.",
       [fullPath substringFromIndex:self.outputDir.length + 1]];
    }
  }

  // In Directory based mode and using service directories, report any services
  // that seem to have gone away (deleteing seems a little risky here).
  if (self.generatePreferred && self.addServiceNameDir) {
    NSError *listingErr = nil;
    NSArray *fileNamesOnDisk = [fm contentsOfDirectoryAtPath:self.outputDir
                                                       error:&listingErr];
    if (listingErr != nil) {
      [self reportWarning:@"Failed to list output directory '%@'. Error: %@",
       self.outputDir, listingErr];
    }

    if (fileNamesOnDisk) {
      NSMutableArray *unexpectedNames =
        [NSMutableArray arrayWithArray:fileNamesOnDisk];
      NSArray *serviceDirectoryNames = self.generatedData.allKeys;
      [unexpectedNames removeObjectsInArray:serviceDirectoryNames];
      for (NSString *fileName in unexpectedNames) {
        BOOL isDir = NO;
        NSString *fullPath =
          [self.outputDir stringByAppendingPathComponent:fileName];
        // Only report on directories there, not files.
        if ([fm fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
          [self reportPrefixed:@" "
                       warning:@"'%@' was in the output dir, and wasn't needed during generation.", fileName];
        }
      }
    }
  }

  if (!didWriteAFile) {
    [self printBold:@" - No changes from what is already on disk."];
  }

  // Check for unused filter messages.
  NSDictionary *messageFilters = self.messageFilters;
  // Clear filters since we use the same calls to report.
  self.messageFilters = nil;
  [messageFilters enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                      NSMutableArray *filters,
                                                      BOOL *stop) {
    for (NSString *message in filters) {
      NSString *escaped = [SGUtils escapeString:message];
      [self reportWarning:@"Unused message filter: %@::%@", key, escaped];
    }
  }];

  self.state = SGMain_Done;
}

@end

int main(int argc, char * const *argv) {
  int status;
  @autoreleasepool {
    // If stdout/stderr are ttys and "color" is in the terminal, assume color
    // output will work.
    char *termCStr = getenv("TERM");
    int stdoutNum = fileno(stdout);
    int stderrNum = fileno(stderr);
    // NSTask sets NSUnbufferedIO. Check for it because that's yet another
    // sign output isn't really going to a TTY.
    // http://lists.apple.com/archives/cocoa-dev/2002/Oct/msg00665.html
    char *bufferedIO = getenv("NSUnbufferedIO");
    if ((stdoutNum >= 0) && (stderrNum >= 0) &&
        isatty(stdoutNum) && isatty(stderrNum) &&
        (termCStr != NULL) &&
        (strstr(termCStr, "color") != NULL) &&
        (bufferedIO == NULL)) {
      kERROR = kERROR_Colored;
      kWARNING = kWARNING_Colored;
      kINFO = kINFO_Colored;
      kEmBegin = kEmBegin_COLORED;
      kEmEnd = kEmEnd_COLORED;
    }

    SGMain *sg = [[SGMain alloc] initWithArgc:argc argv:argv];
    status = [sg run];
    if ((status || sg.printedError) && !sg.didPrintUsage) {
      fprintf(stderr,
              "%s There were one or more errors; check the full output for details.\n",
              kERROR);
    }
  }
  return status;
}
