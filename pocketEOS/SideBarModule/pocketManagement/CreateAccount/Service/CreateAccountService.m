//
//  CreateAccountService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "CreateAccountService.h"


@implementation CreateAccountService

- (CreateAccountRequest *)createAccountRequest{
    if (!_createAccountRequest) {
        _createAccountRequest = [[CreateAccountRequest alloc] init];
    }
    return _createAccountRequest;
}

- (BackupEosAccountRequest *)backupEosAccountRequest{
    if (!_backupEosAccountRequest) {
        _backupEosAccountRequest = [[BackupEosAccountRequest alloc] init];
    }
    return _backupEosAccountRequest;
}

- (CreateEOSAccountRequest *)createEOSAccountRequest{
    if (!_createEOSAccountRequest) {
        _createEOSAccountRequest = [[CreateEOSAccountRequest alloc] init];
    }
    return _createEOSAccountRequest;
}
- (void)createAccount:(CompleteBlock)complete{
    [self.createAccountRequest setShowActivityIndicator:YES];
    [self.createAccountRequest postDataSuccess:^(id DAO, id data) {
        complete(data , YES);
    } failure:^(id DAO, NSError *error) {
        NSLog(@"responseERROR:%@", [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:nil]);
    }];
}


/**
 备份账号到服务器
 */
- (void)backupAccount:(CompleteBlock)complete{
    
    [self.backupEosAccountRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            complete(data , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
    
}

- (void)createEOSAccount:(CompleteBlock)complete{
    [self.createEOSAccountRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@", data);
            complete(data , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

@end
