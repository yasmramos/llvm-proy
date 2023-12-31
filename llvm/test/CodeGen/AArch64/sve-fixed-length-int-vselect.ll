; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -aarch64-sve-vector-bits-min=256  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_256
; RUN: llc -aarch64-sve-vector-bits-min=512  < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=2048 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512

target triple = "aarch64-unknown-linux-gnu"

; Don't use SVE for 64-bit vectors.
define <8 x i8> @select_v8i8(<8 x i8> %op1, <8 x i8> %op2, <8 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.8b, v2.8b, #7
; CHECK-NEXT:    cmlt v2.8b, v2.8b, #0
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <8 x i1> %mask, <8 x i8> %op1, <8 x i8> %op2
  ret <8 x i8> %sel
}

; Don't use SVE for 128-bit vectors.
define <16 x i8> @select_v16i8(<16 x i8> %op1, <16 x i8> %op2, <16 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.16b, v2.16b, #7
; CHECK-NEXT:    cmlt v2.16b, v2.16b, #0
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <16 x i1> %mask, <16 x i8> %op1, <16 x i8> %op2
  ret <16 x i8> %sel
}

define void @select_v32i8(ptr %a, ptr %b) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl32
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    ld1b { z1.b }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.b, p0/z, z0.b, z1.b
; CHECK-NEXT:    sel z0.b, p1, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %mask = icmp eq <32 x i8> %op1, %op2
  %sel = select <32 x i1> %mask, <32 x i8> %op1, <32 x i8> %op2
  store <32 x i8> %sel, ptr %a
  ret void
}

define void @select_v64i8(ptr %a, ptr %b) #0 {
; VBITS_GE_256-LABEL: select_v64i8:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.b, vl32
; VBITS_GE_256-NEXT:    mov w8, #32 // =0x20
; VBITS_GE_256-NEXT:    ld1b { z0.b }, p0/z, [x0, x8]
; VBITS_GE_256-NEXT:    ld1b { z1.b }, p0/z, [x1, x8]
; VBITS_GE_256-NEXT:    ld1b { z2.b }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1b { z3.b }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.b, p0/z, z0.b, z1.b
; VBITS_GE_256-NEXT:    cmpeq p2.b, p0/z, z2.b, z3.b
; VBITS_GE_256-NEXT:    sel z0.b, p1, z0.b, z1.b
; VBITS_GE_256-NEXT:    sel z1.b, p2, z2.b, z3.b
; VBITS_GE_256-NEXT:    st1b { z0.b }, p0, [x0, x8]
; VBITS_GE_256-NEXT:    st1b { z1.b }, p0, [x0]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: select_v64i8:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.b, vl64
; VBITS_GE_512-NEXT:    ld1b { z0.b }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1b { z1.b }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p1.b, p0/z, z0.b, z1.b
; VBITS_GE_512-NEXT:    sel z0.b, p1, z0.b, z1.b
; VBITS_GE_512-NEXT:    st1b { z0.b }, p0, [x0]
; VBITS_GE_512-NEXT:    ret
  %op1 = load <64 x i8>, ptr %a
  %op2 = load <64 x i8>, ptr %b
  %mask = icmp eq <64 x i8> %op1, %op2
  %sel = select <64 x i1> %mask, <64 x i8> %op1, <64 x i8> %op2
  store <64 x i8> %sel, ptr %a
  ret void
}

define void @select_v128i8(ptr %a, ptr %b) vscale_range(8,0) #0 {
; CHECK-LABEL: select_v128i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl128
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    ld1b { z1.b }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.b, p0/z, z0.b, z1.b
; CHECK-NEXT:    sel z0.b, p1, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <128 x i8>, ptr %a
  %op2 = load <128 x i8>, ptr %b
  %mask = icmp eq <128 x i8> %op1, %op2
  %sel = select <128 x i1> %mask, <128 x i8> %op1, <128 x i8> %op2
  store <128 x i8> %sel, ptr %a
  ret void
}

