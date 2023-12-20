; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -aa-pipeline=basic-aa -passes=gvn -S < %s | FileCheck %s

; This test catches an issue in MemoryDependenceAnalysis caching mechanism in presense of TBAA.
define i64 @foo(i64 addrspace(1)** %arg, i1 %arg1, i1 %arg2, i1 %arg3, i32 %arg4) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = load atomic i64 addrspace(1)*, i64 addrspace(1)** [[ARG:%.*]] unordered, align 8
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i64, i64 addrspace(1)* [[TMP]], i64 8
; CHECK-NEXT:    store atomic i64 0, i64 addrspace(1)* [[TMP5]] unordered, align 8
; CHECK-NEXT:    br label [[BB6:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[TMP7:%.*]] = phi i64 [ 0, [[BB:%.*]] ], [ [[TMP22:%.*]], [[BB19:%.*]] ]
; CHECK-NEXT:    br i1 [[ARG1:%.*]], label [[BB19]], label [[BB8:%.*]]
; CHECK:       bb8:
; CHECK-NEXT:    [[TMP9:%.*]] = load atomic i64 addrspace(1)*, i64 addrspace(1)** [[ARG]] unordered, align 8
; CHECK-NEXT:    br i1 [[ARG2:%.*]], label [[BB11:%.*]], label [[BB10:%.*]]
; CHECK:       bb10:
; CHECK-NEXT:    br label [[BB15:%.*]]
; CHECK:       bb11:
; CHECK-NEXT:    br i1 [[ARG3:%.*]], label [[BB12:%.*]], label [[BB18:%.*]]
; CHECK:       bb12:
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i64, i64 addrspace(1)* [[TMP9]], i64 8
; CHECK-NEXT:    store atomic i64 1, i64 addrspace(1)* [[TMP14]] unordered, align 8
; CHECK-NEXT:    ret i64 0
; CHECK:       bb15:
; CHECK-NEXT:    [[TMP16:%.*]] = phi i64 addrspace(1)* [ [[TMP9]], [[BB10]] ], [ [[TMP27:%.*]], [[BB26:%.*]] ]
; CHECK-NEXT:    [[TMP17:%.*]] = phi i64 [ [[TMP7]], [[BB10]] ], [ 0, [[BB26]] ]
; CHECK-NEXT:    switch i32 [[ARG4:%.*]], label [[BB19]] [
; CHECK-NEXT:    i32 0, label [[BB26]]
; CHECK-NEXT:    i32 1, label [[BB23:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb18:
; CHECK-NEXT:    br label [[BB19]]
; CHECK:       bb19:
; CHECK-NEXT:    [[TMP20:%.*]] = phi i64 addrspace(1)* [ [[TMP16]], [[BB15]] ], [ inttoptr (i64 1 to i64 addrspace(1)*), [[BB6]] ], [ [[TMP9]], [[BB18]] ]
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds i64, i64 addrspace(1)* [[TMP20]], i64 8
; CHECK-NEXT:    [[TMP22]] = load atomic i64, i64 addrspace(1)* [[TMP21]] unordered, align 8, !tbaa !0
; CHECK-NEXT:    br label [[BB6]]
; CHECK:       bb23:
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds i64, i64 addrspace(1)* [[TMP16]], i64 8
; CHECK-NEXT:    [[TMP25:%.*]] = load atomic i64, i64 addrspace(1)* [[TMP24]] unordered, align 8
; CHECK-NEXT:    call void @baz(i64 [[TMP25]]) #0
; CHECK-NEXT:    ret i64 0
; CHECK:       bb26:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    [[TMP27]] = load atomic i64 addrspace(1)*, i64 addrspace(1)** [[ARG]] unordered, align 8
; CHECK-NEXT:    [[TMP28:%.*]] = getelementptr inbounds i64, i64 addrspace(1)* [[TMP27]], i64 8
; CHECK-NEXT:    [[TMP29:%.*]] = load atomic i64, i64 addrspace(1)* [[TMP28]] unordered, align 8
; CHECK-NEXT:    [[TMP30:%.*]] = getelementptr inbounds i64, i64 addrspace(1)* [[TMP27]], i64 40
; CHECK-NEXT:    store atomic i64 [[TMP29]], i64 addrspace(1)* [[TMP30]] unordered, align 4
; CHECK-NEXT:    br label [[BB15]]
;
bb:
  %tmp = load atomic i64 addrspace(1)*, i64 addrspace(1)** %arg unordered, align 8
  %tmp5 = getelementptr inbounds i64, i64 addrspace(1)* %tmp, i64 8
  store atomic i64 0, i64 addrspace(1)* %tmp5 unordered, align 8
  br label %bb6

bb6:                                              ; preds = %bb19, %bb
  %tmp7 = phi i64 [ 0, %bb ], [ %tmp22, %bb19 ]
  %tmp111 = inttoptr i64 1 to i64 addrspace(1)*
  br i1 %arg1, label %bb19, label %bb8

bb8:                                              ; preds = %bb6
  %tmp9 = load atomic i64 addrspace(1)*, i64 addrspace(1)** %arg unordered, align 8
  br i1 %arg2, label %bb11, label %bb10

bb10:                                             ; preds = %bb8
  br label %bb15

bb11:                                             ; preds = %bb8
  br i1 %arg3, label %bb12, label %bb18

bb12:                                             ; preds = %bb11
  %tmp13 = phi i64 addrspace(1)* [ %tmp9, %bb11 ]
  %tmp14 = getelementptr inbounds i64, i64 addrspace(1)* %tmp13, i64 8
  store atomic i64 1, i64 addrspace(1)* %tmp14 unordered, align 8
  ret i64 0

bb15:                                             ; preds = %bb26, %bb10
  %tmp16 = phi i64 addrspace(1)* [ %tmp9, %bb10 ], [ %tmp27, %bb26 ]
  %tmp17 = phi i64 [ %tmp7, %bb10 ], [ 0, %bb26 ]
  switch i32 %arg4, label %bb19 [
  i32 0, label %bb26
  i32 1, label %bb23
  ]

bb18:                                             ; preds = %bb11
  br label %bb19

bb19:                                             ; preds = %bb18, %bb15, %bb6
  %tmp20 = phi i64 addrspace(1)* [ %tmp16, %bb15 ], [ %tmp111, %bb6 ], [ %tmp9, %bb18 ]
  %tmp21 = getelementptr inbounds i64, i64 addrspace(1)* %tmp20, i64 8
  %tmp22 = load atomic i64, i64 addrspace(1)* %tmp21 unordered, align 8, !tbaa !0
  br label %bb6

bb23:                                             ; preds = %bb15
  %tmp24 = getelementptr inbounds i64, i64 addrspace(1)* %tmp16, i64 8
  %tmp25 = load atomic i64, i64 addrspace(1)* %tmp24 unordered, align 8
  call void @baz(i64 %tmp25) #0
  ret i64 0

bb26:                                             ; preds = %bb15
  call void @bar()
  %tmp27 = load atomic i64 addrspace(1)*, i64 addrspace(1)** %arg unordered, align 8
  %tmp28 = getelementptr inbounds i64, i64 addrspace(1)* %tmp27, i64 8
  %tmp29 = load atomic i64, i64 addrspace(1)* %tmp28 unordered, align 8
  %tmp30 = getelementptr inbounds i64, i64 addrspace(1)* %tmp27, i64 40
  store atomic i64 %tmp29, i64 addrspace(1)* %tmp30 unordered, align 4
  br label %bb15
}

declare void @bar()

; Function Attrs: inaccessiblememonly readonly
declare void @baz(i64) #0

attributes #0 = { inaccessiblememonly readonly }

!0 = !{!1, !2, i64 8}
!1 = !{!"Name", !2, i64 8}
!2 = !{!"tbaa_local_fields", !3, i64 0}
!3 = !{!"tbaa-access-type"}

