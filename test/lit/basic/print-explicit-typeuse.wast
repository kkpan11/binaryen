;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: wasm-opt %s --no-validation -S -o - | filecheck %s

;; Check that we print explicit type uses for function signatures when the
;; function type uses non-MVP features, whether or not those features are
;; actually enabled.

(module
  ;; CHECK:      (type $mvp (func))
  (type $mvp (func))
  ;; CHECK:      (type $open (sub (func)))
  (type $open (sub (func)))
  ;; CHECK:      (type $shared (shared (func)))
  (type $shared (shared (func)))
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $rec (func))
    (type $rec (func))
    ;; CHECK:       (type $other (struct))
    (type $other (struct))
  )

  ;; CHECK:      (import "" "" (func $mvp-import))
  (import "" "" (func $mvp-import))

  ;; CHECK:      (import "" "" (func $open-import (type $open)))
  (import "" "" (func $open-import (type $open)))

  ;; CHECK:      (import "" "" (func $shared-import (type $shared)))
  (import "" "" (func $shared-import (type $shared)))

  ;; CHECK:      (import "" "" (func $rec-import (type $rec)))
  (import "" "" (func $rec-import (type $rec)))

  ;; CHECK:      (func $mvp
  ;; CHECK-NEXT: )
  (func $mvp (type $mvp))
  ;; CHECK:      (func $open (type $open)
  ;; CHECK-NEXT: )
  (func $open (type $open))
  ;; CHECK:      (func $shared (type $shared)
  ;; CHECK-NEXT: )
  (func $shared (type $shared))
  ;; CHECK:      (func $rec (type $rec)
  ;; CHECK-NEXT: )
  (func $rec (type $rec))
)
