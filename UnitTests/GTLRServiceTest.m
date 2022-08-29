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

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#import <GoogleAPIClientForREST/GTLRService.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>

// TODO: Simplify when the 2.0 SessionFetcher is the min dependency.
#if __has_include(<GTMSessionFetcher/GTMSessionFetcherService.h>)  // 2.x & CocoaPods
  #import <GTMSessionFetcher/GTMSessionFetcherService.h>
  #import <GTMSessionFetcher/GTMMIMEDocument.h>
#else  // SwiftPM 1.x
  #import "../GTMSessionFetcherService.h"
  #import "../GTMMIMEDocument.h"
#endif

#import "GTLRTestingSvc.h"

@interface GTLRServiceTest : XCTestCase
@end


// Surrogates for testing.

@interface GTLRTestingSvc_File_Surrogate : GTLRTestingSvc_File
@end
@interface GTLRTestingSvc_FileList_Surrogate : GTLRTestingSvc_FileList
@end
@interface GTLRTestingSvc_FileList_Surrogate2 : GTLRTestingSvc_FileList
@end
@implementation GTLRTestingSvc_File_Surrogate
@end
@implementation GTLRTestingSvc_FileList_Surrogate
@end
@implementation GTLRTestingSvc_FileList_Surrogate2
@end


// Internal methods redeclared for testing.

@interface GTLRBatchResponsePart : NSObject
@property(nonatomic, assign) NSInteger statusCode;
@property(nonatomic, copy) NSString *statusString;
@property(nonatomic, strong) NSDictionary *headers;
@property(nonatomic, strong) NSError *parseError;
@end

@interface GTLRService (InternalMethods)
+ (NSURL *)URLWithString:(NSString *)urlString
         queryParameters:(NSDictionary *)queryParameters;
- (GTLRBatchResponsePart *)responsePartWithMIMEPart:(GTMMIMEDocumentPart *)mimePart;
@end


//
// Simple authorizer class for testing
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
@interface GTLRTestAuthorizer : NSObject <GTMFetcherAuthorizationProtocol>
// The value string will be added to the authorization header, like
// Authorization: Bearer value
+ (GTLRTestAuthorizer *)authorizerWithValue:(NSString *)value;

@property(atomic, copy) NSString *value;
@property(atomic, retain) NSError *error;
@end
#pragma clang diagnostic pop

// GTLRTestLifetimeObject fulfills the expectation when the provided object deallocates.
//
// This allows dealloc to occur asynchronously and the test code to just wait for it.
@interface GTLRTestLifetimeObject : NSObject
+ (instancetype)trackLifetimeOfObject:(id)object expectation:(XCTestExpectation *)expectation;
@end

#if GTM_BACKGROUND_TASK_FETCHING

// An implementation of a substitute UIApplication to track invocations of begin
// and end. It doesn't attempt to match them up.
@interface CountingUIApplication : NSObject<GTMUIApplicationProtocol>

@property(atomic, readonly) NSCountedSet *beginTaskIDs;
@property(atomic, readonly) NSCountedSet *endTaskIDs;

// Optionally, expire tasks immediately (on the next main thread cycle.)
@property(atomic, assign) BOOL shouldExpireTasks;
@property(atomic, readonly) NSUInteger numberOfExpiredTasks;

@end

#endif  // GTM_BACKGROUND_TASK_FETCHING

@implementation GTLRServiceTest {
  NSURL *_tempFileURLToDelete;
}

- (void)tearDown {
  if (_tempFileURLToDelete) {
    NSError *deleteError;
    XCTAssert([[NSFileManager defaultManager] removeItemAtURL:_tempFileURLToDelete
                                                        error:&deleteError],
              @"%@", deleteError);
  }
  [self clearCountingUIApp];

  [super tearDown];
}

#pragma mark -

