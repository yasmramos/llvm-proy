; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64le-unknown-gnu-linux  < %s | FileCheck %s -check-prefix=PPC64LE

; This tests interaction between MergeICmp and expand-memcmp.

%"struct.std::pair" = type { i32, i32 }

define zeroext i1 @opeq1(
; PPC64LE-LABEL: opeq1:
; PPC64LE:       # %bb.0: # %"entry+land.rhs.i"
; PPC64LE-NEXT:    ld 3, 0(3)
; PPC64LE-NEXT:    ld 4, 0(4)
; PPC64LE-NEXT:    cmpd 3, 4
; PPC64LE-NEXT:    li 3, 0
; PPC64LE-NEXT:    li 4, 1
; PPC64LE-NEXT:    iseleq 3, 4, 3
; PPC64LE-NEXT:    blr
  ptr nocapture readonly dereferenceable(8) %a,
  ptr nocapture readonly dereferenceable(8) %b) local_unnamed_addr #0 {
entry:
  %0 = load i32, ptr %a, align 4
  %1 = load i32, ptr %b, align 4
  %cmp.i = icmp eq i32 %0, %1
  br i1 %cmp.i, label %land.rhs.i, label %opeq1.exit

land.rhs.i:
  %second.i = getelementptr inbounds %"struct.std::pair", ptr %a, i64 0, i32 1
  %2 = load i32, ptr %second.i, align 4
  %second2.i = getelementptr inbounds %"struct.std::pair", ptr %b, i64 0, i32 1
  %3 = load i32, ptr %second2.i, align 4
  %cmp3.i = icmp eq i32 %2, %3
  br label %opeq1.exit

opeq1.exit:
  %4 = phi i1 [ false, %entry ], [ %cmp3.i, %land.rhs.i ]
  ret i1 %4
}


