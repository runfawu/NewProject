//
//  TradeObject.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-17.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeObject : NSObject

/*

  = null;
  = 100038;
  = "\U6b27\U98de\U624b\U673a\U5145\U503c";
  = 1;
  = 20140917;
  = 100929;
  = 73;
  = "30\U5143";
  = 20140917100038000010;
  =
  = 30;
  = 30;
  = 1;
  = "\U7b49\U5f85\U4ed8\U6b3e";
 "" = system;
 "" = 1002013;
 "" = 13762272987;
 "" = null;
  = 30;
 */

@property (nonatomic, strong) NSString *addamt;
@property (nonatomic, strong) NSString *areacode;
@property (nonatomic, strong) NSString *areaname;
@property (nonatomic, strong) NSString *batchno;
@property (nonatomic, strong) NSString *busicode;
@property (nonatomic, strong) NSString *businame;
@property (nonatomic, strong) NSString *buycount;
@property (nonatomic, strong) NSString *createdate;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *goodsid;
@property (nonatomic, strong) NSString *goodsname;
@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSString *paylinkurl;
@property (nonatomic, strong) NSString *planprice;
@property (nonatomic, strong) NSString *realprice;
@property (nonatomic, strong) NSString *statuscode;
@property (nonatomic, strong) NSString *statusname;
@property (nonatomic, strong) NSString *supp_accname;
@property (nonatomic, strong) NSString *supp_accno;
@property (nonatomic, strong) NSString *third_userid;
@property (nonatomic, strong) NSString *third_username;
@property (nonatomic, strong) NSString *totalamt;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
