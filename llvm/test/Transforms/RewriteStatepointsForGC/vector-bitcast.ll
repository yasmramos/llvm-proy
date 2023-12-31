; RUN: opt -S -passes=rewrite-statepoints-for-gc < %s | FileCheck %s
;
; A test to make sure that we can look through bitcasts of
; vector types when a base pointer is contained in a vector.

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"
target triple = "x86_64-unknown-linux-gnu"

declare ptr addrspace(1) @foo()

; Function Attrs: uwtable
define i32 @test() gc "statepoint-example" {
; CHECK-LABEL: @test
entry:
; CHECK-LABEL: entry
; CHECK: %bc = bitcast
; CHECK: %[[p1:[A-Za-z0-9_.]+]] = extractelement
; CHECK: %[[p2:[A-Za-z0-9_]+]] = extractelement
; CHECK: llvm.experimental.gc.statepoint
; CHECK: %[[p2]].relocated = {{.+}} @llvm.experimental.gc.relocate
; CHECK: %[[p1]].relocated = {{.+}} @llvm.experimental.gc.relocate
; CHECK: load atomic
  %bc = bitcast <8 x ptr addrspace(1)> undef to <8 x ptr addrspace(1)>
  %ptr= extractelement <8 x ptr addrspace(1)> %bc, i32 7
  %0 = call ptr addrspace(1) @foo() [ "deopt"() ]
  %1 = load atomic i32, ptr addrspace(1) %ptr unordered, align 4
  ret i32 %1
}
