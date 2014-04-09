#import "CBNetworkClient.h"

/*
 * This is the very simple "network client" for the gasp server. It deals with both push registration
 * and fetching restaurant data from the gasp-server.
 */

@implementation CBNetworkClient


- (NSString *) stringHttpGetContentsAtURL:(NSString *)url {
    NSURL *site = [NSURL URLWithString:url];    
    return [NSString stringWithContentsOfURL:site encoding:NSUTF8StringEncoding error:NULL];
}


- (NSString *) makeURL:(NSString *)url withPath:(NSString *)path {
    return [url stringByAppendingPathComponent:path];
}


/*
 * Talk to the cloudbees push server - tell it that we want to be pushed to - when there is new data.
 * this is a simple post.
 */

- (NSURLConnection *) registerForPush: (NSString *) host withToken:(NSString *)token {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:host]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSString *formString = [@"token=" stringByAppendingString:token];
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [formString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[formString
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    return  [[NSURLConnection alloc]
     initWithRequest:request
     delegate:self
     startImmediately:YES];
}

/*
 * search the gasp server (json)
 */

- (NSDictionary *) performSearch:(NSString *)terms withHost:(NSString *)host {
    NSString *url = [self makeURL: host withPath:[@"search/" stringByAppendingString:[terms stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *data = [self stringHttpGetContentsAtURL:url];
    return [self parseJSON:data];
}

/*
 * fetch a (json) list of restaurants
 */

- (NSArray *) listRestaurants:(NSString *)host {
    NSString *data = [self stringHttpGetContentsAtURL:[self makeURL: host withPath:@"restaurants"]];
    return [self parseJSONList:data];
}


- (BOOL) saveDocument:(NSString *)doc withHost:(NSString *)host {    
    NSString *path = [@"store/" stringByAppendingString:[doc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *data = [self stringHttpGetContentsAtURL:[self makeURL:host withPath:path]];
    return [self parseJSON:data] != nil;
}

/*
 * Convert JSON to an array we can use.
 */

- (NSArray *) parseJSONList:(NSString *)responseString {
    if (responseString == nil) return nil;
    NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if([object isKindOfClass:[NSArray class]]) {
        return (NSArray *) object;
    } else {
        return nil;
    }
}


/*
 * Convert JSON to Dictionary we can use
 */

- (NSDictionary *) parseJSON:(NSString *)responseString {
    if (responseString == nil) return nil;
    NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];    
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if([object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *) object;
    } else {
        return nil;
    }
}


/*
 * We only need one instance of this network client for the app.
 */

+ (CBNetworkClient *)sharedNetworkClient {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



@end
