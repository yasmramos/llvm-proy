; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 3
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

define void @extract_32xi8(ptr %src, ptr %dst) nounwind {
; CHECK-LABEL: extract_32xi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    vpickve2gr.b $a0, $vr0, 1
; CHECK-NEXT:    st.b $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <32 x i8>, ptr %src
  %e = extractelement <32 x i8> %v, i32 1
  store i8 %e, ptr %dst
  ret void
}

define void @extract_16xi16(ptr %src, ptr %dst) nounwind {
; CHECK-LABEL: extract_16xi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    vpickve2gr.h $a0, $vr0, 1
; CHECK-NEXT:    st.h $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <16 x i16>, ptr %src
  %e = extractelement <16 x i16> %v, i32 1
  store i16 %e, ptr %dst
  ret void
}

define void @extract_8xi32(ptr %src, ptr %dst) nounwind {
; CHECK-LABEL: extract_8xi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    vpickve2gr.w $a0, $vr0, 1
; CHECK-NEXT:    st.w $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <8 x i32>, ptr %src
  %e = extractelement <8 x i32> %v, i32 1
  store i32 %e, ptr %dst
  ret void
}

define void @extract_4xi64(ptr %src, ptr %dst) nounwind {
; CHECK-LABEL: extract_4xi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    vpickve2gr.d $a0, $vr0, 1
; CHECK-NEXT:    st.d $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <4 x i64>, ptr %src
  %e = extractelement <4 x i64> %v, i32 1
  store i64 %e, ptr %dst
  ret void
}

define void @extract_8xfloat(ptr %src, ptr %dst) nounwind {
; CHECK-LABEL: extract_8xfloat:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    ori $a0, $zero, 7
; CHECK-NEXT:    xvreplve.w $xr0, $xr0, $a0
; CHECK-NEXT:    fst.s $fa0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <8 x float>, ptr %src
  %e = extractelement <8 x float> %v, i32 7
  store float %e, ptr %dst
  ret void
}

define void @extract_4xdouble(ptr %src, ptr %dst) nounwind {
; CHECK-LABEL: extract_4xdouble:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    ori $a0, $zero, 3
; CHECK-NEXT:    xvreplve.d $xr0, $xr0, $a0
; CHECK-NEXT:    fst.d $fa0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <4 x double>, ptr %src
  %e = extractelement <4 x double> %v, i32 3
  store double %e, ptr %dst
  ret void
}

define void @extract_32xi8_idx(ptr %src, ptr %dst, i32 %idx) nounwind {
; CHECK-LABEL: extract_32xi8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a2, $a2, 31, 0
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    xvreplve.b $xr0, $xr0, $a2
; CHECK-NEXT:    movfr2gr.s $a0, $fa0
; CHECK-NEXT:    srai.w $a0, $a0, 24
; CHECK-NEXT:    st.b $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <32 x i8>, ptr %src
  %e = extractelement <32 x i8> %v, i32 %idx
  store i8 %e, ptr %dst
  ret void
}

define void @extract_16xi16_idx(ptr %src, ptr %dst, i32 %idx) nounwind {
; CHECK-LABEL: extract_16xi16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a2, $a2, 31, 0
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    xvreplve.h $xr0, $xr0, $a2
; CHECK-NEXT:    movfr2gr.s $a0, $fa0
; CHECK-NEXT:    srai.w $a0, $a0, 16
; CHECK-NEXT:    st.h $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <16 x i16>, ptr %src
  %e = extractelement <16 x i16> %v, i32 %idx
  store i16 %e, ptr %dst
  ret void
}

define void @extract_8xi32_idx(ptr %src, ptr %dst, i32 %idx) nounwind {
; CHECK-LABEL: extract_8xi32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a2, $a2, 31, 0
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    xvreplve.w $xr0, $xr0, $a2
; CHECK-NEXT:    movfr2gr.s $a0, $fa0
; CHECK-NEXT:    st.w $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <8 x i32>, ptr %src
  %e = extractelement <8 x i32> %v, i32 %idx
  store i32 %e, ptr %dst
  ret void
}

define void @extract_4xi64_idx(ptr %src, ptr %dst, i32 %idx) nounwind {
; CHECK-LABEL: extract_4xi64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a2, $a2, 31, 0
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    xvreplve.d $xr0, $xr0, $a2
; CHECK-NEXT:    movfr2gr.d $a0, $fa0
; CHECK-NEXT:    st.d $a0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <4 x i64>, ptr %src
  %e = extractelement <4 x i64> %v, i32 %idx
  store i64 %e, ptr %dst
  ret void
}

define void @extract_8xfloat_idx(ptr %src, ptr %dst, i32 %idx) nounwind {
; CHECK-LABEL: extract_8xfloat_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a2, $a2, 31, 0
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    xvreplve.w $xr0, $xr0, $a2
; CHECK-NEXT:    fst.s $fa0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <8 x float>, ptr %src
  %e = extractelement <8 x float> %v, i32 %idx
  store float %e, ptr %dst
  ret void
}

define void @extract_4xdouble_idx(ptr %src, ptr %dst, i32 %idx) nounwind {
; CHECK-LABEL: extract_4xdouble_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a2, $a2, 31, 0
; CHECK-NEXT:    xvld $xr0, $a0, 0
; CHECK-NEXT:    xvreplve.d $xr0, $xr0, $a2
; CHECK-NEXT:    fst.d $fa0, $a1, 0
; CHECK-NEXT:    ret
  %v = load volatile <4 x double>, ptr %src
  %e = extractelement <4 x double> %v, i32 %idx
  store double %e, ptr %dst
  ret void
}
