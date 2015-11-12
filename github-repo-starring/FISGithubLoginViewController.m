//
//  FISGithubLoginViewController.m
//  github-repo-starring
//
//  Created by Guang on 11/11/15.
//  Copyright © 2015 Joe Burgess. All rights reserved.
//

#import "FISGithubLoginViewController.h"
#import "FISConstants.h"

#import <AFNetworking/AFNetworking.h>
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>

@interface FISGithubLoginViewController ()

@end

@implementation FISGithubLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:@"LoginComplete" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginComplete:(NSNotification *)notification
{
    AFOAuthCredential * credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubauth"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
    [manager GET:@"" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary * userinfo = responseObject;
        NSLog(@"%@",userinfo[@"name"]);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@",error);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)logInAction:(id)sender
{ /*
    // need to redirect user to the github login page
    NSMutableString *urlString = [@"https://github.com/login/oauth/authorize?client_id=" mutableCopy];
    [urlString appendString:@"fbfb11ed462f0be0f462"];
    //    [urlString appendString:@"&redirect_uri=my-github-app://oauth"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    */
    NSString * redirectUrl = @"beluga-guang://oauth";
    NSString * urlString = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@",GITHUB_CLIENT_ID,redirectUrl];
    NSURL * url = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url];
}



@end
