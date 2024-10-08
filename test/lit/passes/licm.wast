;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --licm -S -o - | filecheck %s

(module
 (memory 10 20)

 ;; CHECK:      (type $0 (func (param i32)))

 ;; CHECK:      (type $1 (func))

 ;; CHECK:      (memory $0 10 20)

 ;; CHECK:      (func $unreachable-get
 ;; CHECK-NEXT:  (local $x i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (loop $loop
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:   (nop)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $unreachable-get
  (local $x i32)
  (loop $loop
   (unreachable)
   ;; This loop is unreachable. We should not error on handling it (because it
   ;; is unreachable it does not have a basic block, which the analysis uses).
   ;; In this case it is fine to move it out of the loop (though it does not
   ;; really help much).
   (drop
    (local.get $x)
   )
  )
 )

 ;; CHECK:      (func $unreachable-get-call (param $p i32)
 ;; CHECK-NEXT:  (local $x i32)
 ;; CHECK-NEXT:  (loop $loop
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:   (call $unreachable-get-call
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $unreachable-get-call (param $p i32)
  (local $x i32)
  ;; As above, but now the get is in a call. We cannot move the call out, as it
  ;; may have side effects.
  (loop $loop
   (unreachable)
   (call $unreachable-get-call
    (local.get $x)
   )
  )
 )

 ;; CHECK:      (func $unreachable-get-store (param $p i32)
 ;; CHECK-NEXT:  (local $x i32)
 ;; CHECK-NEXT:  (loop $loop
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:   (i32.store
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (i32.const 10)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $unreachable-get-store (param $p i32)
  (local $x i32)
  ;; As above, but now the get is stored. This is a different effect than the
  ;; call in the function before us, and it too cannot be moved.
  (loop $loop
   (unreachable)
   (i32.store
    (local.get $x)
    (i32.const 10)
   )
  )
 )
)

