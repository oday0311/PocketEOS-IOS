//
//  GetTransactionRecordsRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetTransactionRecordsRequest : BaseNetworkRequest

@property(nonatomic , strong) NSMutableArray *symbols;

@property(nonatomic, copy) NSString *from;

@property(nonatomic, copy) NSString *to;

@property(nonatomic, copy) NSNumber *page;

@property(nonatomic, copy) NSNumber *pageSize;

@end
