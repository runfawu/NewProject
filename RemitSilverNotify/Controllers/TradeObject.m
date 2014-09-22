//
//  TradeObject.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-17.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "TradeObject.h"

@implementation TradeObject

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.addamt = [NSString stringWithFormat:@"%@", dict[@"addamt"]];
        self.areacode = dict[@"areacode"];
        self.areaname = dict[@"areaname"];
        self.batchno = dict[@"batchno"];
        self.busicode = dict[@"busicode"];
        self.businame = dict[@"businame"];
        self.buycount = [NSString stringWithFormat:@"%@", dict[@"buycount"]];
        self.createdate = dict[@"createdate"];
        self.createtime = dict[@"createtime"];
        self.goodsid = dict[@"goodsid"];
        self.goodsname = dict[@"goodsname"];
        self.orderid = dict[@"orderid"];
        self.paylinkurl = dict[@"paylinkurl"];
        self.planprice = [NSString stringWithFormat:@"%@", dict[@"planprice"]];
        self.realprice = [NSString stringWithFormat:@"%@", dict[@"realprice"]];
        self.statuscode = dict[@"statuscode"];
        self.statusname = dict[@"statusname"];
        self.supp_accname = dict[@"supp_accname"];
        self.supp_accno = dict[@"supp_accno"];
        self.third_userid = dict[@"third_userid"];
        self.third_username = dict[@"third_username"];
        self.totalamt = dict[@"totalamt"];
    }
    return self;
}

@end
