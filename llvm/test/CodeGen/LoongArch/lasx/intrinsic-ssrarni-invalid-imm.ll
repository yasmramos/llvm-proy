; RUN: not llc --mtriple=loongarch64 --mattr=+lasx < %s 2>&1 | FileCheck %s

declare <32 x i8> @llvm.loongarch.lasx.xvssrarni.b.h(<32 x i8>, <32 x i8>, i32)

define <32 x i8> @lasx_xvssrarni_b_h_lo(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.b.h: argument out of range
entry:
  %res = call <32 x i8> @llvm.loongarch.lasx.xvssrarni.b.h(<32 x i8> %va, <32 x i8> %vb, i32 -1)
  ret <32 x i8> %res
}

define <32 x i8> @lasx_xvssrarni_b_h_hi(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.b.h: argument out of range
entry:
  %res = call <32 x i8> @llvm.loongarch.lasx.xvssrarni.b.h(<32 x i8> %va, <32 x i8> %vb, i32 16)
  ret <32 x i8> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvssrarni.h.w(<16 x i16>, <16 x i16>, i32)

define <16 x i16> @lasx_xvssrarni_h_w_lo(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.h.w: argument out of range
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvssrarni.h.w(<16 x i16> %va, <16 x i16> %vb, i32 -1)
  ret <16 x i16> %res
}

define <16 x i16> @lasx_xvssrarni_h_w_hi(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.h.w: argument out of range
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvssrarni.h.w(<16 x i16> %va, <16 x i16> %vb, i32 32)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvssrarni.w.d(<8 x i32>, <8 x i32>, i32)

define <8 x i32> @lasx_xvssrarni_w_d_lo(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.w.d: argument out of range
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvssrarni.w.d(<8 x i32> %va, <8 x i32> %vb, i32 -1)
  ret <8 x i32> %res
}

define <8 x i32> @lasx_xvssrarni_w_d_hi(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.w.d: argument out of range
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvssrarni.w.d(<8 x i32> %va, <8 x i32> %vb, i32 64)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvssrarni.d.q(<4 x i64>, <4 x i64>, i32)

define <4 x i64> @lasx_xvssrarni_d_q_lo(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.d.q: argument out of range
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvssrarni.d.q(<4 x i64> %va, <4 x i64> %vb, i32 -1)
  ret <4 x i64> %res
}

define <4 x i64> @lasx_xvssrarni_d_q_hi(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.d.q: argument out of range
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvssrarni.d.q(<4 x i64> %va, <4 x i64> %vb, i32 128)
  ret <4 x i64> %res
}

declare <32 x i8> @llvm.loongarch.lasx.xvssrarni.bu.h(<32 x i8>, <32 x i8>, i32)

define <32 x i8> @lasx_xvssrarni_bu_h_lo(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.bu.h: argument out of range
entry:
  %res = call <32 x i8> @llvm.loongarch.lasx.xvssrarni.bu.h(<32 x i8> %va, <32 x i8> %vb, i32 -1)
  ret <32 x i8> %res
}

define <32 x i8> @lasx_xvssrarni_bu_h_hi(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.bu.h: argument out of range
entry:
  %res = call <32 x i8> @llvm.loongarch.lasx.xvssrarni.bu.h(<32 x i8> %va, <32 x i8> %vb, i32 16)
  ret <32 x i8> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvssrarni.hu.w(<16 x i16>, <16 x i16>, i32)

define <16 x i16> @lasx_xvssrarni_hu_w_lo(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.hu.w: argument out of range
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvssrarni.hu.w(<16 x i16> %va, <16 x i16> %vb, i32 -1)
  ret <16 x i16> %res
}

define <16 x i16> @lasx_xvssrarni_hu_w_hi(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.hu.w: argument out of range
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvssrarni.hu.w(<16 x i16> %va, <16 x i16> %vb, i32 32)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvssrarni.wu.d(<8 x i32>, <8 x i32>, i32)

define <8 x i32> @lasx_xvssrarni_wu_d_lo(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.wu.d: argument out of range
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvssrarni.wu.d(<8 x i32> %va, <8 x i32> %vb, i32 -1)
  ret <8 x i32> %res
}

define <8 x i32> @lasx_xvssrarni_wu_d_hi(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.wu.d: argument out of range
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvssrarni.wu.d(<8 x i32> %va, <8 x i32> %vb, i32 64)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvssrarni.du.q(<4 x i64>, <4 x i64>, i32)

define <4 x i64> @lasx_xvssrarni_du_q_lo(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.du.q: argument out of range
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvssrarni.du.q(<4 x i64> %va, <4 x i64> %vb, i32 -1)
  ret <4 x i64> %res
}

define <4 x i64> @lasx_xvssrarni_du_q_hi(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK: llvm.loongarch.lasx.xvssrarni.du.q: argument out of range
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvssrarni.du.q(<4 x i64> %va, <4 x i64> %vb, i32 128)
  ret <4 x i64> %res
}
