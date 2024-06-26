;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt -all -S -o - --generate-global-effects     | filecheck %s --check-prefix CHECK_0
;; RUN: foreach %s %t wasm-opt -all -S -o - --generate-global-effects -O1 | filecheck %s --check-prefix CHECK_1
;; RUN: foreach %s %t wasm-opt -all -S -o - --generate-global-effects -O3 | filecheck %s --check-prefix CHECK_3
;; RUN: foreach %s %t wasm-opt -all -S -o - --generate-global-effects -Os | filecheck %s --check-prefix CHECK_s
;; RUN: foreach %s %t wasm-opt -all -S -o - --generate-global-effects -O  | filecheck %s --check-prefix CHECK_O

;; Test that global effects benefit -O1 and related modes.

(module
  ;; CHECK_0:      (type $0 (func))

  ;; CHECK_0:      (type $1 (func (param i32) (result i32)))

  ;; CHECK_0:      (export "main" (func $main))
  ;; CHECK_1:      (type $0 (func))

  ;; CHECK_1:      (type $1 (func (param i32) (result i32)))

  ;; CHECK_1:      (export "main" (func $main))
  ;; CHECK_3:      (type $0 (func))

  ;; CHECK_3:      (type $1 (func (param i32) (result i32)))

  ;; CHECK_3:      (export "main" (func $main))
  ;; CHECK_s:      (type $0 (func))

  ;; CHECK_s:      (type $1 (func (param i32) (result i32)))

  ;; CHECK_s:      (export "main" (func $main))
  ;; CHECK_O:      (type $0 (func))

  ;; CHECK_O:      (type $1 (func (param i32) (result i32)))

  ;; CHECK_O:      (export "main" (func $main))
  (export "main" (func $main))

  ;; CHECK_0:      (export "main-infinite" (func $main-infinite))
  ;; CHECK_1:      (export "main-infinite" (func $main-infinite))
  ;; CHECK_3:      (export "main-infinite" (func $main-infinite))
  ;; CHECK_s:      (export "main-infinite" (func $main-infinite))
  ;; CHECK_O:      (export "main-infinite" (func $main-infinite))
  (export "main-infinite" (func $main-infinite))

  ;; CHECK_0:      (export "pointless-work" (func $pointless-work))
  ;; CHECK_1:      (export "pointless-work" (func $pointless-work))
  ;; CHECK_3:      (export "pointless-work" (func $pointless-work))
  ;; CHECK_s:      (export "pointless-work" (func $pointless-work))
  ;; CHECK_O:      (export "pointless-work" (func $pointless-work))
  (export "pointless-work" (func $pointless-work))

  ;; CHECK_0:      (func $main (type $0)
  ;; CHECK_0-NEXT:  (if
  ;; CHECK_0-NEXT:   (call $pointless-work
  ;; CHECK_0-NEXT:    (i32.const 0)
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:   (then
  ;; CHECK_0-NEXT:    (drop
  ;; CHECK_0-NEXT:     (call $pointless-work
  ;; CHECK_0-NEXT:      (i32.const 1)
  ;; CHECK_0-NEXT:     )
  ;; CHECK_0-NEXT:    )
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:  )
  ;; CHECK_0-NEXT: )
  ;; CHECK_1:      (func $main (type $0)
  ;; CHECK_1-NEXT:  (nop)
  ;; CHECK_1-NEXT: )
  ;; CHECK_3:      (func $main (type $0)
  ;; CHECK_3-NEXT:  (nop)
  ;; CHECK_3-NEXT: )
  ;; CHECK_s:      (func $main (type $0)
  ;; CHECK_s-NEXT:  (nop)
  ;; CHECK_s-NEXT: )
  ;; CHECK_O:      (func $main (type $0)
  ;; CHECK_O-NEXT:  (nop)
  ;; CHECK_O-NEXT: )
  (func $main
    ;; This calls a function that does pointless work. After generating global
    ;; effects we can see that it is pointless and remove this entire if (except
    ;; for -O0).
    (if
      (call $pointless-work
        (i32.const 0)
      )
      (then
        (drop
          (call $pointless-work
            (i32.const 1)
          )
        )
      )
    )
  )

  ;; CHECK_0:      (func $main-infinite (type $0)
  ;; CHECK_0-NEXT:  (if
  ;; CHECK_0-NEXT:   (call $infinite-work
  ;; CHECK_0-NEXT:    (i32.const 0)
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:   (then
  ;; CHECK_0-NEXT:    (drop
  ;; CHECK_0-NEXT:     (call $infinite-work
  ;; CHECK_0-NEXT:      (i32.const 1)
  ;; CHECK_0-NEXT:     )
  ;; CHECK_0-NEXT:    )
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:  )
  ;; CHECK_0-NEXT: )
  ;; CHECK_1:      (func $main-infinite (type $0)
  ;; CHECK_1-NEXT:  (if
  ;; CHECK_1-NEXT:   (call $infinite-work
  ;; CHECK_1-NEXT:    (i32.const 0)
  ;; CHECK_1-NEXT:   )
  ;; CHECK_1-NEXT:   (then
  ;; CHECK_1-NEXT:    (drop
  ;; CHECK_1-NEXT:     (call $infinite-work
  ;; CHECK_1-NEXT:      (i32.const 1)
  ;; CHECK_1-NEXT:     )
  ;; CHECK_1-NEXT:    )
  ;; CHECK_1-NEXT:   )
  ;; CHECK_1-NEXT:  )
  ;; CHECK_1-NEXT: )
  ;; CHECK_3:      (func $main-infinite (type $0)
  ;; CHECK_3-NEXT:  (if
  ;; CHECK_3-NEXT:   (call $infinite-work
  ;; CHECK_3-NEXT:    (i32.const 0)
  ;; CHECK_3-NEXT:   )
  ;; CHECK_3-NEXT:   (then
  ;; CHECK_3-NEXT:    (drop
  ;; CHECK_3-NEXT:     (call $infinite-work
  ;; CHECK_3-NEXT:      (i32.const 1)
  ;; CHECK_3-NEXT:     )
  ;; CHECK_3-NEXT:    )
  ;; CHECK_3-NEXT:   )
  ;; CHECK_3-NEXT:  )
  ;; CHECK_3-NEXT: )
  ;; CHECK_s:      (func $main-infinite (type $0)
  ;; CHECK_s-NEXT:  (if
  ;; CHECK_s-NEXT:   (call $infinite-work
  ;; CHECK_s-NEXT:    (i32.const 0)
  ;; CHECK_s-NEXT:   )
  ;; CHECK_s-NEXT:   (then
  ;; CHECK_s-NEXT:    (drop
  ;; CHECK_s-NEXT:     (call $infinite-work
  ;; CHECK_s-NEXT:      (i32.const 1)
  ;; CHECK_s-NEXT:     )
  ;; CHECK_s-NEXT:    )
  ;; CHECK_s-NEXT:   )
  ;; CHECK_s-NEXT:  )
  ;; CHECK_s-NEXT: )
  ;; CHECK_O:      (func $main-infinite (type $0)
  ;; CHECK_O-NEXT:  (if
  ;; CHECK_O-NEXT:   (call $infinite-work
  ;; CHECK_O-NEXT:    (i32.const 0)
  ;; CHECK_O-NEXT:   )
  ;; CHECK_O-NEXT:   (then
  ;; CHECK_O-NEXT:    (drop
  ;; CHECK_O-NEXT:     (call $infinite-work
  ;; CHECK_O-NEXT:      (i32.const 1)
  ;; CHECK_O-NEXT:     )
  ;; CHECK_O-NEXT:    )
  ;; CHECK_O-NEXT:   )
  ;; CHECK_O-NEXT:  )
  ;; CHECK_O-NEXT: )
  (func $main-infinite
    ;; We cannot remove in this case as the pointless work may have an infinite
    ;; loop, which we do not eliminate.
    (if
      (call $infinite-work
        (i32.const 0)
      )
      (then
        (drop
          (call $infinite-work
            (i32.const 1)
          )
        )
      )
    )
  )

  ;; CHECK_0:      (func $pointless-work (type $1) (param $x i32) (result i32)
  ;; CHECK_0-NEXT:  (local.set $x
  ;; CHECK_0-NEXT:   (i32.add
  ;; CHECK_0-NEXT:    (local.get $x)
  ;; CHECK_0-NEXT:    (i32.const 1)
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:  )
  ;; CHECK_0-NEXT:  (if
  ;; CHECK_0-NEXT:   (i32.ge_u
  ;; CHECK_0-NEXT:    (local.get $x)
  ;; CHECK_0-NEXT:    (i32.const 12345678)
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:   (then
  ;; CHECK_0-NEXT:    (local.set $x
  ;; CHECK_0-NEXT:     (i32.add
  ;; CHECK_0-NEXT:      (local.get $x)
  ;; CHECK_0-NEXT:      (i32.const 1)
  ;; CHECK_0-NEXT:     )
  ;; CHECK_0-NEXT:    )
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:  )
  ;; CHECK_0-NEXT:  (return
  ;; CHECK_0-NEXT:   (local.get $x)
  ;; CHECK_0-NEXT:  )
  ;; CHECK_0-NEXT: )
  ;; CHECK_1:      (func $pointless-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_1-NEXT:  (if (result i32)
  ;; CHECK_1-NEXT:   (i32.ge_u
  ;; CHECK_1-NEXT:    (local.tee $0
  ;; CHECK_1-NEXT:     (i32.add
  ;; CHECK_1-NEXT:      (local.get $0)
  ;; CHECK_1-NEXT:      (i32.const 1)
  ;; CHECK_1-NEXT:     )
  ;; CHECK_1-NEXT:    )
  ;; CHECK_1-NEXT:    (i32.const 12345678)
  ;; CHECK_1-NEXT:   )
  ;; CHECK_1-NEXT:   (then
  ;; CHECK_1-NEXT:    (i32.add
  ;; CHECK_1-NEXT:     (local.get $0)
  ;; CHECK_1-NEXT:     (i32.const 1)
  ;; CHECK_1-NEXT:    )
  ;; CHECK_1-NEXT:   )
  ;; CHECK_1-NEXT:   (else
  ;; CHECK_1-NEXT:    (local.get $0)
  ;; CHECK_1-NEXT:   )
  ;; CHECK_1-NEXT:  )
  ;; CHECK_1-NEXT: )
  ;; CHECK_3:      (func $pointless-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_3-NEXT:  (if (result i32)
  ;; CHECK_3-NEXT:   (i32.ge_u
  ;; CHECK_3-NEXT:    (local.tee $0
  ;; CHECK_3-NEXT:     (i32.add
  ;; CHECK_3-NEXT:      (local.get $0)
  ;; CHECK_3-NEXT:      (i32.const 1)
  ;; CHECK_3-NEXT:     )
  ;; CHECK_3-NEXT:    )
  ;; CHECK_3-NEXT:    (i32.const 12345678)
  ;; CHECK_3-NEXT:   )
  ;; CHECK_3-NEXT:   (then
  ;; CHECK_3-NEXT:    (i32.add
  ;; CHECK_3-NEXT:     (local.get $0)
  ;; CHECK_3-NEXT:     (i32.const 1)
  ;; CHECK_3-NEXT:    )
  ;; CHECK_3-NEXT:   )
  ;; CHECK_3-NEXT:   (else
  ;; CHECK_3-NEXT:    (local.get $0)
  ;; CHECK_3-NEXT:   )
  ;; CHECK_3-NEXT:  )
  ;; CHECK_3-NEXT: )
  ;; CHECK_s:      (func $pointless-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_s-NEXT:  (if (result i32)
  ;; CHECK_s-NEXT:   (i32.ge_u
  ;; CHECK_s-NEXT:    (local.tee $0
  ;; CHECK_s-NEXT:     (i32.add
  ;; CHECK_s-NEXT:      (local.get $0)
  ;; CHECK_s-NEXT:      (i32.const 1)
  ;; CHECK_s-NEXT:     )
  ;; CHECK_s-NEXT:    )
  ;; CHECK_s-NEXT:    (i32.const 12345678)
  ;; CHECK_s-NEXT:   )
  ;; CHECK_s-NEXT:   (then
  ;; CHECK_s-NEXT:    (i32.add
  ;; CHECK_s-NEXT:     (local.get $0)
  ;; CHECK_s-NEXT:     (i32.const 1)
  ;; CHECK_s-NEXT:    )
  ;; CHECK_s-NEXT:   )
  ;; CHECK_s-NEXT:   (else
  ;; CHECK_s-NEXT:    (local.get $0)
  ;; CHECK_s-NEXT:   )
  ;; CHECK_s-NEXT:  )
  ;; CHECK_s-NEXT: )
  ;; CHECK_O:      (func $pointless-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_O-NEXT:  (if (result i32)
  ;; CHECK_O-NEXT:   (i32.ge_u
  ;; CHECK_O-NEXT:    (local.tee $0
  ;; CHECK_O-NEXT:     (i32.add
  ;; CHECK_O-NEXT:      (local.get $0)
  ;; CHECK_O-NEXT:      (i32.const 1)
  ;; CHECK_O-NEXT:     )
  ;; CHECK_O-NEXT:    )
  ;; CHECK_O-NEXT:    (i32.const 12345678)
  ;; CHECK_O-NEXT:   )
  ;; CHECK_O-NEXT:   (then
  ;; CHECK_O-NEXT:    (i32.add
  ;; CHECK_O-NEXT:     (local.get $0)
  ;; CHECK_O-NEXT:     (i32.const 1)
  ;; CHECK_O-NEXT:    )
  ;; CHECK_O-NEXT:   )
  ;; CHECK_O-NEXT:   (else
  ;; CHECK_O-NEXT:    (local.get $0)
  ;; CHECK_O-NEXT:   )
  ;; CHECK_O-NEXT:  )
  ;; CHECK_O-NEXT: )
  (func $pointless-work (param $x i32) (result i32)
    ;; Some pointless work, with no side effects, that cannot be inlined. (The
    ;; changes here are not important for this test.)
    (local.set $x
      (i32.add
        (local.get $x)
        (i32.const 1)
      )
    )
    (if
      (i32.ge_u
        (local.get $x)
        (i32.const 12345678)
      )
      (then
        (local.set $x
          (i32.add
            (local.get $x)
            (i32.const 1)
          )
        )
      )
    )
    (return
      (local.get $x)
    )
  )

  ;; CHECK_0:      (func $infinite-work (type $1) (param $x i32) (result i32)
  ;; CHECK_0-NEXT:  (loop $loop
  ;; CHECK_0-NEXT:   (local.set $x
  ;; CHECK_0-NEXT:    (i32.add
  ;; CHECK_0-NEXT:     (local.get $x)
  ;; CHECK_0-NEXT:     (i32.const 1)
  ;; CHECK_0-NEXT:    )
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:   (br_if $loop
  ;; CHECK_0-NEXT:    (local.get $x)
  ;; CHECK_0-NEXT:   )
  ;; CHECK_0-NEXT:  )
  ;; CHECK_0-NEXT:  (return
  ;; CHECK_0-NEXT:   (local.get $x)
  ;; CHECK_0-NEXT:  )
  ;; CHECK_0-NEXT: )
  ;; CHECK_1:      (func $infinite-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_1-NEXT:  (loop $loop
  ;; CHECK_1-NEXT:   (br_if $loop
  ;; CHECK_1-NEXT:    (local.tee $0
  ;; CHECK_1-NEXT:     (i32.add
  ;; CHECK_1-NEXT:      (local.get $0)
  ;; CHECK_1-NEXT:      (i32.const 1)
  ;; CHECK_1-NEXT:     )
  ;; CHECK_1-NEXT:    )
  ;; CHECK_1-NEXT:   )
  ;; CHECK_1-NEXT:  )
  ;; CHECK_1-NEXT:  (local.get $0)
  ;; CHECK_1-NEXT: )
  ;; CHECK_3:      (func $infinite-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_3-NEXT:  (loop $loop
  ;; CHECK_3-NEXT:   (br_if $loop
  ;; CHECK_3-NEXT:    (local.tee $0
  ;; CHECK_3-NEXT:     (i32.add
  ;; CHECK_3-NEXT:      (local.get $0)
  ;; CHECK_3-NEXT:      (i32.const 1)
  ;; CHECK_3-NEXT:     )
  ;; CHECK_3-NEXT:    )
  ;; CHECK_3-NEXT:   )
  ;; CHECK_3-NEXT:  )
  ;; CHECK_3-NEXT:  (local.get $0)
  ;; CHECK_3-NEXT: )
  ;; CHECK_s:      (func $infinite-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_s-NEXT:  (loop $loop
  ;; CHECK_s-NEXT:   (br_if $loop
  ;; CHECK_s-NEXT:    (local.tee $0
  ;; CHECK_s-NEXT:     (i32.add
  ;; CHECK_s-NEXT:      (local.get $0)
  ;; CHECK_s-NEXT:      (i32.const 1)
  ;; CHECK_s-NEXT:     )
  ;; CHECK_s-NEXT:    )
  ;; CHECK_s-NEXT:   )
  ;; CHECK_s-NEXT:  )
  ;; CHECK_s-NEXT:  (local.get $0)
  ;; CHECK_s-NEXT: )
  ;; CHECK_O:      (func $infinite-work (type $1) (param $0 i32) (result i32)
  ;; CHECK_O-NEXT:  (loop $loop
  ;; CHECK_O-NEXT:   (br_if $loop
  ;; CHECK_O-NEXT:    (local.tee $0
  ;; CHECK_O-NEXT:     (i32.add
  ;; CHECK_O-NEXT:      (local.get $0)
  ;; CHECK_O-NEXT:      (i32.const 1)
  ;; CHECK_O-NEXT:     )
  ;; CHECK_O-NEXT:    )
  ;; CHECK_O-NEXT:   )
  ;; CHECK_O-NEXT:  )
  ;; CHECK_O-NEXT:  (local.get $0)
  ;; CHECK_O-NEXT: )
  (func $infinite-work (param $x i32) (result i32)
    ;; Some work with no side effects aside from that it appears to potentially
    ;; do infinite work, due to a loop. (The changes here are not important for
    ;; this test.)
    (loop $loop
      (local.set $x
        (i32.add
          (local.get $x)
          (i32.const 1)
        )
      )
      (br_if $loop
        (local.get $x)
      )
    )
    (return
      (local.get $x)
    )
  )
)
