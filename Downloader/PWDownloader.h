//
//  PWDownloader.h
//  TestStaticServer
//
//  Created by Paul Wiseman on 13/08/2022.
//

#import <Foundation/Foundation.h>
#import <Network/Network.h>

#ifndef PWDownloader_h
#define PWDownloader_h

@interface PWDownloader : NSObject

- (void)downloadUrl:(NSString*)url;

@end

#endif /* PWDownloader_h */
