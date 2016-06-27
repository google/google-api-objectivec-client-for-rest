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

#import <Foundation/Foundation.h>

#import "GTLRDiscovery.h"

typedef NS_ENUM(NSUInteger, SGGeneratorHandlerMessageType) {
  kSGGeneratorHandlerMessageError = 1,
  kSGGeneratorHandlerMessageWarning,
  kSGGeneratorHandlerMessageInfo
};

typedef void (^SGGeneratorMessageHandler)(SGGeneratorHandlerMessageType msgType,
                                          NSString *message);

typedef NS_OPTIONS(NSUInteger, SGGeneratorOptions) {
  kSGGeneratorOptionAuditJSON               = 1 << 0,
  kSGGeneratorOptionAllowRootOverride       = 1 << 1,
  kSGGeneratorOptionAllowGuessFormattedName = 1 << 2,
};

@interface SGGenerator : NSObject

@property(readonly) GTLRDiscovery_RestDescription* api;
@property(readonly) SGGeneratorOptions options;
@property(readonly) NSUInteger verboseLevel;
@property(readonly) NSString *frameworkName;

// The API name formatted for use as a directory name.
@property (readonly) NSString *formattedAPIName;

+ (instancetype)generatorForApi:(GTLRDiscovery_RestDescription *)api
                        options:(SGGeneratorOptions)options
                   verboseLevel:(NSUInteger)verboseLevel
          formattedNameOverride:(NSString *)formattedNameOverride
               useFrameworkName:(NSString *)frameworkName;

// Keys are the file names; values are the contents of the files.
- (NSDictionary *)generateFilesWithHandler:(SGGeneratorMessageHandler)messageHandler;

@end
