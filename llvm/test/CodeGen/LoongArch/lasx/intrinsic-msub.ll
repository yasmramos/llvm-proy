; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

declare <32 x i8> @llvm.loongarch.lasx.xvmsub.b(<32 x i8>, <32 x i8>, <32 x i8>)

define <32 x i8> @lasx_xvmsub_b(<32 x i8> %va, <32 x i8> %vb, <32 x i8> %vc) nounwind {
; CHECK-LABEL: lasx_xvmsub_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvmsub.b $xr0, $xr1, $xr2
; CHECK-NEXT:    ret
entry:
  %res = call <32 x i8> @llvm.loongarch.lasx.xvmsub.b(<32 x i8> %va, <32 x i8> %vb, <32 x i8> %vc)
  ret <32 x i8> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvmsub.h(<16 x i16>, <16 x i16>, <16 x i16>)

define <16 x i16> @lasx_xvmsub_h(<16 x i16> %va, <16 x i16> %vb, <16 x i16> %vc) nounwind {
; CHECK-LABEL: lasx_xvmsub_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvmsub.h $xr0, $xr1, $xr2
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvmsub.h(<16 x i16> %va, <16 x i16> %vb, <16 x i16> %vc)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvmsub.w(<8 x i32>, <8 x i32>, <8 x i32>)

define <8 x i32> @lasx_xvmsub_w(<8 x i32> %va, <8 x i32> %vb, <8 x i32> %vc) nounwind {
; CHECK-LABEL: lasx_xvmsub_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvmsub.w $xr0, $xr1, $xr2
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvmsub.w(<8 x i32> %va, <8 x i32> %vb, <8 x i32> %vc)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvmsub.d(<4 x i64>, <4 x i64>, <4 x i64>)

define <4 x i64> @lasx_xvmsub_d(<4 x i64> %va, <4 x i64> %vb, <4 x i64> %vc) nounwind {
; CHECK-LABEL: lasx_xvmsub_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvmsub.d $xr0, $xr1, $xr2
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvmsub.d(<4 x i64> %va, <4 x i64> %vb, <4 x i64> %vc)
  ret <4 x i64> %res
}
