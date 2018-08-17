//
//  SortTool.m
//  Valhalla
//
//  Created by mademao on 2018/8/17.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "SortTool.h"

void Swap(int a[], int i, int j);


#pragma mark - 冒泡

// 最差时间复杂度 ---- O(n^2)
// 最优时间复杂度 ---- 如果能在内部循环第一次运行时,使用一个旗标来表示有无需要交换的可能,可以把最优时间复杂度降低到O(n)
// 平均时间复杂度 ---- O(n^2)
// 所需辅助空间 ------ O(1)
// 稳定性 ------------ 稳定
void BubbleSort(int a[], int count) {
    for (int i = 0; i < count - 1; i++) {
        for (int j = 0; j < count - 1 - i; j++) {
            if (a[j] > a[j + 1]) {
                a[j] = a[j] ^ a[j + 1];
                a[j + 1] = a[j] ^ a[j + 1];
                a[j] = a[j] ^ a[j + 1];
            }
        }
    }
}


#pragma mark - 鸡尾酒冒泡

// 最差时间复杂度 ---- O(n^2)
// 最优时间复杂度 ---- 如果序列在一开始已经大部分排序过的话,会接近O(n)
// 平均时间复杂度 ---- O(n^2)
// 所需辅助空间 ------ O(1)
// 稳定性 ------------ 稳定
void CocktailSort(int a[], int count) {
    int left = 0;
    int right = count - 1;
    while (left < right) {
        for (int i = left; i < right; i++) {
            if (a[i] > a[i + 1]) {
                a[i] = a[i] ^ a[i + 1];
                a[i + 1] = a[i] ^ a[i + 1];
                a[i] = a[i] ^ a[i + 1];
            }
        }
        right--;
        for (int i = right; i > left; i--) {
            if (a[i - 1] > a[i]) {
                a[i - 1] = a[i - 1] ^ a[i];
                a[i] = a[i - 1] ^ a[i];
                a[i - 1] = a[i - 1] ^ a[i];
            }
        }
        left++;
    }
}


#pragma mark - 选择排序

// 最差时间复杂度 ---- O(n^2)
// 最优时间复杂度 ---- O(n^2)
// 平均时间复杂度 ---- O(n^2)
// 所需辅助空间 ------ O(1)
// 稳定性 ------------ 不稳定
void SelectionSort(int a[], int count) {
    for (int i = 0; i < count - 1; i++) {
        int min = i;
        for (int j = i + 1; j < count; j++) {
            if (a[j] < a[min]) {
                min = j;
            }
        }
        if (min != i) {
            a[i] = a[i] ^ a[min];
            a[min] = a[i] ^ a[min];
            a[i] = a[i] ^ a[min];
        }
    }
}


#pragma mark - 插入排序