+ (NSData *)dataForTestFileName:(NSString *)fileName {
  // These used to be done a files in the test bundle, but SwiftPM doesn't do
  // great with that (is improving), but also since some of the payloads are
  // MIME, they have to have ^M on the end of lines, so as files get put in
  // different version control systems, they can be mangled, so by encoding
  // them in base64 there are no issues.
  //
  // To edit one of these, you can do something like:
  //   echo "[ENCODED_STRING]" | base64 -d -o tmp.txt
  // Then do your edits on tmp.txt and then to get the to update here:
  //   base64 -i tmp.txt
  NSDictionary *dataFiles = @{
    @"Classroom1NotFoundError.response.txt":
        @"ewogImVycm9yIjogewogICJjb2RlIjogNDA0LAogICJtZXNzYWdlIjogIlJlcXVlc3RlZCBlbnRpdHkgd2FzIG5vdCBmb3VuZC4iLAogICJzdGF0dXMiOiAiTk9UX0ZPVU5EIiwKICAiZGV0YWlscyI6IFsKICAgewogICAgIkB0eXBlIjogInR5cGUuZ29vZ2xlYXBpcy5jb20iLAogICAgImRldGFpbCI6ICJbT1JJR0lOQUwgRVJST1JdIGdlbmVyaWM6Om5vdF9mb3VuZDoiCiAgIH0KICBdCiB9Cn0K",
    @"Drive1.response.txt":
        @"ewogICJraW5kIiA6ICJkcml2ZSNmaWxlTGlzdCIsCiAgImZpbGVzIiA6IFsKICAgIHsKICAgICAgIm1pbWVUeXBlIiA6ICJpbWFnZVwvcG5nIiwKICAgICAgInRodW1ibmFpbExpbmsiIDogImh0dHBzOlwvXC9saDYuZ29vZ2xldXNlcmNvbnRlbnQuY29tXC8wWHRLYmszM0RwUWR2bG9JVDRIZVRmX1FuRXlmZFI0bkctOWpCMFBtZzA1VnNZdDFnTHJmRXAzQk9nPXMyMjAiLAogICAgICAiaWQiIDogIjBCN3N2WkREd3RLcmhUVEF0UXpSUmNHcFdaMGsiLAogICAgICAid2ViVmlld0xpbmsiIDogImh0dHBzOlwvXC9kcml2ZS5nb29nbGUuY29tXC9maWxlXC9kXC8wQjdzdlpERHd0S3JoVFRBdFJjR3BXWjBrXC92aWV3P3VzcD1kcml2ZXNkayIsCiAgICAgICJraW5kIiA6ICJkcml2ZSNmaWxlIiwKICAgICAgIm5hbWUiIDogImNhbGVuZGFyLWludml0ZS5wbmciLAogICAgICAidHJhc2hlZCIgOiBmYWxzZQogICAgfSwKICAgIHsKICAgICAgIm1pbWVUeXBlIiA6ICJhcHBsaWNhdGlvblwvb2N0ZXQtc3RyZWFtIiwKICAgICAgImlkIiA6ICIwQjdzdlpERHd0S3JoZEZJdGRUQlZTa3RJTVZrIiwKICAgICAgImtpbmQiIDogImRyaXZlI2ZpbGUiLAogICAgICAibmFtZSIgOiAib2JqYyBzdHlsZSB3b3JrLnR4dCIsCiAgICAgICJ0cmFzaGVkIiA6IGZhbHNlLAogICAgICAid2ViVmlld0xpbmsiIDogImh0dHBzOlwvXC9kcml2ZS5nb29nbGUuY29tXC9maWxlXC9kXC8wQjdzdlpERHd0S3JoZEZJdGRUQlZTa3RJTVZrXC92aWV3P3VzcD1kcml2ZXNkayIKICAgIH0sCiAgXSwKICAidGltZUZpZWxkRm9yVGVzdGluZyIgOiAiMjAxMS0wMS0wMlQwMzowNDowNS4wNjdaIgp9Cg==",
    @"Drive1AuthError.response.txt":
        @"ewogICJlcnJvciIgOiB7CiAgICAibWVzc2FnZSIgOiAiSW52YWxpZCBDcmVkZW50aWFscyIsCiAgICAiZXJyb3JzIiA6IFsKICAgICAgewogICAgICAgICJtZXNzYWdlIiA6ICJJbnZhbGlkIENyZWRlbnRpYWxzIiwKICAgICAgICAibG9jYXRpb25UeXBlIiA6ICJoZWFkZXIiLAogICAgICAgICJyZWFzb24iIDogImF1dGhFcnJvciIsCiAgICAgICAgImRvbWFpbiIgOiAiZ2xvYmFsIiwKICAgICAgICAibG9jYXRpb24iIDogIkF1dGhvcml6YXRpb24iLAogICAgICAgICJkZWJ1Z0luZm8iIDogInNlcnZlciBkZXRhaWxzIHdvdWxkIGJlIGhlcmUiCiAgICAgIH0KICAgIF0sCiAgICAiY29kZSIgOiA0MDEKICB9Cn0K",
    @"Drive1Batch.response.txt":
        @"LS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzQNCg0KSFRUUC8xLjEgNDA0IE5vdCBGb3VuZA0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9qc29uOyBjaGFyc2V0PVVURi04DQpEYXRlOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KRXhwaXJlczogTW9uLCAwMSBGZWIgMjAxNiAyMjo1MDo1NyBHTVQNCkNhY2hlLUNvbnRyb2w6IHByaXZhdGUsIG1heC1hZ2U9MA0KQ29udGVudC1MZW5ndGg6IDE3MDgyDQpYLVJlamVjdGVkLVJlYXNvbjogRmFpbGVkIHRvIHJlbW92ZSBFeGNhbGlidXIgZnJvbSBzdG9uZQ0KDQp7DQogImVycm9yIjogew0KICAiZXJyb3JzIjogWw0KICAgew0KICAgICJkb21haW4iOiAiZ2xvYmFsIiwNCiAgICAicmVhc29uIjogIm5vdEZvdW5kIiwNCiAgICAibWVzc2FnZSI6ICJGaWxlIG5vdCBmb3VuZDogYmFkSUQuIiwNCiAgICAibG9jYXRpb25UeXBlIjogInBhcmFtZXRlciIsDQogICAgImxvY2F0aW9uIjogImZpbGVJZCIsDQogICAgImRlYnVnSW5mbyI6ICJjb2RlOiBOT1RfRk9VTkQiDQogICB9DQogIF0sDQogICJjb2RlIjogNDA0LA0KICAibWVzc2FnZSI6ICJGaWxlIG5vdCBmb3VuZDogYmFkSUQuIg0KIH0NCn0NCg0KLS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzUNCg0KSFRUUC8xLjEgMjAwIE9LDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9VVRGLTgNCkRhdGU6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpFeHBpcmVzOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KQ2FjaGUtQ29udHJvbDogcHJpdmF0ZSwgbWF4LWFnZT0wDQpDb250ZW50LUxlbmd0aDogNDQNClJldHJ5LUFmdGVyOiAzMDANCg0Kew0KICJraW5kIjogImRyaXZlI2ZpbGVMaXN0IiwNCiAiZmlsZXMiOiBbXQ0KfQ0KDQotLWJhdGNoXzNhak40MFlwWFpRX0FCZjV3d19neHlnDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2h0dHANCkNvbnRlbnQtSUQ6IHJlc3BvbnNlLWd0bHJfNg0KDQpIVFRQLzEuMSAyMDAgT0sNCkNvbnRlbnQtVHlwZTogYXBwbGljYXRpb24vanNvbjsgY2hhcnNldD1VVEYtOA0KRGF0ZTogTW9uLCAwMSBGZWIgMjAxNiAyMjo1MDo1NyBHTVQNCkV4cGlyZXM6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpDYWNoZS1Db250cm9sOiBwcml2YXRlLCBtYXgtYWdlPTANCkNvbnRlbnQtTGVuZ3RoOiA0NQ0KDQp7DQogInBhcmVudHMiOiBbDQogICIwQUxzdlpERHd0S3JoVWs5UFZBIg0KIF0NCn0NCg0KLS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zy0tDQo=",
    @"Drive1BatchCorrupt.response.txt":
        @"LS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzQNCg0KSFRUUC8xLjEgNDA0IE5vdCBGb3VuZA0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9qc29uOyBjaGFyc2V0PVVURi04DQpEYXRlOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KRXhwaXJlczogTW9uLCAwMSBGZWIgMjAxNiAyMjo1MDo1NyBHTVQNCkNhY2hlLUNvbnRyb2w6IHByaXZhdGUsIG1heC1hZ2U9MA0KQ29udGVudC1MZW5ndGg6IDE3MDgyDQoNCnsNCiAiZXJyb3IiOiB7DQogICJlcnJvcnMiOiBbDQogICB7DQogICAgImRvbWFpbiI6ICJnbG9iYWwiLA0KICAgICJyZWFzb24iOiAibm90Rm91bmQiLA0KICAgICJtZXNzYWdlIjogIkZpbGUgbm90IGZvdW5kOiBiYWRJRC4iLA0KICAgICJsb2NhdGlvblR5cGUiOiAicGFyYW1ldGVyIiwNCiAgICAibG9jYXRpb24iOiAiZmlsZUlkIiwNCiAgICAiZGVidWdJbmZvIjogImNvZGU6IE5PVF9GT1VORCINCiAgIH0NCiAgXSwNCiAgImNvZGUiOiA0MDQsDQogICJtZXNzYWdlIjogIkZpbGUgbm90IGZvdW5kOiBiYWRJRC4iDQogfQ0KfQ0KDQotLWJhdGNoXzNhak40MFlwWFpRX0FCZjV3d19neHlnDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2h0dHANCkNvbnRlbnQtSUQ6IHJlc3BvbnNlLWd0bHJfNQ0KDQpIVFRQLzEuMSAyMDAgT0sNCkNvbnRlbnQtVHlwZTogYXBwbGljYXRpb24vanNvbjsgY2hhcnNldD1VVEYtOA0KRGF0ZTogTW9uLCAwMSBGZWIgMjAxNiAyMjo1MDo1NyBHTVQNCkV4cGlyZXM6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpDYWNoZS1Db250cm9sOiBwcml2YXRlLCBtYXgtYWdlPTANCkNvbnRlbnQtTGVuZ3RoOiA0NA0KDQp7IGFiY2QgOjo9PSB9DQoNCi0tYmF0Y2hfM2FqTjQwWXBYWlFfQUJmNXd3X2d4eWcNCkNvbnRlbnQtVHlwZTogYXBwbGljYXRpb24vaHR0cA0KQ29udGVudC1JRDogcmVzcG9uc2UtZ3Rscl82DQoNCkhUVFAvMS4xIDIwMCBPSw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9qc29uOyBjaGFyc2V0PVVURi04DQpEYXRlOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KRXhwaXJlczogTW9uLCAwMSBGZWIgMjAxNiAyMjo1MDo1NyBHTVQNCkNhY2hlLUNvbnRyb2w6IHByaXZhdGUsIG1heC1hZ2U9MA0KQ29udGVudC1MZW5ndGg6IDQ1DQoNCnsNCiAicGFyZW50cyI6IFsNCiAgIjBBTHN2WkREd3RLcmhVazlQVkEiDQogXQ0KfQ0KDQotLWJhdGNoXzNhak40MFlwWFpRX0FCZjV3d19neHlnLS0NCg==",
    @"Drive1BatchPaging1.response.txt":
        @"LS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzUNCg0KSFRUUC8xLjEgMjAwIE9LDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9VVRGLTgNCkRhdGU6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpFeHBpcmVzOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KQ2FjaGUtQ29udHJvbDogcHJpdmF0ZSwgbWF4LWFnZT0wDQpDb250ZW50LUxlbmd0aDogNDQNCg0Kew0KICJraW5kIjogImRyaXZlI2ZpbGVMaXN0IiwNCiAibmV4dFBhZ2VUb2tlbiI6ICIyIiwNCiAiZmlsZXMiOiBbDQogIHsNCiAgICJraW5kIjogImRyaXZlI2ZpbGUiLA0KICAgImlkIjogIjEtY3NuZGVjTEFSa1FKeWFhTUhCOGJCZjlDS2ciLA0KICAgIm5hbWUiOiAiTG9jYXRpb25zIiwNCiAgICJtaW1lVHlwZSI6ICJhcHBsaWNhdGlvbi92bmQuZ29vZ2xlLWFwcHMubWFwIg0KICB9LA0KICB7DQogICAia2luZCI6ICJkcml2ZSNmaWxlIiwNCiAgICJpZCI6ICIxNmczTjBpMjc2b3dVYzBtNHdWVkhRZGxpUUNRIiwNCiAgICJuYW1lIjogIjk0MCBNYWluIFN0LiIsDQogICAibWltZVR5cGUiOiAiYXBwbGljYXRpb24vdm5kLmdvb2dsZS1hcHBzLm1hcCINCiAgfSwNCiAgew0KICAgImtpbmQiOiAiZHJpdmUjZmlsZSIsDQogICAiaWQiOiAiMVRZRnp5ZlZDNWwtVVh0dTZsZGlNWlM0blBLQSIsDQogICAibmFtZSI6ICJKb29wbWFwIiwNCiAgICJtaW1lVHlwZSI6ICJhcHBsaWNhdGlvbi92bmQuZ29vZ2xlLWFwcHMubWFwIg0KICB9DQogXQ0KfQ0KDQotLWJhdGNoXzNhak40MFlwWFpRX0FCZjV3d19neHlnDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2h0dHANCkNvbnRlbnQtSUQ6IHJlc3BvbnNlLWd0bHJfNg0KDQpIVFRQLzEuMSA0MDQgTm90IEZvdW5kDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9VVRGLTgNCkRhdGU6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpFeHBpcmVzOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KQ2FjaGUtQ29udHJvbDogcHJpdmF0ZSwgbWF4LWFnZT0wDQpDb250ZW50LUxlbmd0aDogMTcwODINCg0Kew0KICJlcnJvciI6IHsNCiAgImVycm9ycyI6IFsNCiAgIHsNCiAgICAiZG9tYWluIjogImdsb2JhbCIsDQogICAgInJlYXNvbiI6ICJub3RGb3VuZCIsDQogICAgIm1lc3NhZ2UiOiAiRmlsZSBub3QgZm91bmQ6IGJhZElELiIsDQogICAgImxvY2F0aW9uVHlwZSI6ICJwYXJhbWV0ZXIiLA0KICAgICJsb2NhdGlvbiI6ICJmaWxlSWQiLA0KICAgICJkZWJ1Z0luZm8iOiAiY29kZTogTk9UX0ZPVU5EIg0KICAgfQ0KICBdLA0KICAiY29kZSI6IDQwNCwNCiAgIm1lc3NhZ2UiOiAiRmlsZSBub3QgZm91bmQ6IGJhZElELiINCiB9DQp9DQoNCi0tYmF0Y2hfM2FqTjQwWXBYWlFfQUJmNXd3X2d4eWcNCkNvbnRlbnQtVHlwZTogYXBwbGljYXRpb24vaHR0cA0KQ29udGVudC1JRDogcmVzcG9uc2UtZ3Rscl83DQoNCkhUVFAvMS4xIDIwMCBPSw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9qc29uOyBjaGFyc2V0PVVURi04DQpEYXRlOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KRXhwaXJlczogTW9uLCAwMSBGZWIgMjAxNiAyMjo1MDo1NyBHTVQNCkNhY2hlLUNvbnRyb2w6IHByaXZhdGUsIG1heC1hZ2U9MA0KQ29udGVudC1MZW5ndGg6IDQ0DQoNCnsNCiAia2luZCI6ICJkcml2ZSNmaWxlTGlzdCIsDQogIm5leHRQYWdlVG9rZW4iOiAiMiIsDQogImZpbGVzIjogWw0KICB7DQogICAia2luZCI6ICJkcml2ZSNmaWxlIiwNCiAgICJpZCI6ICIxLWNzbmRlY0xBUmtRSnlhYU1IQjhiQmZhZHNzQ0tnIiwNCiAgICJuYW1lIjogIlBsYWNlbWFwcyIsDQogICAibWltZVR5cGUiOiAiYXBwbGljYXRpb24vdm5kLmdvb2dsZS1hcHBzLm1hcCINCiAgfSwNCiAgew0KICAgImtpbmQiOiAiZHJpdmUjZmlsZSIsDQogICAiaWQiOiAiMTZnM04waTI3Nm93VWMwbTR3VlZIMzQyM0NRIiwNCiAgICJuYW1lIjogIjk5OSBNYWluIFN0LiIsDQogICAibWltZVR5cGUiOiAiYXBwbGljYXRpb24vdm5kLmdvb2dsZS1hcHBzLm1hcCINCiAgfSwNCiAgew0KICAgImtpbmQiOiAiZHJpdmUjZmlsZSIsDQogICAiaWQiOiAiMVRZRnp5ZlZDNWwtVVh0dTZsZGlNWlNhZHNBIiwNCiAgICJuYW1lIjogIk5vcmcgZnVyeiIsDQogICAibWltZVR5cGUiOiAiYXBwbGljYXRpb24vdm5kLmdvb2dsZS1hcHBzLm1hcCINCiAgfQ0KIF0NCn0NCg0KLS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzgNCg0KSFRUUC8xLjEgMjAwIE9LDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9VVRGLTgNCkRhdGU6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpFeHBpcmVzOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KQ2FjaGUtQ29udHJvbDogcHJpdmF0ZSwgbWF4LWFnZT0wDQpDb250ZW50LUxlbmd0aDogNDUNCg0Kew0KICJwYXJlbnRzIjogWw0KICAiMEFMc3ZaRER3dEtyaFVrOVBWQSINCiBdDQp9DQoNCi0tYmF0Y2hfM2FqTjQwWXBYWlFfQUJmNXd3X2d4eWctLQ0K",
    @"Drive1BatchPaging2.response.txt":
        @"LS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzUNCg0KSFRUUC8xLjEgMjAwIE9LDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9VVRGLTgNCkRhdGU6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpFeHBpcmVzOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KQ2FjaGUtQ29udHJvbDogcHJpdmF0ZSwgbWF4LWFnZT0wDQpDb250ZW50LUxlbmd0aDogNDQNCg0Kew0KICJraW5kIjogImRyaXZlI2ZpbGVMaXN0IiwNCiAibmV4dFBhZ2VUb2tlbiI6ICIzIiwNCiAiZmlsZXMiOiBbDQogIHsNCiAgICJraW5kIjogImRyaXZlI2ZpbGUiLA0KICAgImlkIjogIjBCN3N2WkREd3RoUnpkTFpGUkJSRGs0YTBFIiwNCiAgICJuYW1lIjogIjAwNTEtQW5kcm9pZC1mdW5jdGlvbnMucGF0Y2giLA0KICAgIm1pbWVUeXBlIjogInRleHQveC1kaWZmIg0KICB9LA0KICB7DQogICAia2luZCI6ICJkcml2ZSNmaWxlIiwNCiAgICJpZCI6ICIwQjdzdlpERHd0S3IxQlZNa2RGY1ZrM04xayIsDQogICAibmFtZSI6ICJUcmVlIFR5cGVzLnBkZiIsDQogICAibWltZVR5cGUiOiAiYXBwbGljYXRpb24vcGRmIg0KICB9LA0KICB7DQogICAia2luZCI6ICJkcml2ZSNmaWxlIiwNCiAgICJpZCI6ICIwQjdzdlpERHd0S1ZsQnBhMVExZWsxbVZXYyIsDQogICAibmFtZSI6ICJBY2NvdW50aW5nLnBkZiIsDQogICAibWltZVR5cGUiOiAiYXBwbGljYXRpb24vcGRmIg0KICB9DQogXQ0KfQ0KDQotLWJhdGNoXzNhak40MFlwWFpRX0FCZjV3d19neHlnDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2h0dHANCkNvbnRlbnQtSUQ6IHJlc3BvbnNlLWd0bHJfNw0KDQpIVFRQLzEuMSA0MDAgSW52YWxpZCBSZXF1ZXN0DQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9VVRGLTgNCkRhdGU6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpFeHBpcmVzOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KQ2FjaGUtQ29udHJvbDogcHJpdmF0ZSwgbWF4LWFnZT0wDQpDb250ZW50LUxlbmd0aDogMTcwODINCg0Kew0KICJlcnJvciI6IHsNCiAgImVycm9ycyI6IFsNCiAgIHsNCiAgICAiZG9tYWluIjogImdsb2JhbCIsDQogICAgInJlYXNvbiI6ICJiYWRSZXF1ZXN0IiwNCiAgICAibWVzc2FnZSI6ICJpbnZhbGlkIHJlcXVlc3QuIiwNCiAgICAibG9jYXRpb25UeXBlIjogInBhcmFtZXRlciIsDQogICAgImxvY2F0aW9uIjogImZpbGVJZCIsDQogICAgImRlYnVnSW5mbyI6ICJjb2RlOiBJTlZBTElEX1JFUVVFU1QiDQogICB9DQogIF0sDQogICJjb2RlIjogNDAwLA0KICAibWVzc2FnZSI6ICJJbnZhbGlkIHJlcXVlc3QuIg0KIH0NCn0NCg0KLS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zy0tDQo=",
    @"Drive1BatchPaging3.response.txt":
        @"LS1iYXRjaF8zYWpONDBZcFhaUV9BQmY1d3dfZ3h5Zw0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzUNCg0KSFRUUC8xLjEgMjAwIE9LDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb247IGNoYXJzZXQ9VVRGLTgNCkRhdGU6IE1vbiwgMDEgRmViIDIwMTYgMjI6NTA6NTcgR01UDQpFeHBpcmVzOiBNb24sIDAxIEZlYiAyMDE2IDIyOjUwOjU3IEdNVA0KQ2FjaGUtQ29udHJvbDogcHJpdmF0ZSwgbWF4LWFnZT0wDQpDb250ZW50LUxlbmd0aDogNDQNCg0Kew0KICJraW5kIjogImRyaXZlI2ZpbGVMaXN0IiwNCiAiZmlsZXMiOiBbDQogIHsNCiAgICJraW5kIjogImRyaXZlI2ZpbGUiLA0KICAgImlkIjogIjBCN3N2WkREd3RoUnpkTFpGRGs0YTBFIiwNCiAgICJuYW1lIjogIkhlcm8tZnVuY3Rpb25zLnBhdGNoIiwNCiAgICJtaW1lVHlwZSI6ICJ0ZXh0L3gtZGlmZiINCiAgfSwNCiAgew0KICAgImtpbmQiOiAiZHJpdmUjZmlsZSIsDQogICAiaWQiOiAiMEI3c3ZaRER3dEtyMUJWVmszTjFrIiwNCiAgICJuYW1lIjogIk1vdXNlIFR5cGVzLnBkZiIsDQogICAibWltZVR5cGUiOiAiYXBwbGljYXRpb24vcGRmIg0KICB9DQogXQ0KfQ0KDQotLWJhdGNoXzNhak40MFlwWFpRX0FCZjV3d19neHlnLS0NCg==",
    @"Drive1Corrupt.response.txt":
        @"eyBhYmMgOjo9PSB9Cg==",
    @"Drive1Empty.response.txt":
        @"ewp9Cg==",
    @"Drive1Paging1.response.txt":
        @"ewogICJraW5kIiA6ICJkcml2ZSNmaWxlTGlzdCIsCiAgIm5leHRQYWdlVG9rZW4iIDogIjIiLAogICJmaWxlcyIgOiBbCiAgICB7CiAgICAgICJtaW1lVHlwZSIgOiAiYXBwbGljYXRpb25cL3ZuZC5nb29nbGUtYXBwcy5kb2N1bWVudCIsCiAgICAgICJpZCIgOiAiMV90S2FVaGprM1lrRjNSWWsxZCIsCiAgICAgICJraW5kIiA6ICJkcml2ZSNmaWxlIiwKICAgICAgIm5hbWUiIDogIkhvdXNlIFBob25lIExpc3QiLAogICAgICAidHJhc2hlZCIgOiBmYWxzZQogICAgfSwKICAgIHsKICAgICAgIm1pbWVUeXBlIiA6ICJhcHBsaWNhdGlvblwvcGRmIiwKICAgICAgImlkIiA6ICIwQjdzdlpERHd0S3JoTkcxdVJSbWNra3RTMmMiLAogICAgICAia2luZCIgOiAiZHJpdmUjZmlsZSIsCiAgICAgICJuYW1lIiA6ICJBY2NvdW50aW5nLnBkZiIsCiAgICAgICJ0cmFzaGVkIiA6IGZhbHNlCiAgICB9LAogICAgewogICAgICAibWltZVR5cGUiIDogImFwcGxpY2F0aW9uXC92bmQuZ29vZ2xlLWFwcHMuZm9sZGVyIiwKICAgICAgImlkIiA6ICIwQjdzdlpERHd0S3JoUkMxVGxwb1FYRnJlVzgiLAogICAgICAia2luZCIgOiAiZHJpdmUjZmlsZSIsCiAgICAgICJuYW1lIiA6ICJMb3RzIG9mIHN0dWZmIiwKICAgICAgInRyYXNoZWQiIDogZmFsc2UsCiAgICB9CiAgXQp9Cg==",
    @"Drive1Paging2.response.txt":
        @"ewogICJraW5kIiA6ICJkcml2ZSNmaWxlTGlzdCIsCiAgIm5leHRQYWdlVG9rZW4iIDogIjMiLAogICJmaWxlcyIgOiBbCiAgICB7CiAgICAgICJtaW1lVHlwZSIgOiAiYXBwbGljYXRpb25cL3ZuZC5nb29nbGUtYXBwcy5zcHJlYWRzaGVldCIsCiAgICAgICJpZCIgOiAiMTM0UUlhZWhndFJxLXF2IiwKICAgICAgImtpbmQiIDogImRyaXZlI2ZpbGUiLAogICAgICAibmFtZSIgOiAiTW9yZSBzaGVldHMiLAogICAgICAidHJhc2hlZCIgOiBmYWxzZQogICAgfSwKICAgIHsKICAgICAgIm1pbWVUeXBlIiA6ICJpbWFnZVwvcG5nIiwKICAgICAgImlkIiA6ICIwQjdzdlpERHd0S3JoVUZvWlhnemVVbG1aV00iLAogICAgICAia2luZCIgOiAiZHJpdmUjZmlsZSIsCiAgICAgICJuYW1lIiA6ICJDYWxlbmRhck1vdXNlb3Zlci5wbmciLAogICAgICAidHJhc2hlZCIgOiBmYWxzZQogICAgfSwKICAgIHsKICAgICAgIm1pbWVUeXBlIiA6ICJiaW5hcnlcL29jdGV0LXN0cmVhbSIsCiAgICAgICJpZCIgOiAiMEI3c3ZaRER3dEtyaE9Wa1RVIiwKICAgICAgImtpbmQiIDogImRyaXZlI2ZpbGUiLAogICAgICAibmFtZSIgOiAiRmFzdGZvb2QudGV4dENsaXBwaW5nIiwKICAgICAgInRyYXNoZWQiIDogZmFsc2UsCiAgICB9CiAgXQp9Cg==",
    @"Drive1Paging3.response.txt":
        @"ewogICJraW5kIiA6ICJkcml2ZSNmaWxlTGlzdCIsCiAgImZpbGVzIiA6IFsKICAgIHsKICAgICAgIm1pbWVUeXBlIiA6ICJhcHBsaWNhdGlvblwvdm5kLmdvb2dsZS1hcHBzLnNwcmVhZHNoZWV0IiwKICAgICAgImlkIiA6ICIxZEtjQWJic3Y2UHJMYWdvTDJEX3I2IiwKICAgICAgImtpbmQiIDogImRyaXZlI2ZpbGUiLAogICAgICAibmFtZSIgOiAiMjAwNiB0YXggZGVkdWN0aW9ucyIsCiAgICAgICJ0cmFzaGVkIiA6IGZhbHNlCiAgICB9LAogICAgewogICAgICAibWltZVR5cGUiIDogImFwcGxpY2F0aW9uXC92bmQuZ29vZ2xlLWFwcHMuZG9jdW1lbnQiLAogICAgICAiaWQiIDogIjFNMFhZakdoRWJZMUJ6SHM1c3JPcFEiLAogICAgICAia2luZCIgOiAiZHJpdmUjZmlsZSIsCiAgICAgICJuYW1lIiA6ICJBbm90aGVyIGRvYyIsCiAgICAgICJ0cmFzaGVkIiA6IGZhbHNlCiAgICB9CiAgXQp9Cg==",
    @"Drive1ParamError.response.txt":
        @"ewogICJlcnJvciIgOiB7CiAgICAibWVzc2FnZSIgOiAiSW52YWxpZCBWYWx1ZSIsCiAgICAiZXJyb3JzIiA6IFsKICAgICAgewogICAgICAgICJtZXNzYWdlIiA6ICJJbnZhbGlkIFZhbHVlIiwKICAgICAgICAibG9jYXRpb25UeXBlIiA6ICJwYXJhbWV0ZXIiLAogICAgICAgICJyZWFzb24iIDogImludmFsaWQiLAogICAgICAgICJkb21haW4iIDogImdsb2JhbCIsCiAgICAgICAgImxvY2F0aW9uIiA6ICJwYWdlVG9rZW4iLAogICAgICAgICJkZWJ1Z0luZm8iIDogImNvZGU6IElOVkFMSURfVkFMVUUiCiAgICAgIH0KICAgIF0sCiAgICAiY29kZSIgOiA0MDAKICB9Cn0K",
    @"Drive1ParamErrorAsList.response.txt":
        @"W3sKICAiZXJyb3IiIDogewogICAgIm1lc3NhZ2UiIDogIkludmFsaWQgVmFsdWUiLAogICAgImVycm9ycyIgOiBbCiAgICAgIHsKICAgICAgICAibWVzc2FnZSIgOiAiSW52YWxpZCBWYWx1ZSIsCiAgICAgICAgImxvY2F0aW9uVHlwZSIgOiAicGFyYW1ldGVyIiwKICAgICAgICAicmVhc29uIiA6ICJpbnZhbGlkIiwKICAgICAgICAiZG9tYWluIiA6ICJnbG9iYWwiLAogICAgICAgICJsb2NhdGlvbiIgOiAicGFnZVRva2VuIiwKICAgICAgICAiZGVidWdJbmZvIiA6ICJjb2RlOiBJTlZBTElEX1ZBTFVFIgogICAgICB9CiAgICBdLAogICAgImNvZGUiIDogNDAwCiAgfQp9Cl0K",
    @"NoPayloadsBatch.response.txt":
        @"LS1iYXRjaF9oWExfM19VbkxzUV9BQVlXNmtRNExZVQ0KQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9odHRwDQpDb250ZW50LUlEOiByZXNwb25zZS1ndGxyXzM5DQoNCkhUVFAvMS4xIDIwNCBObyBDb250ZW50DQpEYXRlOiBXZWQsIDI0IEp1biAyMDIwIDA5OjIxOjI0IEdNVA0KDQoNCi0tYmF0Y2hfaFhMXzNfVW5Mc1FfQUFZVzZrUTRMWVUNCkNvbnRlbnQtVHlwZTogYXBwbGljYXRpb24vaHR0cA0KQ29udGVudC1JRDogcmVzcG9uc2UtZ3Rscl80MA0KDQpIVFRQLzEuMSAyMDQgTm8gQ29udGVudA0KDQoNCi0tYmF0Y2hfaFhMXzNfVW5Mc1FfQUFZVzZrUTRMWVUNCg==",
  };

  NSString *base64Str = dataFiles[fileName];
  if (!base64Str) {
    NSLog(@"Unknown filename: %@", fileName);
    return nil;
  }

  NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str
                                                     options:0];
  if (!data) {
    NSLog(@"Failed to decode: %@", fileName);
    return nil;
  }

  return data;
}

static NSHTTPURLResponse *QueryResponseWithURL(NSURL *url,
                                               NSInteger status,
                                               NSString *contentType) {
  // Make a succesful API response to feed to the fetcher testBlock.
  return [[NSHTTPURLResponse alloc] initWithURL:url
                                     statusCode:status
                                    HTTPVersion:@"HTTP/1.1"
                                   headerFields:@{ @"Content-Type" : contentType }];
}

- (GTMSessionFetcherTestBlock)fetcherTestBlockWithResponseForFileName:(NSString *)fileName
                                                               status:(NSInteger)status {
  return [self fetcherTestBlockWithResponseForFileName:fileName
                                                status:status
                                  numberOfStatusErrors:0
                                     multipartBoundary:nil];
}

- (GTMSessionFetcherTestBlock)fetcherTestBlockWithResponseForFileName:(NSString *)fileName
                                                               status:(NSInteger)initialStatus
                                                 numberOfStatusErrors:(NSInteger)numberOfStatusErrors
                                                    multipartBoundary:(NSString *)multipartBoundary {
  GTMSessionFetcherTestBlock testBlock = ^(GTMSessionFetcher *fetcherToTest,
                                           GTMSessionFetcherTestResponse testResponse) {
    NSString *topContentType = @"application/json; charset=UTF-8";
    if (multipartBoundary) {
      topContentType = [NSString stringWithFormat:@"multipart/mixed; boundary=%@",
                        multipartBoundary];
    }

    NSInteger status = initialStatus;
    if (numberOfStatusErrors > 0 && (NSInteger)fetcherToTest.retryCount >= numberOfStatusErrors) {
      status = 200;
    }

    NSHTTPURLResponse *response = QueryResponseWithURL(fetcherToTest.request.URL,
                                                       status,
                                                       topContentType);
    NSData *responseData;
    if (status != 204) {
      if (fileName) {
        responseData = [[self class] dataForTestFileName:fileName];
        XCTAssertNotNil(responseData, @"%@", fileName);
      }
    } else {
      // We expect 204 "No content" on delete, for example.
    }
    NSError *responseError = nil;
    if (status >= 400) {
      responseError = [NSError errorWithDomain:kGTMSessionFetcherStatusDomain
                                          code:status
                                      userInfo:nil];
    }
    testResponse(response, responseData, responseError);
  };
  return testBlock;
}

static NSString *QueryValueForURLItem(NSURL *url, NSString *itemName) {
  NSURLComponents *components = [NSURLComponents componentsWithURL:url
                                           resolvingAgainstBaseURL:YES];
  NSArray *queryItems = components.queryItems;
  for (NSURLQueryItem *thisItem in queryItems) {
    if ([thisItem.name isEqual:itemName]) {
      return thisItem.value;
    }
  }
  return nil;
}

// This matches GTLRURITemplate's version.
static NSString *EscapeString(NSString *str, BOOL allowReserved) {
  NSMutableCharacterSet *cs = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
  NSString * const kReservedChars = @":/?#[]@!$&'()*+,;=";
  if (allowReserved) {
    [cs addCharactersInString:kReservedChars];
  } else {
    [cs removeCharactersInString:kReservedChars];
  }
  NSString *resultStr = [str stringByAddingPercentEncodingWithAllowedCharacters:cs];
  return resultStr;
}


