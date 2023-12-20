; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-vectorize -force-vector-width=4 -force-vector-interleave=1 -prefer-predicate-over-epilogue=predicate-else-scalar-epilogue -prefer-predicated-reduction-select -dce -instcombine -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"

define i32 @reduction_sum_single(i32* noalias nocapture %A) {
; CHECK-LABEL: @reduction_sum_single(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ [[TMP25:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP24:%.*]] = select <4 x i1> [[TMP0:%.*]], <4 x i32> [[TMP23:%.*]], <4 x i32> zeroinitializer
; CHECK:         [[TMP25]] = add <4 x i32> [[VEC_PHI]], [[TMP24]]
; CHECK:       middle.block:
; CHECK:         [[TMP27:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[TMP25]])
;
entry:
  br label %.lr.ph

.lr.ph:                                           ; preds = %entry, %.lr.ph
  %indvars.iv = phi i32 [ %indvars.iv.next, %.lr.ph ], [ 0, %entry ]
  %sum.02 = phi i32 [ %l7, %.lr.ph ], [ 0, %entry ]
  %l2 = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l3 = load i32, i32* %l2, align 4
  %l7 = add i32 %sum.02, %l3
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph
  %sum.0.lcssa = phi i32 [ %l7, %.lr.ph ]
  ret i32 %sum.0.lcssa
}

define i32 @reduction_sum(i32* noalias nocapture %A, i32* noalias nocapture %B) {
; CHECK-LABEL: @reduction_sum(
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ [[TMP47:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP44:%.*]] = add <4 x i32> [[VEC_PHI]], [[VEC_IND:%.*]]
; CHECK:         [[TMP45:%.*]] = add <4 x i32> [[TMP44]], [[TMP23:%.*]]
; CHECK:         [[TMP46:%.*]] = add <4 x i32> [[TMP45]], [[TMP43:%.*]]
; CHECK:         [[TMP47]] = select <4 x i1> [[TMP3:%.*]], <4 x i32> [[TMP46]], <4 x i32> [[VEC_PHI]]
; CHECK:       middle.block:
; CHECK:         [[TMP49:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[TMP47]])
;
entry:
  br label %.lr.ph

.lr.ph:                                           ; preds = %entry, %.lr.ph
  %indvars.iv = phi i32 [ %indvars.iv.next, %.lr.ph ], [ 0, %entry ]
  %sum.02 = phi i32 [ %l9, %.lr.ph ], [ 0, %entry ]
  %l2 = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l3 = load i32, i32* %l2, align 4
  %l4 = getelementptr inbounds i32, i32* %B, i32 %indvars.iv
  %l5 = load i32, i32* %l4, align 4
  %l7 = add i32 %sum.02, %indvars.iv
  %l8 = add i32 %l7, %l3
  %l9 = add i32 %l8, %l5
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph
  %sum.0.lcssa = phi i32 [ %l9, %.lr.ph ]
  ret i32 %sum.0.lcssa
}

define i32 @reduction_prod(i32* noalias nocapture %A, i32* noalias nocapture %B) {
; CHECK-LABEL: @reduction_prod(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ <i32 1, i32 1, i32 1, i32 1>, %vector.ph ], [ [[TMP46:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP44:%.*]] = mul <4 x i32> [[VEC_PHI]], [[TMP23:%.*]]
; CHECK:         [[TMP45:%.*]] = mul <4 x i32> [[TMP44]], [[TMP43:%.*]]
; CHECK:         [[TMP46]] = select <4 x i1> [[TMP3:%.*]], <4 x i32> [[TMP45]], <4 x i32> [[VEC_PHI]]
; CHECK:       middle.block:
; CHECK:         [[TMP48:%.*]] = call i32 @llvm.vector.reduce.mul.v4i32(<4 x i32> [[TMP46]])
;
entry:
  br label %.lr.ph

.lr.ph:                                           ; preds = %entry, %.lr.ph
  %indvars.iv = phi i32 [ %indvars.iv.next, %.lr.ph ], [ 0, %entry ]
  %prod.02 = phi i32 [ %l9, %.lr.ph ], [ 1, %entry ]
  %l2 = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l3 = load i32, i32* %l2, align 4
  %l4 = getelementptr inbounds i32, i32* %B, i32 %indvars.iv
  %l5 = load i32, i32* %l4, align 4
  %l8 = mul i32 %prod.02, %l3
  %l9 = mul i32 %l8, %l5
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph
  %prod.0.lcssa = phi i32 [ %l9, %.lr.ph ]
  ret i32 %prod.0.lcssa
}

define i32 @reduction_and(i32* nocapture %A, i32* nocapture %B) {
; CHECK-LABEL: @reduction_and(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ <i32 -1, i32 -1, i32 -1, i32 -1>, %vector.ph ], [ [[TMP46:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP44:%.*]] = and <4 x i32> [[VEC_PHI]], [[TMP23:%.*]]
; CHECK:         [[TMP45:%.*]] = and <4 x i32> [[TMP44]], [[TMP43:%.*]]
; CHECK:         [[TMP46]] = select <4 x i1> [[TMP3:%.*]], <4 x i32> [[TMP45]], <4 x i32> [[VEC_PHI]]
; CHECK:       middle.block:
; CHECK:         [[TMP48:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[TMP46]])
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i32 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %result.08 = phi i32 [ %and, %for.body ], [ -1, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l0 = load i32, i32* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %B, i32 %indvars.iv
  %l1 = load i32, i32* %arrayidx2, align 4
  %add = and i32 %result.08, %l0
  %and = and i32 %add, %l1
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %result.0.lcssa = phi i32 [ %and, %for.body ]
  ret i32 %result.0.lcssa
}

define i32 @reduction_or(i32* nocapture %A, i32* nocapture %B) {
; CHECK-LABEL: @reduction_or(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ [[TMP46:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP45:%.*]] = select <4 x i1> [[TMP3:%.*]], <4 x i32> [[TMP44:%.*]], <4 x i32> zeroinitializer
; CHECK:         [[TMP46]] = or <4 x i32> [[VEC_PHI]], [[TMP45]]
; CHECK:       middle.block:
; CHECK:         [[TMP48:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP46]])
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i32 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %result.08 = phi i32 [ %or, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l0 = load i32, i32* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %B, i32 %indvars.iv
  %l1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %l1, %l0
  %or = or i32 %add, %result.08
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %result.0.lcssa = phi i32 [ %or, %for.body ]
  ret i32 %result.0.lcssa
}

define i32 @reduction_xor(i32* nocapture %A, i32* nocapture %B) {
; CHECK-LABEL: @reduction_xor(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ [[TMP46:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP45:%.*]] = select <4 x i1> [[TMP3:%.*]], <4 x i32> [[TMP44:%.*]], <4 x i32> zeroinitializer
; CHECK:         [[TMP46]] = xor <4 x i32> [[VEC_PHI]], [[TMP45]]
; CHECK:       middle.block:
; CHECK:         [[TMP48:%.*]] = call i32 @llvm.vector.reduce.xor.v4i32(<4 x i32> [[TMP46]])
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i32 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %result.08 = phi i32 [ %xor, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l0 = load i32, i32* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %B, i32 %indvars.iv
  %l1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %l1, %l0
  %xor = xor i32 %add, %result.08
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %result.0.lcssa = phi i32 [ %xor, %for.body ]
  ret i32 %result.0.lcssa
}

define float @reduction_fadd(float* nocapture %A, float* nocapture %B) {
; CHECK-LABEL: @reduction_fadd(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x float> [ zeroinitializer, %vector.ph ], [ [[TMP46:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP44:%.*]] = fadd fast <4 x float> [[VEC_PHI]], [[TMP23:%.*]]
; CHECK:         [[TMP45:%.*]] = fadd fast <4 x float> [[TMP44]], [[TMP43:%.*]]
; CHECK:         [[TMP46]] = select <4 x i1> [[TMP3:%.*]], <4 x float> [[TMP45]], <4 x float> [[VEC_PHI]]
; CHECK:       middle.block:
; CHECK:         [[TMP48:%.*]] = call fast float @llvm.vector.reduce.fadd.v4f32(float -0.000000e+00, <4 x float> [[TMP46]])
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i32 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %result.08 = phi float [ %fadd, %for.body ], [ 0.0, %entry ]
  %arrayidx = getelementptr inbounds float, float* %A, i32 %indvars.iv
  %l0 = load float, float* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds float, float* %B, i32 %indvars.iv
  %l1 = load float, float* %arrayidx2, align 4
  %add = fadd fast float %result.08, %l0
  %fadd = fadd fast float %add, %l1
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %result.0.lcssa = phi float [ %fadd, %for.body ]
  ret float %result.0.lcssa
}

define float @reduction_fmul(float* nocapture %A, float* nocapture %B) {
; CHECK-LABEL: @reduction_fmul(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x float> [ <float 0.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %vector.ph ], [ [[TMP46:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP44:%.*]] = fmul fast <4 x float> [[VEC_PHI]], [[TMP23:%.*]]
; CHECK:         [[TMP45:%.*]] = fmul fast <4 x float> [[TMP44]], [[TMP43:%.*]]
; CHECK:         [[TMP46]] = select <4 x i1> [[TMP3:%.*]], <4 x float> [[TMP45]], <4 x float> [[VEC_PHI]]
; CHECK:       middle.block:
; CHECK:         [[TMP48:%.*]] = call fast float @llvm.vector.reduce.fmul.v4f32(float 1.000000e+00, <4 x float> [[TMP46]])
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i32 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %result.08 = phi float [ %fmul, %for.body ], [ 0.0, %entry ]
  %arrayidx = getelementptr inbounds float, float* %A, i32 %indvars.iv
  %l0 = load float, float* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds float, float* %B, i32 %indvars.iv
  %l1 = load float, float* %arrayidx2, align 4
  %add = fmul fast float %result.08, %l0
  %fmul = fmul fast float %add, %l1
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %result.0.lcssa = phi float [ %fmul, %for.body ]
  ret float %result.0.lcssa
}

define i32 @reduction_min(i32* nocapture %A, i32* nocapture %B) {
; CHECK-LABEL: @reduction_min(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ <i32 1000, i32 1000, i32 1000, i32 1000>, %vector.ph ], [ [[TMP26:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP24:%.*]] = icmp slt <4 x i32> [[VEC_PHI]], [[TMP23:%.*]]
; CHECK:         [[TMP25:%.*]] = select <4 x i1> [[TMP24]], <4 x i32> [[VEC_PHI]], <4 x i32> [[TMP23]]
; CHECK:         [[TMP26]] = select <4 x i1> [[TMP0:%.*]], <4 x i32> [[TMP25]], <4 x i32> [[VEC_PHI]]
; CHECK:       middle.block:
; CHECK:         [[TMP28:%.*]] = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> [[TMP26]])
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i32 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %result.08 = phi i32 [ %v0, %for.body ], [ 1000, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l0 = load i32, i32* %arrayidx, align 4
  %c0 = icmp slt i32 %result.08, %l0
  %v0 = select i1 %c0, i32 %result.08, i32 %l0
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %result.0.lcssa = phi i32 [ %v0, %for.body ]
  ret i32 %result.0.lcssa
}

define i32 @reduction_max(i32* nocapture %A, i32* nocapture %B) {
; CHECK-LABEL: @reduction_max(
; CHECK:       vector.body:
; CHECK:         [[VEC_PHI:%.*]] = phi <4 x i32> [ <i32 1000, i32 1000, i32 1000, i32 1000>, %vector.ph ], [ [[TMP26:%.*]], %pred.load.continue6 ]
; CHECK:         [[TMP24:%.*]] = icmp ugt <4 x i32> [[VEC_PHI]], [[TMP23:%.*]]
; CHECK:         [[TMP25:%.*]] = select <4 x i1> [[TMP24]], <4 x i32> [[VEC_PHI]], <4 x i32> [[TMP23]]
; CHECK:         [[TMP26]] = select <4 x i1> [[TMP0:%.*]], <4 x i32> [[TMP25]], <4 x i32> [[VEC_PHI]]
; CHECK:       middle.block:
; CHECK:         [[TMP28:%.*]] = call i32 @llvm.vector.reduce.umax.v4i32(<4 x i32> [[TMP26]])
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i32 [ %indvars.iv.next, %for.body ], [ 0, %entry ]
  %result.08 = phi i32 [ %v0, %for.body ], [ 1000, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %indvars.iv
  %l0 = load i32, i32* %arrayidx, align 4
  %c0 = icmp ugt i32 %result.08, %l0
  %v0 = select i1 %c0, i32 %result.08, i32 %l0
  %indvars.iv.next = add i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next, 257
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %result.0.lcssa = phi i32 [ %v0, %for.body ]
  ret i32 %result.0.lcssa
}
