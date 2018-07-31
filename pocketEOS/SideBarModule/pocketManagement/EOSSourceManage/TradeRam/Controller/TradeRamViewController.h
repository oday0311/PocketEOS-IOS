//
//  TradeRamViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"
#import "AccountResult.h"
#import "Account.h"

@interface TradeRamViewController : BaseViewController
@property(nonatomic , copy) NSString *pageType;
@property(nonatomic , strong) EOSResourceResult *eosResourceResult;
@property(nonatomic , strong) AccountResult *accountResult;
@end