define void @select_v256i8(ptr %a, ptr %b) vscale_range(16,0) #0 {
; CHECK-LABEL: select_v256i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl256
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    ld1b { z1.b }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.b, p0/z, z0.b, z1.b
; CHECK-NEXT:    sel z0.b, p1, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <256 x i8>, ptr %a
  %op2 = load <256 x i8>, ptr %b
  %mask = icmp eq <256 x i8> %op1, %op2
  %sel = select <256 x i1> %mask, <256 x i8> %op1, <256 x i8> %op2
  store <256 x i8> %sel, ptr %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <4 x i16> @select_v4i16(<4 x i16> %op1, <4 x i16> %op2, <4 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.4h, v2.4h, #15
; CHECK-NEXT:    cmlt v2.4h, v2.4h, #0
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <4 x i1> %mask, <4 x i16> %op1, <4 x i16> %op2
  ret <4 x i16> %sel
}

; Don't use SVE for 128-bit vectors.
define <8 x i16> @select_v8i16(<8 x i16> %op1, <8 x i16> %op2, <8 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v2.8h, v2.8b, #0
; CHECK-NEXT:    shl v2.8h, v2.8h, #15
; CHECK-NEXT:    cmlt v2.8h, v2.8h, #0
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <8 x i1> %mask, <8 x i16> %op1, <8 x i16> %op2
  ret <8 x i16> %sel
}

define void @select_v16i16(ptr %a, ptr %b) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl16
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.h, p0/z, z0.h, z1.h
; CHECK-NEXT:    sel z0.h, p1, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %mask = icmp eq <16 x i16> %op1, %op2
  %sel = select <16 x i1> %mask, <16 x i16> %op1, <16 x i16> %op2
  store <16 x i16> %sel, ptr %a
  ret void
}

define void @select_v32i16(ptr %a, ptr %b) #0 {
; VBITS_GE_256-LABEL: select_v32i16:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.h, vl16
; VBITS_GE_256-NEXT:    mov x8, #16 // =0x10
; VBITS_GE_256-NEXT:    ld1h { z0.h }, p0/z, [x0, x8, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z1.h }, p0/z, [x1, x8, lsl #1]
; VBITS_GE_256-NEXT:    ld1h { z2.h }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1h { z3.h }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.h, p0/z, z0.h, z1.h
; VBITS_GE_256-NEXT:    cmpeq p2.h, p0/z, z2.h, z3.h
; VBITS_GE_256-NEXT:    sel z0.h, p1, z0.h, z1.h
; VBITS_GE_256-NEXT:    sel z1.h, p2, z2.h, z3.h
; VBITS_GE_256-NEXT:    st1h { z0.h }, p0, [x0, x8, lsl #1]
; VBITS_GE_256-NEXT:    st1h { z1.h }, p0, [x0]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: select_v32i16:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.h, vl32
; VBITS_GE_512-NEXT:    ld1h { z0.h }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1h { z1.h }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p1.h, p0/z, z0.h, z1.h
; VBITS_GE_512-NEXT:    sel z0.h, p1, z0.h, z1.h
; VBITS_GE_512-NEXT:    st1h { z0.h }, p0, [x0]
; VBITS_GE_512-NEXT:    ret
  %op1 = load <32 x i16>, ptr %a
  %op2 = load <32 x i16>, ptr %b
  %mask = icmp eq <32 x i16> %op1, %op2
  %sel = select <32 x i1> %mask, <32 x i16> %op1, <32 x i16> %op2
  store <32 x i16> %sel, ptr %a
  ret void
}

define void @select_v64i16(ptr %a, ptr %b) vscale_range(8,0) #0 {
; CHECK-LABEL: select_v64i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl64
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.h, p0/z, z0.h, z1.h
; CHECK-NEXT:    sel z0.h, p1, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i16>, ptr %a
  %op2 = load <64 x i16>, ptr %b
  %mask = icmp eq <64 x i16> %op1, %op2
  %sel = select <64 x i1> %mask, <64 x i16> %op1, <64 x i16> %op2
  store <64 x i16> %sel, ptr %a
  ret void
}

define void @select_v128i16(ptr %a, ptr %b) vscale_range(16,0) #0 {
; CHECK-LABEL: select_v128i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl128
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.h, p0/z, z0.h, z1.h
; CHECK-NEXT:    sel z0.h, p1, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <128 x i16>, ptr %a
  %op2 = load <128 x i16>, ptr %b
  %mask = icmp eq <128 x i16> %op1, %op2
  %sel = select <128 x i1> %mask, <128 x i16> %op1, <128 x i16> %op2
  store <128 x i16> %sel, ptr %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <2 x i32> @select_v2i32(<2 x i32> %op1, <2 x i32> %op2, <2 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v2.2s, v2.2s, #31
; CHECK-NEXT:    cmlt v2.2s, v2.2s, #0
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <2 x i1> %mask, <2 x i32> %op1, <2 x i32> %op2
  ret <2 x i32> %sel
}

