// RUN: mlir-opt -split-input-file -test-written-to %s 2>&1 |\
// RUN:          FileCheck %s --check-prefixes=CHECK,IP
// RUN: mlir-opt -split-input-file -test-written-to='interprocedural=false' %s \
// RUN:          2>&1 | FileCheck %s --check-prefixes=CHECK,LOCAL
// RUN: mlir-opt -split-input-file \
// RUN:          -test-written-to='assume-func-writes=true' %s 2>&1 |\
// RUN:          FileCheck %s --check-prefixes=CHECK,IP_AW
// RUN: mlir-opt -split-input-file \
// RUN:       -test-written-to='interprocedural=false assume-func-writes=true' \
// RUN:       %s 2>&1 | FileCheck %s --check-prefixes=CHECK,LC_AW

// Check prefixes are as follows:
// 'check': common for all runs;
// 'ip': interprocedural runs;
// 'ip_aw': interpocedural runs assuming calls to external functions write to
//          all arguments;
// 'local': local (non-interprocedural) analysis not assuming calls writing;
// 'lc_aw': local analysis assuming external calls writing to all arguments.

// Note that despite the name of the test analysis being "written to", it is set
// up in a peculiar way where passing a value through a block or region argument
// (via visitCall/BranchOperand) is considered as "writing" that value to the
// corresponding operand, which is itself a value and not necessarily "memory".
// This is arguably okay for testing purposes, but may be surprising for readers
// trying to interpret this test using their intuition.

// CHECK-LABEL: test_tag: constant0
// CHECK: result #0: [a]
// CHECK-LABEL: test_tag: constant1
// CHECK: result #0: [b]
func.func @test_two_writes(%m0: memref<i32>, %m1: memref<i32>) -> (memref<i32>, memref<i32>) {
  %c0 = arith.constant {tag = "constant0"} 0 : i32
  %c1 = arith.constant {tag = "constant1"} 1 : i32
  memref.store %c0, %m0[] {tag_name = "a"} : memref<i32>
  memref.store %c1, %m1[] {tag_name = "b"} : memref<i32>
  return %m0, %m1 : memref<i32>, memref<i32>
}

// -----

// CHECK-LABEL: test_tag: c0
// CHECK: result #0: [b]
// CHECK-LABEL: test_tag: c1
// CHECK: result #0: [b]
// CHECK-LABEL: test_tag: condition
// CHECK: result #0: [brancharg0]
// CHECK-LABEL: test_tag: c2
// CHECK: result #0: [a]
// CHECK-LABEL: test_tag: c3
// CHECK: result #0: [a]
func.func @test_if(%m0: memref<i32>, %m1: memref<i32>, %condition: i1) {
  %c0 = arith.constant {tag = "c0"} 2 : i32
  %c1 = arith.constant {tag = "c1"} 3 : i32
  %condition2 = arith.addi %condition, %condition {tag = "condition"} : i1
  %0, %1 = scf.if %condition2 -> (i32, i32) {
    %c2 = arith.constant {tag = "c2"} 0 : i32
    scf.yield %c2, %c0: i32, i32
  } else {
    %c3 = arith.constant {tag = "c3"} 1 : i32
    scf.yield %c3, %c1: i32, i32
  }
  memref.store %0, %m0[] {tag_name = "a"} : memref<i32>
  memref.store %1, %m1[] {tag_name = "b"} : memref<i32>
  return
}

// -----

// CHECK-LABEL: test_tag: c0
// CHECK: result #0: [a c]
// CHECK-LABEL: test_tag: c1
// CHECK: result #0: [b c]
// CHECK-LABEL: test_tag: br
// CHECK: operand #0: [brancharg0]
func.func @test_blocks(%m0: memref<i32>,
                       %m1: memref<i32>,
                       %m2: memref<i32>, %cond : i1) {
  %0 = arith.constant {tag = "c0"} 0 : i32
  %1 = arith.constant {tag = "c1"} 1 : i32
  cf.cond_br %cond, ^a(%0: i32), ^b(%1: i32) {tag = "br"}
^a(%a0: i32):
  memref.store %a0, %m0[] {tag_name = "a"} : memref<i32>
  cf.br ^c(%a0 : i32)
^b(%b0: i32):
  memref.store %b0, %m1[] {tag_name = "b"} : memref<i32>
  cf.br ^c(%b0 : i32)
^c(%c0 : i32):
  memref.store %c0, %m2[] {tag_name = "c"} : memref<i32>
  return
}

// -----

// CHECK-LABEL: test_tag: two
// CHECK: result #0: [a]
func.func @test_infinite_loop(%m0: memref<i32>) {
  %0 = arith.constant 0 : i32
  %1 = arith.constant 1 : i32
  %2 = arith.constant {tag = "two"} 2 : i32
  %3 = arith.constant -1 : i32
  cf.br ^loop(%0, %1, %2: i32, i32, i32)
^loop(%a: i32, %b: i32, %c: i32):
  memref.store %a, %m0[] {tag_name = "a"} : memref<i32>
  cf.br ^loop(%b, %c, %3 : i32, i32, i32)
}

