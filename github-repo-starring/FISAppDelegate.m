//
//  FISAppDelegate.m
//  github-repo-starring
//
//  Created by Joe Burgess on 5/12/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISAppDelegate.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import <AFNetworking/AFNetworking.h>
#import "FISConstants.h"

@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(NSString *)firstValueForQueryItemNamed:(NSString *)name inURL:(NSURL *)url
{
    NSURLComponents *urlComps = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:nil];
    NSArray *queryItems = urlComps.queryItems;
    
    for(NSURLQueryItem *queryItem in queryItems) {
        if([queryItem.name isEqualToString:name]) {
            return queryItem.value;
        }
    }
    return nil;
}



-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    NSLog(@"We were opened because someone went to %@", url);

    NSString * code = [self firstValueForQueryItemNamed:@"code" inURL:url];
    NSURL * baseURL = [NSURL URLWithString:@"https://github.com/"];
    
    AFOAuth2Manager * oauth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL clientID:GITHUB_CLIENT_ID secret:GITHUB_CLIENT_SECRET];
    oauth2Manager.useHTTPBasicAuthentication = NO;
    [oauth2Manager authenticateUsingOAuthWithURLString:@"/login/oauth/access_token" code:code redirectURI:@"" success:^(AFOAuthCredential *credential) {
        [AFOAuthCredential storeCredential:credential withIdentifier:@"githubauth"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginComplete" object:nil];

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    return YES;
}

@end