; Don't use SVE for 128-bit vectors.
define <4 x i32> @select_v4i32(<4 x i32> %op1, <4 x i32> %op2, <4 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v2.4s, v2.4h, #0
; CHECK-NEXT:    shl v2.4s, v2.4s, #31
; CHECK-NEXT:    cmlt v2.4s, v2.4s, #0
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <4 x i1> %mask, <4 x i32> %op1, <4 x i32> %op2
  ret <4 x i32> %sel
}

define void @select_v8i32(ptr %a, ptr %b) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    sel z0.s, p1, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %mask = icmp eq <8 x i32> %op1, %op2
  %sel = select <8 x i1> %mask, <8 x i32> %op1, <8 x i32> %op2
  store <8 x i32> %sel, ptr %a
  ret void
}

define void @select_v16i32(ptr %a, ptr %b) #0 {
; VBITS_GE_256-LABEL: select_v16i32:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.s, vl8
; VBITS_GE_256-NEXT:    mov x8, #8 // =0x8
; VBITS_GE_256-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z1.s }, p0/z, [x1, x8, lsl #2]
; VBITS_GE_256-NEXT:    ld1w { z2.s }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1w { z3.s }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.s, p0/z, z0.s, z1.s
; VBITS_GE_256-NEXT:    cmpeq p2.s, p0/z, z2.s, z3.s
; VBITS_GE_256-NEXT:    sel z0.s, p1, z0.s, z1.s
; VBITS_GE_256-NEXT:    sel z1.s, p2, z2.s, z3.s
; VBITS_GE_256-NEXT:    st1w { z0.s }, p0, [x0, x8, lsl #2]
; VBITS_GE_256-NEXT:    st1w { z1.s }, p0, [x0]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: select_v16i32:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.s, vl16
; VBITS_GE_512-NEXT:    ld1w { z0.s }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1w { z1.s }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p1.s, p0/z, z0.s, z1.s
; VBITS_GE_512-NEXT:    sel z0.s, p1, z0.s, z1.s
; VBITS_GE_512-NEXT:    st1w { z0.s }, p0, [x0]
; VBITS_GE_512-NEXT:    ret
  %op1 = load <16 x i32>, ptr %a
  %op2 = load <16 x i32>, ptr %b
  %mask = icmp eq <16 x i32> %op1, %op2
  %sel = select <16 x i1> %mask, <16 x i32> %op1, <16 x i32> %op2
  store <16 x i32> %sel, ptr %a
  ret void
}

define void @select_v32i32(ptr %a, ptr %b) vscale_range(8,0) #0 {
; CHECK-LABEL: select_v32i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl32
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    sel z0.s, p1, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i32>, ptr %a
  %op2 = load <32 x i32>, ptr %b
  %mask = icmp eq <32 x i32> %op1, %op2
  %sel = select <32 x i1> %mask, <32 x i32> %op1, <32 x i32> %op2
  store <32 x i32> %sel, ptr %a
  ret void
}

define void @select_v64i32(ptr %a, ptr %b) vscale_range(16,0) #0 {
; CHECK-LABEL: select_v64i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl64
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    sel z0.s, p1, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i32>, ptr %a
  %op2 = load <64 x i32>, ptr %b
  %mask = icmp eq <64 x i32> %op1, %op2
  %sel = select <64 x i1> %mask, <64 x i32> %op1, <64 x i32> %op2
  store <64 x i32> %sel, ptr %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <1 x i64> @select_v1i64(<1 x i64> %op1, <1 x i64> %op2, <1 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    csetm x8, ne
; CHECK-NEXT:    fmov d2, x8
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %sel = select <1 x i1> %mask, <1 x i64> %op1, <1 x i64> %op2
  ret <1 x i64> %sel
}

; Don't use SVE for 128-bit vectors.
define <2 x i64> @select_v2i64(<2 x i64> %op1, <2 x i64> %op2, <2 x i1> %mask) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v2.2d, v2.2s, #0
; CHECK-NEXT:    shl v2.2d, v2.2d, #63
; CHECK-NEXT:    cmlt v2.2d, v2.2d, #0
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %sel = select <2 x i1> %mask, <2 x i64> %op1, <2 x i64> %op2
  ret <2 x i64> %sel
}

