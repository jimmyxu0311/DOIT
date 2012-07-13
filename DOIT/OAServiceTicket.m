#import "OAServiceTicket.h"


@implementation OAServiceTicket
@synthesize request, response, didSucceed;

- (id)initWithRequest:(OAMutableURLRequest *)aRequest response:(NSURLResponse *)aResponse didSucceed:(BOOL)success 
{
    if (self = [super init])
	{
		self.request = aRequest;
		self.response = aResponse;
		self.didSucceed = success;
	}
    return self;
}

- (void)dealloc
{
	[request release];
	[response release];
	[super dealloc];
}

@end
