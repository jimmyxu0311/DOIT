#import <Foundation/Foundation.h>
#import "OAMutableURLRequest.h"


@interface OAServiceTicket : NSObject {
@private
    OAMutableURLRequest *request;
    NSURLResponse *response;
    BOOL didSucceed;
}
@property(retain) OAMutableURLRequest *request;
@property(retain) NSURLResponse *response;
@property(assign) BOOL didSucceed;

- (id)initWithRequest:(OAMutableURLRequest *)aRequest response:(NSURLResponse *)aResponse didSucceed:(BOOL)success;

@end