static BOOL WWWFormDataHasValue(NSData *wwwFormData,
                                NSString *itemName, NSString *itemValue) {
  NSString *escapedItemValue = EscapeString(itemValue, NO);
  NSRange fullRange = NSMakeRange(0, wwwFormData.length);
  NSString *needle = [NSString stringWithFormat:@"&%@=%@&", itemName, escapedItemValue];
  NSData *needleData = [needle dataUsingEncoding:NSUTF8StringEncoding];
  NSRange range = [wwwFormData rangeOfData:needleData
                                   options:0
                                     range:fullRange];
  if (range.location != NSNotFound) {
    return YES;
  }

  // It could be the first or last, so check those cases.
  needle = [NSString stringWithFormat:@"%@=%@&", itemName, escapedItemValue];
  needleData = [needle dataUsingEncoding:NSUTF8StringEncoding];
  range = [wwwFormData rangeOfData:needleData
                           options:NSDataSearchAnchored
                             range:fullRange];
  if (range.location == 0) {
    return YES;
  }
  needle = [NSString stringWithFormat:@"&%@=%@", itemName, escapedItemValue];
  needleData = [needle dataUsingEncoding:NSUTF8StringEncoding];
  range = [wwwFormData rangeOfData:needleData
                           options:(NSDataSearchAnchored | NSDataSearchBackwards)
                             range:fullRange];
  if (range.location != NSNotFound) {
    return YES;
  }

  // Last case, the data was just the one pair.
  needle = [NSString stringWithFormat:@"%@=%@", itemName, escapedItemValue];
  needleData = [needle dataUsingEncoding:NSUTF8StringEncoding];
  if ([wwwFormData isEqual:needleData]) {
    return YES;
  }

  return NO;
}

static BOOL IsCurrentQueue(dispatch_queue_t targetQueue) {
  const char *targetQueueLabel = dispatch_queue_get_label(targetQueue);
  const char *currentQueueLabel = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
  int result = strcmp(currentQueueLabel, targetQueueLabel);
  return result == 0;
}

- (GTLRService *)driveServiceForTest {
  // TestingSvsService is a minimal clone of Drive, but the tests don't use the
  // "real" Drive service so the tests won't break if/when the Drive api
  // evolves.
  GTLRService *service = [[GTLRTestingSvcService alloc] init];
  service.authorizer = [GTLRTestAuthorizer authorizerWithValue:@"catpaws"];
  return service;
}

- (BOOL)service:(GTLRService *)service waitForTicket:(GTLRServiceTicket *)ticket {
  BOOL finishedInTime = [service waitForTicket:ticket timeout:10.0];
  return finishedInTime;
}

- (void)expectTicketNotifications {
  [self expectationForNotification:kGTLRServiceTicketStartedNotification
                            object:nil
                           handler:nil];
  [self expectationForNotification:kGTLRServiceTicketStoppedNotification
                            object:nil
                           handler:nil];
}

- (void)expectTicketAndParsingNotifications {
  [self expectTicketNotifications];

  // Parsing notifications are expected whenever the fetcher returns a nil error
  // and non-empty data.
  [self expectationForNotification:kGTLRServiceTicketParsingStartedNotification
                            object:nil
                           handler:nil];
  [self expectationForNotification:kGTLRServiceTicketParsingStoppedNotification
                            object:nil
                           handler:nil];
}

- (void)setCountingUIAppWithExpirations:(BOOL)shouldExpireTasks {
#if GTM_BACKGROUND_TASK_FETCHING
  CountingUIApplication *countingUIApp = [[CountingUIApplication alloc] init];
  countingUIApp.shouldExpireTasks = shouldExpireTasks;

  [GTMSessionFetcher setSubstituteUIApplication:countingUIApp];
#endif
}

- (void)verifyCountingUIAppWithExpectedCount:(NSUInteger)expectedCount
                         expectedExpirations:(NSUInteger)expectedExpirations {
#if GTM_BACKGROUND_TASK_FETCHING
  CountingUIApplication *countingUIApp = [GTMSessionFetcher substituteUIApplication];
  XCTAssertNotNil(countingUIApp);

  XCTAssertEqual(countingUIApp.beginTaskIDs.count, expectedCount);
  XCTAssertEqualObjects(countingUIApp.beginTaskIDs, countingUIApp.endTaskIDs);

  XCTAssertEqual(countingUIApp.numberOfExpiredTasks, expectedExpirations);

  [self clearCountingUIApp];
#endif
}

- (void)clearCountingUIApp {
#if GTM_BACKGROUND_TASK_FETCHING
  [GTMSessionFetcher setSubstituteUIApplication:nil];
#endif
}

#pragma mark - Query Execution Tests

- (void)testService_SingleQuery {
  // Successful request with valid authorization.
  //
  // Response is file Drive1.response.txt
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  service.serviceProperties = @{ @"Marsupial" : @"Koala", @"Dolphin" : @"Spinner" };

  [self expectTicketAndParsingNotifications];

  [self setCountingUIAppWithExpirations:NO];

  NSString *timeParam = @"2011-05-04T23:28:20.888Z";

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)";
  query.pageSize = 10;
  query.requestID = @"gtlr_1234";
  query.timeParamForTesting = [GTLRDateTime dateTimeWithRFC3339String:timeParam];

  query.additionalHTTPHeaders = @{ @"X-Feline": @"Fluffy",
                                   @"X-Canine": @"Spot" };

  query.additionalURLQueryParameters = @{ @"meowParam": @"Meow" };

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket, BOOL suggestedWillRetry,
                                           NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };
  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    XCTFail(@"No body upload expected.");
  };
  query.executionParameters.ticketProperties = @{ @"Bird" : @"Kookaburra", @"Dolphin" : @"Tucuxi" };

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.kind, @"drive#fileList");
            XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

            GTLRTestingSvc_File *item0 = object.files[0];

            XCTAssertEqualObjects([item0 class], [GTLRTestingSvc_File class]);
            XCTAssertEqualObjects(item0.kind, @"drive#file");

            XCTAssertEqualObjects(object.timeFieldForTesting.RFC3339String,
                                  @"2011-01-02T03:04:05.067Z");

            XCTAssertEqualObjects(callbackTicket, queryTicket);

            // The ticket's query should be a copy of the original; query execution leaves
            // the original unmolested so the client can modify and reuse it.
            GTLRQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, query);
            XCTAssertEqualObjects(ticketQuery.requestID, query.requestID);

            // Service properties should be copied to the ticket.
            XCTAssertEqualObjects(callbackTicket.ticketProperties[@"Marsupial"], @"Koala");
            XCTAssertEqualObjects(callbackTicket.ticketProperties[@"Bird"], @"Kookaburra");
            XCTAssertEqualObjects(callbackTicket.ticketProperties[@"Dolphin"], @"Tucuxi");

            XCTAssert([NSThread isMainThread]);

            [queryFinished fulfill];
          }];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // GTLRQuery query parameters.
  NSURLRequest *fetcherRequest = queryTicket.objectFetcher.request;
  XCTAssertEqualObjects(QueryValueForURLItem(fetcherRequest.URL, @"fields"), query.fields);
  XCTAssertEqualObjects(QueryValueForURLItem(fetcherRequest.URL, @"pageSize"), @"10");
  XCTAssertEqualObjects(QueryValueForURLItem(fetcherRequest.URL, @"prettyPrint"), @"false");
  XCTAssertEqualObjects(QueryValueForURLItem(fetcherRequest.URL, @"timeParamForTesting"),
                        timeParam);

  // Test things added to the request:
  // Authorization header, additionalHTTPHeaders, and additionalURLQueryParameters
  //
  // Headers.
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"Authorization"],
                        @"Bearer catpaws");
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"X-Feline"], @"Fluffy");
  // URL query parameters.
  XCTAssertEqualObjects(QueryValueForURLItem(fetcherRequest.URL, @"meowParam"), @"Meow");

  // The fetcher releases its authorizer upon completion, so to test the request,
  // we'll use the service's authorizer.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
  id<GTMFetcherAuthorizationProtocol> authorizer = service.authorizer;
#pragma clang diagnostic pop
  XCTAssertNotNil(authorizer);
  XCTAssert([authorizer isAuthorizedRequest:fetcherRequest],
            @"%@", fetcherRequest.allHTTPHeaderFields);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // The fetcher and GTLRService both start and end background tasks, so we expect 2 invocations of
  // beginBackgroundTask and endBackgroundTask.

  [self verifyCountingUIAppWithExpectedCount:2
                         expectedExpirations:0];
}

- (void)testService_SingleQuery_LongURLToFormPost {
  // Successful request with valid authorization but with URL query arguments
  // forcing it into a www forms post.
  //
  // Response is file Drive1.response.txt
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  service.serviceProperties = @{ @"Marsupial" : @"Koala", @"Dolphin" : @"Spinner" };

  [self expectTicketAndParsingNotifications];

  [self setCountingUIAppWithExpirations:NO];

  NSString *timeParam = @"2011-05-04T23:28:20.888Z";

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)";
  query.pageSize = 10;
  query.requestID = @"gtlr_1234";
  query.timeParamForTesting = [GTLRDateTime dateTimeWithRFC3339String:timeParam];

  // Add a bunch of entries to ensure we go over the URL size limit.
  NSMutableArray<NSString *> *extras = [NSMutableArray array];
  for (NSUInteger x = 0 ; x < 1024; ++x) {
    [extras addObject:[@(x) description]];
  }
  query.extras = extras;

  query.additionalHTTPHeaders = @{ @"X-Feline": @"Fluffy",
                                   @"X-Canine": @"Spot" };

  query.additionalURLQueryParameters = @{ @"meowParam": @"Meow" };

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket, BOOL suggestedWillRetry,
                                           NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };
  XCTestExpectation *uploadedSomeBytes = [self expectationWithDescription:@"uploadedSomeBytes"];
  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    // The arg will go in the body, so uploadProgressBlock will see them.
    if (numberOfBytesRead == dataLength) {
      [uploadedSomeBytes fulfill];
    }
    XCTAssert([NSThread isMainThread]);
  };
  query.executionParameters.ticketProperties = @{ @"Bird" : @"Kookaburra", @"Dolphin" : @"Tucuxi" };

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.kind, @"drive#fileList");
            XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

            GTLRTestingSvc_File *item0 = object.files[0];

            XCTAssertEqualObjects([item0 class], [GTLRTestingSvc_File class]);
            XCTAssertEqualObjects(item0.kind, @"drive#file");

            XCTAssertEqualObjects(object.timeFieldForTesting.RFC3339String,
                                  @"2011-01-02T03:04:05.067Z");

            XCTAssertEqualObjects(callbackTicket, queryTicket);

            // The ticket's query should be a copy of the original; query execution leaves
            // the original unmolested so the client can modify and reuse it.
            GTLRQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, query);
            XCTAssertEqualObjects(ticketQuery.requestID, query.requestID);

            // Service properties should be copied to the ticket.
            XCTAssertEqualObjects(callbackTicket.ticketProperties[@"Marsupial"], @"Koala");
            XCTAssertEqualObjects(callbackTicket.ticketProperties[@"Bird"], @"Kookaburra");
            XCTAssertEqualObjects(callbackTicket.ticketProperties[@"Dolphin"], @"Tucuxi");

            XCTAssert([NSThread isMainThread]);

            [queryFinished fulfill];
          }];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  NSURLRequest *fetcherRequest = queryTicket.objectFetcher.request;

  // Should be a POST with the X-HTTP-Method-Override header and correct
  // Content-Type.
  XCTAssertEqualObjects(fetcherRequest.HTTPMethod, @"POST");
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"X-HTTP-Method-Override"],
                        @"GET");
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"Content-Type"],
                        @"application/x-www-form-urlencoded");

  // GTLRQuery query parameters.
  XCTAssertNil(fetcherRequest.URL.query); // Should be in the body instead.
  NSData *dataPosted = queryTicket.objectFetcher.bodyData;
  XCTAssertNotNil(dataPosted);
  XCTAssertTrue(WWWFormDataHasValue(dataPosted, @"fields", query.fields));
  XCTAssertTrue(WWWFormDataHasValue(dataPosted, @"pageSize", @"10"));
  XCTAssertTrue(WWWFormDataHasValue(dataPosted, @"prettyPrint", @"false"));
  XCTAssertTrue(WWWFormDataHasValue(dataPosted, @"timeParamForTesting", timeParam));

  // Test things added to the request:
  // Authorization header, additionalHTTPHeaders, and additionalURLQueryParameters
  //
  // Headers.
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"Authorization"],
                        @"Bearer catpaws");
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"X-Feline"], @"Fluffy");
  // URL query parameters.
  XCTAssertTrue(WWWFormDataHasValue(dataPosted, @"meowParam", @"Meow"));

  // The fetcher releases its authorizer upon completion, so to test the request,
  // we'll use the service's authorizer.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
  id<GTMFetcherAuthorizationProtocol> authorizer = service.authorizer;
#pragma clang diagnostic pop
  XCTAssertNotNil(authorizer);
  XCTAssert([authorizer isAuthorizedRequest:fetcherRequest],
            @"%@", fetcherRequest.allHTTPHeaderFields);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // The fetcher and GTLRService both start and end background tasks, so we expect 2 invocations of
  // beginBackgroundTask and endBackgroundTask.

  [self verifyCountingUIAppWithExpectedCount:2
                         expectedExpirations:0];
}

- (void)testService_SingleQuery_SelectorCallback {
  // Successful request with selector callback.
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  [self expectTicketAndParsingNotifications];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name)";

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  // We'll put the callback tests in a block in the ticket properties.
  query.executionParameters.ticketProperties =
    @{ @"callback tests" : ^(GTLRServiceTicket *callbackTicket,
                             GTLRTestingSvc_FileList *object,
                             NSError *error){
      // Verify the top-level object and one of its items.
      XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
      XCTAssertNil(error);

      XCTAssertEqualObjects(object.kind, @"drive#fileList");
      XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

      // The ticket's query should be a copy of the original; query execution leaves
      // the original unmolested so the client can modify and reuse it.
      GTLRQuery *ticketQuery = callbackTicket.executingQuery;
      XCTAssertNotEqual(ticketQuery, query);
      XCTAssertEqualObjects(ticketQuery.requestID, query.requestID);

      XCTAssert([NSThread isMainThread]);

      [queryFinished fulfill];
    }};

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
                   delegate:self
          didFinishSelector:@selector(serviceTicket:finishedWithObject:error:)];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

// Callback method for use in testService_SingleQuery_SelectorCallback
//
// The ticket properties have a block to be executed.
- (void)serviceTicket:(GTLRServiceTicket *)callbackTicket
   finishedWithObject:(GTLRTestingSvc_FileList *)object
                error:(NSError *)callbackError {
  GTLRServiceCompletionHandler block = callbackTicket.ticketProperties[@"callback tests"];
  block(callbackTicket, object, callbackError);
}

- (void)testService_SingleQuery_QueryWithResourceURL {
  // Successful based on fixed URL.
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  [self expectTicketAndParsingNotifications];

  GTLRTestingSvcQuery_FilesList *templateQuery = [GTLRTestingSvcQuery_FilesList query];
  templateQuery.fields = @"kind,files(id,kind,name)";

  // Set a specific request URL by getting the actual query URL.
  NSURLRequest *request = [service requestForQuery:templateQuery];
  NSURL *requestURL = request.URL;

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service fetchObjectWithURL:requestURL
                      objectClass:[GTLRTestingSvc_FileList class]
              executionParameters:nil
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object,
                              NSError *callbackError) {
    // Verify the top-level object and one of its items.
    XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
    XCTAssertNil(callbackError);

    XCTAssertEqualObjects(object.kind, @"drive#fileList");
    XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

    XCTAssert([NSThread isMainThread]);

    [queryFinished fulfill];
  }];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  NSURL *fetcherRequestURL = queryTicket.objectFetcher.request.URL;
  XCTAssertEqualObjects(fetcherRequestURL.host, @"www.googleapis.com");
  XCTAssertEqualObjects(fetcherRequestURL.path, @"/drive/v3/files");
}

- (void)testService_SingleQuery_ExpiredBackgroundTasks {
  // Successful request with expired background tasks.
  [self setCountingUIAppWithExpirations:YES];

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt"
                                             status:456
                               numberOfStatusErrors:1
                                  multipartBoundary:nil];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind)";

  XCTestExpectation *completionExp = [self expectationWithDescription:@"completionExp"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            [completionExp fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // The fetcher and GTLRService both start and end background tasks, so we expect 2 invocations of
  // beginBackgroundTask and endBackgroundTask, both expired.
  [self verifyCountingUIAppWithExpectedCount:2
                         expectedExpirations:2];
}

- (void)testService_SingleQuery_Paging {
  // Successful request with 3 pages of results, 8 total result items.
  //
  // Response is file Drive1.response.txt
  GTLRService *service = [self driveServiceForTest];

  [self setCountingUIAppWithExpirations:NO];

  __block GTLRServiceTicket *queryTicket;
  __block int pageCounter = 0;  // 1-based as page requests come in to the fetcher.

  void (^checkRequestParamsAndHeaders)(NSURLRequest *) = ^(NSURLRequest *request){
    // GTLRQuery query parameters.
    XCTAssertEqualObjects(QueryValueForURLItem(request.URL, @"pageSize"), @"3");
    if (pageCounter == 0) {
      XCTAssertNil(QueryValueForURLItem(request.URL, @"pageToken"));
    } else {
      XCTAssertEqualObjects(QueryValueForURLItem(request.URL, @"pageToken"),
                            @(pageCounter + 1).stringValue);
    }
    // All queries should have all header fields and added params.
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Authorization"], @"Bearer catpaws");
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"X-Feline"], @"Fluffy");

    XCTAssertEqualObjects(QueryValueForURLItem(request.URL, @"meowParam"), @"Meow");
  };

  service.fetcherService.testBlock = ^(GTMSessionFetcher *fetcherToTest,
                                       GTMSessionFetcherTestResponse testResponse) {
    checkRequestParamsAndHeaders(fetcherToTest.request);
    XCTAssertEqual(queryTicket.pagesFetchedCounter, (NSUInteger)pageCounter);

    ++pageCounter;

    NSHTTPURLResponse *response = QueryResponseWithURL(fetcherToTest.request.URL,
                                                       200, @"application/json");
    NSString *fileName = [NSString stringWithFormat:@"Drive1Paging%d.response.txt", pageCounter];
    NSData *responseData = [[self class] dataForTestFileName:fileName];;
    XCTAssertNotNil(responseData, @"%@", fileName);
    testResponse(response, responseData, nil);
  };

  [self expectTicketAndParsingNotifications];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name,trashed)";
  query.pageSize = 3;

  query.additionalHTTPHeaders = @{ @"X-Feline": @"Fluffy",
                                   @"X-Canine": @"Spot" };

  query.additionalURLQueryParameters = @{ @"meowParam": @"Meow" };

  query.executionParameters.shouldFetchNextPages = @YES;
  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket, BOOL suggestedWillRetry,
                                           NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };
  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    XCTFail(@"No body upload expected.");
  };

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  queryTicket = [service executeQuery:query
                    completionHandler:^(GTLRServiceTicket *callbackTicket,
                                        GTLRTestingSvc_FileList *object, NSError *error) {
    XCTAssertEqual(pageCounter, 3);

    // Verify the top-level object and one of its items.
    XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
    XCTAssertNil(error);

    XCTAssertEqualObjects(object.kind, @"drive#fileList");
    XCTAssertEqual(object.files.count, 8U, @"%@", object.files);

    GTLRTestingSvc_File *item0 = object.files[0];
    XCTAssertEqualObjects([item0 class], [GTLRTestingSvc_File class]);
    XCTAssertEqualObjects(item0.kind, @"drive#file");
    XCTAssertEqualObjects(item0.identifier, @"1_tKaUhjk3YkF3RYk1d");

    GTLRTestingSvc_File *item7 = object.files[7];
    XCTAssertEqualObjects([item7 class], [GTLRTestingSvc_File class]);
    XCTAssertEqualObjects(item7.kind, @"drive#file");
    XCTAssertEqualObjects(item7.identifier, @"1M0XYjGhEbY1BzHs5srOpQ");

    XCTAssert([NSThread isMainThread]);

    [queryFinished fulfill];
  }];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // We expect six calls to beginBackgroundTask and endBackgroundTask, one for
  // fetcher and GTLRService for each page.
  [self verifyCountingUIAppWithExpectedCount:6
                         expectedExpirations:0];
}

