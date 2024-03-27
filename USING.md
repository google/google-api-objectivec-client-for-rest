# Using the Google APIs Client Library for Objective-C for REST (GTLR)

Google APIs allow client software to access and manipulate data hosted by Google services.

The Google APIs Objective-C Client Library for REST APIs is a Objective-C
framework that enables developers for iOS, macOS, tvOS, and watchOS to easily
write native applications using Google's JSON REST APIs. The framework handles

  * JSON parsing and generation
  * Networking
  * File uploading and downloading
  * Batch requests and responses
  * Service-specific protocols and query generation
  * Testing without network activity
  * HTTP logging

## Preparing to Use the Library

### Example Applications

The Examples directory contains example applications showing typical
interactions with Google services using the framework. The applications act as
simple browsers for the data classes for each service. The WindowController
source files of the samples were written with typical Cocoa idioms to serve as
quick introductions to use of the APIs.

The example applications run on macOS, but the library does not provide any user
interface support apart from authentication, so use of the library APIs is the
same for Mac and iOS applications.

In order to use the example applications that require authentication, you can
follow the same steps as for the
[GTMAppAuth Examples](https://github.com/google/GTMAppAuth/tree/master/Examples/Example-macOS)
The **client secret** can be blank/nil.

Google APIs which do not require authentication may require an **API key**, also
obtained from the [Developer Console](https://console.developers.google.com/).

### Adding the Library to a Project

#### Integration via CocoaPods

If you are building from CocoaPods, just use the pod provided, `GoogleAPIClientForREST`. 

The `Core` subspec includes the common parts of the library. There is also a
subspec for each service API provided, such as Calendar and Drive. Your project
can just depend on one or more service subspecs, and the core library files will
be built as well.

See the
[podspec file](https://github.com/google/google-api-objectivec-client-for-rest/blob/main/GoogleAPIClientForREST.podspec)
for the subspec names.

For example, if you needed the _Drive_ apis, you'd just need to add:

```
pod 'GoogleAPIClientForREST/Drive'
```

To your `Podfile` and run `pod install`.

If you are generating code for your own APIs, then add
`pod 'GoogleAPIClientForREST/Core'` to get the supporting runtime and then
manually add the generated sources to your Xcode project.

#### Integration via Swift Package Manager (SwiftPM)

Refer to the Xcode docs for how to add SwiftPM based dependences to the Xcode UI
or via your `Package.swift` file.

The `GoogleAPIClientForRESTCore` product includes the common parts of the
library, and then there are specific products for each service API provide. Your
project can use one or multiple services.

See the
[Package.swift](https://github.com/google/google-api-objectivec-client-for-rest/blob/main/Package.swift)
for the different product names.

For example, if you needed the _Drive_ apis, you just need to depend on the
`GoogleAPIClientForREST_Drive` product.

If you are generating code for your own APIs, then add
`GoogleAPIClientForRESTCore` to get the supporting runtime and then manually add
the generated sources to your Xcode project.

### `#import`s and `@import`s

Since CocoaPods and SwiftPM use different models for how things are built, the
module names for `@import` directives will be specific to each packaging system.

However, if consuming this library via Objective-C, all the packages export
their headers as _GoogleAPIClientForREST/HEADER.h_, so you can always `#import`
them as a framework import and that will work with either packaging system,
i.e. - `#import <GoogleAPIClientForREST/GTLRService.h` and
`#import <GoogleAPIClientForREST/GTLRYouTube.h`.

### Dependencies

The Google APIs Library for Objective-C for REST uses the prefix `GTLR`.

The library uses one other Google libraries with a `GTM` prefix. It provides
http handling
([gtm-session-fetcher](https://github.com/google/gtm-session-fetcher)).

### Authentication and Authorization

**Authentication** is the confirmation of a user's identity using her username,
password, and possibly other data, such as captcha answers or 2-step codes
provided via mobile phone. Authentication is required for access to non-public
data.

**Authorization** is the use of access tokens to allow specific requests.
Applications pass the OAuth 2 authorization object to a service class's
`setAuthorizer:` method to authorize queries.

Google APIs rely on OAuth 2 for user sign-in.  The `GTMSessionFetcher` provides
an Objective-C protocol to provide this, any library that supports that protocol
will work.

**Note:** Neither packaging system used here includes a dependency on any
authentication support, if you plan on using an api that also needs
authentication, you'll either want to use
[GTMAppAuth](https://github.com/google/GTMAppAuth) by depending on `GTMAppAuth`
also, or you can use something else like the
[Google Sign-In SDK](https://developers.google.com/identity/sign-in/ios/); see
their site for full information this.

**Note:** The `Oauth2` subspec in the pod is *NOT* needed for authentication,
that is for talking to that service directly. You just need something like
`GTMAppAuth` or the `Google Sign-In SDK`.

### API Quotas

For each API used by your application, enable the API and check its default
**quota** in the Services section of the
[Developer Console](https://console.developers.google.com/).

Applications which make frequent API requests or have many users may need more
than the default limit. The specific API documentation or the service's control
in the API Console will explain how to request a larger quota.

**Note:** Be sure to estimate your application's total queries per day for all
users and request an appropriate quota _before_ releasing your application to a
large audience. An inadequate quota may lead to errors on API requests after
your application ships.

### Generated Interfaces

The Google APIs Client Library for Objective-C includes generated service,
query and data classes. These are Objective-C files constructed by processing
the output of the
[Google APIs Discovery Service](https://developers.google.com/discovery).
The generated classes are derived from `GTLRService`, `GTLRQuery`, and
`GTLRObject`.

## Basics

### Objects and Queries

Servers respond to client API requests with an object.  The object is typically
either an individual item, or a collection with an `items` property that
accesses an `NSArray` of items.

For example, a search for files on Google Drive would return a
`GTLRDrive_FileList` collection, where the items of the collection are the
`GTLRDrive_File` items found by the search.

The individual items are derived from **GTLRObject**. The collection is derived
from **GTLRCollectionObject**, which is a `GTLRObject` that also provides for
indexed access to items via subscripts. `GTLRCollectionObject` also supports
`for` loops over the collection items by implementing the `NSFastEnumeration`
protocol, as shown in the next code snippet.

Each request to the server is a **query**. Server interactions in the library
are handled by a **service object**.  A single transaction with a service is
tracked with a **service ticket**.

For example, here is how to use the API library to fetch a list of items in
a public YouTube playlist.

```Objective-C
- (void)fetchPublicPlaylistWithID:(NSString *)playlistID {
  // Create a service for executing queries. For best performance, reuse
  // the same service instance throughout the app.
  //
  // Some of the service's properties may be set on a per-query basis
  // via the query's executionParameters property.
  GTLRYouTubeService *service = [[GTLRYouTubeService alloc] init];

  // Services which do not require user authentication may need an API key
  // from the Google Developers Console
  service.APIKey = @"put your API key here";

  // APIs which retrieve a collection of items may need to fetch
  // multiple pages. The service can optionally make multiple requests
  // to fetch all pages. The page size can be set in most APIs with the
  // query parameter maxResults.
  service.shouldFetchNextPages = YES;

  // The library can retry common networking errors. The retry criteria
  // may be customized by setting the service's retryBlock property.
  service.retryEnabled = YES;

  // Each API method has a unique class.  The required properties
  // of the API method are the parameters of the constructor.
  // Optional properties of the API method are properties of the
  // class.
  
  // The YouTube API requires a "part" parameter for each query.
  // The playlist ID an an optional property of the method.
  GTLRYouTubeQuery_PlaylistItemsList *query =
    [GTLRYouTubeQuery_PlaylistItemsList queryWithPart:@"snippet"];
  query.playlistId = playlistID;

  // A ticket is returned to let the app monitor or cancel query execution.
  GTLRServiceTicket *ticket =
    [service executeQuery:query
        completionHandler:^(GTLRServiceTicket *callbackTicket,
                            GTLRYouTube_PlaylistItemListResponse *playlistItemList,
                            NSError *callbackError) {
    // This callback block is run when the fetch completes.
    if (callbackError != nil) {
      NSLog(@"Fetch failed: %@", callbackError);
    } else {
      // The error is nil, so the fetch succeeded.
      //
      // GTLRYouTube_PlaylistItemListResponse derives from
      // GTLRCollectionObject, so it supports iteration of
      // items and subscript access to items.
      for (GTLRYouTube_PlaylistItem *item in playlistItemList) {
        // Print the name of each playlist item.
        NSLog(@"%@", item.snippet.title);
      }
    }
  }];
}
```

Unseen by the application, the server is returning a JSON tree in response to
queries.  Each `GTLRObject`, such as `GTLRYouTube_PlaylistItemListResponse` in
the example above, is just an Objective-C wrapper for a tree of JSON data. The
`GTLRObject` allows the JSON data to be treated like a first-class Objective-C
object, using normal Objective-C property notation. This use of properties is
visible in the code snippet above, where each product item result name is
accessible as `item.snippet.title`.

`GTLRObject`'s support for Objective-C properties allows compile-time syntax
checking and enables Xcode's autocompletion for each object.  The header files
for each object class clearly define the fields of each object. For example, the
YouTube playlist item object interface looks in part like this:

```Objective-C
@interface GTLRYouTube_PlaylistItem : GTLRObject

@property(strong) GTLRYouTube_PlaylistItemContentDetails *contentDetails;
@property(copy) NSString *ETag;
@property(copy) NSString *identifier;
@property(copy) NSString *kind;
@property(strong) GTLRYouTube_PlaylistItemSnippet *snippet;
@property(strong) GTLRYouTube_PlaylistItemStatus *status;

@end
```

Each object property returns either a standard Objective-C type (`NSString`,
`NSNumber`, `NSArray`), other `GTLRObjects`, or `GTLRDateTime`.

When your application gets a property from a `GTLRObject`, the library converts
the property name to the JSON key string to get or set the result in the
underlying JSON tree.  Subtrees of the JSON are returned wrapped in a new
`GTLRObject`s. To reduce memory overhead, the `GTLRObjects` are not created for
inner trees of the JSON until they are needed by the application.

Normally, applications will use `GTLRObject` properties and so will not need to
access the plain JSON tree, but it is available for each `GTLRObject` as a
dictionary with the property `JSON`.

Queries may also be executed with a delegate and selector for the callback:

```Objective-C
GTLRServiceTicket *ticket = [service executeQuery:query
                                         delegate:self
                                 finishedSelector:@selector(serviceTicket:finishedWithObject:error:)];
```

The delegate is retained until the query has completed, or until the ticket has
been canceled.

### Services and Tickets

Service objects maintain cookies and track other persistent data across queries.
Typically, an application will create and retain a single instance of a service
object to use for executing all queries.

The service object makes a copy of each query for execution, so changes to a
query object made after calling `executeQuery:` will not affect the request.

Query execution by the service is inherently asynchronous. There is no need
to use a dispatch or operation queue to run queries on other threads.
Generally, it's best to execute queries on the main application thread. Any
number of queries may be executed either concurrently or sequentially,
subject to rate limits shown in the
[Developer Console](https://console.developers.google.com/). Additional
information about threading support is listed below in the section on
performance optimizations.

A new ticket is created each time a query is executed by the service. When a
ticket is created, many of the ticket properties, such as retry settings and
surrogates (both described below), are initialized from the service's properties
and from the query’s `executionProperties` property.

The application may choose to retain the ticket after a query starts executing,
allowing the user to cancel the service request.

Once either a query's callback has been invoked or the ticket is canceled, the
ticket is no longer useful and may be released. To cancel a query in progress,
call `[ticket cancelTicket]`.

The query being executed by a ticket is available as `ticket.originalQuery`.
For queries that fetch multiple result pages, the query for the page currently
being fetched is available as `ticket.executingQuery`. The `GTMSessionFetcher`
object used to execute the query is accessible as `ticket.objectFetcher`.

### Result Pages

A query may return an object with only a subset of the results in the items
array. The object is considered one of several **pages**. When a result object
includes a **nextPageToken** token, then the query can be executed again with
the token provided as the **pageToken** property of the new query, fetching the
next set of results.

```Objective-C
// Check if more pages are available for this collection object.
if (object.nextPageToken) {
  // Manually make a query to fetch the next page of results by reusing a copy
  // of the previous query that was made before the query was executed.
  GTLRTasksQuery *nextQuery = copyOfPreviousQuery;
  nextQuery.pageToken = object.nextPageToken;
  GTLRServiceTicket *nextTicket = [service executeQuery:nextQuery ...
}
```

For APIs that provide a nextPageToken property, the library can automatically
fetch all pages, and return an object whose items array includes the items of
all pages (up to 25 pages). This can be turned on by setting the
`shouldFetchNextPages` property of a service or of the query’s execution
parameters:

```Objective-C
// Turn on automatic page fetches
service.shouldFetchNextPages = YES;
```

Note, however, that results spread over many pages may take a long time to be
retrieved, as each page fetch will lead to a new http request.  The server can
be told to use a larger page size (that is, more items in each page returned) by
fetching a query for the feed with a `maxResults` value:

```Objective-C
// Specify a large page size to reduce the need to fetch additional result pages
GTLRTasksQuery *query = [GTLRTasksQuery_TasklistsList query];
query.maxResults = 1000;
ticket = [service executeQuery:query ...
```

Ideally, `maxResults` will be large enough that, for typical user data, all
results will be returned in a single page.

For queries that search public data, with potentially a very large number of
items resulting, `shouldFetchNextPages` should _not_ be enabled for the service
or the ticket. Additional pages of large data sets can be fetched manually.

### Query Operations

Query objects typically implement these basic operations:
  * **list** - fetch a list of items
  * **insert** - add an item to a list
  * **update** - replace an entire item
  * **patch** - replace fields of an item
  * **delete** - remove an item

There may be custom query operations as well, such as for uploading and
downloading files. To find the Objective-C query class for a documented API
operation, search for the **method name** shown in the documentation for the
API. It is listed before each method name in the query class interface, as
shown here for the method named “youtube.playlistItems.list”:

```Objective-C
/**
 *  Returns a collection of playlist items that match the API request
 *  parameters.
 *
 *  Method: youtube.playlistItems.list
 */
@interface GTLRYouTubeQuery_PlaylistItemsList : GTLRYouTubeQuery

/**
 *  Fetches a GTLRYouTube_PlaylistItemListResponse
 *
 *  @param part The part parameter specifies a comma-separated list of one or
 *    more playlistItem resource properties that the API response will include.
 *
 *  @returns GTLRYouTube_PlaylistItemListResponse
 */
+ (instancetype)queryWithPart:(NSString *)part;
```

The comments for each method also specify the type of object passed to the
callback if the query succeeds. In this example, the callback object class is
`GTLRYouTube_PlaylistItemListResponse`.

### Creating GTLRObjects from Scratch

Typically, `GTLRObject`s are created by the library from JSON returned from a
server, but occasionally it is useful to create one from scratch, such as when
inserting a new item or patching an existing item.  The `+object` method creates
an empty instance of a `GTLRObject`.

This snippet shows how to create a new folder for the user's Google Drive
account:

```Objective-C
- (void)createAFolder {
  GTLRDriveService *service = self.driveService;

  GTLRDrive_File *folder = [GTLRDrive_File object];
  folder.name = @"New Folder Name"
  folder.mimeType = @"application/vnd.google-apps.folder";

  GTLRDriveQuery_FilesCreate *query =
    [GTLRDriveQuery_FilesCreate queryWithObject:folderObj
                               uploadParameters:nil];
  [service executeQuery:query
      completionHandler:^(GTLRServiceTicket *callbackTicket,
                          GTLRDrive_File *folderItem,
                          NSError *callbackError) {
    // Callback
    if (callbackError == nil) {
      // Succeeded.
    }
  }];
}
```

### Uploading Files

Queries that can upload files will take a `GTLRUploadParameters` object. The
upload parameters object requires a MIME type describing the file data, and
either an `NSData` with the file's contents, or an `NSURL` for reading
from the local file.

Here is an example of uploading a file to the user’s Google Drive account.

```Objective-C
- (void)uploadFileURL:(NSURL *)fileToUploadURL {
  GTLRDriveService *service = self.driveService;

  GTLRUploadParameters *uploadParameters =
      [GTLRUploadParameters uploadParametersWithFileURL:fileToUploadURL
                                               MIMEType:@"text/plain"];
                                               
  GTLRDrive_File *newFile = [GTLRDrive_File object];
  newFile.name = path.lastPathComponent;

  GTLRDriveQuery_FilesCreate *query =
    [GTLRDriveQuery_FilesCreate queryWithObject:newFile
                               uploadParameters:uploadParameters];

  GTLRServiceTicket *uploadTicket =
    [service executeQuery:query
        completionHandler:^(GTLRServiceTicket *callbackTicket,
                            GTLRDrive_File *uploadedFile,
                            NSError *callbackError) {
    if (callbackError == nil) {
      // Succeeded
    }
  }];
}
```

The library by default uses Google's resumable (chunked) upload protocol for
transferring the file to the server. The chunked upload requires one or more
additional server requests. When uploading a large file (perhaps over a
megabyte), the chunk transfer can be done with a background NSURLSession
by settings the property `uploadParameters.useBackgroundSession`. 

Conversely, small uploads (perhaps under 500K) can be done even more quickly
with a single server request by setting the property

```Objective-C
uploadParameters.shouldUploadWithSingleRequest = YES;
```

Use the libary’s http logging feature to see and understand what server requests
are used for uploading.

#### Progress Monitoring

The application can supply a block to be called for displaying progress during
uploads.

```Objective-C
query.executionParameters.uploadProgressBlock =
  ^(GTLRServiceTicket *ticket,
    unsigned long long numberOfBytesRead,
    unsigned long long dataLength) {
  [uploadProgressIndicator setDoubleValue:(double)numberOfBytesRead];
  [uploadProgressIndicator setMaxValue:(double)dataLength];
};
```

#### Pause and Resume

Uploads in progress can be paused and resumed.

```Objective-C
if (ticket.uploadPaused) {
  [ticket resumeUpload];
} else {
  [ticket pauseUpload];
}
```

Pause and resume are not supported for uploads sent with the
`shouldUploadWithSingleRequest` property set.

Uploads can be cancelled with the ticket's `cancelTicket` method.

### Downloading Files

The library supports two ways to download files. Files that are expected
to be small may be downloaded with a library query. Larger files should
instead be downloaded with a `GTMSessionFetcher`, a class that supports
convenient http uploading and downloading.

#### Downloading with a Query

APIs that support direct download of media files will pass the downloaded
file to the query callback as a `GTLRDataObject` instance, as shown here:

```Objective-C
GTLRQuery *query = [GTLRDriveQuery_FilesGet queryForMediaWithFileId:fileID];
[service executeQuery:query
    completionHandler:^(GTLRServiceTicket *callbackTicket,
                        GTLRDataObject *dataObject,
                        NSError *callbackError) {
  if (callbackError == nil) {
    // The file downloaded successfully; its data is available as dataObject.data
  }
}];
```

#### Downloading with a GTMSessionFetcher

A GTMSessionFetcher can download any NSURLRequest. The service methods
`requestForQuery:completion:` / `requestForQuery:` will convert a library query
into an NSURLRequest.

NOTE: Because formatting the `User-Agent` header (required to create the
`GTMSessionFetcher`) can block the calling thread, always use
`requestForQuery:completion:` when calling from the UI thread / main queue.  If
the code is creating the `GTMSessionFetcher` from a background queue that is OK
to block, then using `requestForQuery:` can be more appropriate.

Download of any individual user’s data from Google services requires
that the request be authorized. A fetcher created from the `GTLRService`
object’s fetcher service will authorize the download request.

Here is an example of an authorized file download using a fetcher:

```Objective-C
GTLRQuery *query = [GTLRDriveQuery_FilesGet queryForMediaWithFileId:fileID];
[service requestForQuery:query
              completion:^(NSURLRequest *downloadRequest) {
  GTMSessionFetcher *fetcher =
    [service.fetcherService fetcherWithRequest:downloadRequest];

  [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *fetchError) {
    if (fetchError == nil) {
      // Download succeeded.
    }
  }];
}];
```

The class GTMSessionFetcher has many more features for monitoring and
controlling http downloads and uploads, and can download directly to a
file instead of to an NSData. See the fetcher header file for details.

## Performance and Memory Optimizations

### Partial Responses

Applications can avoid fetching unneeded data by setting a query's `fields`
property. Google APIs support a syntax similar to XPath for selecting fields to
be included in the response.

For example, to request only the IDs and author email addresses for each item in
the collection, use this request:

```Objective-C
query.fields = @"items(id,author/email,kind),kind,nextPageToken";
```

_Note:_ The above is just an example, the exact value you need will depend on
the api/method you are using and what fields you want included in the reply.
`GTLRObject` provides a
[`fieldsDescription`](https://github.com/google/google-api-objectivec-client-for-rest/blob/cf920eebf97ed5d8c5a8a1f5f4941087366737c2/Source/Objects/GTLRObject.h#L188-L197)
method which returns a string describing all of the set fields in an object.  The string may
be useful as a starting point when making a query to request specific fields.  You'll
want to use it on the root object from a query to get the full hierarchy.

The library may use the `kind` fields of responses to choose the proper object
classes, so requests for partial responses should _always_ include the `kind`
fields for both items and collections, as shown above. Otherwise, the library
may be forced to incorrectly instantiate the `GTLRObject` base class for the
response.

Queries for collections should also accept the `nextPageToken` field, as that
field is returned when an additional result page should be fetched. The service
API documentation should specify if a `nextPageToken` field is returned with
collection responses.

Refer to the
[documentation](https://developers.google.com/google-apps/tasks/performance?csw=1#partial)
for details on the fields parameter.

### Partial Updates

An update query will replace an entire item of a collection. Typically, it is
more useful to replace only one or a few fields of an item. A patch query
accomplishes that: it replaces only the fields specified by the patch object.

Here is how to use a partial update to change only the name of a calendar:

```Objective-C
GTLRCalendar_Calendar *patchObject = [GTLRCalendar_Calendar object];
patchObject.summary = newCalendarName;

GTLRCalendarQuery_CalendarsPatch *query =
    [GTLRCalendarQuery_CalendarsPatch queryWithObject:patchObject
                                           calendarId:calendarID];
[service executeQuery:query ...
```

An explicit **null value** indicates that a field should be deleted. For
example, removing just the location from a calendar looks like this:

```Objective-C
GTLRCalendar_Calendar *patchObject = [GTLRCalendar_Calendar object];
patchObject.location = [GTLRObject nullValue];

GTLRCalendarQuery_CalendarsPatch *query =
    [GTLRCalendarQuery_CalendarsPatch queryWithObject:patchObject
                                           calendarId:calendarID];
[service executeQuery:query ...
```

An array in a patch object field always replaces the entire array for the object
on the server, as described in the
[documentation](http://code.google.com/apis/calendar/v3/performance.html#patch)
for partial updates.

`GTLRObject` includes a helpful method `patchObjectFromOriginal:` for making a
patch object that contains just the changes from a previous version of that
object.

### Batch Operations

Several unrelated queries may be executed together in a **batch**. Batch
execution is faster than is executing queries individually.

There are two ways to obtain the results of batch queries: the unified
completion handler callback for the batch query execution, with results
for all queries, and individual completion blocks for each query.

Typically, it is easier to use individual query completion blocks for
unrelated methods (such as requesting a variety of different attributes
of a single item), and the unified completion handler for batches of
related methods (such as requesting the same attributes of an array of
one class of item).

Both types of callbacks may be used. The individual query completion
blocks are always called before the completion handler for the batch
query execution. Individual query completion blocks are optional, and
may be omitted.

#### Individual Query Completion Blocks

A completion block can be specified for each query, as shown here:

```Objective-C
GTLRCalendarQuery_EventsList *eventsQuery =
    [GTLRCalendarQuery_EventsList queryWithCalendarId:calendarID];
eventsQuery.completionBlock = ^(GTLRServiceTicket *callbackTicket,
                                GTLRCalendar_Events *events,
                                NSError *callbackError) {
  If (callbackError == nil) {
    // This query succeeded.
  }
};

GTLRBatchQuery *batch = [GTLRBatchQuery batchQuery];
[batch addQuery:eventsQuery];
```

Errors passed to the query's completion block will have an underlying
`GTLRErrorObject` when execution succeeded but the server returned an error for
this specific query:

```
GTLRErrorObject *errorObj = [GTLRErrorObject underlyingObjectForError:error];
if (errorObj) {
    // The server returned this error for this specific query.
  } else {
    // This error occurred because the batch execution failed.
}
```

#### Unified Batch Completion Handler

The unified result of executing a batch query is a `GTLRBatchResult` object
with two dictionaries, one for the results of successful queries, and one for
the error objects returned by unsuccessful queries.

Note that in addition to the dictionary of error results, there is also an
`NSError` passed to the completion handler which indicates if the execution did
not succeed.

```Objective-C
GTLRBatchQuery *batchQuery = [GTLRBatchQuery batchQuery];
[batchQuery addQuery:query1];
[batchQuery addQuery:query2];

[service executeQuery:batchQuery
    completionHandler:^(GTLRServiceTicket *callbackTicket,
                        GTLRBatchResult *batchResult,
                        NSError *callbackError) {
    if (callbackError == nil) {
      // Execute succeeded: step through the query successes
      // and failures in the result.
      NSDictionary *successes = batchResult.successes;
      for (NSString *requestID in successes) {
        GTLRObject *result = [successes objectForKey:requestID];
      }

      NSDictionary *failures = batchResults.failures;
      for (NSString *requestID in failures) {
        GTLRErrorObject *errorObj = [failures objectForKey:requestID];
      }
    } else {
      // Here, callbackError is non-nil so the execute failed: 
      // no success or failure results were obtained from the server.
    }
  }];
```

Each query object is created with a unique `requestID`, though your application
may set a custom `requestID` string for the query prior to execution. The
`requestID` string must be non-empty, and all queries in a batch must have
unique `requestID`s.

### Threading

Typically, applications will execute queries on the main thread, and the query
completion handler will be called back on the main thread.

To have callbacks performed on a different queue than the main queue, specify a dispatch queue for the service’s `callbackQueue` property.

## Convenience Features

### Converting a Query to an NSURLRequest

A service object can convert a GTLRQuery to a plain NSMutableURLRequest with the
service method `requestForQuery:completion:`. That may be useful for downloading
media files, or for performing an API request without using the service’s
`executeQuery:` method.

Requests that retrieve user data require authorization. The `GTMSessionFetcher`
authorizer property handles authorization for requests fetched with the
fetcher. Alternatively, a GTMAppAuth authorizer object can authorize a
plain NSMutableURLRequest.

### Query Execution Notifications

Apps that want to monitor performance or network activity may observe the
notifications `kGTLRServiceTicketStartedNotification` and
`kGTLRServiceTicketStoppedNotification`.

### Saving Objects (Serialization)

#### Archiving

`GTLRObject` conforms to `NSSecureCoding` so may be serialized with
`NSKeyedArchiver` and deserialized with `NSKeyedUnarchiver`. The
object’s `userProperties` dictionary is not encoded into the archive.

#### Other Ways to Serialize

A `GTLRObject` has an underlying NSDictionary accessible through its
`JSON` property. The dictionary may be saved as a property list using
`NSPropertyListSerialization` or as JSON using `NSJSONSerialization`.
Here is an example of serializing with a property list:

```Objective-C
// Saving to disk.
NSError *serializeError;
NSData *data = [NSPropertyListSerialization dataWithPropertyList:events.JSON
                    format:NSPropertyListBinaryFormat_v1_0
                   options:0
                     error:&serializeError];
if (data) {
  NSError *writeError;
  BOOL didWrite = [data writeToURL:fileURL
                           options:0
                             error:&writeError];
}
```

An object's JSON can also be expressed as a string with the `JSONString` method.

The object may later be recreated with the class methods `+objectWithJSON:` or `+objectWithJSON:objectClassResolver:`. The
JSON dictionary should be constructed with mutable containers:

```Objective-C
NSData *data = [NSData dataWithContentsOfURL:fileURL
                                     options:0
                                       error:&error];
if (data) {
  NSMutableDictionary *dict =
    [NSPropertyListSerialization propertyListWithData:data
                                              options:NSPropertyListMutableContainers
                                               format:NULL
                                                error:&error];
  if (dict) {
    GTLRCalendar_Events *eventsList =
      [GTLRCalendar_Events objectWithJSON:dict];
    // or
    GTLRCalendar_Events *eventsList2 =
      [GTLRCalendar_Events objectWithJSON:dict
                      objectClassResolver:calendarService.objectClassResolver];
  }
}
```

The version taking an `objectClassResolver` will do a better job of finding the correct object classes to use based on the `kind` properties in the JSON.

### Adding Custom Data

Often it is useful to add data locally to a `GTLRObject`. For example, an
entry used to represent a file being uploaded would be more convenient if
it also carried a path to the file on the local disk.

Your application can add data to any instance of a `GTLRObject` in two ways.
These techniques only add data to objects _locally_ for the Objective-C
code; the data will not be retained on the server, nor serialized by
NSKeyedArchiver.

#### User Properties

An application can set and retrieve a dictionary with an object’s
`userProperties` property, such as this:

```Objective-C
GTLRDrive_File *file = [GTLRDrive_File object];
file.userProperties = @{ @”LocalFileURL” : fileLocalURL };
```
#### Subclassing GTLRObjects

Alternatively, applications may subclass `GTLRObject`s to add properties and
methods. To have your subclasses be instantiated in place of the standard
object class during the parsing of JSON as part of query execution, set the
`objectClassResolver` property of the service:

```Objective-C
GTLRDriveService *service = [[GTLRDriveService alloc] init];
NSDictionary *surrogates = @{
  [GTLRDrive_File class] : [MyFile class],
  [GTLRDrive_FileList class] : [MyFileList class]
};
NSDictionary *serviceKindMap = [[service class] kindStringToClassMap];
GTLRObjectClassResolver *updatedResolver =
  [GTLRObjectClassResolver resolverWithKindMap:serviceKindMap
                                    surrogates:surrogates];
service.objectClassResolver = updatedResolver;
```

The surrogates may also be set for a single query using the query’s
`executionParameters` property:

```Objective-C
GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
query.executionProperties.objectClassResolver = updatedResolver;
```

### Passing Data to Query Callbacks

It is often useful to pass data to a callback method, particularly when
using selector callbacks rather than blocks.

Each ticket has a property `ticketProperties` which is initialized to the
service’s `serviceProperties`. An app may set the `serviceProperties` or
`ticketProperties` to provide access to application-specific data:

```Objective-C
query.executionParameters.ticketProperties = @{ @"file source", localFileURL };
ticket = [service executeQuery:query
                   delegate:self
          didFinishSelector:@selector(serviceTicket:finishedWithObject:error:)];
```

The callback can then access the data:

```Objective-C
- (void)serviceTicket:(GTLRServiceTicket *)callbackTicket
   finishedWithObject:(Test_GTLRDrive_File *)object
                error:(NSError *)callbackError {
  if (callbackError == nil) {
    NSURL *localFileURL = callbackTicket.ticketProperties[@"file source"];
  }
}
```

### Automatic Retry

GTRL service classes and the `GTMSessionFetcher` class provide a mechanism for
automatic retry of a few common network and server errors, with appropriate
increasing delays between each attempt.  You can turn on the automatic retry
support for a GTLR service by setting the `retryEnabled` property.

```Objective-C
// Turn on automatic retry of some common error results
service.retryEnabled = YES;
```

The default errors retried are http status 408 (request timeout), 502 (gateway
failure), 503 (service unavailable), and 504 (gateway timeout),
`NSURLErrorNetworkConnectionLost`, and `NSURLErrorTimedOut`. You may specify a
maximum retry interval other than the default of 1 minute, and can provide an
optional `retryBlock` for the service or for a single query to customize the
criteria for each retry attempt.

### Testing

For unit tests, queries can be executed without any network activity. 

When testing, set the `testBlock` property of a service object or a query’s
execution parameters. The `testBlock` should call its response parameter
with an object or error, like this:

```Objective-C
query.executionParameters.testBlock = ^(GTLRServiceTicket *ticket,
                                        GTLRQueryTestResponse testResponse) {
  // The query is available from the ticket.
  GTLRQuery *testQuery = ticket.originalQuery;

  // The testBlock can create a GTLRObject or GTLRBatchResult, or an NSError.
  //
  // Here, we will make a GTLRObject as the test response.
  GTLRDrive_File *fileObj = [GTLRDrive_File object];
  fileObj.name = @"My Fake File";

  NSError *testError = nil;

  testResponse(fileObj, testError);
};
```

As a convenient alternative to creating a test block, the test code can just
create a service object with
`+[GTLRService mockServiceWithFakedObject:fakedError:]` and pass the desired
result object or error. That creates a service class instance with an
appropriate test block.

When a service or query has a `testBlock`, the block will be called instead of
the library performing the normal network activity. Since the `executeQuery:`
invocation is asynchronous, the unit test should use either
`[GTRLService waitForTicket:timeout:]` or
`[XCTestCase waitForExpectationsWithTimeout:]` to wait for the completion
handler to be called.

## Logging HTTP Server Traffic

Debugging query execution is often easier when you can browse the JSON and
headers being sent back and forth over the network.  To make this convenient,
the framework can save copies of the server traffic, including http headers, to
files in a local directory.  Your application should call

```Objective-C
[GTMSessionFetcher setLoggingEnabled:YES]
```

to turn on logging.  The project building the fetcher class must also include
`GTMSessionFetcherLogging.h` and `.m`.

Normally, logs are written to the directory GTMSessionDebugLogs in the logs
directory. The logs directory is in the current user's Desktop folder for Mac
applications. In the iPhone simulator, the default logs location is the user's
home directory. On the iPhone device, the default location is the application's
documents folder on the device.

When http logging begins on iOS, the logs folder path is written to the console, like

> GTMSessionFetcher logging to
> "/Users/username/Library/Developer/CoreSimulator/Devices/3B2F01FE-9D64-4C20/data/Containers/Data/Application/FB8E3483-23022D135FB4/GTMHTTPDebugLogs"

The path (including the quotes) can be pasted into a terminal window to open the logs folder:

```shell
open "/Users/username/Library/Developer/.../GTMHTTPDebugLogs"
```

The path to the logs folder can be specified with the `+setLoggingDirectory:`
method.

To view the most recently saved logs, use a web browser to open the symlink
named `MyAppName_log_newest.html` (for whatever your application's name is) in
the logging directory.

For each executed query, when logging is enabled, the http log is also available
as the property `ticket.objectFetcher.log`

**_iOS Note:_** Logging support is stripped out in non-DEBUG builds by default.
This can be overridden by explicitly setting `STRIP_GTM_FETCH_LOGGING=0` for
the project.

**_Tip:_** Providing a convenient way for your users to enable logging is often
helpful in diagnosing problems when using the API.

## Questions and Comments

**If you have any questions or comments** about the library or this
documentation, please join the
[discussion group](http://groups.google.com/group/google-api-objectivec-client).
