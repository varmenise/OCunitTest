//
//  ios_clickstartLogicTests.m
//  ios-clickstartLogicTests
//
//  Created by Michael Neale on 11/03/13.
//  Copyright (c) 2013 Michael Neale. All rights reserved.
//

#import "gaspLogicTests.h"
#import "CBViewController.h"
#import "CBNetworkClient.h"

@implementation ios_clickstartLogicTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testOnAController
{
    CBViewController *cont = [CBViewController new];
    NSString *result = [cont hello:@"world" more:@"that is all"];
    STAssertEqualObjects(@"world", result, @"Hello to the world");
}

- (void) testHttpGet
{
    CBNetworkClient *client = [CBNetworkClient sharedNetworkClient];
    STAssertNil([client stringHttpGetContentsAtURL:@"http://localhost:9876"], @"Nil for no service");
    STAssertNotNil([client stringHttpGetContentsAtURL:@"http://www.google.com"], @"We can reach google");
}

- (void) testParsingJSON
{
    CBNetworkClient *client = [CBNetworkClient sharedNetworkClient];
    NSDictionary *res = [client parseJSON:@"{\"hello\":\"world\"}"];
    STAssertNotNil(res, @"we get a dictionary");
    STAssertEqualObjects(@"world", [res valueForKey:@"hello"], @"it should have this value");
    STAssertNil([client parseJSON:@"garbage"], @"should be nil as not json");
    STAssertNil([client parseJSON:nil], @"should handle nil");
}

- (void) testMakeUrl
{
    CBNetworkClient *client = [CBNetworkClient sharedNetworkClient];
    STAssertEqualObjects(@"base/path", [client makeURL:@"base" withPath:@"path"], @"Check path");
}


- (void) testRestaurantList
{
    NSString *json = @"[{\"id\":1,\"name\":\"Sumika\",\"website\":\"http://sumikagrill.com/\",\"url\":\"/restaurants/1\"}]";
    CBNetworkClient *client = [CBNetworkClient sharedNetworkClient];
    NSArray *ls = [client parseJSONList:json];
    STAssertNotNil(ls, @"should have one");
 
    
    STAssertNotNil([ls objectAtIndex:0], @"Should have something at least");
    STAssertTrue([[ls objectAtIndex:0] isKindOfClass:[NSDictionary class]], @"Should contain an NSDictionary");
    NSDictionary *record = [ls objectAtIndex:0];
    STAssertEqualObjects([record valueForKey:@"name"], @"Sumika", @"restaurant name");
 
}


@end