// 最差时间复杂度 ---- 最坏情况为输入序列是降序排列的,此时时间复杂度O(n^2)
// 最优时间复杂度 ---- 最好情况为输入序列是升序排列的,此时时间复杂度O(n)
// 平均时间复杂度 ---- O(n^2)
// 所需辅助空间 ------ O(1)
// 稳定性 ------------ 稳定
void InsertionSort(int a[], int count) {
    for (int i = 1; i < count; i++) {
        int get = a[i];
        int j = i - 1;
        while (j >= 0 && a[j] > get) {
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = get;
    }
}


#pragma mark - 二分插入排序

// 最差时间复杂度 ---- O(n^2)
// 最优时间复杂度 ---- O(nlogn)
// 平均时间复杂度 ---- O(n^2)
// 所需辅助空间 ------ O(1)
// 稳定性 ------------ 稳定
void InsertionSortDichotomy(int a[], int count) {
    for (int i = 1; i < count; i++) {
        int get = a[i];
        int left = 0;
        int right = i - 1;
        while (left <= right) {
            int mid = (left + right) / 2.0;
            if (a[mid] > get) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        for (int j = i - 1; j >= left; j--) {
            a[j + 1] = a[j];
        }
        a[left] = get;
    }
}


#pragma mark - 希尔排序

// 最差时间复杂度 ---- 根据步长序列的不同而不同。已知最好的为O(n(logn)^2)
// 最优时间复杂度 ---- O(n)
// 平均时间复杂度 ---- 根据步长序列的不同而不同。
// 所需辅助空间 ------ O(1)
// 稳定性 ------------ 不稳定
void ShellSort(int a[], int count) {
    int gap = count / 2;
    while (gap >= 1) {
        for (int i = gap; i < count; i++) {
            int get = a[i];
            int j = i - gap;
            while (j >= 0 && a[j] > get) {
                a[j + gap] = a[j];
                j -= gap;
            }
            a[j + gap] = get;
        }
        gap /= 2;
    }
}


#pragma mark - 归并排序

// 最差时间复杂度 ---- O(nlogn)
// 最优时间复杂度 ---- O(nlogn)
// 平均时间复杂度 ---- O(nlogn)
// 所需辅助空间 ------ O(n)
// 稳定性 ------------ 稳定
void Merge(int a[], int left, int mid, int right) {
    int len = right - left + 1;
    int temp[len];
    int index = 0;
    int i = left;
    int j = mid + 1;
    
    while (i <= mid && j <= right) {
        temp[index++] = a[i] <= a[j] ? a[i++] : a[j++];
    }
    while (i <= mid) {
        temp[index++] = a[i++];
    }
    while (j <= right) {
        temp[index++] = a[j++];
    }
    for (int k = 0; k < len; k++) {
        a[left++] = temp[k];
    }
}

void MergeSortRecursion(int a[], int left, int right) {
    if (left == right) {
        return;
    }
    int mid = (left + right) / 2;
    MergeSortRecursion(a, left, mid);
    MergeSortRecursion(a, mid + 1, right);
    Merge(a, left, mid, right);
}

void MergeSortIteration(int a[], int count) {
    int left, mid, right;
    for (int i = 1; i < count; i *= 2) {
        left = 0;
        while (left + i < count) {
            mid = left + i - 1;
            right = mid + i < count ? mid + i : count - 1;
            Merge(a, left, mid, right);
            left = right + 1;
        }
    }
}


#pragma mark - 堆排序

// 最差时间复杂度 ---- O(nlogn)
// 最优时间复杂度 ---- O(nlogn)
// 平均时间复杂度 ---- O(nlogn)
// 所需辅助空间 ------ O(1)
// 稳定性 ------------ 不稳定
void Heapify(int a[], int i, int size) {
    int left_child = 2 * i + 1;
    int right_child = 2 * i + 2;
    int max = i;
    if (left_child < size && a[left_child] > a[max]) {
        max = left_child;
    }
    if (right_child < size && a[right_child] > a[max]) {
        max = right_child;
    }
    if (max != i) {
        Swap(a, max, i);
        Heapify(a, max, size);
    }
}

int BuildHeap(int a[], int count) {
    int heap_size = count;
    for (int i = heap_size / 2 - 1; i >= 0; i--) {
        Heapify(a, i, heap_size);
    }
    return heap_size;
}

void HeapSort(int a[], int count) {
    int heap_size = BuildHeap(a, count);
    while (heap_size > 1) {
        Swap(a, 0, --heap_size);
        Heapify(a, 0, heap_size);
    }
}


#pragma mark - 快速排序

int Partition(int a[], int left, int right) {
    int p = a[left];
    while (left < right) {
        while (left < right && a[right] >= p) {
            right--;
        }
        Swap(a, left, right);
        while (left < right && a[left] <= p) {
            left++;
        }
        Swap(a, left, right);
    }
    return left;
}

void QuickSort(int a[], int left, int right) {
    if (left >= right) {
        return;
    }
    int index = Partition(a, left, right);
    QuickSort(a, left, index - 1);
    QuickSort(a, index + 1, right);
}


#pragma mark - 交换

void Swap(int a[], int i, int j) {
    if (i == j) {
        return;
    }
    a[i] = a[i] ^ a[j];
    a[j] = a[i] ^ a[j];
    a[i] = a[i] ^ a[j];
}
