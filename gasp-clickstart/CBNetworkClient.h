//
//  CBNetUtils.h
//  ios-clickstart
//
//  Created by Michael Neale on 15/03/13.
//  Copyright (c) 2013 Michael Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBNetworkClient : NSObject

- (NSString *) stringHttpGetContentsAtURL:(NSString *)url;
- (NSDictionary *) parseJSON:(NSString *)responseString;
- (NSArray *) parseJSONList:(NSString *)responseString;
- (NSArray *) listRestaurants:(NSString *)host;
- (NSDictionary *) performSearch:(NSString *)terms withHost:(NSString *)url;
- (NSString *) makeURL:(NSString *)url withPath:(NSString *)path;
- (NSURLConnection *) registerForPush: (NSString *) host withToken:(NSString *)token;
- (BOOL) saveDocument:(NSString *)doc withHost:(NSString *)host;
+ (CBNetworkClient *)sharedNetworkClient;

@end
