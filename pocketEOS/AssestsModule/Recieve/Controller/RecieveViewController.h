//
//  RecieveViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferModel.h"

@interface RecieveViewController : BaseViewController
// 默认选择的账号
@property(nonatomic, strong) NSString *accountName;
@property(nonatomic, strong) TransferModel *transferModel;
@property(nonatomic , strong) NSMutableArray *get_token_info_service_data_array;
@end
