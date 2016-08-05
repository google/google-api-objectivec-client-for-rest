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

#import "GTLRBatchResult.h"

#import "GTLRErrorObject.h"

@implementation GTLRBatchResult

@synthesize successes = _successes,
            failures = _failures,
            responseHeaders = _responseHeaders;

- (id)copyWithZone:(NSZone *)zone {
  GTLRBatchResult* newObject = [super copyWithZone:zone];
  newObject.successes = [self.successes copyWithZone:zone];
  newObject.failures = [self.failures copyWithZone:zone];
  newObject.responseHeaders = [self.responseHeaders copyWithZone:zone];
  return newObject;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ %p (successes:%tu failures:%tu responseHeaders:%tu)",
          [self class], self,
          self.successes.count, self.failures.count, self.responseHeaders.count];
}

@end
