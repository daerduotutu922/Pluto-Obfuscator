// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve2 -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve2 -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - -x c++ %s | FileCheck %s -check-prefix=CPP-CHECK
// RUN: %clang_cc1 -DSVE_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sve2 -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -DSVE_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sve2 -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - -x c++ %s | FileCheck %s -check-prefix=CPP-CHECK
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -fsyntax-only -verify -verify-ignore-unexpected=error %s
// RUN: %clang_cc1 -DSVE_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -fsyntax-only -verify=overload -verify-ignore-unexpected=error %s

// REQUIRES: aarch64-registered-target

#include <arm_sve.h>

#ifdef SVE_OVERLOADED_FORMS
// A simple used,unused... macro, long enough to represent any SVE builtin.
#define SVE_ACLE_FUNC(A1,A2_UNUSED,A3,A4_UNUSED) A1##A3
#else
#define SVE_ACLE_FUNC(A1,A2,A3,A4) A1##A2##A3##A4
#endif

// CHECK-LABEL: @test_svrshrnt_n_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 1)
// CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z19test_svrshrnt_n_s16u10__SVInt8_tu11__SVInt16_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 1)
// CPP-CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
svint8_t test_svrshrnt_n_s16(svint8_t op, svint16_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_s16'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_s16,,)(op, op1, 1);
}

// CHECK-LABEL: @test_svrshrnt_n_s16_1(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 8)
// CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z21test_svrshrnt_n_s16_1u10__SVInt8_tu11__SVInt16_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 8)
// CPP-CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
svint8_t test_svrshrnt_n_s16_1(svint8_t op, svint16_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_s16'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_s16,,)(op, op1, 8);
}

// CHECK-LABEL: @test_svrshrnt_n_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 1)
// CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z19test_svrshrnt_n_s32u11__SVInt16_tu11__SVInt32_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 1)
// CPP-CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
svint16_t test_svrshrnt_n_s32(svint16_t op, svint32_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_s32'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_s32,,)(op, op1, 1);
}

// CHECK-LABEL: @test_svrshrnt_n_s32_1(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 16)
// CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z21test_svrshrnt_n_s32_1u11__SVInt16_tu11__SVInt32_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 16)
// CPP-CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
svint16_t test_svrshrnt_n_s32_1(svint16_t op, svint32_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_s32'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_s32,,)(op, op1, 16);
}

// CHECK-LABEL: @test_svrshrnt_n_s64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 1)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z19test_svrshrnt_n_s64u11__SVInt32_tu11__SVInt64_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 1)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svrshrnt_n_s64(svint32_t op, svint64_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_s64'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_s64,,)(op, op1, 1);
}

// CHECK-LABEL: @test_svrshrnt_n_s64_1(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 32)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z21test_svrshrnt_n_s64_1u11__SVInt32_tu11__SVInt64_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 32)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svrshrnt_n_s64_1(svint32_t op, svint64_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_s64'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_s64,,)(op, op1, 32);
}

// CHECK-LABEL: @test_svrshrnt_n_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 1)
// CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z19test_svrshrnt_n_u16u11__SVUint8_tu12__SVUint16_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 1)
// CPP-CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
svuint8_t test_svrshrnt_n_u16(svuint8_t op, svuint16_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_u16'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_u16,,)(op, op1, 1);
}

// CHECK-LABEL: @test_svrshrnt_n_u16_1(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 8)
// CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z21test_svrshrnt_n_u16_1u11__SVUint8_tu12__SVUint16_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.rshrnt.nxv8i16(<vscale x 16 x i8> [[OP:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i32 8)
// CPP-CHECK-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
svuint8_t test_svrshrnt_n_u16_1(svuint8_t op, svuint16_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_u16'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_u16,,)(op, op1, 8);
}

// CHECK-LABEL: @test_svrshrnt_n_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 1)
// CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z19test_svrshrnt_n_u32u12__SVUint16_tu12__SVUint32_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 1)
// CPP-CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
svuint16_t test_svrshrnt_n_u32(svuint16_t op, svuint32_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_u32'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_u32,,)(op, op1, 1);
}

// CHECK-LABEL: @test_svrshrnt_n_u32_1(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 16)
// CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z21test_svrshrnt_n_u32_1u12__SVUint16_tu12__SVUint32_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.aarch64.sve.rshrnt.nxv4i32(<vscale x 8 x i16> [[OP:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i32 16)
// CPP-CHECK-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
svuint16_t test_svrshrnt_n_u32_1(svuint16_t op, svuint32_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_u32'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_u32,,)(op, op1, 16);
}

// CHECK-LABEL: @test_svrshrnt_n_u64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 1)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z19test_svrshrnt_n_u64u12__SVUint32_tu12__SVUint64_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 1)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svuint32_t test_svrshrnt_n_u64(svuint32_t op, svuint64_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_u64'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_u64,,)(op, op1, 1);
}

// CHECK-LABEL: @test_svrshrnt_n_u64_1(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 32)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z21test_svrshrnt_n_u64_1u12__SVUint32_tu12__SVUint64_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.aarch64.sve.rshrnt.nxv2i64(<vscale x 4 x i32> [[OP:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i32 32)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svuint32_t test_svrshrnt_n_u64_1(svuint32_t op, svuint64_t op1)
{
  // overload-warning@+2 {{implicit declaration of function 'svrshrnt'}}
  // expected-warning@+1 {{implicit declaration of function 'svrshrnt_n_u64'}}
  return SVE_ACLE_FUNC(svrshrnt,_n_u64,,)(op, op1, 32);
}
