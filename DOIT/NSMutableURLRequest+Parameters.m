#import "NSMutableURLRequest+Parameters.h"


@implementation NSMutableURLRequest (OAParameterAdditions)

- (NSArray *)parameters 
{
    NSString *encodedParameters;
	BOOL shouldfree = NO;
	
	NSString *contentType = [self valueForHTTPHeaderField:@"Content-Type"];
	if ([contentType  hasPrefix:@"multipart/form-data; boundary="]) {
		encodedParameters = [[self URL] query];
		NSString *absoluteString = [self.URL absoluteString];
		NSRange rang = [absoluteString rangeOfString:@"?"];
		if (rang.location != NSNotFound) {
			absoluteString = [absoluteString substringToIndex:rang.location];
		}
		self.URL = [NSURL URLWithString:absoluteString];
	}
    else if ([[self HTTPMethod] isEqualToString:@"GET"] || [[self HTTPMethod] isEqualToString:@"DELETE"]) 
        encodedParameters = [[self URL] query];
	else 
	{
        // POST, PUT
		shouldfree = YES;
        encodedParameters = [[NSString alloc] initWithData:[self HTTPBody] encoding:NSASCIIStringEncoding];
    }
    
    if ((encodedParameters == nil) || ([encodedParameters isEqualToString:@""]))
        return nil;
    
    NSArray *encodedParameterPairs = [encodedParameters componentsSeparatedByString:@"&"];
    NSMutableArray *requestParameters = [[NSMutableArray alloc] initWithCapacity:16];
    
    for (NSString *encodedPair in encodedParameterPairs) 
	{
        NSArray *encodedPairElements = [encodedPair componentsSeparatedByString:@"="];
        OARequestParameter *parameter = [OARequestParameter requestParameterWithName:[[encodedPairElements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
																			   value:[[encodedPairElements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [requestParameters addObject:parameter];
    }
    
	// Cleanup
	if (shouldfree)
		[encodedParameters release];
	
    return [requestParameters autorelease];
}

- (void)setParameters:(NSArray *)parameters 
{
    NSMutableString *encodedParameterPairs = [NSMutableString stringWithCapacity:256];
    
    int position = 1;
    for (OARequestParameter *requestParameter in parameters) 
	{
        [encodedParameterPairs appendString:[requestParameter URLEncodedNameValuePair]];
        if (position < [parameters count])
            [encodedParameterPairs appendString:@"&"];
		
        position++;
    }
    
    if ([[self HTTPMethod] isEqualToString:@"GET"] || [[self HTTPMethod] isEqualToString:@"DELETE"])
        [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [[self URL] URLStringWithoutQuery], encodedParameterPairs]]];
    else 
	{
        // POST, PUT
        NSData *postData = [encodedParameterPairs dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        [self setHTTPBody:postData];
        [self setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
}

@end
