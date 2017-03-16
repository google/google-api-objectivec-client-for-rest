#import <Foundation/Foundation.h>

// This file is just compiled during the UnitTests to ensure all the GTLR
// headers can safely be imported into a compile that has ARC disabled.

#if __has_feature(objc_arc)
#error "This file needs to be compiled without ARC enabled."
#endif

#import "GTLRDefines.h"

#import "GTLRBatchQuery.h"
#import "GTLRBatchResult.h"
#import "GTLRDateTime.h"
#import "GTLRDuration.h"
#import "GTLRErrorObject.h"
#import "GTLRObject.h"
#import "GTLRQuery.h"
#import "GTLRService.h"
#import "GTLRUploadParameters.h"

#import "GTLRBase64.h"
#import "GTLRFramework.h"
#import "GTLRURITemplate.h"
#import "GTLRUtilities.h"
