// This test checks that the ifuncs works after bolt.
// Compiling with 00 results in IFUNC indirect calling.

// RUN: %clang %cflags -O0 -no-pie %s -fuse-ld=lld \
// RUN:    -o %t.exe -Wl,-q
// RUN: llvm-bolt %t.exe -o %t.bolt.exe --use-old-text=0 --lite=0
// RUN: %t.bolt.exe  | FileCheck %s

// RUN: %clang %cflags -O3 -no-pie %s -fuse-ld=lld \
// RUN:    -o %t.O3.exe -Wl,-q
// RUN: llvm-bolt %t.O3.exe -o %t.O3.bolt.exe --use-old-text=0 --lite=0
// RUN: %t.O3.bolt.exe  | FileCheck %s

// CHECK: foo

#include <stdio.h>
#include <string.h>

static void foo() { printf("foo\n"); }

static void *resolver_foo(void) { return foo; }

__attribute__((ifunc("resolver_foo"))) void ifoo();

static void *resolver_memcpy(void) { return memcpy; }

__attribute__((ifunc("resolver_memcpy"))) void *
imemcpy(void *dest, const void *src, size_t n);

int main() {
  int a = 0xdeadbeef, b = 0;
  imemcpy(&b, &a, sizeof(b));
  if (a != b)
    return -1;

  ifoo();
}