- (void)testService_SingleQuery_SkipAuth {
  // Disallow authorizing request.
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  // Request with an auth error.
  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";
  query.requestID = @"gtlr_1234";
  query.shouldSkipAuthorization = YES;

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(error);

            [queryFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Authorization should have been skipped.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
  id<GTMFetcherAuthorizationProtocol> authorizer = service.authorizer;
#pragma clang diagnostic pop
  NSURLRequest *fetcherRequest = queryTicket.objectFetcher.request;
  XCTAssertNotNil(authorizer);
  XCTAssertFalse([authorizer isAuthorizedRequest:fetcherRequest],
                 @"%@", fetcherRequest.allHTTPHeaderFields);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)performTestService_SingleQuery_InvalidParam:(NSString *)responseFileName {
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:responseFileName status:400];

  // Request an invalid page.
  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";
  query.pageToken = @"NotARealToken";
  query.requestID = @"gtlr_1234";

  XCTestExpectation *queryFinishedExp = [self expectationWithDescription:@"queryFinished"];
  XCTestExpectation *retryExp = [self expectationWithDescription:@"queryFinished"];

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                           BOOL suggestedWillRetry,
                                           NSError *error) {
    [retryExp fulfill];
    return NO;
  };
  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    XCTFail(@"No body upload expected.");
  };

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            XCTAssertNil(object);
            XCTAssertEqualObjects(error.domain, kGTLRErrorObjectDomain);
            XCTAssertEqual(error.code, 400);

            GTLRErrorObject *errorObject = [error.userInfo objectForKey:kGTLRStructuredErrorKey];
            XCTAssertEqual(errorObject.code.intValue, 400);
            XCTAssertEqualObjects(errorObject.message, @"Invalid Value");
            XCTAssertEqual(errorObject.errors.count, (NSUInteger)1);
            XCTAssertEqualObjects(errorObject.errors[0].reason, @"invalid");
            XCTAssertEqualObjects(errorObject.errors[0].message, @"Invalid Value");

            [queryFinishedExp fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  NSURLRequest *fetcherRequest = queryTicket.objectFetcher.request;
  XCTAssertEqualObjects(QueryValueForURLItem(fetcherRequest.URL, @"pageToken"), @"NotARealToken");

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_InvalidParam {
  // Unsuccessful request (invalid page token).
  //
  // Response is file Drive1ParamError.response.txt
  [self performTestService_SingleQuery_InvalidParam:@"Drive1ParamError.response.txt"];
}

- (void)testService_SingleQuery_InvalidParam_ListResult {
  // Unsuccessful request (invalid page token).
  //
  // This is the same as testService_SingleQuery_InvalidParam, expect the response
  // is what happens if the server sees this as a HTTP Streaming call, meaning the
  // error will come back in an array.
  //
  // Response is file Drive1ParamErrorAsList.response.txt
  [self performTestService_SingleQuery_InvalidParam:@"Drive1ParamErrorAsList.response.txt"];
}

- (void)testService_SingleQuery_InvalidAuth {
  // Unsuccessful request (invalid auth).
  //
  // Response is file Drive1AuthError.response.txt
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1AuthError.response.txt" status:401];

  // Request with an auth error.
  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";
  query.requestID = @"gtlr_1234";

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            XCTAssertNil(object);
            XCTAssertEqualObjects(error.domain, kGTLRErrorObjectDomain);
            XCTAssertEqual(error.code, 401);

            [queryFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_CorruptResponse {
  // Successful request with invalid JSON in the response.
  //
  // Response is file Drive1Corrupt.response.txt
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1Corrupt.response.txt" status:200];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name)";
  query.requestID = @"gtlr_1234";

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                           BOOL suggestedWillRetry,
                                           NSError * error) {
    XCTFail(@"No retry expected.");
    return NO;
  };

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertNil(object);
            // NSPropertyListReadCorruptError = 3840
            XCTAssertEqual(error.code, NSPropertyListReadCorruptError, @"%@", error);

            [queryFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_ServiceCallbackQueue {
  [self performCallbackQueueTestUsingExecutionParams:NO];
}

- (void)testService_SingleQuery_ExecutionParamsCallbackQueue {
  [self performCallbackQueueTestUsingExecutionParams:YES];
}

- (void)performCallbackQueueTestUsingExecutionParams:(BOOL)useExecutionParams {
  // Retry once then successful request with callbacks on a specific queue.
  //
  // Response is file Drive1.response.txt
  dispatch_queue_t myCallbackQueue = dispatch_queue_create("myCallbackQueue",
                                                           DISPATCH_QUEUE_SERIAL);
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt"
                                             status:456
                               numberOfStatusErrors:1
                                  multipartBoundary:nil];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind)";

  if (useExecutionParams) {
    query.executionParameters.callbackQueue = myCallbackQueue;
  } else {
    service.callbackQueue = myCallbackQueue;
  }

  XCTestExpectation *completionExp = [self expectationWithDescription:@"completionExp"];
  XCTestExpectation *retryBlockExp = [self expectationWithDescription:@"retryBlockExp"];

  service.retryBlock = ^(GTLRServiceTicket *ticket,
                         BOOL suggestedWillRetry,
                         NSError *error) {
    XCTAssert(IsCurrentQueue(myCallbackQueue));

    [retryBlockExp fulfill];
    return YES;
  };
  service.retryEnabled = YES;

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            XCTAssert(IsCurrentQueue(myCallbackQueue));
            [completionExp fulfill];
          }];

  // Changing the callback queue doesn't affect tickets already issued.
  service.callbackQueue = dispatch_get_main_queue();

  XCTAssert([self service:service waitForTicket:queryTicket]);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_NoCallbacks {
  // Successful request but without any callback blocks provided.
  //
  // Response is file Drive1.response.txt
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  [self expectTicketAndParsingNotifications];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)";
  query.pageSize = 10;
  query.requestID = @"gtlr_1234";

  GTLRServiceTicket *queryTicket = [service executeQuery:query
                                       completionHandler:nil];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_CancelDuringFetch {
  // Successful request, canceled before the fetch returns.
  GTLRService *service = [self driveServiceForTest];

  XCTestExpectation *fetchExp = [self expectationWithDescription:@"fetch happened"];

  __block GTLRServiceTicket *queryTicket;

  service.fetcherService.testBlock = ^(GTMSessionFetcher *fetcherToTest,
                                       GTMSessionFetcherTestResponse testResponse) {
    // Cancel the ticket during the fetch.  This must be async so the ticket variable is non-nil.
    dispatch_async(dispatch_get_main_queue(), ^{
      XCTAssertNotNil(queryTicket);
      [queryTicket cancelTicket];

      NSHTTPURLResponse *response = QueryResponseWithURL(fetcherToTest.request.URL,
                                                         200, @"text/plain");
      NSData *responseData = [NSData data];
      testResponse(response, responseData, nil);

      [fetchExp fulfill];
    });
  };

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name)";
  query.completionBlock = ^(GTLRServiceTicket *callbackTicket, GTLRObject *callbackObj,
                            NSError *callbackError) {
    XCTFail(@"Cancel should skip callbacks");
  };

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                           BOOL suggestedWillRetry,
                                           NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };

  queryTicket = [service executeQuery:query
                    completionHandler:^(GTLRServiceTicket *callbackTicket,
                                        GTLRTestingSvc_FileList *object, NSError *error) {
                      XCTFail(@"Cancel should skip callbacks");
                    }];


  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssertFalse(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_CancelDuringParse {
  // Successful request, canceled after the fetch returns.
  GTLRService *service = [self driveServiceForTest];

  XCTestExpectation *parseExp = [self expectationWithDescription:@"parse notification"];

  __block GTLRServiceTicket *queryTicket;

  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  // Cancel the ticket when we're notified synchronously during parsing.
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  id observer = [nc addObserverForName:@"kGTLRServiceTicketParsingStartedForTestNotification"
                  object:nil
                   queue:nil
              usingBlock:^(NSNotification * _Nonnull note) {
    XCTAssertNotNil(queryTicket);
    XCTAssertEqualObjects(queryTicket, note.object);

    [queryTicket cancelTicket];

    [parseExp fulfill];
  }];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name)";
  query.completionBlock = ^(GTLRServiceTicket *callbackTicket, GTLRObject *callbackObj,
                            NSError *callbackError) {
    XCTFail(@"Cancel should skip callbacks");
  };

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                           BOOL suggestedWillRetry,
                                           NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };

  queryTicket = [service executeQuery:query
                    completionHandler:^(GTLRServiceTicket *callbackTicket,
                                        GTLRTestingSvc_FileList *object, NSError *error) {
                      XCTFail(@"Cancel should skip callbacks");
                    }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssertFalse(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  [nc removeObserver:observer];
}

- (void)testService_Delete {
  // Successful deletion.
  //
  // Response is empty with status 204 "No content"
  [self expectTicketNotifications];

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:nil status:204];

  GTLRTestingSvcQuery_FilesDelete *query =
      [GTLRTestingSvcQuery_FilesDelete queryWithFileId:@"1234"];
  query.fields = @"kind,nextPageToken";
  query.requestID = @"gtlr_1234";

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRObject *object, NSError *error) {
        // Verify that there was no error, but no object returned.
        XCTAssertNil(object);
        XCTAssertNil(error);

        [queryFinished fulfill];
      }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // File ID should be the tail of the query URL.
  NSURLRequest *fetcherRequest = queryTicket.objectFetcher.request;
  XCTAssertEqualObjects(fetcherRequest.URL.lastPathComponent, @"1234");

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)performBodyObjectTestWithQuery:(GTLRTestingSvcQuery_PermissionsCreate *)query
                          expectedBody:(NSDictionary *)expectedJSONBody {
  XCTestExpectation *fetchExp = [self expectationWithDescription:@"Fetched"];
  XCTestExpectation *executeCompletionExp = [self expectationWithDescription:@"Execute block"];

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock = ^(GTMSessionFetcher *fetcherToTest,
                                       GTMSessionFetcherTestResponse testResponse) {
    NSData *fetchBody = fetcherToTest.bodyData;
    NSJSONSerialization *fetchJSONBody = nil;
    if (fetchBody) {
      NSError *parseError;
      fetchJSONBody = [NSJSONSerialization JSONObjectWithData:fetchBody
                                             options:NSJSONReadingMutableContainers
                                               error:&parseError];
      XCTAssertNil(parseError);
    }
    XCTAssertEqualObjects(fetchJSONBody, expectedJSONBody);

    NSHTTPURLResponse *response = QueryResponseWithURL(fetcherToTest.request.URL,
                                                       200,
                                                       @"text/plain");
    testResponse(response, [NSData data], nil);

    [fetchExp fulfill];
  };

  GTLRServiceTicket *queryTicket = [service executeQuery:query
                                       completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                           GTLRTestingSvc_File *uploadedFile,
                                                           NSError *error) {
    [executeCompletionExp fulfill];
  }];

  XCTAssert([self service:service waitForTicket:queryTicket]);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_BodyObject {
  GTLRTestingSvc_Permission *permissionObj = [GTLRTestingSvc_Permission object];
  permissionObj.displayName = @"Rex the Tyrannosaurus";
  permissionObj.type = @"reader";
  GTLRTestingSvcQuery_PermissionsCreate *query =
      [GTLRTestingSvcQuery_PermissionsCreate queryWithObject:permissionObj
                                                      fileId:@"12345"];
  NSDictionary *expectedJSON = @{ @"type" : @"reader", @"displayName" : @"Rex the Tyrannosaurus" };
  [self performBodyObjectTestWithQuery:query
                          expectedBody:expectedJSON];
}

- (void)testService_EmptyBodyObject {
  // Verify that a non-nil but empty body object creates an empty JSON request body.
  GTLRTestingSvc_Permission *emptyPermissionObj = [GTLRTestingSvc_Permission object];
  GTLRTestingSvcQuery_PermissionsCreate *query =
      [GTLRTestingSvcQuery_PermissionsCreate queryWithObject:emptyPermissionObj
                                                      fileId:@"12345"];

  NSDictionary *expectedJSON = [NSDictionary dictionary];
  [self performBodyObjectTestWithQuery:query
                          expectedBody:expectedJSON];
}

- (void)testService_NilBodyObject {
  // Verify that a nil  body object creates a nil request body.

  // We need to force a query to have a nil body object, so create a query with a non-nil
  // body object and then remove it.
  GTLRTestingSvc_Permission *emptyPermissionObj = [GTLRTestingSvc_Permission object];
  GTLRTestingSvcQuery_PermissionsCreate *query =
      [GTLRTestingSvcQuery_PermissionsCreate queryWithObject:emptyPermissionObj
                                                      fileId:@"12345"];
  query.bodyObject = nil;

  [self performBodyObjectTestWithQuery:query
                          expectedBody:nil];
}

