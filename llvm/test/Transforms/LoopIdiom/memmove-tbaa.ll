; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes="loop-idiom" < %s -S | FileCheck %s

define void @looper(double* nocapture %out) {
; CHECK-LABEL: @looper(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[M:%.*]] = getelementptr double, double* %out, i32 16
; CHECK-NEXT:    [[M2:%.*]] = bitcast double* [[M]] to i8*
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[M2]], i64 256, i1 false), !tbaa [[TBAA0:![0-9]+]]
;
entry:
  %M = getelementptr double, double* %out, i32 16
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %M, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !5
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8, !tbaa !5
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %j.020, 31
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}


define void @looperBadMerge(double* nocapture %out) {
; CHECK-LABEL: @looperBadMerge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[M:%.*]] = getelementptr double, double* %out, i32 16
; CHECK-NEXT:    [[M2:%.*]] = bitcast double* [[M]] to i8*
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[M2]], i64 256, i1 false), !tbaa [[TBAAF:![0-9]+]]
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
;
entry:
  %M = getelementptr double, double* %out, i32 16
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %M, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !5
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8, !tbaa !3
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %j.020, 31
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}

define void @looperGoodMerge(double* nocapture %out) {
; CHECK-LABEL: @looperGoodMerge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[M:%.*]] = getelementptr double, double* %out, i32 16
; CHECK-NEXT:    [[M2:%.*]] = bitcast double* [[M]] to i8*
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[M2]], i64 256, i1 false) 
; CHECK-NOT:     !tbaa
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
;
entry:
  %M = getelementptr double, double* %out, i32 16
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %M, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !5
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %j.020, 31
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}

; CHECK: [[TBAA0]] = !{[[TBAA1:.+]], [[TBAA1]], i64 0}
; CHECK: [[TBAA1]] = !{!"double", [[TBAA2:.+]], i64 0}
; CHECK: [[TBAA2]] = !{!"omnipotent char", [[TBAA3:.+]], i64 0}
; CHECK: [[TBAAF]] = !{[[TBAA2]], [[TBAA2]], i64 0}

!3 = !{!4, !4, i64 0}
!4 = !{!"float", !7, i64 0}
!5 = !{!6, !6, i64 0}
!6 = !{!"double", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
