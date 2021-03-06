//
//  iOSDevWeeklyTests.m
//  iOSDevWeeklyTests
//
//  Created by Colin Günther on 08.08.12.
//  Copyright (c) 2012 Cogun. All rights reserved.
//


#import "iOSDevWeeklyTests.h"

#import "GDataXMLNode.h"

#import "COGUDevWeeklyNewsManager.h"


@implementation iOSDevWeeklyTests

- (void)setUp
{
    [super setUp];
    self.newsManager = [[COGUDevWeeklyNewsManager alloc] init];
    [self.newsManager removeDatabase];
}


- (void)tearDown
{
    [super tearDown];
    self.newsManager = nil;
}


- (void)testFetchingAllWeeklyNewsIssues;
{
    dispatch_semaphore_t testCompleted = dispatch_semaphore_create(0);

    [self.newsManager fetchAllIssuesSuccessHandler:^(id context){
        STAssertNotNil(context, nil);
        dispatch_semaphore_signal(testCompleted);
    } failureHandler:^(NSError *error) {
        STFail(@"Failed to fetch all issues (error: %@)", error);
        dispatch_semaphore_signal(testCompleted);
    }];

    while (dispatch_semaphore_wait(testCompleted, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    dispatch_release(testCompleted);
}


- (void)testAddingIssueToDatabase;
{
    dispatch_semaphore_t testCompleted = dispatch_semaphore_create(0);
    
    [self.newsManager fetchAllIssuesSuccessHandler:^(NSArray* devWeeklyDocuments){
        STAssertNotNil(devWeeklyDocuments, nil);
        GDataXMLDocument* arbitraryIssue = [devWeeklyDocuments lastObject];
        NSError* addingIssueError = nil;
        BOOL addingToDatabaseSucceeded = [self.newsManager addIssueToDatabase:arbitraryIssue error:&addingIssueError];
        STAssertTrue(addingToDatabaseSucceeded, nil);
        STAssertNil(addingIssueError, @"Failed to add arbitrary issue to database (error: %@)", addingIssueError);
        NSError* countingError = nil;
        NSNumber* numberOfIssuesInDatabase = [self.newsManager numberOfIssuesInDatabaseError:&countingError];
        STAssertEqualObjects(numberOfIssuesInDatabase, @1, nil);
        STAssertNil(countingError, @"Failed to count the issues in the database (error: %@)", countingError);
        dispatch_semaphore_signal(testCompleted);
    } failureHandler:^(NSError *error) {
        STFail(@"Failed to fetch all issues (error: %@)", error);
        dispatch_semaphore_signal(testCompleted);
    }];
    
    while (dispatch_semaphore_wait(testCompleted, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    dispatch_release(testCompleted);
}


- (void)testPrefillingDatabase;
{
    dispatch_semaphore_t testCompleted = dispatch_semaphore_create(0);

    [self.newsManager prefillIssuesDatabaseIfEmptySuccessHandler:^(NSNumber* issuesCount) {
        STAssertNotNil(issuesCount, nil);        
        NSError* countingError = nil;
        NSNumber* numberOfIssuesInDatabase = [self.newsManager numberOfIssuesInDatabaseError:&countingError];
        STAssertEqualObjects(numberOfIssuesInDatabase, issuesCount, nil);
        STAssertNil(countingError, @"Failed to count the issues in the database (error: %@)", countingError);
        dispatch_semaphore_signal(testCompleted);
    } failureHandler:^(NSError *error) {
        STFail(@"Failed to prefill database (error: %@)", error);
        dispatch_semaphore_signal(testCompleted);
    }];

    while (dispatch_semaphore_wait(testCompleted, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }

    dispatch_release(testCompleted);
}

@end
