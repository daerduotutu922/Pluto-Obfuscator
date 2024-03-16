; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: opt -S -openmp-opt-cgscc < %s | FileCheck %s
; RUN: opt -S -passes=openmp-opt-cgscc < %s | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@inofth = external global i32, align 4

define void @set() {
; CHECK-LABEL: define {{[^@]+}}@set() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @inofth, align 4
; CHECK-NEXT:    call void @omp_set_num_threads(i32 noundef [[TMP0]])
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, i32* @inofth, align 4
  call void @omp_set_num_threads(i32 noundef %0)
  ret void
}

define i32 @test(i32 %a) {
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: (i32 [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @set()
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @omp_get_max_threads()
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[CALL]], [[A]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret i32 0
; CHECK:       if.end:
; CHECK-NEXT:    ret i32 1
;
entry:
  call void @set()
  %call = call i32 @omp_get_max_threads()
  %cmp = icmp ne i32 %call, %a
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %if.then, %entry
  ret i32 1
}

declare void @omp_set_num_threads(i32 noundef)
declare i32 @omp_get_max_threads()

!llvm.module.flags = !{!0}

!0 = !{i32 7, !"openmp", i32 50}
