; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; The argument types should match if it is the standard library calloc.
; Don't crash analyzing an imposter.

declare i8* @calloc(i64, i32)

define void @PR50846() {
; CHECK-LABEL: @PR50846(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @calloc(i64 1, i32 1)
; CHECK-NEXT:    ret void
;
  %call = call i8* @calloc(i64 1, i32 1)
  ret void
}
