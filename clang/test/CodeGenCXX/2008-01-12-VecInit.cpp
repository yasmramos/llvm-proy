// RUN: %clang_cc1 -emit-llvm %s -o -
// 
typedef int __attribute__((vector_size(16))) v;
v vt = {1, 2, 3, 4};
