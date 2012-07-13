#import <Foundation/Foundation.h>

@interface OAToken : NSObject {
	NSString *pin;							//added for the Twitter OAuth implementation
@protected
	NSString *key;
	NSString *secret;
}
@property(retain) NSString *pin;			//added for the Twitter OAuth implementation
@property(retain) NSString *key;
@property(retain) NSString *secret;

- (id)initWithKey:(NSString *)aKey secret:(NSString *)aSecret;
- (id)initWithUserDefaultsUsingServiceProviderName:(NSString *)provider prefix:(NSString *)prefix;
- (id)initWithHTTPResponseBody:(NSString *)body;
- (int)storeInUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix;

@end