- (void)testService_SingleQuery_NoFields {
  // Successful request with valid authorization.
  //
  // Response is file Drive1Empty.response
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1Empty.response.txt" status:200];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"";

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify a bare object with no JSON was returned.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(object.JSON);
            XCTAssertNil(error);

            [queryFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_MediaQuery_UsingMediaRedirect {
  [self performMediaQueryTestUsingMediaService:NO];
}

- (void)testService_MediaQuery_UsingMediaService {
  [self performMediaQueryTestUsingMediaService:YES];
}

- (void)performMediaQueryTestUsingMediaService:(BOOL)useMediaService {
  // Successful request with data object response.
  [self expectTicketAndParsingNotifications];

  NSData *expectedData = [self tempDataForUploading];
  NSString *expectedContentType = @"text/plain";

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock = ^(GTMSessionFetcher *fetcherToTest,
                                       GTMSessionFetcherTestResponse testResponse) {
    NSHTTPURLResponse *response = QueryResponseWithURL(fetcherToTest.request.URL,
                                                       200, expectedContentType);
    NSData *responseData = expectedData;
    testResponse(response, responseData, nil);
  };

  GTLRTestingSvcQuery_FilesGet *query = [GTLRTestingSvcQuery_FilesGet queryForMediaWithFileId:@"abcde"];
  query.useMediaDownloadService = useMediaService;

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRDataObject *object, NSError *error) {
            NSURL *fetcherURL = callbackTicket.fetchRequest.URL;
            if (useMediaService) {
              XCTAssertEqualObjects(fetcherURL.path, @"/download/drive/v3/files/abcde");
            } else {
              XCTAssertEqualObjects(fetcherURL.path, @"/drive/v3/files/abcde");
            }
            XCTAssertEqualObjects(QueryValueForURLItem(fetcherURL, @"alt"), @"media");

            XCTAssertEqualObjects([object class], [GTLRDataObject class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.data, expectedData);
            XCTAssertEqualObjects(object.contentType, expectedContentType);

            XCTAssert([NSThread isMainThread]);

            [queryFinished fulfill];
          }];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_BatchQuery {
  [self performBatchQueryTestSkippingAuthorization:NO];
}

- (void)testService_BatchQuery_SkipAuth {
  [self performBatchQueryTestSkippingAuthorization:YES];
}

- (void)performBatchQueryTestSkippingAuthorization:(BOOL)shouldSkipAuthorization {
  // Mixed failure and success batch request with valid authorization.
  //
  // Response is file Drive1Batch1.response.txt
  //
  // WARNING: Batch response file must be saved with CRLF line endings and checked in as a binary
  // file to be valid multipart MIME. (Edit it with TextWrangler/BBEdit set to "Windows (CRLF)"
  // for the document.)

  [self expectTicketAndParsingNotifications];

  [self setCountingUIAppWithExpirations:NO];

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1Batch.response.txt"
                                             status:200
                               numberOfStatusErrors:0
                                  multipartBoundary:@"batch_3ajN40YpXZQ_ABf5ww_gxyg"];

  XCTestExpectation *permissionExp = [self expectationWithDescription:@"permissionCallback"];
  XCTestExpectation *childExp = [self expectationWithDescription:@"childCallback"];
  XCTestExpectation *parentsExp = [self expectationWithDescription:@"parentsCallback"];
  XCTestExpectation *batchFinished = [self expectationWithDescription:@"batchFinished"];

  GTLRTestingSvcQuery_PermissionsList *permissionQuery =
      [GTLRTestingSvcQuery_PermissionsList queryWithFileId:@"badID"];
  permissionQuery.requestID = @"gtlr_4";
  permissionQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_PermissionList *obj,
                                      NSError *permissionError) {
    XCTAssertNil(obj);
    XCTAssertEqual(permissionError.code, 404);
    GTLRErrorObject *errorObject = permissionError.userInfo[kGTLRStructuredErrorKey];
    XCTAssertEqual(errorObject.code.intValue, 404);

    XCTAssert([NSThread isMainThread]);

    [permissionExp fulfill];
  };

  GTLRTestingSvcQuery_FilesList *childQuery = [GTLRTestingSvcQuery_FilesList query];
  childQuery.q = [NSString stringWithFormat:@"'0B7svZDDwtKrhS2FDS2JZclU1U0E' in parents"];
  childQuery.requestID = @"gtlr_5";
  childQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                 NSError *childError) {
    XCTAssertEqualObjects([fileList class], [GTLRTestingSvc_FileList class]);
    XCTAssertEqualObjects(fileList.kind, @"drive#fileList");
    XCTAssertNil(childError);

    XCTAssert([NSThread isMainThread]);

    [childExp fulfill];
  };

  GTLRTestingSvcQuery_FilesGet *parentsQuery =
      [GTLRTestingSvcQuery_FilesGet queryWithFileId:@"0B7svZDDwtKrhS2FDS2JZclU1U0E"];
  parentsQuery.fields = @"parents";
  parentsQuery.requestID = @"gtlr_6";
  parentsQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *file,
                                   NSError *parentsError) {
    XCTAssertEqualObjects([file class], [GTLRTestingSvc_File class]);
    XCTAssertEqualObjects(file.parents, @[ @"0ALsvZDDwtKrhUk9PVA" ]);
    XCTAssertNil(parentsError);

    XCTAssert([NSThread isMainThread]);

    [parentsExp fulfill];
  };
  parentsQuery.additionalHTTPHeaders = @{ @"Tiger" : @"Siberian" };

  // Combine the separate queries into one batch.
  GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];
  [batchQuery addQuery:permissionQuery];
  [batchQuery addQuery:childQuery];
  [batchQuery addQuery:parentsQuery];

  // Test adding http headers to the query
  batchQuery.additionalHTTPHeaders = @{ @"X-Feline": @"Fluffy",
                                        @"X-Canine": @"Spot" };

  batchQuery.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                                BOOL suggestedWillRetry,
                                                NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };

  XCTestExpectation *uploadedSomeBytes = [self expectationWithDescription:@"uploadedSomeBytes"];
  batchQuery.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                         unsigned long long numberOfBytesRead,
                                                         unsigned long long dataLength) {
    if (numberOfBytesRead == dataLength) {
      [uploadedSomeBytes fulfill];
    }
    XCTAssert([NSThread isMainThread]);
  };

  batchQuery.shouldSkipAuthorization = shouldSkipAuthorization;

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:batchQuery
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRBatchResult *batchResult, NSError *error) {
            // Verify the batch result and each success and failure result.
            XCTAssertEqualObjects([batchResult class], [GTLRBatchResult class]);
            XCTAssertNil(error);

            XCTAssertEqual(batchResult.successes.count, 2U);
            XCTAssertEqual(batchResult.failures.count, 1U);
            XCTAssertEqual(batchResult.responseHeaders.count, 3U);

            GTLRErrorObject *failureError = batchResult.failures[@"gtlr_4"];
            XCTAssertEqualObjects([failureError class], [GTLRErrorObject class]);
            XCTAssertEqual(failureError.code.intValue, 404);

            NSDictionary *responseHeaderGTLR_4 = batchResult.responseHeaders[@"gtlr_4"];
            XCTAssertEqualObjects(responseHeaderGTLR_4[@"X-Rejected-Reason"],
                           @"Failed to remove Excalibur from stone");

            GTLRTestingSvc_FileList *fileList = batchResult.successes[@"gtlr_5"];
            XCTAssertEqualObjects([fileList class], [GTLRTestingSvc_FileList class]);
            XCTAssertEqualObjects(fileList.kind, @"drive#fileList");

            NSDictionary *responseHeaderGTLR_5 = batchResult.responseHeaders[@"gtlr_5"];
            XCTAssertEqual(((NSNumber *)responseHeaderGTLR_5[@"Retry-After"]).intValue, 300);

            GTLRTestingSvc_File *file = batchResult.successes[@"gtlr_6"];
            XCTAssertEqualObjects([file class], [GTLRTestingSvc_File class]);
            XCTAssertEqualObjects(file.parents, @[ @"0ALsvZDDwtKrhUk9PVA" ]);
            // As with a single query, the batch ticket's query should be a copy of the original;
            // query execution leaves the original unmolested so the client can modify and reuse it.
            GTLRBatchQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, batchQuery);
            // Since the batch has a copy of the original query, all request IDs of both batch
            // queries should be the same.
            XCTAssertEqualObjects([ticketQuery.queries valueForKey:@"requestID"],
                                  [batchQuery.queries valueForKey:@"requestID"]);


            NSDictionary *responseHeaderGTLR_6 = batchResult.responseHeaders[@"gtlr_6"];
            XCTAssertNil(responseHeaderGTLR_6[@"X-Rejected-Reason"]);
            XCTAssertNil(responseHeaderGTLR_6[@"Retry-After"]);

            XCTAssert([NSThread isMainThread]);

            [batchFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // The request is to a fixed URL.
  NSURLRequest *fetcherRequest = queryTicket.objectFetcher.request;
  XCTAssertEqualObjects(fetcherRequest.URL.absoluteString,
                        @"https://www.googleapis.com/batch");

  // Test additionalHTTPHeaders.
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"X-Feline"], @"Fluffy");
  XCTAssertEqualObjects([fetcherRequest valueForHTTPHeaderField:@"X-Canine"], @"Spot");

  // Verify the payload was the expected multipart MIME.
  NSData *requestBody = fetcherRequest.HTTPBody;
  NSString *requestBoundary = ((GTLRBatchQuery *)queryTicket.executingQuery).boundary;
  NSArray *requestMIMEParts = [GTMMIMEDocument MIMEPartsWithBoundary:requestBoundary
                                                         data:requestBody];
  XCTAssertEqual(requestMIMEParts.count, 3U);

  GTMMIMEDocumentPart *part0 = requestMIMEParts[0];
  NSString *body0Str = [[NSString alloc] initWithData:part0.body encoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects(part0.headers[@"Content-ID"], @"gtlr_4");
  XCTAssert([body0Str hasPrefix:@"GET /drive/v3/files/badID/permissions"],
            @"%@", body0Str);

  // Verify the additional HTTP headers were added to the third query.
  //
  // We'll parse the request MIME part as a response part since request parts also have outer
  // and inner headers, similar to response parts.
  GTMMIMEDocumentPart *part2 = requestMIMEParts[2];
  XCTAssertEqualObjects(part2.headers[@"Content-ID"], @"gtlr_6");

  GTLRBatchResponsePart *requestPart = [service responsePartWithMIMEPart:part2];
  NSDictionary *requestPartHeaders = requestPart.headers;
  XCTAssertEqualObjects(requestPartHeaders[@"Tiger"], @"Siberian");

  NSString *part2BodyStr = [[NSString alloc] initWithData:part2.body encoding:NSUTF8StringEncoding];
  NSString *expectedBodyGet = @"GET /drive/v3/files/0B7svZDDwtKrhS2FDS2JZclU1U0E?fields=parents";
  XCTAssert([part2BodyStr hasPrefix:expectedBodyGet], @"%@", part2BodyStr);

  // Verify authorization.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
  id<GTMFetcherAuthorizationProtocol> authorizer = service.authorizer;
#pragma clang diagnostic pop
  XCTAssertNotNil(authorizer);
  bool didAuthorize = [authorizer isAuthorizedRequest:fetcherRequest];
  XCTAssertEqual(didAuthorize, !shouldSkipAuthorization, @"%@", fetcherRequest.allHTTPHeaderFields);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // We expect two calls to beginBackgroundTask and endBackgroundTask, one each for
  // fetcher and GTLRService.
  [self verifyCountingUIAppWithExpectedCount:2
                         expectedExpirations:0];
}

- (void)testParsingMinimalBatchReplies {
  // Deletes in a batch have no payload, ensure parsing works as expected.

  NSData *responseData =
      [[self class] dataForTestFileName:@"NoPayloadsBatch.response.txt"];;
  XCTAssertNotNil(responseData);

  GTLRService *service = [self driveServiceForTest];

  NSArray *mimeParts =
      [GTMMIMEDocument MIMEPartsWithBoundary:@"batch_hXL_3_UnLsQ_AAYW6kQ4LYU"
                                        data:responseData];
  XCTAssertNotNil(mimeParts);
  XCTAssertEqual(mimeParts.count, 2U);

  GTLRBatchResponsePart *part0 = [service responsePartWithMIMEPart:mimeParts[0]];
  XCTAssertNotNil(part0);
  XCTAssertEqual(part0.statusCode, 204);
  XCTAssertEqualObjects(part0.statusString, @"No Content");
  XCTAssertEqual(part0.headers.count, 1U);
  XCTAssertEqualObjects(part0.headers[@"Date"], @"Wed, 24 Jun 2020 09:21:24 GMT");
  XCTAssertNil(part0.parseError);

  GTLRBatchResponsePart *part1 = [service responsePartWithMIMEPart:mimeParts[1]];
  XCTAssertNotNil(part1);
  XCTAssertEqual(part1.statusCode, 204);
  XCTAssertEqualObjects(part1.statusString, @"No Content");
  XCTAssertEqual(part1.headers.count, 0U);
  XCTAssertNil(part1.parseError);
}

- (GTMSessionFetcherTestBlock)fetcherTestBlockForBatchPaging {
  __block int pageCounter = 0;

  GTMSessionFetcherTestBlock testBlock = ^(GTMSessionFetcher *fetcherToTest,
                                           GTMSessionFetcherTestResponse testResponse) {
    // Not currently done here (like it is above in the batch test) but to be thorough,
    // we could inspect inside the batch request MIME parts to ensure any additional headers
    // and query parameters were passed through.
    ++pageCounter;

    NSString *contentType = @"multipart/mixed; boundary=batch_3ajN40YpXZQ_ABf5ww_gxyg";
    NSHTTPURLResponse *response = QueryResponseWithURL(fetcherToTest.request.URL,
                                                       200, contentType);
    NSString *fileName = [NSString stringWithFormat:@"Drive1BatchPaging%d.response.txt",
                          pageCounter];
    NSData *responseData = [[self class] dataForTestFileName:fileName];;
    XCTAssertNotNil(responseData, @"%@", fileName);
    testResponse(response, responseData, nil);
  };
  return testBlock;
}

- (void)testService_BatchQuery_Paging {
  // WARNING: Batch response file must be saved with CRLF line endings and checked in as a binary
  // file to be valid multipart MIME.
  [self expectTicketAndParsingNotifications];

  [self setCountingUIAppWithExpirations:NO];

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock = [self fetcherTestBlockForBatchPaging];

  XCTestExpectation *query1Exp = [self expectationWithDescription:@"query1Callback"];
  XCTestExpectation *query2Exp = [self expectationWithDescription:@"query2Callback"];
  XCTestExpectation *query3Exp = [self expectationWithDescription:@"query3Callback"];
  XCTestExpectation *query4Exp = [self expectationWithDescription:@"query4Callback"];
  XCTestExpectation *batchFinished = [self expectationWithDescription:@"batchFinished"];

  // First query succeeds in three pages.
  // Second query fails on first page.
  // Third query succeeds on first page but fails on second.
  // Fourth query succeeds on first page.

  GTLRTestingSvcQuery_FilesList *childQuery1 = [GTLRTestingSvcQuery_FilesList query];
  childQuery1.q = [NSString stringWithFormat:@"'0B7svZDDwtKrhS2FDS2JZclU1U0E' in parents"];
  childQuery1.requestID = @"gtlr_5";
  childQuery1.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                 NSError *childError) {
    XCTAssertEqualObjects([fileList class], [GTLRTestingSvc_FileList class]);
    XCTAssertEqualObjects(fileList.kind, @"drive#fileList");
    XCTAssertEqual(fileList.files.count, (NSUInteger)8);
    XCTAssertEqualObjects(fileList.files[7].name, @"Mouse Types.pdf");
    XCTAssertEqualObjects(fileList.files[7].identifier, @"0B7svZDDwtKr1BVVk3N1k");
    XCTAssertNil(childError);

    XCTAssert([NSThread isMainThread]);

    [query1Exp fulfill];
  };

  GTLRTestingSvcQuery_FilesList *childQuery2 = [GTLRTestingSvcQuery_FilesList query];
  childQuery2.q = [NSString stringWithFormat:@"'0B7svZABCtKrhS2FDS2JZclU1U0E' in parents"];
  childQuery2.requestID = @"gtlr_6";
  childQuery2.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                 NSError *childError) {
    XCTAssertNil(fileList);
    XCTAssertEqual(childError.code, 404);

    XCTAssert([NSThread isMainThread]);

    [query2Exp fulfill];
  };

  GTLRTestingSvcQuery_FilesList *childQuery3 = [GTLRTestingSvcQuery_FilesList query];
  childQuery3.q = [NSString stringWithFormat:@"'0B7svZDEFtKrhS2FDS2JZclU1U0E' in parents"];
  childQuery3.requestID = @"gtlr_7";
  childQuery3.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                 NSError *childError) {
    XCTAssertNil(fileList);
    XCTAssertEqual(childError.code, 400);

    XCTAssert([NSThread isMainThread]);

    [query3Exp fulfill];
  };

  GTLRTestingSvcQuery_FilesGet *parentsQuery =
      [GTLRTestingSvcQuery_FilesGet queryWithFileId:@"0B7svZDDwtKrhS2FDS2JZclU1U0E"];
  parentsQuery.fields = @"parents";
  parentsQuery.requestID = @"gtlr_8";
  parentsQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *file,
                                   NSError *parentsError) {
    XCTAssertEqualObjects([file class], [GTLRTestingSvc_File class]);
    XCTAssertEqualObjects(file.parents, @[ @"0ALsvZDDwtKrhUk9PVA" ]);
    XCTAssertNil(parentsError);

    XCTAssert([NSThread isMainThread]);

    [query4Exp fulfill];
  };

  // Combine the separate queries into one batch.
  NSArray *queries = @[ childQuery1, childQuery2, childQuery3, parentsQuery ];
  GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQueryWithQueries:queries];

  batchQuery.executionParameters.shouldFetchNextPages = @YES;

  GTLRServiceTicket *queryTicket =
      [service executeQuery:batchQuery
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRBatchResult *batchResult, NSError *error) {
            // Verify the batch result and each success and failure result.
            XCTAssertEqualObjects([batchResult class], [GTLRBatchResult class]);
            XCTAssertNil(error);

            XCTAssertEqual(batchResult.successes.count, (NSUInteger)2);
            XCTAssertEqual(batchResult.failures.count, (NSUInteger)2);
            XCTAssertEqual(batchResult.responseHeaders.count, (NSUInteger)4);
            XCTAssertEqual(callbackTicket.pagesFetchedCounter, 3U);

            // The first query, gtlr_5, requires all three pages to fetch the full file list.
            GTLRTestingSvc_FileList *fileList = batchResult.successes[@"gtlr_5"];
            XCTAssertEqualObjects([fileList class], [GTLRTestingSvc_FileList class]);
            XCTAssertEqualObjects(fileList.kind, @"drive#fileList");
            XCTAssertEqual(fileList.files.count, (NSUInteger)8);

            GTLRErrorObject *errorObj = batchResult.failures[@"gtlr_6"];
            errorObj.code = @404;

            errorObj = batchResult.failures[@"gtlr_7"];
            errorObj.code = @400;

            GTLRTestingSvc_File *file = batchResult.successes[@"gtlr_8"];
            XCTAssertEqualObjects([file class], [GTLRTestingSvc_File class]);
            XCTAssertEqualObjects(file.parents, @[ @"0ALsvZDDwtKrhUk9PVA" ]);

            // As with a single query, the batch ticket's query should be a copy of the original;
            // query execution leaves the original unmolested so the client can modify and reuse it.
            GTLRBatchQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, batchQuery);
            // Since the batch has a copy of the original query, all request IDs of both batch
            // queries should be the same.
            XCTAssertEqualObjects([ticketQuery.queries valueForKey:@"requestID"],
                                  [batchQuery.queries valueForKey:@"requestID"]);

            XCTAssert([NSThread isMainThread]);

            [batchFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // We expect six calls to beginBackgroundTask and endBackgroundTask, one each for
  // fetcher and GTLRService for each page.
  [self verifyCountingUIAppWithExpectedCount:6
                         expectedExpirations:0];
}

