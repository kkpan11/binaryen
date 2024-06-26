;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt --enable-simd --trace-calls="noparamsnoresults,singleparamnoresults,multiparamsnoresults:tracempnr,noparamssingleresult,multiparamssingleresult" %s -S -o - | filecheck %s

(module

  (import "env" "no_params_no_results"
    (func $noparamsnoresults))
  (import "env" "single_param_no_results"
    (func $singleparamnoresults (param f64)))
  (import "env" "multi_params_no_results"
    (func $multiparamsnoresults (param i32 i64 f32)))
  (import "env" "no_params_single_result"
    (func $noparamssingleresult (result v128)))
  (import "env" "multi_params_single_result"
    (func $multiparamssingleresult (param i32 v128)(result v128)))
  (import "env" "dont_trace_me"
    (func $donttraceme))


  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (result v128)))

  ;; CHECK:      (type $2 (func (param f64)))

  ;; CHECK:      (type $3 (func (param i32 i64 f32)))

  ;; CHECK:      (type $4 (func (param i32 v128) (result v128)))

  ;; CHECK:      (type $5 (func (param v128 i32 v128)))

  ;; CHECK:      (type $6 (func (param v128)))

  ;; CHECK:      (import "env" "no_params_no_results" (func $noparamsnoresults))

  ;; CHECK:      (import "env" "single_param_no_results" (func $singleparamnoresults (param f64)))

  ;; CHECK:      (import "env" "multi_params_no_results" (func $multiparamsnoresults (param i32 i64 f32)))

  ;; CHECK:      (import "env" "no_params_single_result" (func $noparamssingleresult (result v128)))

  ;; CHECK:      (import "env" "multi_params_single_result" (func $multiparamssingleresult (param i32 v128) (result v128)))

  ;; CHECK:      (import "env" "dont_trace_me" (func $donttraceme))

  ;; CHECK:      (import "env" "tracempnr" (func $tracempnr (param i32 i64 f32)))

  ;; CHECK:      (import "env" "trace_multiparamssingleresult" (func $trace_multiparamssingleresult (param v128 i32 v128)))

  ;; CHECK:      (import "env" "trace_noparamsnoresults" (func $trace_noparamsnoresults))

  ;; CHECK:      (import "env" "trace_noparamssingleresult" (func $trace_noparamssingleresult (param v128)))

  ;; CHECK:      (import "env" "trace_singleparamnoresults" (func $trace_singleparamnoresults (param f64)))

  ;; CHECK:      (func $test_no_params_no_results
  ;; CHECK-NEXT:  (call $noparamsnoresults)
  ;; CHECK-NEXT:  (call $trace_noparamsnoresults)
  ;; CHECK-NEXT: )
  (func $test_no_params_no_results
    (call $noparamsnoresults)
  )

  ;; CHECK:      (func $test_single_param_no_results
  ;; CHECK-NEXT:  (local $0 f64)
  ;; CHECK-NEXT:  (call $singleparamnoresults
  ;; CHECK-NEXT:   (local.tee $0
  ;; CHECK-NEXT:    (f64.const 4.5)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $trace_singleparamnoresults
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test_single_param_no_results
    (call $singleparamnoresults (f64.const 4.5))
  )

  ;; we specify a custom name (tracempnr) for the tracer function
  ;; CHECK:      (func $test_multi_params_no_results
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i64)
  ;; CHECK-NEXT:  (local $2 f32)
  ;; CHECK-NEXT:  (call $multiparamsnoresults
  ;; CHECK-NEXT:   (local.tee $0
  ;; CHECK-NEXT:    (i32.const 5)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.tee $1
  ;; CHECK-NEXT:    (i64.const 6)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.tee $2
  ;; CHECK-NEXT:    (f32.const 1.5)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $tracempnr
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test_multi_params_no_results
    (call $multiparamsnoresults
      (i32.const 5)
      (i64.const 6)
      (f32.const 1.5)
    )
  )

  ;; CHECK:      (func $test_no_params_single_result (result v128)
  ;; CHECK-NEXT:  (local $0 v128)
  ;; CHECK-NEXT:  (call $trace_noparamssingleresult
  ;; CHECK-NEXT:   (local.tee $0
  ;; CHECK-NEXT:    (call $noparamssingleresult)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $0)
  ;; CHECK-NEXT: )
  (func $test_no_params_single_result (result v128)
    call $noparamssingleresult
  )

  ;; CHECK:      (func $test_multi_params_single_result (result v128)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 v128)
  ;; CHECK-NEXT:  (local $2 v128)
  ;; CHECK-NEXT:  (call $trace_multiparamssingleresult
  ;; CHECK-NEXT:   (local.tee $2
  ;; CHECK-NEXT:    (call $multiparamssingleresult
  ;; CHECK-NEXT:     (local.tee $0
  ;; CHECK-NEXT:      (i32.const 3)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (local.tee $1
  ;; CHECK-NEXT:      (v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $2)
  ;; CHECK-NEXT: )
  (func $test_multi_params_single_result (result v128)
    (call $multiparamssingleresult
      (i32.const 3)
      (v128.const i32x4 1 2 3 4))
  )

  ;; this function should not be traced
  ;; CHECK:      (func $test_dont_trace_me
  ;; CHECK-NEXT:  (call $donttraceme)
  ;; CHECK-NEXT: )
  (func $test_dont_trace_me
    (call $donttraceme)
  )
)
