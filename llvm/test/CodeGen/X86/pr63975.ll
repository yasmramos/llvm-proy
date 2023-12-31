; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s

@g = external dso_local local_unnamed_addr global i16, align 2
@l = external dso_local local_unnamed_addr global [1 x i16], align 2

define void @PR63975() {
; CHECK-LABEL: PR63975:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movw $4, g(%rip)
; CHECK-NEXT:    movw $0, l(%rip)
; CHECK-NEXT:    retq
entry:
  store i16 4, ptr @g, align 2
  %i = load i16, ptr @g, align 2
  %broadcast.splatinsert7 = insertelement <8 x i16> poison, i16 %i, i64 0
  %broadcast.splat8 = shufflevector <8 x i16> %broadcast.splatinsert7, <8 x i16> poison, <8 x i32> zeroinitializer
  %i1 = and <8 x i16> %broadcast.splat8, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %i2 = or <8 x i16> %i1, <i16 246, i16 246, i16 246, i16 246, i16 246, i16 246, i16 246, i16 246>
  %i3 = and <8 x i16> %broadcast.splat8, <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  %i4 = add nuw nsw <8 x i16> %i2, %i3
  %i5 = icmp ne <8 x i16> %i4, <i16 250, i16 250, i16 250, i16 250, i16 250, i16 250, i16 250, i16 250>
  %i6 = zext <8 x i1> %i5 to <8 x i16>
  %i7 = zext <8 x i1> %i5 to <8 x i16>
  %i8 = add nuw nsw <8 x i16> %i7, %i6
  %i9 = extractelement <8 x i16> %i8, i64 2
  store i16 %i9, ptr @l, align 2
  ret void
}
