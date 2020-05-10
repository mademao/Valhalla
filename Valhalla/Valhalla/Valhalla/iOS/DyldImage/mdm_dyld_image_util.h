//
//  mdm_dyld_image_util.h
//  Valhalla
//
//  Created by mademao on 2020/5/10.
//  Copyright © 2020 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mach/vm_types.h>
#import <dlfcn.h>

#pragma mark - mdm_dyld_image_item

typedef struct _mdm_dyld_image_item_ {
    const char *name;           //image 名称
    const char *path;           //image 路径
    const char *uuid;           //image uuid
    uint64_t headerAddr;        //运行时header地址
    uint64_t imageBeginAddr;    //运行时image起始地址，理论上与headerAddr相同
    uint64_t imageEndAddr;      //运行时image结束地址，值等于 imageBeginAddr + imageVMSize
    uint64_t imageVMAddr;       //image真实起始地址，根据不同架构有不同值。imageVMAddr + imageSlide = headerAddr
    uint64_t imageVMSize;       //image在内存中占用大小
    uint64_t imageSlide;        //ASLR为image提供的偏移量
    uint64_t linkeditBase;      //linkeditBase地址
    uint64_t symtabAddr;        //LC_SYMTAB起始地址
} mdm_dyld_image_item;

#pragma mark - mdm_sys_dyld_image_info

typedef struct _mdm_sys_dyld_image_info_ {
    vm_address_t addr_begin;
    vm_address_t addr_end;
    struct _mdm_sys_dyld_image_info_ *prev;
} mdm_sys_dyld_image_info;

#pragma mark - mdm_dyld_image_info

typedef struct _mdm_dyld_image_info_ {
    mdm_dyld_image_item *allImageInfo;
    uint32_t imageInfoCount;
    
    vm_address_t images_begin;
    vm_address_t images_end;
    mdm_sys_dyld_image_info *sys_dyld_image_info;
} mdm_dyld_image_info;


#pragma mark - C method

extern mdm_dyld_image_info * mdm_current_dyld_image_info;

void mdm_dyld_load_current_dyld_image_info();

void mdm_dyld_clear_current_dyld_image_info();

void mdm_dyld_print_info(mdm_dyld_image_info *dyld_image_info);

bool mdm_dyld_check_in_sys_libraries(mdm_dyld_image_info *dyld_image_info, vm_address_t address);

bool mdm_dyld_check_in_all_Libraries(mdm_dyld_image_info *dyld_image_info, vm_address_t address);

bool mdm_dyld_get_DLInfo(mdm_dyld_image_info *dyld_image_info, vm_address_t addr, Dl_info *const info);

bool mdm_dyld_get_addr_offset(mdm_dyld_image_info *dyld_image_info, vm_address_t addr, vm_address_t *addrOffset, NSString **uuid);