- (void)testService_BatchQuery_CorruptResponse {
  // Mixed failure and success batch request with on corrupt JSON resonse.
  //
  // Response is file Drive1BatchCorrupt.response.txt
  //
  // WARNING: Batch response file must be saved with CRLF line endings and checked in as a binary
  // file to be valid multipart MIME. (Edit it with TextWrangler/BBEdit set to "Windows (CRLF)"
  // for the document.)

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1BatchCorrupt.response.txt"
                                             status:200
                               numberOfStatusErrors:0
                                  multipartBoundary:@"batch_3ajN40YpXZQ_ABf5ww_gxyg"];

  XCTestExpectation *permissionExp = [self expectationWithDescription:@"permissionCallback"];
  XCTestExpectation *childExp = [self expectationWithDescription:@"childCallback"];
  XCTestExpectation *parentsExp = [self expectationWithDescription:@"parentsCallback"];
  XCTestExpectation *batchFinished = [self expectationWithDescription:@"batchFinished"];

  GTLRTestingSvcQuery_PermissionsList *permissionQuery =
      [GTLRTestingSvcQuery_PermissionsList queryWithFileId:@"badID"];
  permissionQuery.requestID = @"gtlr_4";
  permissionQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_PermissionList *obj,
                                      NSError *permissionError) {
    XCTAssertNil(obj);
    XCTAssertEqual(permissionError.code, 404);
    GTLRErrorObject *errorObject = permissionError.userInfo[kGTLRStructuredErrorKey];
    XCTAssertEqual(errorObject.code.intValue, 404);

    [permissionExp fulfill];
  };

  // The second part has corrupt JSON.
  GTLRTestingSvcQuery_FilesList *childQuery = [GTLRTestingSvcQuery_FilesList query];
  childQuery.q = [NSString stringWithFormat:@"'0B7svZDDwtKrhS2FDS2JZclU1U0E' in parents"];
  childQuery.requestID = @"gtlr_5";
  childQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                 NSError *childError) {
    XCTAssertNil(fileList);
    XCTAssertEqual(childError.code, NSPropertyListReadCorruptError);

    [childExp fulfill];
  };

  GTLRTestingSvcQuery_FilesGet *parentsQuery =
      [GTLRTestingSvcQuery_FilesGet queryWithFileId:@"0B7svZDDwtKrhS2FDS2JZclU1U0E"];
  parentsQuery.fields = @"parents";
  parentsQuery.requestID = @"gtlr_6";
  parentsQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *file,
                                   NSError *parentsError) {
    XCTAssertEqualObjects([file class], [GTLRTestingSvc_File class]);
    XCTAssertEqualObjects(file.parents, @[ @"0ALsvZDDwtKrhUk9PVA" ]);
    XCTAssertNil(parentsError);

    [parentsExp fulfill];
  };

  // Combine the separate queries into one batch.
  GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];
  [batchQuery addQuery:permissionQuery];
  [batchQuery addQuery:childQuery];
  [batchQuery addQuery:parentsQuery];

  batchQuery.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                                BOOL suggestedWillRetry,
                                                NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:batchQuery
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRBatchResult *batchResult, NSError *error) {
            // Verify the batch result and each success and failure result.
            XCTAssertEqualObjects([batchResult class], [GTLRBatchResult class]);
            XCTAssertNil(error);

            XCTAssertEqual(batchResult.successes.count, 1U);
            XCTAssertEqual(batchResult.failures.count, 2U);
            XCTAssertEqual(batchResult.responseHeaders.count, 3U);

            GTLRErrorObject *failureError = batchResult.failures[@"gtlr_4"];
            XCTAssertEqualObjects([failureError class], [GTLRErrorObject class]);
            XCTAssertEqual(failureError.code.intValue, 404);

            // This object has corrupt JSON.
            GTLRErrorObject *fileListError = batchResult.failures[@"gtlr_5"];
            XCTAssertEqual(fileListError.code.intValue, NSPropertyListReadCorruptError);

            GTLRTestingSvc_File *file = batchResult.successes[@"gtlr_6"];
            XCTAssertEqualObjects([file class], [GTLRTestingSvc_File class]);
            XCTAssertEqualObjects(file.parents, @[ @"0ALsvZDDwtKrhUk9PVA" ]);

            // As with a single query, the batch ticket's query should be a copy of the original;
            // query execution leaves the original unmolested so the client can modify and reuse it.
            GTLRBatchQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, batchQuery);
            // Since the batch has a copy of the original query, all request IDs of both batch
            // queries should be the same.
            XCTAssertEqualObjects([ticketQuery.queries valueForKey:@"requestID"],
                                  [batchQuery.queries valueForKey:@"requestID"]);

            [batchFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_BatchQuery_CallbackQueue {
  // Batch with callbacks on a specified GCD queue.
  //
  // Response is file Drive1Batch1.response.txt

  dispatch_queue_t myCallbackQueue = dispatch_queue_create("myCallbackQueue",
                                                           DISPATCH_QUEUE_SERIAL);

  GTLRService *service = [self driveServiceForTest];
  service.callbackQueue = myCallbackQueue;

  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1Batch.response.txt"
                                             status:200
                               numberOfStatusErrors:0
                                  multipartBoundary:@"batch_3ajN40YpXZQ_ABf5ww_gxyg"];

  XCTestExpectation *permissionExp = [self expectationWithDescription:@"permissionCallback"];
  XCTestExpectation *childExp = [self expectationWithDescription:@"childCallback"];
  XCTestExpectation *parentsExp = [self expectationWithDescription:@"parentsCallback"];
  XCTestExpectation *batchFinished = [self expectationWithDescription:@"batchFinished"];

  GTLRTestingSvcQuery_PermissionsList *permissionQuery =
      [GTLRTestingSvcQuery_PermissionsList queryWithFileId:@"badID"];
  permissionQuery.requestID = @"gtlr_4";
  permissionQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_PermissionList *obj,
                                      NSError *permissionError) {
    XCTAssert(IsCurrentQueue(myCallbackQueue));
    [permissionExp fulfill];
  };

  GTLRTestingSvcQuery_FilesList *childQuery = [GTLRTestingSvcQuery_FilesList query];
  childQuery.q = [NSString stringWithFormat:@"'0B7svZDDwtKrhS2FDS2JZclU1U0E' in parents"];
  childQuery.requestID = @"gtlr_5";
  childQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                 NSError *childError) {
    XCTAssert(IsCurrentQueue(myCallbackQueue));
    [childExp fulfill];
  };

  GTLRTestingSvcQuery_FilesGet *parentsQuery =
      [GTLRTestingSvcQuery_FilesGet queryWithFileId:@"0B7svZDDwtKrhS2FDS2JZclU1U0E"];
  parentsQuery.fields = @"parents";
  parentsQuery.requestID = @"gtlr_6";
  parentsQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *file,
                                   NSError *parentsError) {
    XCTAssert(IsCurrentQueue(myCallbackQueue));
    [parentsExp fulfill];
  };

  // Combine the separate queries into one batch.
  GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];
  [batchQuery addQuery:permissionQuery];
  [batchQuery addQuery:childQuery];
  [batchQuery addQuery:parentsQuery];

  // Test adding http headers to the query
  batchQuery.additionalHTTPHeaders = @{ @"X-Feline": @"Fluffy",
                                        @"X-Canine": @"Spot" };

  batchQuery.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                                BOOL suggestedWillRetry,
                                                NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };

  XCTestExpectation *uploadedSomeBytes = [self expectationWithDescription:@"uploadedSomeBytes"];
  batchQuery.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                         unsigned long long numberOfBytesRead,
                                                         unsigned long long dataLength) {
    if (numberOfBytesRead == dataLength) {
      [uploadedSomeBytes fulfill];
    }
    XCTAssert(IsCurrentQueue(myCallbackQueue));
  };

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:batchQuery
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRBatchResult *batchResult, NSError *error) {
            XCTAssert(IsCurrentQueue(myCallbackQueue));
            [batchFinished fulfill];
          }];

  // Changing the callback queue doesn't affect tickets already issued.
  service.callbackQueue = dispatch_get_main_queue();

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_Surrogates {
  // Successful request with surrogates.
  //
  // Response is file Drive1.response.txt
  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt" status:200];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind)";

  NSDictionary *serviceSurrogates = @{
    (id<NSCopying>)[GTLRTestingSvc_File class]     : [GTLRTestingSvc_File_Surrogate class],
    (id<NSCopying>)[GTLRTestingSvc_FileList class] : [GTLRTestingSvc_FileList_Surrogate class]
  };
  [service setSurrogates:serviceSurrogates];

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  // Override a resolver in the query's executionParameters.
  NSDictionary *querySurrogates = @{
    (id<NSCopying>)[GTLRTestingSvc_File class]     : [GTLRTestingSvc_File_Surrogate class],
    (id<NSCopying>)[GTLRTestingSvc_FileList class] : [GTLRTestingSvc_FileList_Surrogate2 class]
  };
  NSDictionary *kindMap = [[service class] kindStringToClassMap];
  query.executionParameters.objectClassResolver =
    [GTLRObjectClassResolver resolverWithKindMap:kindMap surrogates:querySurrogates];

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList_Surrogate2 class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.kind, @"drive#fileList");
            XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

            [queryFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_BatchQuery_Surrogates {
  // Mixed failure and success batch request with surrogates.
  //
  // Response is file Drive1Batch1.response.txt
  //
  // See warning above about batch file needing CRLF line endings.

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1Batch.response.txt"
                                             status:200
                               numberOfStatusErrors:0
                                  multipartBoundary:@"batch_3ajN40YpXZQ_ABf5ww_gxyg"];

  XCTestExpectation *batchFinished = [self expectationWithDescription:@"batchFinished"];

  GTLRTestingSvcQuery_PermissionsList *permissionQuery =
      [GTLRTestingSvcQuery_PermissionsList queryWithFileId:@"badID"];
  permissionQuery.requestID = @"gtlr_4";

  GTLRTestingSvcQuery_FilesList *childQuery = [GTLRTestingSvcQuery_FilesList query];
  childQuery.q = [NSString stringWithFormat:@"'0B7svZDDwtKrhS2FDS2JZclU1U0E' in parents"];
  childQuery.requestID = @"gtlr_5";

  GTLRTestingSvcQuery_FilesGet *parentsQuery =
      [GTLRTestingSvcQuery_FilesGet queryWithFileId:@"0B7svZDDwtKrhS2FDS2JZclU1U0E"];
  parentsQuery.fields = @"parents";
  parentsQuery.requestID = @"gtlr_6";

  // Combine the separate queries into one batch.
  GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];
  [batchQuery addQuery:permissionQuery];
  [batchQuery addQuery:childQuery];
  [batchQuery addQuery:parentsQuery];

  NSDictionary *kindMap = [[service class] kindStringToClassMap];
  NSDictionary *surrogates = @{
    (id<NSCopying>)[GTLRTestingSvc_File class] : [GTLRTestingSvc_File_Surrogate class],
    (id<NSCopying>)[GTLRTestingSvc_FileList class] : [GTLRTestingSvc_FileList_Surrogate class]
  };
  batchQuery.executionParameters.objectClassResolver =
    [GTLRObjectClassResolver resolverWithKindMap:kindMap surrogates:surrogates];

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:batchQuery
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRBatchResult *batchResult, NSError *error) {
            // Verify the batch result and each success and failure result.
            XCTAssertEqualObjects([batchResult class], [GTLRBatchResult class]);
            XCTAssertNil(error);

            XCTAssertEqual(batchResult.successes.count, 2U);
            XCTAssertEqual(batchResult.failures.count, 1U);
            XCTAssertEqual(batchResult.responseHeaders.count, 3U);

            GTLRErrorObject *failureError = batchResult.failures[@"gtlr_4"];
            XCTAssertEqualObjects([failureError class], [GTLRErrorObject class]);
            XCTAssertEqual(failureError.code.intValue, 404);

            GTLRTestingSvc_FileList *fileList = batchResult.successes[@"gtlr_5"];
            XCTAssertEqualObjects([fileList class], [GTLRTestingSvc_FileList_Surrogate class]);
            XCTAssertEqualObjects(fileList.kind, @"drive#fileList");

            GTLRTestingSvc_File *file = batchResult.successes[@"gtlr_6"];
            XCTAssertEqualObjects([file class], [GTLRTestingSvc_File_Surrogate class]);
            XCTAssertEqualObjects(file.parents, @[ @"0ALsvZDDwtKrhUk9PVA" ]);

            // As with a single query, the batch ticket's query should be a copy of the original;
            // query execution leaves the original unmolested so the client can modify and reuse it.
            GTLRBatchQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, batchQuery);
            // Since the batch has a copy of the original query, all request IDs of both batch
            // queries should be the same.
            XCTAssertEqualObjects([ticketQuery.queries valueForKey:@"requestID"],
                                  [batchQuery.queries valueForKey:@"requestID"]);

            [batchFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_SingleQuery_RetrySucceeding {
  // Successful request with retry.
  //
  // Response is file Drive1.response.txt
  GTLRService *service = [self driveServiceForTest];

  [self setCountingUIAppWithExpirations:NO];

  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt"
                                             status:456
                               numberOfStatusErrors:1
                                  multipartBoundary:nil];


  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind)";

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  XCTestExpectation *retryBlockExp = [self expectationWithDescription:@"retryBlock"];
  service.retryBlock = ^(GTLRServiceTicket *ticket,
                         BOOL suggestedWillRetry,
                         NSError *error) {
    XCTAssertEqual(error.code, 456);
    XCTAssertEqual(suggestedWillRetry, NO);

    XCTAssert([NSThread isMainThread]);

    [retryBlockExp fulfill];
    return YES;
  };
  service.retryEnabled = YES;

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.kind, @"drive#fileList");
            XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

            [queryFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // We expect three calls to beginBackgroundTask and endBackgroundTask, two for
  // fetchers and one for GTLRService.
  [self verifyCountingUIAppWithExpectedCount:3
                         expectedExpirations:0];
}

- (void)testService_SingleQuery_RetryFailing {
  // Failed request with a retry attempt.
  //
  // Response is file Drive1.response.txt
  GTLRService *service = [self driveServiceForTest];

  [self setCountingUIAppWithExpirations:NO];

  service.fetcherService.testBlock =
      [self fetcherTestBlockWithResponseForFileName:nil
                                             status:456
                               numberOfStatusErrors:100
                                  multipartBoundary:nil];


  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(mimeType,id,kind)";

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  XCTestExpectation *retryBlockExp = [self expectationWithDescription:@"retryBlock"];
  service.retryBlock = ^(GTLRServiceTicket *ticket,
                         BOOL suggestedWillRetry,
                         NSError *error) {
    XCTAssertEqual(error.code, 456);
    XCTAssertEqual(suggestedWillRetry, NO);

    if (ticket.objectFetcher.retryCount == 0) {
      return YES;
    }
    // Give up after one retry.
    [retryBlockExp fulfill];
    return NO;
  };
  service.retryEnabled = YES;

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            XCTAssertNil(object);
            XCTAssertEqual(error.code, 456);

            [queryFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];

  // We expect three calls to beginBackgroundTask and endBackgroundTask, two for
  // fetchers and one for GTLRService.
  [self verifyCountingUIAppWithExpectedCount:3
                         expectedExpirations:0];
}

#pragma mark - Lifetime Tests

- (void)testService_SingleQuery_Retry_ObjectLifetimes {
  // This test is based on a fallacy, that we can assume objects are dealloc'd at
  // a certain point in time,
  //
  // If this test turns out to be a source of headaches, we can just give up and do
  // these checks manually on occasion.

  XCTestExpectation *ticketDealloc = [self expectationWithDescription:@"ticketDealloc"];
  XCTestExpectation *initialQueryDealloc = [self expectationWithDescription:@"initialQueryDealloc"];
  XCTestExpectation *executedQueryDealloc = [self expectationWithDescription:@"execdQueryDealloc"];
  XCTestExpectation *resultObjectDealloc = [self expectationWithDescription:@"resultObjectDealloc"];
  XCTestExpectation *fetcherDealloc = [self expectationWithDescription:@"fetcherDealloc"];

  @autoreleasepool {
    // Successful request with one retry.
    GTLRService *service = [self driveServiceForTest];

    service.fetcherService.testBlock =
        [self fetcherTestBlockWithResponseForFileName:@"Drive1.response.txt"
                                               status:456
                                 numberOfStatusErrors:1
                                    multipartBoundary:nil];


    GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
    query.fields = @"kind,nextPageToken,files(mimeType,id,kind)";

    // Create a retain cycle in the query callback.
    id queryHolder = query;
    query.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                              id _Nullable object,
                              NSError * _Nullable callbackError) {
      XCTAssertNotNil(queryHolder);
    };

    XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

    XCTestExpectation *retryBlockExp = [self expectationWithDescription:@"retryBlock"];
    service.retryBlock = ^(GTLRServiceTicket *ticket,
                           BOOL suggestedWillRetry,
                           NSError *error) {
      [retryBlockExp fulfill];
      return YES;
    };
    service.retryEnabled = YES;

    [GTLRTestLifetimeObject trackLifetimeOfObject:query
                                      expectation:initialQueryDealloc];

    __block GTLRServiceTicket *queryTicket =
        [service executeQuery:query
            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                GTLRTestingSvc_FileList *resultObject, NSError *error) {
              // Retain the original query and original ticket in the completion handler
              // to try to create a cycle.
              XCTAssertNotNil(query);
              XCTAssertNotNil(queryTicket);

              [GTLRTestLifetimeObject trackLifetimeOfObject:callbackTicket
                                                expectation:ticketDealloc];

              [GTLRTestLifetimeObject trackLifetimeOfObject:callbackTicket.executingQuery
                                                expectation:executedQueryDealloc];

              [GTLRTestLifetimeObject trackLifetimeOfObject:resultObject
                                                expectation:resultObjectDealloc];

              [GTLRTestLifetimeObject trackLifetimeOfObject:callbackTicket.objectFetcher
                                                expectation:fetcherDealloc];
              [queryFinished fulfill];
            }];

    XCTAssert([self service:service waitForTicket:queryTicket]);
    XCTAssert(queryTicket.hasCalledCallback);
  }  // @autoreleasepool

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_BatchQuery_Paging_Lifetime {
  // Object lifetime expectations.
  XCTestExpectation *ticketDealloc = [self expectationWithDescription:@"ticketDealloc"];
  XCTestExpectation *initialBatchQueryDealloc = [self expectationWithDescription:@"initialBatchQueryDealloc"];
  XCTestExpectation *initialQuery1Dealloc = [self expectationWithDescription:@"initialQuery1Dealloc"];
  XCTestExpectation *initialQuery2Dealloc = [self expectationWithDescription:@"initialQuery2Dealloc"];
  XCTestExpectation *initialQuery3Dealloc = [self expectationWithDescription:@"initialQuery3Dealloc"];
  XCTestExpectation *initialQuery4Dealloc = [self expectationWithDescription:@"initialQuery4Dealloc"];
  XCTestExpectation *executedBatchQueryDealloc = [self expectationWithDescription:@"execdBatchQueryDealloc"];
  XCTestExpectation *executedQuery1Dealloc = [self expectationWithDescription:@"execdQuery1Dealloc"];
  XCTestExpectation *executedQuery2Dealloc = [self expectationWithDescription:@"execdQuery2Dealloc"];
  XCTestExpectation *executedQuery3Dealloc = [self expectationWithDescription:@"execdQuery3Dealloc"];
  XCTestExpectation *executedQuery4Dealloc = [self expectationWithDescription:@"execdQuery4Dealloc"];
  XCTestExpectation *resultObjectDealloc = [self expectationWithDescription:@"resultObjectDealloc"];
  XCTestExpectation *fetcherDealloc = [self expectationWithDescription:@"fetcherDealloc"];

  @autoreleasepool {
    __block GTLRServiceTicket *queryTicket;

    GTLRService *service = [self driveServiceForTest];
    service.fetcherService.testBlock = [self fetcherTestBlockForBatchPaging];

    // Callback expectations.
    XCTestExpectation *query1Exp = [self expectationWithDescription:@"query1Callback"];
    XCTestExpectation *query2Exp = [self expectationWithDescription:@"query2Callback"];
    XCTestExpectation *query3Exp = [self expectationWithDescription:@"query3Callback"];
    XCTestExpectation *query4Exp = [self expectationWithDescription:@"query4Callback"];
    XCTestExpectation *batchFinished = [self expectationWithDescription:@"batchFinished"];

    // First query succeeds in three pages.
    // Second query fails on first page.
    // Third query succeeds on first page but fails on second.
    // Fourth query succeeds on first page.

    GTLRTestingSvcQuery_FilesList *childQuery1 = [GTLRTestingSvcQuery_FilesList query];
    childQuery1.q = [NSString stringWithFormat:@"'0B7svZDDwtKrhS2FDS2JZclU1U0E' in parents"];
    childQuery1.requestID = @"gtlr_5";
    childQuery1.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                   NSError *childError) {
      XCTAssertNotNil(fileList);
      XCTAssertNil(childError);

      // Force a reference to the original ticket.
      XCTAssertNotNil(queryTicket);

      [query1Exp fulfill];
    };

    GTLRTestingSvcQuery_FilesList *childQuery2 = [GTLRTestingSvcQuery_FilesList query];
    childQuery2.q = [NSString stringWithFormat:@"'0B7svZABCtKrhS2FDS2JZclU1U0E' in parents"];
    childQuery2.requestID = @"gtlr_6";
    childQuery2.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                   NSError *childError) {
      XCTAssertNil(fileList);
      XCTAssertNotNil(childError);

      [query2Exp fulfill];
    };

    GTLRTestingSvcQuery_FilesList *childQuery3 = [GTLRTestingSvcQuery_FilesList query];
    childQuery3.q = [NSString stringWithFormat:@"'0B7svZDEFtKrhS2FDS2JZclU1U0E' in parents"];
    childQuery3.requestID = @"gtlr_7";
    childQuery3.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                   NSError *childError) {
      XCTAssertNil(fileList);
      XCTAssertNotNil(childError);

      [query3Exp fulfill];
    };

    GTLRTestingSvcQuery_FilesGet *parentsQuery =
        [GTLRTestingSvcQuery_FilesGet queryWithFileId:@"0B7svZDDwtKrhS2FDS2JZclU1U0E"];
    parentsQuery.fields = @"parents";
    parentsQuery.requestID = @"gtlr_8";
    parentsQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *file,
                                     NSError *parentsError) {
      XCTAssertNotNil(file);
      XCTAssertNil(parentsError);

      [query4Exp fulfill];
    };

    [GTLRTestLifetimeObject trackLifetimeOfObject:childQuery1
                                      expectation:initialQuery1Dealloc];

    [GTLRTestLifetimeObject trackLifetimeOfObject:childQuery2
                                      expectation:initialQuery2Dealloc];

    [GTLRTestLifetimeObject trackLifetimeOfObject:childQuery3
                                      expectation:initialQuery3Dealloc];

    [GTLRTestLifetimeObject trackLifetimeOfObject:parentsQuery
                                      expectation:initialQuery4Dealloc];

    // Combine the separate queries into one batch.
    NSArray *queries = @[ childQuery1, childQuery2, childQuery3, parentsQuery ];
    GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQueryWithQueries:queries];

    batchQuery.executionParameters.shouldFetchNextPages = @YES;

    [GTLRTestLifetimeObject trackLifetimeOfObject:batchQuery
                                      expectation:initialBatchQueryDealloc];

    queryTicket =
        [service executeQuery:batchQuery
            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                GTLRBatchResult *batchResult, NSError *error) {
      // Force a reference to the original ticket.
      XCTAssertNotNil(queryTicket);

      // Verify the batch result and each success and failure result.
      XCTAssertEqualObjects([batchResult class], [GTLRBatchResult class]);
      XCTAssertNil(error);

      XCTAssertEqual(batchResult.successes.count, (NSUInteger)2);
      XCTAssertEqual(batchResult.failures.count, (NSUInteger)2);
      XCTAssertEqual(callbackTicket.pagesFetchedCounter, 3U);

      GTLRTestingSvc_FileList *fileList = batchResult.successes[@"gtlr_5"];
      XCTAssertEqual(fileList.files.count, (NSUInteger)8);

      [GTLRTestLifetimeObject trackLifetimeOfObject:callbackTicket
                                        expectation:ticketDealloc];

      // The ticket has a copy of the original batch query, which has copies of the individual
      // queries.
      GTLRBatchQuery *ticketQuery = callbackTicket.executingQuery;
      [GTLRTestLifetimeObject trackLifetimeOfObject:ticketQuery
                                        expectation:executedBatchQueryDealloc];

      [GTLRTestLifetimeObject trackLifetimeOfObject:[ticketQuery queryForRequestID:@"gtlr_5"]
                                        expectation:executedQuery1Dealloc];
      [GTLRTestLifetimeObject trackLifetimeOfObject:[ticketQuery queryForRequestID:@"gtlr_6"]
                                        expectation:executedQuery2Dealloc];
      [GTLRTestLifetimeObject trackLifetimeOfObject:[ticketQuery queryForRequestID:@"gtlr_7"]
                                        expectation:executedQuery3Dealloc];
      [GTLRTestLifetimeObject trackLifetimeOfObject:[ticketQuery queryForRequestID:@"gtlr_8"]
                                        expectation:executedQuery4Dealloc];

      [GTLRTestLifetimeObject trackLifetimeOfObject:batchResult
                                        expectation:resultObjectDealloc];

      [GTLRTestLifetimeObject trackLifetimeOfObject:callbackTicket.objectFetcher
                                        expectation:fetcherDealloc];

      [batchFinished fulfill];
    }];

    XCTAssert([self service:service waitForTicket:queryTicket]);
    XCTAssert(queryTicket.hasCalledCallback);
  }  // @autoreleasepool

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - Upload Tests