// -----

// CHECK-LABEL: test_tag: c0
// CHECK: result #0: [a b c]
func.func @test_switch(%flag: i32, %m0: memref<i32>) {
  %0 = arith.constant {tag = "c0"} 0 : i32
  cf.switch %flag : i32, [
      default: ^a(%0 : i32),
      42: ^b(%0 : i32),
      43: ^c(%0 : i32)
  ]
^a(%a0: i32):
  memref.store %a0, %m0[] {tag_name = "a"} : memref<i32>
  cf.br ^c(%a0 : i32)
^b(%b0: i32):
  memref.store %b0, %m0[] {tag_name = "b"} : memref<i32>
  cf.br ^c(%b0 : i32)
^c(%c0 : i32):
  memref.store %c0, %m0[] {tag_name = "c"} : memref<i32>
  return
}

// -----

// CHECK-LABEL: test_tag: add
// IP:    result #0: [a]
// LOCAL: result #0: [callarg0]
// LC_AW: result #0: [func.call]
func.func @test_caller(%m0: memref<f32>, %arg: f32) {
  %0 = arith.addf %arg, %arg {tag = "add"} : f32
  %1 = func.call @callee(%0) : (f32) -> f32
  %2 = arith.mulf %1, %1 : f32
  %3 = arith.mulf %2, %2 : f32
  %4 = arith.mulf %3, %3 : f32
  memref.store %4, %m0[] {tag_name = "a"} : memref<f32>
  return
}

func.func private @callee(%0 : f32) -> f32 {
  %1 = arith.mulf %0, %0 : f32
  %2 = arith.mulf %1, %1 : f32
  func.return %2 : f32
}

// -----

func.func private @callee(%0 : f32) -> f32 {
  %1 = arith.mulf %0, %0 : f32
  func.return %1 : f32
}

// CHECK-LABEL: test_tag: sub
// IP:    result #0: [a]
// LOCAL: result #0: [callarg0]
// LC_AW: result #0: [func.call]
func.func @test_caller_below_callee(%m0: memref<f32>, %arg: f32) {
  %0 = arith.subf %arg, %arg {tag = "sub"} : f32
  %1 = func.call @callee(%0) : (f32) -> f32
  memref.store %1, %m0[] {tag_name = "a"} : memref<f32>
  return
}

// -----

func.func private @callee1(%0 : f32) -> f32 {
  %1 = func.call @callee2(%0) : (f32) -> f32
  func.return %1 : f32
}

func.func private @callee2(%0 : f32) -> f32 {
  %1 = func.call @callee3(%0) : (f32) -> f32
  func.return %1 : f32
}

func.func private @callee3(%0 : f32) -> f32 {
  func.return %0 : f32
}

// CHECK-LABEL: test_tag: mul
// IP:    result #0: [a]
// LOCAL: result #0: [callarg0]
// LC_AW: result #0: [func.call]
func.func @test_callchain(%m0: memref<f32>, %arg: f32) {
  %0 = arith.mulf %arg, %arg {tag = "mul"} : f32
  %1 = func.call @callee1(%0) : (f32) -> f32
  memref.store %1, %m0[] {tag_name = "a"} : memref<f32>
  return
}

// -----

// CHECK-LABEL: test_tag: zero
// CHECK: result #0: [c]
// CHECK-LABEL: test_tag: init
// CHECK: result #0: [a b c]
// CHECK-LABEL: test_tag: condition
// CHECK: operand #0: [brancharg0]
// CHECK: operand #2: [a b c]
func.func @test_while(%m0: memref<i32>, %init : i32, %cond: i1) {
  %zero = arith.constant {tag = "zero"} 0 : i32
  %init2 = arith.addi %init, %init {tag = "init"} : i32
  %0, %1 = scf.while (%arg1 = %zero, %arg2 = %init2) : (i32, i32) -> (i32, i32) {
    memref.store %arg2, %m0[] {tag_name = "a"} : memref<i32>
    scf.condition(%cond) {tag = "condition"} %arg1, %arg2 : i32, i32
  } do {
   ^bb0(%arg1: i32, %arg2: i32):
    memref.store %arg1, %m0[] {tag_name = "c"} : memref<i32>
    %res = arith.addi %arg2, %arg2 : i32
    scf.yield %res, %res: i32, i32
  }
  memref.store %1, %m0[] {tag_name = "b"} : memref<i32>
  return
}

// -----

// CHECK-LABEL: test_tag: zero
// CHECK: result #0: []
// CHECK-LABEL: test_tag: one
// CHECK: result #0: [a]
// CHECK-LABEL: test_tag: condition
// CHECK: operand #0: [brancharg0]
//
// The important thing to note in this test is that the sparse backward dataflow
// analysis framework also works on complex region branch ops like this one
// where the number of operands in the `scf.yield` op don't match the number of
// results in the parent op.
func.func @test_complex_while(%m0: memref<i32>, %cond: i1) {
  %zero = arith.constant {tag = "zero"} 0 : i32
  %one = arith.constant {tag = "one"} 1 : i32
  %0 = scf.while (%arg1 = %zero, %arg2 = %one) : (i32, i32) -> (i32) {
    scf.condition(%cond) {tag = "condition"} %arg2 : i32
  } do {
   ^bb0(%arg1: i32):
    scf.yield %arg1, %arg1: i32, i32
  }
  memref.store %0, %m0[] {tag_name = "a"} : memref<i32>
  return
}

