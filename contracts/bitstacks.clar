;; Title: BitStacks Insight Protocol: Decentralized Analytics with Bitcoin-Aligned Governance
;;
;; Summary:
;; A Stacks L2-native analytics engine combining Bitcoin-settled security with advanced tokenomics,
;; featuring dynamic staking tiers, governance-weighted participation, and algorithmic reward distribution.
;; Protocol operations are verifiable through Bitcoin-anchored transactions via Stacks L2.
;;
;; Description:
;; BitStacks Insight Protocol (BIP) redefines decentralized analytics infrastructure through:
;; - Bitcoin-backed security: All governance actions and stake settlements finalized on Bitcoin L1
;; - Adaptive Staking Matrix: Tiered rewards based on stake duration/amount with lock-up multipliers
;; - Governance Power Escalation: Voting weight tied to stake commitment and protocol participation
;; - STX Liquidity Engine: Non-custodial staking pool supporting Stacks L2 ecosystem growth
;; - Compliance Architecture: On-chain audit trails compatible with Bitcoin's regulatory framework
;;
;; Technical Architecture:
;; 1. Bitcoin-Connected Governance: Proposal lifecycle anchored through Stacks L2->L1 proofs
;; 2. Time-Variable Staking: Reward curves adapt to network participation metrics
;; 3. Multi-Sig Security Model: Hybrid authorization with Bitcoin script compatibility
;; 4. Layer-2 Efficiency: High-frequency analytics computations offloaded from Bitcoin mainchain

;; Token Definition
(define-fungible-token ANALYTICS-TOKEN u0)

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-INVALID-PROTOCOL (err u1001))
(define-constant ERR-INVALID-AMOUNT (err u1002))
(define-constant ERR-INSUFFICIENT-STX (err u1003))
(define-constant ERR-COOLDOWN-ACTIVE (err u1004))
(define-constant ERR-NO-STAKE (err u1005))
(define-constant ERR-BELOW-MINIMUM (err u1006))
(define-constant ERR-PAUSED (err u1007))

;; Protocol Configuration
(define-data-var contract-paused bool false)
(define-data-var emergency-mode bool false)
(define-data-var stx-pool uint u0)
(define-data-var base-reward-rate uint u500) ;; 5% base rate (100 = 1%)
(define-data-var bonus-rate uint u100) ;; 1% bonus for longer staking
(define-data-var minimum-stake uint u1000000) ;; Minimum stake amount
(define-data-var cooldown-period uint u1440) ;; 24 hour cooldown in blocks
(define-data-var proposal-count uint u0)

;; Data Structures
(define-map Proposals
    { proposal-id: uint }
    {
        creator: principal,
        description: (string-utf8 256),
        start-block: uint,
        end-block: uint,
        executed: bool,
        votes-for: uint,
        votes-against: uint,
        minimum-votes: uint
    }
)

(define-map UserPositions
    principal
    {
        total-collateral: uint,
        total-debt: uint,
        health-factor: uint,
        last-updated: uint,
        stx-staked: uint,
        analytics-tokens: uint,
        voting-power: uint,
        tier-level: uint,
        rewards-multiplier: uint
    }
)

(define-map StakingPositions
    principal
    {
        amount: uint,
        start-block: uint,
        last-claim: uint,
        lock-period: uint,
        cooldown-start: (optional uint),
        accumulated-rewards: uint
    }
)

(define-map TierLevels
    uint
    {
        minimum-stake: uint,
        reward-multiplier: uint,
        features-enabled: (list 10 bool)
    }
)

;; Private Functions

;; Determines user tier based on stake amount
(define-private (get-tier-info (stake-amount uint))
    (if (>= stake-amount u10000000)
        {tier-level: u3, reward-multiplier: u200}
        (if (>= stake-amount u5000000)
            {tier-level: u2, reward-multiplier: u150}
            {tier-level: u1, reward-multiplier: u100}
        )
    )
)

;; Calculates reward multiplier based on lock duration
(define-private (calculate-lock-multiplier (lock-period uint))
    (if (>= lock-period u8640)     ;; 2 months
        u150                       ;; 1.5x multiplier
        (if (>= lock-period u4320) ;; 1 month
            u125                   ;; 1.25x multiplier
            u100                   ;; 1x multiplier (no lock)
        )
    )
)

;; Computes rewards for a user based on stake and duration
(define-private (calculate-rewards (user principal) (blocks uint))
    (let
        (
            (staking-position (unwrap! (map-get? StakingPositions user) u0))
            (user-position (unwrap! (map-get? UserPositions user) u0))
            (stake-amount (get amount staking-position))
            (base-rate (var-get base-reward-rate))
            (multiplier (get rewards-multiplier user-position))
        )
        (/ (* (* (* stake-amount base-rate) multiplier) blocks) u14400000)
    )
)

;;  Validates proposal description length
(define-private (is-valid-description (desc (string-utf8 256)))
    (and 
        (>= (len desc) u10)   ;; Minimum description length
        (<= (len desc) u256)  ;; Maximum description length
    )
)