- (NSData *)tempDataForUploading {
  NSMutableString *string = [NSMutableString string];
  for (int index = 0; index < 10000; index++) {
    [string appendFormat:@"%c", 'A' + (index % 26)];
  }
  return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL *)tempFileURLForUploading {
  // Write a file that we can test uploading.
  NSURL *tempDir = [NSURL fileURLWithPath:NSTemporaryDirectory()];
  NSURL *tempFileURL = [tempDir URLByAppendingPathComponent:@"tempFileURLForUploading"
                                                isDirectory:NO];
  NSError *writeError;
  NSData *data = [self tempDataForUploading];
  BOOL didWrite = [data writeToURL:tempFileURL
                           options:NSDataWritingAtomic
                             error:&writeError];
  XCTAssert(didWrite, @"%@", writeError);
  if (didWrite) {
    _tempFileURLToDelete = tempFileURL;
  }
  return tempFileURL;
}

- (void)testService_Upload_FileHandle {
  NSURL *fileURL = [self tempFileURLForUploading];
  NSError *readingError;
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:fileURL
                                                                 error:&readingError];
  XCTAssertNotNil(fileHandle, @"%@", readingError);
  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileHandle:fileHandle
                                                 MIMEType:@"text/plain"];
  uploadParameters.useBackgroundSession = NO;
  [self performServiceUploadTestWithParameters:uploadParameters];
}

- (void)testService_Upload_FileURL {
  NSURL *fileURL = [self tempFileURLForUploading];
  NSError *fileError;
  XCTAssert([fileURL checkResourceIsReachableAndReturnError:&fileError], @"%@", fileError);
  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileURL:fileURL
                                               MIMEType:@"text/plain"];
  uploadParameters.useBackgroundSession = YES;
  [self performServiceUploadTestWithParameters:uploadParameters];
}

- (void)testService_Upload_FileURL_WithoutMetadata {
  NSURL *fileURL = [self tempFileURLForUploading];
  NSError *fileError;
  XCTAssert([fileURL checkResourceIsReachableAndReturnError:&fileError], @"%@", fileError);
  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileURL:fileURL
                                               MIMEType:@"text/plain"];
  uploadParameters.shouldSendUploadOnly = YES;
  uploadParameters.useBackgroundSession = YES;
  [self performServiceUploadTestWithParameters:uploadParameters];
}

- (void)testService_Upload_NSData {
  NSData *uploadData = [self tempDataForUploading];
  XCTAssert(uploadData.length > 1000);

  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithData:uploadData
                                            MIMEType:@"text/plain"];
  uploadParameters.useBackgroundSession = NO;
  [self performServiceUploadTestWithParameters:uploadParameters];
}

- (void)testService_Upload_NSData_WithoutMetadata {
  NSData *uploadData = [self tempDataForUploading];

  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithData:uploadData
                                            MIMEType:@"text/plain"];
  uploadParameters.shouldSendUploadOnly = YES;
  uploadParameters.useBackgroundSession = NO;
  [self performServiceUploadTestWithParameters:uploadParameters];
}

- (void)testService_Upload_NSData_SingleRequest {
  NSData *uploadData = [self tempDataForUploading];

  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithData:uploadData
                                            MIMEType:@"text/plain"];
  uploadParameters.shouldUploadWithSingleRequest = YES;
  uploadParameters.useBackgroundSession = NO;
  [self performServiceUploadTestWithParameters:uploadParameters];
}

- (void)testService_Upload_NSData_SingleRequest_WithoutMetadata {
  NSData *uploadData = [self tempDataForUploading];

  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithData:uploadData
                                            MIMEType:@"text/plain"];
  uploadParameters.shouldUploadWithSingleRequest = YES;
  uploadParameters.shouldSendUploadOnly = YES;
  uploadParameters.useBackgroundSession = NO;
  [self performServiceUploadTestWithParameters:uploadParameters];
}

- (void)performServiceUploadTestWithParameters:(GTLRUploadParameters *)uploadParameters {
  [self expectTicketAndParsingNotifications];

  XCTestExpectation *executeCompletionExp = [self expectationWithDescription:@"Execute block"];
  XCTestExpectation *queryCompletionExp = [self expectationWithDescription:@"Query block"];
  XCTestExpectation *progressExp;

  if (uploadParameters.shouldUploadWithSingleRequest || !uploadParameters.shouldSendUploadOnly) {
    // A request body is present except when doing chunked upload without metadata.
    progressExp = [self expectationWithDescription:@"Upload progress"];
  }

  GTLRTestingSvc_File *newFile = [GTLRTestingSvc_File object];
  newFile.name = @"File de Feline";

  GTLRService *service = [self driveServiceForTest];
  service.fetcherService.testBlock = ^(GTMSessionFetcher *fetcherToTest,
                                       GTMSessionFetcherTestResponse testResponse) {
    NSURL *fetchURL = fetcherToTest.request.URL;

    // Upload fetcher testBlock doesn't do chunk fetches, so this must be the initial upload fetch,
    // without an upload_id in the URL.
    NSString *uploadID = QueryValueForURLItem(fetchURL, @"upload_id");
    XCTAssertNil(uploadID);

    NSError *parseError;
    NSData *fetchBody = fetcherToTest.bodyData;
    if (uploadParameters.shouldUploadWithSingleRequest) {
      if (uploadParameters.shouldSendUploadOnly) {
        // Single part, no metadata.
        XCTAssertEqualObjects(fetchBody, [self tempDataForUploading]);
      } else {
        // Multipart.
        NSArray <GTMMIMEDocumentPart *>*bodyParts =
            [GTMMIMEDocument MIMEPartsWithBoundary:@"END_OF_PART" data:fetchBody];
        XCTAssertEqual(bodyParts.count, 2U);
        XCTAssertEqualObjects(bodyParts[0].headers[@"Content-Type"],
                              @"application/json; charset=utf-8");
        XCTAssertEqualObjects(bodyParts[1].headers[@"Content-Type"], @"text/plain");
        XCTAssertEqualObjects(bodyParts[1].body, [self tempDataForUploading]);
      }
    } else {
      // Chunked, resumable upload.
      if (uploadParameters.shouldSendUploadOnly) {
        // No metadata, so no initial fetch body.
        XCTAssertNil(fetchBody);
      } else {
        // The initial fetch body is the metadata.
        NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:fetchBody
                                                                 options:0
                                                                   error:&parseError];
        XCTAssertEqualObjects(jsonBody, newFile.JSON);
      }
    }

    // This is the initial request from the client.
    uploadID = @"AEnB2Uqzt_QIERV0PsZrB";
    NSDictionary *responseHeaders = @{
      @"X-Goog-Upload-Status" : @"final",
      @"Content-Type" : @"application/json; charset=UTF-8"
    };
    NSHTTPURLResponse *response =
        [[NSHTTPURLResponse alloc] initWithURL:(NSURL * _Nonnull)fetcherToTest.request.URL
                                    statusCode:200
                                   HTTPVersion:@"HTTP/1.1"
                                  headerFields:responseHeaders];
    NSDictionary *responseBodyDict = @{
        @"mimeType" : @"text/plain",
        @"id" : @"0svZDDwtKrhcHh2dmcyZ05MZWc",
        @"kind" : @"drive#file",
        @"name" : @"abcdefg.txt"
    };
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseBodyDict
                                                           options:0
                                                             error:NULL];
    NSError *responseError = nil;
    testResponse(response, responseData, responseError);
  };

  GTLRTestingSvcQuery_FilesCreate *query =
      [GTLRTestingSvcQuery_FilesCreate queryWithObject:newFile
                                      uploadParameters:uploadParameters];
  query.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *uploadedFile,
                            NSError *permissionError) {
    XCTAssertEqualObjects(uploadedFile.name, @"abcdefg.txt");
    XCTAssertEqualObjects(uploadedFile.kind, @"drive#file");
    [queryCompletionExp fulfill];
  };

  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *progressTicket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    if (numberOfBytesRead == dataLength) {
      [progressExp fulfill];
    }
  };

  GTLRServiceTicket *queryTicket = [service executeQuery:query
                                       completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                           GTLRTestingSvc_File *uploadedFile,
                                                           NSError *error) {
    XCTAssertEqualObjects(uploadedFile.name, @"abcdefg.txt");
    XCTAssertEqualObjects(uploadedFile.kind, @"drive#file");
    [executeCompletionExp fulfill];
  }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - testBlock Tests

- (GTLRTestingSvc_FileList *)fileListObjectForTest {
  GTLRTestingSvc_File *item0 = [GTLRTestingSvc_File object];
  item0.kind = @"drive#file";
  item0.name = @"frogfile";
  GTLRTestingSvc_File *item1 = [GTLRTestingSvc_File object];
  item1.kind = @"drive#file";
  item1.name = @"possumfile";

  GTLRTestingSvc_FileList *object = [GTLRTestingSvc_FileList object];
  object.kind = @"drive#fileList";
  object.files = @[ item0, item1 ];
  return object;
}

- (void)testService_MockService_Succeeding {
  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";

  GTLRTestingSvc_FileList *fileObj = [self fileListObjectForTest];
  GTLRService *service = [GTLRService mockServiceWithFakedObject:fileObj
                                                      fakedError:nil];

  XCTestExpectation *queryFinishedExp = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.kind, @"drive#fileList");
            XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

            [queryFinishedExp fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_MockService_Failing {
  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";

  NSError *expectedError = [NSError errorWithDomain:NSURLErrorDomain
                                               code:NSURLErrorResourceUnavailable
                                           userInfo:nil];

  GTLRService *service = [GTLRService mockServiceWithFakedObject:nil
                                                      fakedError:expectedError];

  XCTestExpectation *queryFinishedExp = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            XCTAssertNil(object);
            XCTAssertEqual(error.code, NSURLErrorResourceUnavailable);

            [queryFinishedExp fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_testBlock_Succeeding {
  // No need for a fetcher testBlock.
  [self expectTicketAndParsingNotifications];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";
  query.requestID = @"gtlr_1234";

  GTLRService *service = [self driveServiceForTest];
  service.rootURLString = @"https://example.invalid/";
  service.testBlock = ^(GTLRServiceTicket *ticket, GTLRServiceTestResponse testResponse) {
    XCTAssertEqualObjects(((GTLRQuery *)ticket.originalQuery).requestID, query.requestID);
    XCTAssertEqualObjects(((GTLRQuery *)ticket.executingQuery).requestID, query.requestID);
    XCTAssertEqualObjects(ticket.fetchRequest.URL.absoluteString,
                          @"https://example.invalid/drive/v3/files?"
                          @"fields=kind%2CnextPageToken%2Cfiles%28id%2Ckind%2Cname%29&"
                          @"prettyPrint=false");

    GTLRTestingSvc_FileList *obj = [self fileListObjectForTest];

    testResponse(obj, nil);
  };

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                           BOOL suggestedWillRetry,
                                           NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };
  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    XCTFail(@"No body upload expected.");
  };

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  __block GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.kind, @"drive#fileList");
            XCTAssertEqual(object.files.count, 2U, @"%@", object.files);

            GTLRTestingSvc_File *item0 = object.files[0];

            XCTAssertEqualObjects([item0 class], [GTLRTestingSvc_File class]);
            XCTAssertEqualObjects(item0.kind, @"drive#file");

            XCTAssertEqualObjects(callbackTicket, queryTicket);

            // The ticket's query should be a copy of the original; query execution leaves
            // the original unmolested so the client can modify and reuse it.
            GTLRQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, query);
            XCTAssertEqualObjects(ticketQuery.requestID, query.requestID);

            XCTAssert([NSThread isMainThread]);

            [queryFinished fulfill];
          }];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_testBlock_Failing {
  [self expectTicketNotifications];

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";
  query.requestID = @"gtlr_1234";

  NSError *expectedError = [NSError errorWithDomain:NSURLErrorDomain
                                               code:NSURLErrorResourceUnavailable
                                           userInfo:nil];

  GTLRService *service = [self driveServiceForTest];
  service.rootURLString = @"https://example.invalid/";
  service.testBlock = ^(GTLRServiceTicket *ticket, GTLRServiceTestResponse testResponse) {
    testResponse(nil, expectedError);
  };

  XCTestExpectation *queryFinishedExp = [self expectationWithDescription:@"queryFinishedExp"];
  XCTestExpectation *retryBlockExp = [self expectationWithDescription:@"retryBlockExp"];

  query.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                           BOOL suggestedWillRetry,
                                           NSError *error) {
    XCTAssertEqual(suggestedWillRetry, NO);
    [retryBlockExp fulfill];
    return NO;
  };

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertNil(object);
            XCTAssertEqualObjects(error, expectedError);
            [queryFinishedExp fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_testBlock_CallbackQueue {
  // No need for a fetcher testBlock.

  dispatch_queue_t myCallbackQueue = dispatch_queue_create("myCallbackQueue",
                                                           DISPATCH_QUEUE_SERIAL);

  GTLRTestingSvcQuery_FilesList *query = [GTLRTestingSvcQuery_FilesList query];
  query.fields = @"kind,nextPageToken,files(id,kind,name)";
  query.requestID = @"gtlr_1234";

  GTLRService *service = [self driveServiceForTest];
  service.rootURLString = @"https://example.invalid/";
  service.testBlock = ^(GTLRServiceTicket *ticket, GTLRServiceTestResponse testResponse) {
    GTLRTestingSvc_FileList *obj = [self fileListObjectForTest];
    testResponse(obj, nil);
  };
  service.callbackQueue = myCallbackQueue;

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRTestingSvc_FileList *object, NSError *error) {
            // Verify the top-level object and one of its items.
            XCTAssertEqualObjects([object class], [GTLRTestingSvc_FileList class]);
            XCTAssertNil(error);

            XCTAssert(IsCurrentQueue(myCallbackQueue));

            [queryFinished fulfill];
          }];

  service.callbackQueue = dispatch_get_main_queue();

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_testBlock_MediaQuery {
  // Successful request with data object response.
  NSData *expectedData = [self tempDataForUploading];
  NSString *expectedContentType = @"text/plain";

  GTLRService *service = [self driveServiceForTest];

  GTLRTestingSvcQuery_FilesGet *query =
      [GTLRTestingSvcQuery_FilesGet queryForMediaWithFileId:@"abcde"];

  // For variety, we'll attach the testBlock to the query's service execution parameters.
  query.executionParameters.testBlock = ^(GTLRServiceTicket *ticket,
                                          GTLRServiceTestResponse testResponse) {
    GTLRDataObject *obj = [GTLRDataObject object];
    obj.data = expectedData;
    obj.contentType = expectedContentType;

    testResponse(obj, nil);
  };

  XCTestExpectation *queryFinished = [self expectationWithDescription:@"queryFinished"];

  GTLRServiceTicket *queryTicket =
      [service executeQuery:query
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRDataObject *object, NSError *error) {
            NSURL *fetcherURL = callbackTicket.fetchRequest.URL;
            XCTAssertEqualObjects(QueryValueForURLItem(fetcherURL, @"alt"), @"media");

            XCTAssertEqualObjects([object class], [GTLRDataObject class]);
            XCTAssertNil(error);

            XCTAssertEqualObjects(object.data, expectedData);
            XCTAssertEqualObjects(object.contentType, expectedContentType);

            XCTAssert([NSThread isMainThread]);

            [queryFinished fulfill];
          }];

  XCTAssertFalse(queryTicket.hasCalledCallback);

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_testBlock_BatchQuery {
  // The test block will return a batch with one success and one failure.
  GTLRService *service = [self driveServiceForTest];
  service.rootURLString = @"https://example.invalid/";

  XCTestExpectation *childExp = [self expectationWithDescription:@"childCallback"];
  XCTestExpectation *parentsExp = [self expectationWithDescription:@"parentsCallback"];
  XCTestExpectation *batchFinished = [self expectationWithDescription:@"batchFinished"];

  GTLRTestingSvcQuery_FilesList *childQuery = [GTLRTestingSvcQuery_FilesList query];
  childQuery.q = [NSString stringWithFormat:@"'ABCDE' in parents"];
  childQuery.requestID = @"gtlr_5";
  childQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_FileList *fileList,
                                 NSError *childError) {
    XCTAssertEqualObjects([fileList class], [GTLRTestingSvc_FileList class]);
    XCTAssertEqualObjects(fileList.kind, @"drive#fileList");
    XCTAssertNil(childError);

    [childExp fulfill];
  };

  NSError *expectedError = [NSError errorWithDomain:NSURLErrorDomain
                                               code:NSURLErrorResourceUnavailable
                                           userInfo:nil];
  GTLRErrorObject *expectedErrorObject = [GTLRErrorObject objectWithFoundationError:expectedError];

  GTLRTestingSvcQuery_FilesGet *parentsQuery =
      [GTLRTestingSvcQuery_FilesGet queryWithFileId:@"0B7svZDDwtKrhS2FDS2JZclU1U0E"];
  parentsQuery.fields = @"parents";
  parentsQuery.requestID = @"gtlr_6";
  parentsQuery.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *file,
                                   NSError *parentsError) {
    XCTAssertNil(file);
    XCTAssertEqualObjects(parentsError.domain, expectedError.domain);
    XCTAssertEqual(parentsError.code, expectedError.code);

    [parentsExp fulfill];
  };
  parentsQuery.additionalHTTPHeaders = @{ @"Tiger" : @"Siberian" };

  // Combine the separate queries into one batch.
  GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];
  [batchQuery addQuery:childQuery];
  [batchQuery addQuery:parentsQuery];

  // Test adding http headers to the query
  batchQuery.additionalHTTPHeaders = @{ @"X-Feline": @"Fluffy",
                                        @"X-Canine": @"Spot" };

  service.testBlock = ^(GTLRServiceTicket *ticket, GTLRServiceTestResponse testResponse) {
    XCTAssert([ticket.fetchRequest.URL.absoluteString hasPrefix:@"https://example.invalid/"],
              @"%@", ticket.fetchRequest);
    GTLRTestingSvc_FileList *fileList = [self fileListObjectForTest];

    GTLRBatchResult *batchResult = [GTLRBatchResult object];
    batchResult.successes = @{ childQuery.requestID : fileList };
    batchResult.failures = @{ parentsQuery.requestID : expectedErrorObject };
    batchResult.responseHeaders = @{ childQuery.requestID : @{} , parentsQuery.requestID : @{} };

    testResponse(batchResult, nil);
  };

  batchQuery.executionParameters.retryBlock = ^(GTLRServiceTicket *ticket,
                                                BOOL suggestedWillRetry,
                                                NSError *error) {
    XCTFail(@"No retry expected.");
    return NO;
  };

  XCTestExpectation *uploadedSomeBytes = [self expectationWithDescription:@"uploadedSomeBytes"];
  batchQuery.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                         unsigned long long numberOfBytesRead,
                                                         unsigned long long dataLength) {
    if (numberOfBytesRead == dataLength) {
      [uploadedSomeBytes fulfill];
    }
    XCTAssert([NSThread isMainThread]);
  };

  GTLRServiceTicket *queryTicket =
      [service executeQuery:batchQuery
          completionHandler:^(GTLRServiceTicket *callbackTicket,
                              GTLRBatchResult *batchResult, NSError *batchError) {
            // Verify the batch result and each success and failure result.
            XCTAssertEqualObjects([batchResult class], [GTLRBatchResult class]);
            XCTAssertNil(batchError);

            XCTAssertEqual(batchResult.successes.count, 1U);
            XCTAssertEqual(batchResult.failures.count, 1U);
            XCTAssertEqual(batchResult.responseHeaders.count, 2U);

            GTLRTestingSvc_FileList *fileList = batchResult.successes[@"gtlr_5"];
            XCTAssertEqualObjects([fileList class], [GTLRTestingSvc_FileList class]);
            XCTAssertEqualObjects(fileList.kind, @"drive#fileList");

            GTLRErrorObject *failureObject = batchResult.failures[@"gtlr_6"];
            XCTAssertEqualObjects([failureObject class], [GTLRErrorObject class]);
            XCTAssertEqual(failureObject.code.intValue, NSURLErrorResourceUnavailable);

            // As with a single query, the batch ticket's query should be a copy of the original;
            // query execution leaves the original unmolested so the client can modify and reuse it.
            GTLRBatchQuery *ticketQuery = callbackTicket.executingQuery;
            XCTAssertNotEqual(ticketQuery, batchQuery);
            // Since the batch has a copy of the original query, all request IDs of both batch
            // queries should be the same.
            XCTAssertEqualObjects([ticketQuery.queries valueForKey:@"requestID"],
                                  [batchQuery.queries valueForKey:@"requestID"]);

            XCTAssert([NSThread isMainThread]);

            [batchFinished fulfill];
          }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // The request is to a fixed URL.
  XCTAssertEqualObjects(queryTicket.fetchRequest.URL.absoluteString,
                        @"https://example.invalid/batch");

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testService_testBlock_Upload_FileHandle {
  NSURL *fileURL = [self tempFileURLForUploading];
  NSError *readingError;
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:fileURL
                                                                 error:&readingError];
  XCTAssertNotNil(fileHandle, @"%@", readingError);

  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileHandle:fileHandle
                                                  MIMEType:@"text/plain"];
  [self performServiceUploadTestBlockTestWithParameters:uploadParameters];
}

