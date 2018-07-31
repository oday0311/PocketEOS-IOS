//
//  TransactionRecordsService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "TransactionRecordsService.h"
#import "TransactionRecord.h"
#import "TransactionRecordsResult.h"
#import "TransactionsResult.h"

@interface TransactionRecordsService()
@property(nonatomic, strong) NSMutableArray *eosTransactionResponseArray;
@property(nonatomic, strong) NSMutableArray *octTransactionResponseArray;
@property(nonatomic, strong) NSMutableArray *assestsTransactionResponseArray;
@property(nonatomic, strong) NSMutableArray *redPacketTransactionResponseArray;
@property(nonatomic, strong) NSMutableArray *sendTransactionResponseArray;
@property(nonatomic, strong) NSMutableArray *recieveTransactionResponseArray;
@property(nonatomic , assign) NSUInteger page;
@end


@implementation TransactionRecordsService
- (GetTransactionRecordsRequest *)getTransactionRecordsRequest{
    if (!_getTransactionRecordsRequest) {
        _getTransactionRecordsRequest = [[GetTransactionRecordsRequest alloc] init];
    }
    return _getTransactionRecordsRequest;
}

- (NSMutableArray *)eosTransactionDatasourceArray{
    if (!_eosTransactionDatasourceArray) {
        _eosTransactionDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _eosTransactionDatasourceArray;
}

- (NSMutableArray *)octTransactionDatasourceArray{
    if (!_octTransactionDatasourceArray) {
        _octTransactionDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _octTransactionDatasourceArray;
}

- (NSMutableArray *)assestsTransactionDatasourceArray{
    if (!_assestsTransactionDatasourceArray) {
        _assestsTransactionDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _assestsTransactionDatasourceArray;
}

- (NSMutableArray *)redPacketDatasourceArray{
    if (!_redPacketDatasourceArray) {
        _redPacketDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _redPacketDatasourceArray;
}
- (NSMutableArray *)sendTransactionDatasourceArray{
    if (!_sendTransactionDatasourceArray) {
        _sendTransactionDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _sendTransactionDatasourceArray;
}

- (NSMutableArray *)recieveTransactionDatasourceArray{
    if (!_recieveTransactionDatasourceArray) {
        _recieveTransactionDatasourceArray = [[NSMutableArray alloc] init];
    }
    return _recieveTransactionDatasourceArray;
}

- (NSMutableArray *)eosTransactionResponseArray{
    if (!_eosTransactionResponseArray) {
        _eosTransactionResponseArray = [[NSMutableArray alloc] init];
    }
    return _eosTransactionResponseArray;
}

- (NSMutableArray *)octTransactionResponseArray{
    if (!_octTransactionResponseArray) {
        _octTransactionResponseArray = [[NSMutableArray alloc] init];
    }
    return _octTransactionResponseArray;
}

- (NSMutableArray *)assestsTransactionResponseArray{
    if (!_assestsTransactionResponseArray) {
        _assestsTransactionResponseArray = [[NSMutableArray alloc] init];
    }
    return _assestsTransactionResponseArray;
}

- (NSMutableArray *)redPacketTransactionResponseArray{
    if (!_redPacketTransactionResponseArray) {
        _redPacketTransactionResponseArray = [[NSMutableArray alloc] init];
    }
    return _redPacketTransactionResponseArray;
}

- (NSMutableArray *)sendTransactionResponseArray{
    if (!_sendTransactionResponseArray) {
        _sendTransactionResponseArray = [[NSMutableArray alloc] init];
    }
    return _sendTransactionResponseArray;
}

- (NSMutableArray *)recieveTransactionResponseArray{
    if (!_recieveTransactionResponseArray) {
        _recieveTransactionResponseArray = [[NSMutableArray alloc] init];
    }
    return _recieveTransactionResponseArray;
}

- (void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    _page = 0;
    self.getTransactionRecordsRequest.page = @(_page);
    self.getTransactionRecordsRequest.pageSize = @(PER_PAGE_SIZE_10);
    [self.getTransactionRecordsRequest postOuterDataSuccess:^(id DAO, id data) {
        
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        [weakSelf.eosTransactionResponseArray removeAllObjects];
        [weakSelf.eosTransactionDatasourceArray removeAllObjects];
        [weakSelf.octTransactionResponseArray removeAllObjects];
        [weakSelf.octTransactionDatasourceArray removeAllObjects];
        [weakSelf.assestsTransactionResponseArray removeAllObjects];
        [weakSelf.assestsTransactionDatasourceArray removeAllObjects];
        [weakSelf.redPacketTransactionResponseArray removeAllObjects];
        [weakSelf.redPacketDatasourceArray removeAllObjects];
        [weakSelf.sendTransactionResponseArray removeAllObjects];
        [weakSelf.sendTransactionDatasourceArray removeAllObjects];
        [weakSelf.recieveTransactionDatasourceArray removeAllObjects];
        [weakSelf.recieveTransactionResponseArray removeAllObjects];

        TransactionRecordsResult *result = [TransactionRecordsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.msg)];
        }else{
            TransactionsResult *transactionsResult = [TransactionsResult mj_objectWithKeyValues:result.data];
            for (TransactionRecord *record in transactionsResult.actions) {
                if ([record.quantity containsString:@" "]) {
                    NSArray*quantityArr = [record.quantity componentsSeparatedByString:@" "];
                    record.amount  = quantityArr[0];
                    record.assestsType = quantityArr[1];
                }

                //transfer
                if ([record.transactionType isEqualToString:@"transfer"]) {
                    [weakSelf.responseArray addObject:record];
                    if ([record.assestsType isEqualToString:@"EOS"]){
                        [weakSelf.eosTransactionResponseArray addObject:record];
                    }else if ([record.assestsType isEqualToString:@"OCT"]){
                        [weakSelf.octTransactionResponseArray addObject:record];
                    }
                    [weakSelf.assestsTransactionResponseArray addObject:record];
                    // redpacket
                    if ([record.from isEqualToString:RedPacketReciever] || [record.to isEqualToString:RedPacketReciever]) {
                        [weakSelf.redPacketTransactionResponseArray addObject:record];
                    }

                    // send
                    if ([record.from isEqualToString:self.getTransactionRecordsRequest.from]) {
                         [weakSelf.sendTransactionResponseArray addObject:record];
                    }

                    // recieve
                    if ([record.to isEqualToString:self.getTransactionRecordsRequest.to]) {
                         [weakSelf.recieveTransactionResponseArray addObject:record];
                    }
                }
            }
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
            weakSelf.eosTransactionDatasourceArray = [NSMutableArray arrayWithArray:weakSelf.eosTransactionResponseArray];
            weakSelf.octTransactionDatasourceArray = [NSMutableArray arrayWithArray:weakSelf.octTransactionResponseArray];
            weakSelf.assestsTransactionDatasourceArray = [NSMutableArray arrayWithArray:weakSelf.assestsTransactionResponseArray];
            weakSelf.redPacketDatasourceArray = [NSMutableArray arrayWithArray:weakSelf.redPacketTransactionResponseArray];
            weakSelf.sendTransactionDatasourceArray = [NSMutableArray arrayWithArray:weakSelf.sendTransactionResponseArray];
            weakSelf.recieveTransactionDatasourceArray = [NSMutableArray arrayWithArray:weakSelf.recieveTransactionResponseArray];

        }
        complete(@(weakSelf.dataSourceArray.count) , YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}
//
- (void)buildNextPageDataSource:(CompleteBlock)complete{
    
    WS(weakSelf);
    _page +=1;
    self.getTransactionRecordsRequest.page = @(_page);
    self.getTransactionRecordsRequest.pageSize = @(PER_PAGE_SIZE_10);
    [self.getTransactionRecordsRequest postOuterDataSuccess:^(id DAO, id data) {
        
        [weakSelf.responseArray removeAllObjects];
        [weakSelf.eosTransactionResponseArray removeAllObjects];
        [weakSelf.octTransactionResponseArray removeAllObjects];
        [weakSelf.assestsTransactionResponseArray removeAllObjects];
        [weakSelf.sendTransactionResponseArray removeAllObjects];
        [weakSelf.recieveTransactionResponseArray removeAllObjects];
        TransactionRecordsResult *result = [TransactionRecordsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.msg)];
        }else{
            TransactionsResult *transactionsResult = [TransactionsResult mj_objectWithKeyValues:result.data];
            for (TransactionRecord *record in transactionsResult.actions) {
                if ([record.quantity containsString:@" "]) {
                    NSArray*quantityArr = [record.quantity componentsSeparatedByString:@" "];
                    record.amount  = quantityArr[0];
                    record.assestsType = quantityArr[1];
                }

                if ([record.transactionType isEqualToString:@"transfer"]) {
                    [weakSelf.responseArray addObject:record];
                    if ([record.assestsType isEqualToString:@"EOS"]){
                        [weakSelf.eosTransactionResponseArray addObject:record];
                    }else if ([record.assestsType isEqualToString:@"OCT"]){
                        [weakSelf.octTransactionResponseArray addObject:record];
                    }
                    [weakSelf.assestsTransactionResponseArray addObject:record];

                    // send
                    if ([record.from isEqualToString:weakSelf.getTransactionRecordsRequest.from]) {
                        [weakSelf.sendTransactionResponseArray addObject:record];
                    }

                    // recieve
                    if ([record.to isEqualToString:weakSelf.getTransactionRecordsRequest.from]) {
                        [weakSelf.recieveTransactionResponseArray addObject:record];
                    }

                }
            }

            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
            [weakSelf.eosTransactionDatasourceArray addObjectsFromArray:weakSelf.eosTransactionResponseArray];
            [weakSelf.octTransactionDatasourceArray addObjectsFromArray:weakSelf.octTransactionResponseArray];
            [weakSelf.assestsTransactionDatasourceArray addObjectsFromArray:weakSelf.assestsTransactionResponseArray];
            [weakSelf.sendTransactionDatasourceArray addObjectsFromArray:weakSelf.sendTransactionResponseArray];
            [weakSelf.recieveTransactionDatasourceArray addObjectsFromArray:weakSelf.recieveTransactionResponseArray];


        }
        complete(@(weakSelf.responseArray.count) , YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}
@end
