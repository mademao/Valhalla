//
//  SortTool.h
//  Valhalla
//
//  Created by mademao on 2018/8/17.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 https://www.cnblogs.com/eniac12/p/5329396.html
 */

void BubbleSort(int a[], int count);
void CocktailSort(int a[], int count);
void SelectionSort(int a[], int count);
void InsertionSort(int a[], int count);
void InsertionSortDichotomy(int a[], int count);
void ShellSort(int a[], int count);
void MergeSortRecursion(int a[], int left, int right);
void MergeSortIteration(int a[], int count);
void HeapSort(int a[], int count);
void QuickSort(int a[], int left, int right);
