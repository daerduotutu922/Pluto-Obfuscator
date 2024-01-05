; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

define i1 @wrapping_add_unknown_1(i8 %a) {
; CHECK-LABEL: @wrapping_add_unknown_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = add i8 [[A:%.*]], -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[SUB]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %sub = add i8 %a, -1
  %cmp = icmp eq i8 %sub, 0
  ret i1 %cmp
}

define i1 @wrapping_add_known_1(i8 %a) {
; CHECK-LABEL: @wrapping_add_known_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE:%.*]] = icmp eq i8 [[A:%.*]], 1
; CHECK-NEXT:    br i1 [[PRE]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[SUB_1:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i8 [[SUB_1]], 0
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    [[SUB_2:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i8 [[SUB_2]], 0
; CHECK-NEXT:    ret i1 [[C_2]]
;
entry:
  %pre = icmp eq i8 %a, 1
  br i1 %pre, label %then, label %else

then:
  %sub.1 = add i8 %a, -1
  %c.1 = icmp eq i8 %sub.1, 0
  ret i1 %c.1

else:
  %sub.2 = add i8 %a, -1
  %c.2 = icmp eq i8 %sub.2, 0
  ret i1 %c.2
}

define i1 @wrapping_add_unknown_2(i8 %a) {
; CHECK-LABEL: @wrapping_add_unknown_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE:%.*]] = icmp eq i8 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[PRE]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[SUB_1:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i8 [[SUB_1]], 0
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    [[SUB_2:%.*]] = add i8 [[A]], -1
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i8 [[SUB_2]], 0
; CHECK-NEXT:    ret i1 [[C_2]]
;
entry:
  %pre = icmp eq i8 %a, 0
  br i1 %pre, label %then, label %else

then:
  %sub.1 = add i8 %a, -1
  %c.1 = icmp eq i8 %sub.1, 0
  ret i1 %c.1

else:
  %sub.2 = add i8 %a, -1
  %c.2 = icmp eq i8 %sub.2, 0
  ret i1 %c.2
}