// -----

// CHECK-LABEL: test_tag: zero
// CHECK: result #0: [brancharg0]
// CHECK-LABEL: test_tag: ten
// CHECK: result #0: [brancharg1]
// CHECK-LABEL: test_tag: one
// CHECK: result #0: [brancharg2]
// CHECK-LABEL: test_tag: x
// CHECK: result #0: [a]
func.func @test_for(%m0: memref<i32>) {
  %zero = arith.constant {tag = "zero"} 0 : index
  %ten = arith.constant {tag = "ten"} 10 : index
  %one = arith.constant {tag = "one"} 1 : index
  %x = arith.constant {tag = "x"} 0 : i32
  %0 = scf.for %i = %zero to %ten step %one iter_args(%ix = %x) -> (i32) {
    scf.yield %ix : i32
  }
  memref.store %0, %m0[] {tag_name = "a"} : memref<i32>
  return
}

// -----

// CHECK-LABEL: test_tag: default_a
// CHECK:       result #0: [a]
// CHECK-LABEL: test_tag: default_b
// CHECK:       result #0: [b]
// CHECK-LABEL: test_tag: 1a
// CHECK:       result #0: [a]
// CHECK-LABEL: test_tag: 1b
// CHECK:       result #0: [b]
// CHECK-LABEL: test_tag: 2a
// CHECK:       result #0: [a]
// CHECK-LABEL: test_tag: 2b
// CHECK:       result #0: [b]
// CHECK-LABEL: test_tag: switch
// CHECK:       operand #0: [brancharg0]
func.func @test_switch(%arg0 : index, %m0: memref<i32>) {
  %0, %1 = scf.index_switch %arg0 {tag="switch"} -> i32, i32
  case 1 {
    %2 = arith.constant {tag="1a"} 10 : i32
    %3 = arith.constant {tag="1b"} 100 : i32
    scf.yield %2, %3 : i32, i32
  }
  case 2 {
    %4 = arith.constant {tag="2a"} 20 : i32
    %5 = arith.constant {tag="2b"} 200 : i32
    scf.yield %4, %5 : i32, i32
  }
  default {
    %6 = arith.constant {tag="default_a"} 30 : i32
    %7 = arith.constant {tag="default_b"} 300 : i32
    scf.yield %6, %7 : i32, i32
  }
  memref.store %0, %m0[] {tag_name = "a"} : memref<i32>
  memref.store %1, %m0[] {tag_name = "b"} : memref<i32>
  return
}

// -----

// The point of this test is to ensure the analysis doesn't crash in presence of
// external functions.

// CHECK-LABEL: llvm.func @decl(i64)
// CHECK-LABEL: llvm.func @func(%arg0: i64) {
// CHECK-NEXT:  llvm.call @decl(%arg0) : (i64) -> ()
// CHECK-NEXT:  llvm.return

llvm.func @decl(i64)

llvm.func @func(%lb : i64) -> () {
  llvm.call @decl(%lb) : (i64) -> ()
  llvm.return
}

// -----

func.func private @callee(%arg0 : i32, %arg1 : i32) -> i32 {
  func.return %arg0 : i32
}

// CHECK-LABEL: test_tag: a

// IP:           operand #0: [b]
// LOCAL:        operand #0: [callarg0]
// LC_AW:        operand #0: [test.call_on_device]

// IP:           operand #1: []
// LOCAL:        operand #1: [callarg1]
// LC_AW:        operand #1: [test.call_on_device]

// IP:           operand #2: [callarg2]
// LOCAL:        operand #2: [callarg2]
// LC_AW:        operand #2: [test.call_on_device]

// CHECK:        result #0: [b]
func.func @test_call_on_device(%arg0: i32, %arg1: i32, %device: i32, %m0: memref<i32>) {
  %0 = test.call_on_device @callee(%arg0, %arg1), %device {tag = "a"} : (i32, i32, i32) -> (i32)
  memref.store %0, %m0[] {tag_name = "b"} : memref<i32>
  return
}

// -----

func.func private @external_callee(%arg0: i32) -> i32

// CHECK-LABEL: test_tag: add_external
// IP:    operand #0: [callarg0]
// LOCAL: operand #0: [callarg0]
// LC_AW: operand #0: [func.call]
// IP_AW: operand #0: [func.call]

func.func @test_external_callee(%arg0: i32, %m0: memref<i32>) {
  %0 = arith.addi %arg0, %arg0 { tag = "add_external"}: i32
  %1 = func.call @external_callee(%arg0) : (i32) -> i32
  memref.store %1, %m0[] {tag_name = "a"} : memref<i32>
  return
}
