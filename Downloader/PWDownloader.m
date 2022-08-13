//
//  PWDownloader.m
//  Downloader
//
//  Created by Paul Wiseman on 13/08/2022.
//

#import "PWDownloader.h"

@implementation PWDownloader

- (void)downloadUrl:(NSString *)url {
	
	nw_endpoint_t endpoint = nw_endpoint_create_url(url.UTF8String);
	nw_parameters_t parameters = nw_parameters_create_secure_tcp(NW_PARAMETERS_DISABLE_PROTOCOL, NW_PARAMETERS_DEFAULT_CONFIGURATION);
	nw_connection_t connection = nw_connection_create(endpoint, parameters);
	nw_connection_set_queue(connection, dispatch_get_main_queue());
	
	nw_connection_set_state_changed_handler(connection, ^(nw_connection_state_t state, nw_error_t  _Nullable error) {
		
		NSLog(@"Connection state: %u", state);
		if (error) {
			NSLog(@"Downloader error: %@", error);
		}
		
	});
	
	[self sendRequest:connection url:url];
	
	nw_connection_start(connection);
	
}

- (void)sendRequest:(nw_connection_t)connection url:(NSString*)url {
	
	// Get hostname and path from url
	NSRange searchRange = NSMakeRange(0, [url length]);
	NSString* pattern = @".*//([^/^:]*)[:0-9]+(.*)";
	NSError* error = nil;
	
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
	NSTextCheckingResult* result = [regex firstMatchInString:url options:0 range:searchRange];
	
	NSRange hostRange = [result rangeAtIndex:1];
	NSRange pathRange = [result rangeAtIndex:2];
	NSString* host = [url substringWithRange:hostRange];
	NSString* path = [url substringWithRange:pathRange];

	NSString* message = [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\nHost: %@\r\n\r\n", path, host];
	
	NSData* data = [message dataUsingEncoding:NSASCIIStringEncoding];
	const char* dataC = (const char*)[data bytes];
	
	dispatch_data_t content = dispatch_data_create(dataC, strlen(dataC), dispatch_get_main_queue(), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
	
	nw_connection_send(connection, content, NW_CONNECTION_DEFAULT_STREAM_CONTEXT, false, ^(nw_error_t  _Nullable error) {
		if (error) {
			NSLog(@"%@", error);
		} else {
			[self setupReceiveMessageWithConnection:connection];
		}
	});
	
}

- (void)setupReceiveMessageWithConnection:(nw_connection_t)connection {
	
	NSLog(@"Calling receive");
	
	nw_connection_receive(connection, 1, 65536, ^(dispatch_data_t  _Nullable content, nw_content_context_t  _Nullable context, bool is_complete, nw_error_t  _Nullable error) {
		
		NSUInteger messageLength = 0;
		if (content != nil) {
			NSData *data = (NSData*)content;
			const char *charData = (const char *)[data bytes];
			messageLength = strlen(charData);
			NSLog(@"got %zu bytes", messageLength);
		}
		
		if (error != nil) {
			NSLog(@"Receive error: %@", error);
		}
		
		if (!is_complete && messageLength > 0) {
			[self setupReceiveMessageWithConnection:connection];
		}
		
	});
	
}

@end
