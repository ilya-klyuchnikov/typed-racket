#lang s-exp typed-racket/base-env/extra-env-lang

;; This module provides a base type environment including
;; racket/draw bindings

(begin
 (require racket/draw/private/bitmap
          racket/draw/private/bitmap-dc
          racket/draw/private/brush
          racket/draw/private/color
          racket/draw/private/font
          racket/draw/private/font-dir
          racket/draw/private/gl-config
          racket/draw/private/gl-context
          racket/draw/private/gradient
          racket/draw/private/pen
          racket/draw/private/record-dc
          racket/draw/private/region
          (for-syntax (only-in (rep type-rep) make-Instance))
          (only-in typed/racket/base -> U)
          "private/gui-types.rkt"
          (for-syntax (submod "private/gui-types.rkt" #%type-decl)))

 (provide (all-from-out racket/draw/private/bitmap
                        racket/draw/private/bitmap-dc
                        racket/draw/private/brush
                        racket/draw/private/color
                        racket/draw/private/font
                        racket/draw/private/pen
                        racket/draw/private/region)
          LoadFileKind
          Font-Family
          Font-Style
          Font-Weight
          Font-Smoothing
          Font-Hinting
          Bitmap%
          Bitmap-DC%
          Brush-Style
          Brush%
          Brush-List%
          Color%
          Color-Database<%>
          DC<%>
          Font%
          Font-List%
          GL-Config%
          GL-Context<%>
          Linear-Gradient%
          Pen%
          Pen-List%
          Pen-Style
          Pen-Cap-Style
          Pen-Join-Style
          Point%
          Radial-Gradient%
          Region%))

(begin-for-syntax
  (define -Bitmap% (parse-type #'Bitmap%))
  (define -Color% (parse-type #'Color%))
  (define -Brush-Style (parse-type #'Brush-Style))
  (define -Pen-Style (parse-type #'Pen-Style))
  (define -Pen-Cap-Style (parse-type #'Pen-Cap-Style))
  (define -Pen-Join-Style (parse-type #'Pen-Join-Style))
  (define -Font-Family (parse-type #'Font-Family))
  (define -Font-Style (parse-type #'Font-Style))
  (define -Font-Weight (parse-type #'Font-Weight))
  (define -Font-Smoothing (parse-type #'Font-Smoothing))
  (define -Font-Hinting (parse-type #'Font-Hinting))
  (define -LoadFileKind (parse-type #'LoadFileKind)))

(type-environment
 [bitmap% (parse-type #'Bitmap%)]
 [bitmap-dc% (parse-type #'Bitmap-DC%)]
 [brush% (parse-type #'Brush%)]
 [brush-list% (parse-type #'Brush-List%)]
 [color% (parse-type #'Color%)]
 [font% (parse-type #'Font%)]
 [font-list% (parse-type #'Font-List%)]
 [get-current-gl-context (parse-type #'(-> (U #f GL-Context<%>)))]
 [gl-config% (parse-type #'GL-Config%)]
 [linear-gradient% (parse-type #'Linear-Gradient%)]
 [pen% (parse-type #'Pen%)]
 [radial-gradient% (parse-type #'Radial-Gradient%)]
 [region% (parse-type #'Region%)]
 ;; 26 Drawing Functions
 ; current-ps-setup
 [get-face-list (->optkey [(one-of/c 'mono 'all)]
                          #:all-variants? Univ #f
                          (-lst -String))]
 [get-family-builtin-face (-> -Font-Family -String)]
 [make-bitmap
  (->optkey -PosInt -PosInt [Univ] #:backing-scale -Real #f
            (make-Instance (parse-type #'Bitmap%)))]
 [make-brush
  (->key #:color (Un -String (-inst -Color%)) #f
         #:style -Brush-Style #f
         #:gradient (Un (-val #f)
                        (-inst (parse-type #'Linear-Gradient%))
                        (-inst (parse-type #'Radial-Gradient%)))
                    #f
         #:transformation (-opt (-vec* (-vec* -Real -Real -Real
                                              -Real -Real -Real)
                                       -Real -Real -Real -Real -Real))
                          #f
         #:immutable? Univ #f
         (-inst (parse-type #'Bitmap%)))]
 [make-color
  (->optkey -Byte -Byte -Byte
            [-Real]
            #:immutable? Univ #f
            (-inst -Color%))]
 [make-font
  (->key #:size -Real #f
         #:face (-opt -String) #f
         #:family -Font-Family #f
         #:style -Font-Style #f
         #:weight -Font-Weight #f
         #:underlined? Univ #f
         #:smoothing -Font-Smoothing #f
         #:size-in-pizels? Univ #f
         #:hinting -Font-Hinting #f
         (-inst (parse-type #'Font%)))]
 [make-monochrome-bitmap
  (->* (list -Integer -Integer) (-opt -Bytes) (-inst -Bitmap%))]
 [make-pen
  (->key #:color (Un -String (-inst -Color%)) #f
         #:width -Real #f
         #:style -Pen-Style #f
         #:cap -Pen-Cap-Style #f
         #:join -Pen-Join-Style #f
         #:stipple (-opt (-inst -Bitmap%)) #f
         #:immutable? Univ #f
         (-inst (parse-type #'Pen%)))]
 [make-platform-bitmap
  (->key -Integer -Integer #:backing-scale -Real #f (-inst -Bitmap%))]
 [read-bitmap
  (->optkey (Un -Pathlike -Input-Port)
            [-LoadFileKind (Un (make-Instance (parse-type #'Color%)) (-val #f)) Univ]
            #:backing-scale -Real #f
            #:try-@2x? Univ #f
            (make-Instance (parse-type #'Bitmap%)))]
 [recorded-datum->procedure
  (-> Univ (-> (-inst (parse-type #'DC<%>)) -Void))]
 [the-brush-list (make-Instance (parse-type #'Brush-List%))]
 [the-color-database (make-Instance (parse-type #'Color-Database<%>))]
 [the-font-list (make-Instance (parse-type #'Font-List%))]
 ; font-name-directory
 [the-pen-list (make-Instance (parse-type #'Pen-List%))])