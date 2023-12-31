; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
;; Check the cases involving internal CFI instrumented functions where we do not expect functions to be merged.
; RUN: opt -S -passes=mergefunc < %s | FileCheck %s

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i1 @llvm.type.test(ptr, metadata) #6

define internal void @A__on_zero_sharedEv(ptr noundef nonnull align 8 dereferenceable(32) %this) {
; CHECK-LABEL: define internal void @A__on_zero_sharedEv
; CHECK-SAME: (ptr noundef nonnull align 8 dereferenceable(32) [[THIS:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[THIS_ADDR:%.*]] = alloca ptr, align 8
; CHECK-NEXT:    store ptr [[THIS]], ptr [[THIS_ADDR]], align 8
; CHECK-NEXT:    [[THIS1:%.*]] = load ptr, ptr [[THIS_ADDR]], align 8
; CHECK-NEXT:    [[VTABLE:%.*]] = load ptr, ptr [[THIS1]], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = call i1 @llvm.type.test(ptr [[VTABLE]], metadata [[META0:![0-9]+]]), !nosanitize !1
; CHECK-NEXT:    ret void
;
entry:
  %this.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  %this1 = load ptr, ptr %this.addr, align 8
  %vtable = load ptr, ptr %this1, align 8
  %0 = call i1 @llvm.type.test(ptr %vtable, metadata !11), !nosanitize !47
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define internal void @B__on_zero_sharedEv(ptr noundef nonnull align 8 dereferenceable(32) %this) {
; CHECK-LABEL: define internal void @B__on_zero_sharedEv
; CHECK-SAME: (ptr noundef nonnull align 8 dereferenceable(32) [[THIS:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[THIS_ADDR:%.*]] = alloca ptr, align 8
; CHECK-NEXT:    store ptr [[THIS]], ptr [[THIS_ADDR]], align 8
; CHECK-NEXT:    [[THIS1:%.*]] = load ptr, ptr [[THIS_ADDR]], align 8
; CHECK-NEXT:    [[VTABLE:%.*]] = load ptr, ptr [[THIS1]], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = call i1 @llvm.type.test(ptr [[VTABLE]], metadata [[META2:![0-9]+]]), !nosanitize !1
; CHECK-NEXT:    ret void
;
entry:
  %this.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  %this1 = load ptr, ptr %this.addr, align 8
  %vtable = load ptr, ptr %this1, align 8
  %0 = call i1 @llvm.type.test(ptr %vtable, metadata !22), !nosanitize !47
  ret void
}

!10 = !{i64 16, !11}
!11 = distinct !{}
!21 = !{i64 16, !22}
!22 = distinct !{}
!47 = !{}
