;; SDIV Registry Contract
;; This contract manages the core registry for Selective Disclosure Identity Verification

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-REGISTERED (err u101))
(define-constant ERR-NOT-REGISTERED (err u102))
(define-constant ERR-INVALID-CREDENTIAL (err u103))
(define-constant ERR-EXPIRED (err u104))

;; Data Variables
(define-data-var contract-owner principal tx-sender)
(define-data-var next-identity-id uint u0)

;; Data Maps
(define-map identities
    principal
    {
        identity-id: uint,
        status: (string-ascii 10),
        registration-time: uint,
        last-updated: uint
    }
)

(define-map credentials
    {identity-id: uint, credential-type: (string-ascii 20)}
    {
        hash: (buff 32),
        issuer: principal,
        issuance-date: uint,
        expiry-date: uint,
        revoked: bool
    }
)

(define-map attribute-permissions
    {identity-id: uint, verifier: principal}
    {
        allowed-attributes: (list 10 (string-ascii 20)),
        expiry: uint
    }
)

;; Public Functions

;; Register a new identity
(define-public (register-identity)
    (let
        (
            (caller tx-sender)
            (new-id (var-get next-identity-id))
        )
        (asserts! (is-none (map-get? identities caller)) ERR-ALREADY-REGISTERED)
        (map-set identities
            caller
            {
                identity-id: new-id,
                status: "active",
                registration-time: block-height,
                last-updated: block-height
            }
        )
        (var-set next-identity-id (+ new-id u1))
        (ok new-id)
    )
)

;; Add a new credential
(define-public (add-credential (credential-type (string-ascii 20)) (credential-hash (buff 32)) (expiry uint))
    (let
        (
            (caller tx-sender)
            (identity (unwrap! (map-get? identities caller) ERR-NOT-REGISTERED))
        )
        (asserts! (>= expiry block-height) ERR-EXPIRED)
        (map-set credentials
            {
                identity-id: (get identity-id identity),
                credential-type: credential-type
            }
            {
                hash: credential-hash,
                issuer: caller,
                issuance-date: block-height,
                expiry-date: expiry,
                revoked: false
            }
        )
        (ok true)
    )
)

;; Grant permission to a verifier
(define-public (grant-verification-permission 
    (verifier principal)
    (allowed-attributes (list 10 (string-ascii 20)))
    (expiry uint)
)
    (let
        (
            (caller tx-sender)
            (identity (unwrap! (map-get? identities caller) ERR-NOT-REGISTERED))
        )
        (asserts! (>= expiry block-height) ERR-EXPIRED)
        (map-set attribute-permissions
            {
                identity-id: (get identity-id identity),
                verifier: verifier
            }
            {
                allowed-attributes: allowed-attributes,
                expiry: expiry
            }
        )
        (ok true)
    )
)

;; Revoke a credential
(define-public (revoke-credential (credential-type (string-ascii 20)))
    (let
        (
            (caller tx-sender)
            (identity (unwrap! (map-get? identities caller) ERR-NOT-REGISTERED))
            (credential-key {
                identity-id: (get identity-id identity),
                credential-type: credential-type
            })
        )
        (match (map-get? credentials credential-key)
            credential
            (begin
                (map-set credentials
                    credential-key
                    (merge credential {revoked: true})
                )
                (ok true)
            )
            ERR-INVALID-CREDENTIAL
        )
    )
)

;; Read-only Functions

;; Check if an identity exists
(define-read-only (is-identity-registered (address principal))
    (is-some (map-get? identities address))
)

;; Get identity details
(define-read-only (get-identity-details (address principal))
    (map-get? identities address)
)

;; Check credential status
(define-read-only (get-credential-status (identity-id uint) (credential-type (string-ascii 20)))
    (map-get? credentials {identity-id: identity-id, credential-type: credential-type})
)

;; Check verification permissions
(define-read-only (get-verification-permissions (identity-id uint) (verifier principal))
    (map-get? attribute-permissions {identity-id: identity-id, verifier: verifier})
)

;; Contract initialization
(define-private (initialize-contract)
    (var-set contract-owner tx-sender)
)

;; Initialize contract on deploy
(initialize-contract)