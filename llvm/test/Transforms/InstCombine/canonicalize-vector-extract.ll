; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; llvm.vector.extract canonicalizes to shufflevector in the fixed case. In the
; scalable case, we lower to the EXTRACT_SUBVECTOR ISD node.

declare <10 x i32> @llvm.vector.extract.v10i32.v8i32(<8 x i32> %vec, i64 %idx)
declare <2 x i32> @llvm.vector.extract.v2i32.v4i32(<8 x i32> %vec, i64 %idx)
declare <3 x i32> @llvm.vector.extract.v3i32.v8i32(<8 x i32> %vec, i64 %idx)
declare <4 x i32> @llvm.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32> %vec, i64 %idx)
declare <4 x i32> @llvm.vector.extract.v4i32.v8i32(<8 x i32> %vec, i64 %idx)
declare <8 x i32> @llvm.vector.extract.v8i32.v8i32(<8 x i32> %vec, i64 %idx)
declare <vscale x 8 x i32> @llvm.vector.extract.nxv8i32.nxv8i32(<vscale x 8 x i32> %vec, i64 %idx)

; ============================================================================ ;
; Trivial cases
; ============================================================================ ;

; Extracting the entirety of a vector is a nop.
define <8 x i32> @trivial_nop(<8 x i32> %vec) {
; CHECK-LABEL: @trivial_nop(
; CHECK-NEXT:    ret <8 x i32> [[VEC:%.*]]
;
  %1 = call <8 x i32> @llvm.vector.extract.v8i32.v8i32(<8 x i32> %vec, i64 0)
  ret <8 x i32> %1
}

define <vscale x 8 x i32> @trivial_nop_scalable(<vscale x 8 x i32> %vec) {
; CHECK-LABEL: define <vscale x 8 x i32> @trivial_nop_scalable(
; CHECK-SAME: <vscale x 8 x i32> [[VEC:%.*]]) {
; CHECK-NEXT:    ret <vscale x 8 x i32> [[VEC]]
;
  %ext = call <vscale x 8 x i32> @llvm.vector.extract.nxv8i32.nxv8i32(<vscale x 8 x i32> %vec, i64 0)
  ret <vscale x 8 x i32> %ext
}

; ============================================================================ ;
; Valid canonicalizations
; ============================================================================ ;

define <2 x i32> @valid_extraction_a(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_a(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %1 = call <2 x i32> @llvm.vector.extract.v2i32.v4i32(<8 x i32> %vec, i64 0)
  ret <2 x i32> %1
}

define <2 x i32> @valid_extraction_b(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_b(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %1 = call <2 x i32> @llvm.vector.extract.v2i32.v4i32(<8 x i32> %vec, i64 2)
  ret <2 x i32> %1
}

define <2 x i32> @valid_extraction_c(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_c(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <2 x i32> <i32 4, i32 5>
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %1 = call <2 x i32> @llvm.vector.extract.v2i32.v4i32(<8 x i32> %vec, i64 4)
  ret <2 x i32> %1
}

define <2 x i32> @valid_extraction_d(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_d(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <2 x i32> <i32 6, i32 7>
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %1 = call <2 x i32> @llvm.vector.extract.v2i32.v4i32(<8 x i32> %vec, i64 6)
  ret <2 x i32> %1
}

define <4 x i32> @valid_extraction_e(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_e(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = call <4 x i32> @llvm.vector.extract.v4i32.v8i32(<8 x i32> %vec, i64 0)
  ret <4 x i32> %1
}

define <4 x i32> @valid_extraction_f(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_f(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = call <4 x i32> @llvm.vector.extract.v4i32.v8i32(<8 x i32> %vec, i64 4)
  ret <4 x i32> %1
}

define <3 x i32> @valid_extraction_g(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_g(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <3 x i32> <i32 0, i32 1, i32 2>
; CHECK-NEXT:    ret <3 x i32> [[TMP1]]
;
  %1 = call <3 x i32> @llvm.vector.extract.v3i32.v8i32(<8 x i32> %vec, i64 0)
  ret <3 x i32> %1
}

define <3 x i32> @valid_extraction_h(<8 x i32> %vec) {
; CHECK-LABEL: @valid_extraction_h(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> poison, <3 x i32> <i32 3, i32 4, i32 5>
; CHECK-NEXT:    ret <3 x i32> [[TMP1]]
;
  %1 = call <3 x i32> @llvm.vector.extract.v3i32.v8i32(<8 x i32> %vec, i64 3)
  ret <3 x i32> %1
}

; ============================================================================ ;
; Scalable cases
; ============================================================================ ;

; Scalable extractions should not be canonicalized. This will be lowered to the
; EXTRACT_SUBVECTOR ISD node later.
define <4 x i32> @scalable_extract(<vscale x 4 x i32> %vec) {
; CHECK-LABEL: @scalable_extract(
; CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32> [[VEC:%.*]], i64 0)
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = call <4 x i32> @llvm.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32> %vec, i64 0)
  ret <4 x i32> %1
}
