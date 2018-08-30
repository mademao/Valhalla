//
//  Player.h
//  FormTableView
//
//  Created by 马德茂 on 16/5/26.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
/**
 *  选手名称
 */
@property (nonatomic, copy) NSString *playername;
/**
 *  局数
 */
@property (nonatomic, strong) NSNumber *appearedtimes;
/**
 *  kda
 */
@property (nonatomic, strong) NSNumber *kda;
/**
 *  参团率
 */
@property (nonatomic, strong) NSNumber *killsparticipant;
/**
 *  场均击杀
 */
@property (nonatomic, strong) NSNumber *killspermatch;
/**
 *  单场最高击杀
 */
@property (nonatomic, strong) NSNumber *highestkills;
/**
 *  场均死亡
 */
@property (nonatomic, strong) NSNumber *deathspermatch;
/**
 *  单场最高死亡
 */
@property (nonatomic, strong) NSNumber *highestdeaths;
/**
 *  场均助攻
 */
@property (nonatomic, strong) NSNumber *assistspermatch;
/**
 *  单场最高助攻
 */
@property (nonatomic, strong) NSNumber *highestassists;
/**
 *  GPM
 */
@property (nonatomic, strong) NSNumber *goldpermin;
/**
 *  CSPM
 */
@property (nonatomic, strong) NSNumber *lasthitpermin;
/**
 *  每分钟输出
 */
@property (nonatomic, strong) NSNumber *damagetoheropermin;
/**
 *  输出占比
 */
@property (nonatomic, strong) NSNumber *damagetoheropercentage;
/**
 *  每分钟承受伤害
 */
@property (nonatomic, strong) NSNumber *damagetakenpermin;
/**
 *  承受伤害占比
 */
@property (nonatomic, strong) NSNumber *damagetakenpercentage;
/**
 *  每分钟排眼数
 */
@property (nonatomic, strong) NSNumber *wardskilledpermin;

@end
