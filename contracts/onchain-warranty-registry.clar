;; =====================================================
;; OnChainWarrantyRegistry
;; Verifiable & transferable on-chain warranties
;; =====================================================

;; -----------------------------
;; Data Variables
;; -----------------------------

(define-data-var issuer principal tx-sender)

;; -----------------------------
;; Data Maps
;; -----------------------------

;; warranty-id => warranty details
(define-map warranties
  uint
  {
    owner: principal,
    issued-at: uint,
    expires-at: uint,
    active: bool
  }
)

(define-data-var warranty-count uint u0)

;; -----------------------------
;; Errors
;; -----------------------------

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-NOT-FOUND u101)
(define-constant ERR-EXPIRED u102)
(define-constant ERR-INACTIVE u103)

;; -----------------------------
;; Helpers
;; -----------------------------

(define-read-only (is-issuer)
  (is-eq tx-sender (var-get issuer))
)

;; -----------------------------
;; Warranty Issuance
;; -----------------------------

(define-public (issue-warranty
  (owner principal)
  (duration uint)
)
  (begin
    (asserts! (is-issuer) (err ERR-NOT-AUTHORIZED))
    (asserts! (> duration u0) (err ERR-EXPIRED))

    (let (
      (id (var-get warranty-count))
      (expiry (+ stacks-block-height duration))
    )
      (map-set warranties id {
        owner: owner,
        issued-at: stacks-block-height,
        expires-at: expiry,
        active: true
      })

      (var-set warranty-count (+ id u1))
      (ok id)
    )
  )
)

;; -----------------------------
;; Transfer Warranty
;; -----------------------------

(define-public (transfer-warranty
  (warranty-id uint)
  (new-owner principal)
)
  (let ((w (map-get? warranties warranty-id)))
    (match w data
      (begin
        (asserts! (is-eq tx-sender (get owner data)) (err ERR-NOT-AUTHORIZED))
        (asserts! (get active data) (err ERR-INACTIVE))

        (map-set warranties warranty-id {
          owner: new-owner,
          issued-at: (get issued-at data),
          expires-at: (get expires-at data),
          active: true
        })

        (ok true)
      )
      (err ERR-NOT-FOUND)
    )
  )
)

;; -----------------------------
;; Warranty Revocation
;; -----------------------------

(define-public (revoke-warranty (warranty-id uint))
  (begin
    (asserts! (is-issuer) (err ERR-NOT-AUTHORIZED))

    (let ((w (map-get? warranties warranty-id)))
      (match w data
        (begin
          (map-set warranties warranty-id {
            owner: (get owner data),
            issued-at: (get issued-at data),
            expires-at: (get expires-at data),
            active: false
          })
          (ok true)
        )
        (err ERR-NOT-FOUND)
      )
    )
  )
)

;; -----------------------------
;; Read-only Views
;; -----------------------------

(define-read-only (get-warranty (warranty-id uint))
  (map-get? warranties warranty-id)
)

(define-read-only (is-warranty-valid (warranty-id uint))
  (match (map-get? warranties warranty-id) w
    (and
      (get active w)
      (< stacks-block-height (get expires-at w))
    )
    false
  )
)
