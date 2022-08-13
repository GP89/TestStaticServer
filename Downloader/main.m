//
//  main.m
//  Downloader
//
//  Created by Paul Wiseman on 13/08/2022.
//

#import <Foundation/Foundation.h>
#import "PWDownloader.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
	    // insert code here...
		PWDownloader* downloader = [[PWDownloader alloc] init];
		[downloader downloadUrl:@"http://localhost:8080/NIO.o"];
		dispatch_main();
	}
	return 0;
}
