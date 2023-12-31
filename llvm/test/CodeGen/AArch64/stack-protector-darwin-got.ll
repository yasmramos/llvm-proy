; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=aarch64-apple-darwin < %s -o - | FileCheck %s

@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

; Check we use the GOT to reference ___stack_chk_guard on Darwin

define void @test(ptr %a) #0 {
; CHECK-LABEL: test:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub sp, sp, #80
; CHECK-NEXT:    stp x20, x19, [sp, #48] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #64] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 80
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:  Lloh0:
; CHECK-NEXT:    adrp x8, ___stack_chk_guard@GOTPAGE
; CHECK-NEXT:    mov x1, x0
; CHECK-NEXT:    add x19, sp, #16
; CHECK-NEXT:  Lloh1:
; CHECK-NEXT:    ldr x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
; CHECK-NEXT:  Lloh2:
; CHECK-NEXT:    ldr x8, [x8]
; CHECK-NEXT:    str x8, [sp, #40]
; CHECK-NEXT:    str x0, [sp, #8]
; CHECK-NEXT:    add x0, sp, #16
; CHECK-NEXT:    bl _strcpy
; CHECK-NEXT:  Lloh3:
; CHECK-NEXT:    adrp x0, l_.str@PAGE
; CHECK-NEXT:  Lloh4:
; CHECK-NEXT:    add x0, x0, l_.str@PAGEOFF
; CHECK-NEXT:    str x19, [sp]
; CHECK-NEXT:    bl _printf
; CHECK-NEXT:  Lloh5:
; CHECK-NEXT:    adrp x8, ___stack_chk_guard@GOTPAGE
; CHECK-NEXT:  Lloh6:
; CHECK-NEXT:    ldr x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
; CHECK-NEXT:    ldr x9, [sp, #40]
; CHECK-NEXT:  Lloh7:
; CHECK-NEXT:    ldr x8, [x8]
; CHECK-NEXT:    cmp x8, x9
; CHECK-NEXT:    b.ne LBB0_2
; CHECK-NEXT:  ; %bb.1: ; %entry
; CHECK-NEXT:    ldp x29, x30, [sp, #64] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x20, x19, [sp, #48] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #80
; CHECK-NEXT:    ret
; CHECK-NEXT:  LBB0_2: ; %entry
; CHECK-NEXT:    bl ___stack_chk_fail
; CHECK-NEXT:    .loh AdrpLdrGotLdr Lloh5, Lloh6, Lloh7
; CHECK-NEXT:    .loh AdrpAdd Lloh3, Lloh4
; CHECK-NEXT:    .loh AdrpLdrGotLdr Lloh0, Lloh1, Lloh2
entry:
  %a.addr = alloca ptr, align 8
  %buf = alloca [16 x i8], align 16
  store ptr %a, ptr %a.addr, align 8
  %0 = load ptr, ptr %a.addr, align 8
  %call = call ptr @strcpy(ptr %buf, ptr %0)
  %call2 = call i32 (ptr, ...) @printf(ptr @.str, ptr %buf)
  ret void
}

declare ptr @strcpy(ptr, ptr)
declare i32 @printf(ptr, ...)

attributes #0 = { ssp }