define void @select_v4i64(ptr %a, ptr %b) vscale_range(2,0) #0 {
; CHECK-LABEL: select_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl4
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.d, p0/z, z0.d, z1.d
; CHECK-NEXT:    sel z0.d, p1, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %mask = icmp eq <4 x i64> %op1, %op2
  %sel = select <4 x i1> %mask, <4 x i64> %op1, <4 x i64> %op2
  store <4 x i64> %sel, ptr %a
  ret void
}

define void @select_v8i64(ptr %a, ptr %b) #0 {
; VBITS_GE_256-LABEL: select_v8i64:
; VBITS_GE_256:       // %bb.0:
; VBITS_GE_256-NEXT:    ptrue p0.d, vl4
; VBITS_GE_256-NEXT:    mov x8, #4 // =0x4
; VBITS_GE_256-NEXT:    ld1d { z0.d }, p0/z, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z1.d }, p0/z, [x1, x8, lsl #3]
; VBITS_GE_256-NEXT:    ld1d { z2.d }, p0/z, [x0]
; VBITS_GE_256-NEXT:    ld1d { z3.d }, p0/z, [x1]
; VBITS_GE_256-NEXT:    cmpeq p1.d, p0/z, z0.d, z1.d
; VBITS_GE_256-NEXT:    cmpeq p2.d, p0/z, z2.d, z3.d
; VBITS_GE_256-NEXT:    sel z0.d, p1, z0.d, z1.d
; VBITS_GE_256-NEXT:    sel z1.d, p2, z2.d, z3.d
; VBITS_GE_256-NEXT:    st1d { z0.d }, p0, [x0, x8, lsl #3]
; VBITS_GE_256-NEXT:    st1d { z1.d }, p0, [x0]
; VBITS_GE_256-NEXT:    ret
;
; VBITS_GE_512-LABEL: select_v8i64:
; VBITS_GE_512:       // %bb.0:
; VBITS_GE_512-NEXT:    ptrue p0.d, vl8
; VBITS_GE_512-NEXT:    ld1d { z0.d }, p0/z, [x0]
; VBITS_GE_512-NEXT:    ld1d { z1.d }, p0/z, [x1]
; VBITS_GE_512-NEXT:    cmpeq p1.d, p0/z, z0.d, z1.d
; VBITS_GE_512-NEXT:    sel z0.d, p1, z0.d, z1.d
; VBITS_GE_512-NEXT:    st1d { z0.d }, p0, [x0]
; VBITS_GE_512-NEXT:    ret
  %op1 = load <8 x i64>, ptr %a
  %op2 = load <8 x i64>, ptr %b
  %mask = icmp eq <8 x i64> %op1, %op2
  %sel = select <8 x i1> %mask, <8 x i64> %op1, <8 x i64> %op2
  store <8 x i64> %sel, ptr %a
  ret void
}

define void @select_v16i64(ptr %a, ptr %b) vscale_range(8,0) #0 {
; CHECK-LABEL: select_v16i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl16
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.d, p0/z, z0.d, z1.d
; CHECK-NEXT:    sel z0.d, p1, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i64>, ptr %a
  %op2 = load <16 x i64>, ptr %b
  %mask = icmp eq <16 x i64> %op1, %op2
  %sel = select <16 x i1> %mask, <16 x i64> %op1, <16 x i64> %op2
  store <16 x i64> %sel, ptr %a
  ret void
}

define void @select_v32i64(ptr %a, ptr %b) vscale_range(16,0) #0 {
; CHECK-LABEL: select_v32i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl32
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x1]
; CHECK-NEXT:    cmpeq p1.d, p0/z, z0.d, z1.d
; CHECK-NEXT:    sel z0.d, p1, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i64>, ptr %a
  %op2 = load <32 x i64>, ptr %b
  %mask = icmp eq <32 x i64> %op1, %op2
  %sel = select <32 x i1> %mask, <32 x i64> %op1, <32 x i64> %op2
  store <32 x i64> %sel, ptr %a
  ret void
}

attributes #0 = { "target-features"="+sve" uwtable }