- (void)testService_testBlock_Upload_FileURL {
  NSURL *fileURL = [self tempFileURLForUploading];
  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileURL:fileURL
                                               MIMEType:@"text/plain"];
  [self performServiceUploadTestBlockTestWithParameters:uploadParameters];
}

- (void)testService_testBlock_Upload_NSData {
  NSData *uploadData = [self tempDataForUploading];
  XCTAssert(uploadData.length > 1000);

  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithData:uploadData
                                            MIMEType:@"text/plain"];
  [self performServiceUploadTestBlockTestWithParameters:uploadParameters];
}

- (void)performServiceUploadTestBlockTestWithParameters:(GTLRUploadParameters *)uploadParameters {
  XCTestExpectation *executeCompletionExp = [self expectationWithDescription:@"Execute block"];
  XCTestExpectation *queryCompletionExp = [self expectationWithDescription:@"Query block"];
  XCTestExpectation *progressExp = [self expectationWithDescription:@"Upload progress"];
  XCTestExpectation *testBlockExp = [self expectationWithDescription:@"testBlock"];

  GTLRTestingSvc_File *newFile = [GTLRTestingSvc_File object];
  newFile.name = @"File de Feline";

  GTLRService *service = [self driveServiceForTest];
  service.rootURLString = @"https://example.invalid/";

  service.testBlock = ^(GTLRServiceTicket *ticket, GTLRServiceTestResponse testResponse) {
    NSString *uploadID = QueryValueForURLItem(ticket.fetchRequest.URL, @"upload_id");
    XCTAssertNil(uploadID);

    // Below we attach an ETag header to the upload object, and force the http method to PUT,
    // so the ETag should be present in the initial request header.
    NSString *headerETag = ticket.fetchRequest.allHTTPHeaderFields[@"If-Match"];
    XCTAssertEqualObjects(headerETag, newFile.ETag);

    GTLRTestingSvc_File *fileObj = [GTLRTestingSvc_File object];
    fileObj.kind = @"drive#file";
    fileObj.name = @"abcdefg.txt";
    fileObj.identifier = @"0svZDDwtKrhcHh2dmcyZ05MZWc";
    testResponse(fileObj, nil);

    [testBlockExp fulfill];
  };

  GTLRTestingSvcQuery_FilesCreate *query =
      [GTLRTestingSvcQuery_FilesCreate queryWithObject:newFile
                                      uploadParameters:uploadParameters];
  query.completionBlock = ^(GTLRServiceTicket *ticket, GTLRTestingSvc_File *uploadedFile,
                            NSError *permissionError) {
    XCTAssertEqualObjects(uploadedFile.name, @"abcdefg.txt");
    XCTAssertEqualObjects(uploadedFile.kind, @"drive#file");

    [queryCompletionExp fulfill];
  };

  query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *progressTicket,
                                                    unsigned long long numberOfBytesRead,
                                                    unsigned long long dataLength) {
    if (numberOfBytesRead == dataLength) {
      [progressExp fulfill];
    }
  };

  // To test that the ETag is copied from the query's object, we'll change the
  // request from POST to PUT, which will be ignored by the test block simulation
  // of the upload server, but will cause the ETag to be added as an If-Match request
  // header.
  newFile.ETag = @"wheeTag";
  [query setValue:@"PUT" forKey:@"httpMethod"];

  GTLRServiceTicket *queryTicket = [service executeQuery:query
                                       completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                           GTLRTestingSvc_File *uploadedFile,
                                                           NSError *error) {
    XCTAssertEqualObjects(uploadedFile.name, @"abcdefg.txt");
    XCTAssertEqualObjects(uploadedFile.kind, @"drive#file");

    [executeCompletionExp fulfill];
  }];

  XCTAssert([self service:service waitForTicket:queryTicket]);
  XCTAssert(queryTicket.hasCalledCallback);

  // Ensure all expectations were satisfied.
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - Utility Method Tests

- (void)testRequestForQuery {
  GTLRService *service = [[GTLRService alloc] init];
  service.rootURLString = @"https://www.test.com/";
  service.servicePath = @"api/";

  // Basic query.
  GTLRQuery *query = [[GTLRQuery alloc] initWithPathURITemplate:@"path/{path_part}"
                                                     HTTPMethod:nil
                                             pathParameterNames:@[ @"path_part" ]];
  query.JSON = [@{
    @"path_part" : @"foo",
    @"arg" : @"mumble",
  } mutableCopy];

  NSString *userAgent = service.requestUserAgent;
  NSDictionary *baseHTTPHeaders = @{ @"User-Agent" : userAgent };
  NSMutableDictionary *expectedHTTPHeaders = [baseHTTPHeaders mutableCopy];

  NSString *expectedURLString = @"https://www.test.com/api/path/foo?arg=mumble";
  NSMutableURLRequest *result = [service requestForQuery:query];
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
  XCTAssertEqualObjects(result.HTTPMethod, @"GET");
  XCTAssertEqualObjects(result.allHTTPHeaderFields, expectedHTTPHeaders);

  // Extra query arg and HTTP header.
  query.additionalURLQueryParameters = (id)@{ @"queryArg" : @YES };
  query.additionalHTTPHeaders = @{ @"X-Query" : @"All Good!" };
  expectedURLString = @"https://www.test.com/api/path/foo?arg=mumble&queryArg=true";
  [expectedHTTPHeaders setObject:@"All Good!" forKey:@"X-Query"];
  result = [service requestForQuery:query];
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
  XCTAssertEqualObjects(result.HTTPMethod, @"GET");
  XCTAssertEqualObjects(result.allHTTPHeaderFields, expectedHTTPHeaders);

  // With a service arg and HTTP header.
  service.additionalURLQueryParameters = (id)@{ @"serviceArg" : @42 };
  service.additionalHTTPHeaders = @{ @"X-Service" : @"Grumble" };
  expectedURLString = @"https://www.test.com/api/path/foo?arg=mumble&queryArg=true&serviceArg=42";
  [expectedHTTPHeaders setObject:@"Grumble" forKey:@"X-Service"];
  result = [service requestForQuery:query];
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
  XCTAssertEqualObjects(result.HTTPMethod, @"GET");
  XCTAssertEqualObjects(result.allHTTPHeaderFields, expectedHTTPHeaders);

  // Overlap between the query and service for an arg and HTTP header (query
  // wins).
  query.additionalURLQueryParameters = @{ @"arg1" : @"query", @"arg2" : @"query" };
  query.additionalHTTPHeaders = @{ @"X-1" : @"Query", @"X-2" : @"Query" };
  service.additionalURLQueryParameters = @{ @"arg1" : @"service", @"arg3" : @"service" };
  service.additionalHTTPHeaders = @{ @"X-1" : @"Service", @"X-3" : @"Service" };
  expectedURLString = @"https://www.test.com/api/path/foo?arg=mumble&arg1=query&arg2=query&arg3=service";
  expectedHTTPHeaders = [baseHTTPHeaders mutableCopy];
  [expectedHTTPHeaders addEntriesFromDictionary:@{
    @"X-1" : @"Query",
    @"X-2" : @"Query",
    @"X-3" : @"Service",
  }];
  result = [service requestForQuery:query];
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
  XCTAssertEqualObjects(result.HTTPMethod, @"GET");
  XCTAssertEqualObjects(result.allHTTPHeaderFields, expectedHTTPHeaders);

  // Different HTTPMethod.
  query = [[GTLRQuery alloc] initWithPathURITemplate:@"blah"
                                          HTTPMethod:@"POST"
                                  pathParameterNames:nil];
  expectedURLString = @"https://www.test.com/api/blah";
  service.additionalURLQueryParameters = nil;
  service.additionalHTTPHeaders = nil;
  expectedHTTPHeaders = [baseHTTPHeaders mutableCopy];
  result = [service requestForQuery:query];
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
  XCTAssertEqualObjects(result.HTTPMethod, @"POST");
  XCTAssertEqualObjects(result.allHTTPHeaderFields, expectedHTTPHeaders);

  // Add an APIKey.
  service.APIKey = @"Abracadabra!";
  result = [service requestForQuery:query];
  expectedURLString = @"https://www.test.com/api/blah?key=Abracadabra%21";
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
  XCTAssertEqualObjects(result.HTTPMethod, @"POST");
  XCTAssertEqualObjects(result.allHTTPHeaderFields, expectedHTTPHeaders);

  // Add an APIKey Restriction
  service.APIKeyRestrictionBundleID = @"foo.bar.baz";
  expectedHTTPHeaders[kXIosBundleIdHeader] = @"foo.bar.baz";
  result = [service requestForQuery:query];
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
  XCTAssertEqualObjects(result.HTTPMethod, @"POST");
  XCTAssertEqualObjects(result.allHTTPHeaderFields, expectedHTTPHeaders);
}

- (void)testRequestForQuery_MediaDownload {
  GTLRTestingSvcQuery_FilesGet *query =
      [GTLRTestingSvcQuery_FilesGet queryForMediaWithFileId:@"abcde"];
  query.useMediaDownloadService = NO;

  GTLRService *service = [self driveServiceForTest];

  // Without download service.
  NSURLRequest *result = [service requestForQuery:query];
  NSString *expectedURLString = @"https://www.googleapis.com/drive/v3/files/abcde?alt=media";
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);

  // With download service.
  query.useMediaDownloadService = YES;
  result = [service requestForQuery:query];
  expectedURLString = @"https://www.googleapis.com/download/drive/v3/files/abcde?alt=media";
  XCTAssertEqualObjects(result.URL.absoluteString, expectedURLString);
}

#pragma mark - Internal Utility Method Tests

- (void)testFullURLFromStringQueryParameters {
  NSString *inputStr;
  NSDictionary *inputDict;
  NSURL *output;
  NSString *expectedStr;
  NSURL *expected;

  inputStr = nil;
  inputDict = nil;
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  XCTAssertNil(output);

  inputStr = @"";
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  XCTAssertNil(output);

  inputStr = nil;
  inputDict = @{ @"b" : @"1" };
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  XCTAssertNil(output);

  inputStr = @"";
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  XCTAssertNil(output);

  inputStr = @"http://www.google.com";
  inputDict = nil;
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  expected = [NSURL URLWithString:@"http://www.google.com"];
  XCTAssertEqualObjects(output, expected);

  inputDict = @{ };
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  XCTAssertEqualObjects(output, expected);

  // Keys will be sorted, but order within any arrays is preserved.
  inputDict = @{
    @"g" : @42,
    @"f" : @[ @YES, @NO ],
    @"e" : @[ @1, @2, @3 ],
    @"d" : @[ @"d1", @"d3", @"d2" ],
    @"c" : @YES,
    @"b" : @"&",
    @"a" : @"1",
  };
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  expectedStr = @"http://www.google.com?a=1&b=%26&c=true&d=d1&d=d3&d=d2&e=1&e=2&e=3&f=true&f=false&g=42";
  expected = [NSURL URLWithString:expectedStr];
  XCTAssertEqualObjects(output, expected);

  inputStr = @"http://www.google.com?q=spam";
  output = [GTLRService URLWithString:inputStr queryParameters:inputDict];
  expectedStr = @"http://www.google.com?q=spam&a=1&b=%26&c=true&d=d1&d=d3&d=d2&e=1&e=2&e=3&f=true&f=false&g=42";
  expected = [NSURL URLWithString:expectedStr];
  XCTAssertEqualObjects(output, expected);
}

@end

//
// Simple authorizer object for testing - implementation
//

@implementation GTLRTestAuthorizer
@synthesize value = _value,
            error = _error;

+ (GTLRTestAuthorizer *)authorizerWithValue:(NSString *)value {
  GTLRTestAuthorizer *obj = [[self alloc] init];
  obj.value = value;
  return obj;
}

- (NSString *)authorizationValue {
  NSString *str = [NSString stringWithFormat:@"Bearer %@", _value];
  return str;
}

- (void)authorizeRequest:(nullable NSMutableURLRequest *)request
       completionHandler:(void (^)(NSError *_Nullable error))handler {
  NSString *str = [self authorizationValue];
  [request setValue:str forHTTPHeaderField:@"Authorization"];

  handler(_error);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)authorizeRequest:(NSMutableURLRequest *)request
                delegate:(id)delegate
       didFinishSelector:(SEL)sel {
  NSString *str = [self authorizationValue];
  [request setValue:str forHTTPHeaderField:@"Authorization"];

  id localSelf = self;
  NSMethodSignature *sig = [delegate methodSignatureForSelector:sel];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
  [invocation setSelector:sel];
  [invocation setTarget:delegate];
  [invocation setArgument:&localSelf atIndex:2];
  [invocation setArgument:&request atIndex:3];
  [invocation setArgument:&_error atIndex:4];
  [invocation invoke];
}
#pragma clang diagnostic pop

- (void)stopAuthorization {
}

- (void)stopAuthorizationForRequest:(NSURLRequest *)request {
}

- (BOOL)isAuthorizingRequest:(NSURLRequest *)request {
  return NO;
}

- (BOOL)isAuthorizedRequest:(NSURLRequest *)request {
  NSString *requestValue = [request valueForHTTPHeaderField:@"Authorization"];
  NSString *str = [self authorizationValue];
  return GTLR_AreEqualOrBothNil(requestValue, str);
}

- (NSString *)userEmail {
  return @"test@example.com";
}
@end

@implementation GTLRTestLifetimeObject {
  XCTestExpectation *_expectation;
}

+ (instancetype)trackLifetimeOfObject:(id)object expectation:(XCTestExpectation *)expectation {
  NSAssert(expectation != nil, @"missing expectation for %@", object);
  NSAssert(object != nil, @"missing object for %@", expectation);

  GTLRTestLifetimeObject *lifetime = [[self alloc] initWithExpectation:expectation];
  objc_setAssociatedObject(object, "GTLRTestLifetimeObject", lifetime, OBJC_ASSOCIATION_RETAIN);
  return lifetime;
}

- (instancetype)initWithExpectation:(XCTestExpectation *)expectation {
  self = [super init];
  if (self) {
    _expectation = expectation;
  }
  return self;
}

- (void)dealloc {
  [_expectation fulfill];
}

@end

#if GTM_BACKGROUND_TASK_FETCHING

@implementation CountingUIApplication

@synthesize beginTaskIDs = _beginTaskIDs,
            endTaskIDs = _endTaskIDs,
            shouldExpireTasks = _shouldExpireTasks,
            numberOfExpiredTasks = _numberOfExpiredTasks;

UIBackgroundTaskIdentifier gTaskID = 1000;

- (instancetype)init {
  self = [super init];
  if (self) {
    _beginTaskIDs = [NSCountedSet set];
    _endTaskIDs = [NSCountedSet set];
  }
  return self;
}

- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithName:(NSString *)taskName
                                        expirationHandler:(dispatch_block_t)handler {
  UIBackgroundTaskIdentifier taskID;

  @synchronized(self) {
    taskID = ++gTaskID;
    [self.beginTaskIDs addObject:@(taskID)];
  }
  if (_shouldExpireTasks) {
    dispatch_async(dispatch_get_main_queue(), ^{
      handler();
      self->_numberOfExpiredTasks++;
    });
  }
  return taskID;
}

- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)taskID {
  @synchronized(self) {
    [self.endTaskIDs addObject:@(taskID)];
  }
}

@end

#endif  // GTM_BACKGROUND_TASK_FETCHING
