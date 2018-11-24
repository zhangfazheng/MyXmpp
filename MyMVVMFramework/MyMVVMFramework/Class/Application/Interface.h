//
//  Interface.h
//  MyFramework
//
//  Created by 张发政 on 2017/1/6.
//  Copyright © 2017年 zhangfazheng. All rights reserved.
//

#ifndef Interface_h
#define Interface_h


/**完整url*/
//http://apis.baidu.com/apistore/idservice/id
//#define BaseURL @"http://192.168.1.76:8080/CyberplusOA"
//#define BaseURL @"http://192.168.1.76:8080"
#define BaseURL @"http://124.127.86.251:8080/CyberplusOA"

#define PhoneLogin  @"public/login.do"
#define PhoneRegister  @"public/register.do"
#define GetAllDepartments  @"dept/getAllDepts.do"
#define GetMyDepartments  @"dept/getDeptAndUser.do"
#define QueryUserByFullName  @"user/getUserByRealName.do"

//根据参数分页查询用户
#define GetUserPageResult  @"user/getUserPageResult.do"
//获取用户权限内的所有应用
#define GetOnlineUserApp  @"app/getClientOnlineUserApp.do"
//获取某用户权限更新时间戳
#define GetUserAuthorityUpdateTime  @"user/getUserAuthorityUpdateTime.do"



// 获取Launch载入图
#define startPage @"http://baobab.wandoujia.com/api/v1/configs?model=iPhone%206%20Plus&version=362&vc=1604&t=MjAxNjExMjYxNjUzMzMzMDQsNzQ5Ng%3D%3D&u=f36990f193fd8fcefb66969d2ba6043eae73bb9a&net=wifi&v=2.9.0&f=iphone"

#endif /* Interface_h */

