; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s | FileCheck %s

; This is an overloaded struct return, we should not try to update it to an
; anonymous struct return.

%ty = type { i32 }

define %ty @test(%ty %arg) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[COPY:%.*]] = call [[TY:%.*]] @llvm.ssa.copy.s_tys([[TY]] [[ARG:%.*]])
; CHECK-NEXT:    ret [[TY]] [[COPY]]
;
  %copy = call %ty @llvm.ssa.copy.s_tys(%ty %arg)
  ret %ty %copy
}

define %ty @test_not_real_intrinsic() {
; CHECK-LABEL: @test_not_real_intrinsic(
; CHECK-NEXT:    [[RET:%.*]] = call [[TY:%.*]] @llvm.dummy()
; CHECK-NEXT:    ret [[TY]] [[RET]]
;
  %ret = call %ty @llvm.dummy()
  ret %ty %ret
}

declare %ty @llvm.dummy()

declare %ty @llvm.ssa.copy.s_tys(%ty)
