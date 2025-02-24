# BitStacks Insight Protocol (BIP)

A Stacks L2-native analytics engine that combines Bitcoin-settled security with advanced tokenomics, featuring dynamic staking tiers, governance-weighted participation, and algorithmic reward distribution.

## Overview

BitStacks Insight Protocol redefines decentralized analytics infrastructure by leveraging Bitcoin's security through Stacks L2. The protocol implements a sophisticated staking and governance system with multiple tiers of participation and rewards.

## Key Features

### Bitcoin-Backed Security

- All governance actions and stake settlements are finalized on Bitcoin L1
- Utilizes Stacks L2 for efficient operations while maintaining Bitcoin's security guarantees

### Adaptive Staking Matrix

- Three-tiered staking system with increasing benefits
- Dynamic reward multipliers based on stake amount and lock duration
- Flexible lock periods: no lock, 1 month, or 2 months
- Cooldown period mechanism for unstaking

### Governance System

- Proposal creation and voting mechanisms
- Voting power tied to stake commitment
- Minimum voting power requirements for proposal creation
- Configurable voting periods

### Security Features

- Emergency pause functionality
- Multi-tiered authorization system
- Cooldown periods for unstaking
- Minimum stake requirements

## Technical Architecture

### Staking Tiers

| Tier | Minimum Stake (uSTX) | Reward Multiplier | Features Enabled  |
| ---- | -------------------- | ----------------- | ----------------- |
| 1    | 1,000,000            | 1x                | Basic features    |
| 2    | 5,000,000            | 1.5x              | Enhanced features |
| 3    | 10,000,000           | 2x                | Full access       |

### Lock Period Multipliers

| Lock Duration | Multiplier |
| ------------- | ---------- |
| No Lock       | 1x         |
| 1 Month       | 1.25x      |
| 2 Months      | 1.5x       |

## Smart Contract Functions

### Public Functions

#### Staking Operations

- `stake-stx`: Stake STX tokens with optional lock period
- `initiate-unstake`: Begin the unstaking process
- `complete-unstake`: Finalize unstaking after cooldown

#### Governance

- `create-proposal`: Create a new governance proposal
- `vote-on-proposal`: Cast votes on active proposals

#### Administrative

- `initialize-contract`: Set up initial protocol configuration
- `pause-contract`: Pause contract operations
- `resume-contract`: Resume contract operations

### Read-Only Functions

- `get-contract-owner`: Returns contract owner address
- `get-stx-pool`: Returns current STX pool balance
- `get-proposal-count`: Returns total number of proposals

## Data Structures

### UserPositions

Tracks user-specific data including:

- Total collateral and debt
- Health factor
- Staked STX amount
- Analytics tokens
- Voting power
- Tier level
- Rewards multiplier

### StakingPositions

Manages staking-specific information:

- Staked amount
- Start block
- Last claim timestamp
- Lock period
- Cooldown status
- Accumulated rewards

### Proposals

Stores governance proposal details:

- Creator address
- Description
- Start and end blocks
- Execution status
- Vote tallies
- Minimum vote requirements

## Error Codes

| Code | Description                     |
| ---- | ------------------------------- |
| 1000 | Not authorized                  |
| 1001 | Invalid protocol parameters     |
| 1002 | Invalid amount                  |
| 1003 | Insufficient STX                |
| 1004 | Cooldown period active          |
| 1005 | No stake found                  |
| 1006 | Below minimum stake requirement |
| 1007 | Contract paused                 |

## Security Considerations

1. **Cooldown Period**: Enforces a 24-hour cooldown period for unstaking to prevent manipulation
2. **Minimum Stakes**: Requires minimum stake amounts to participate
3. **Authorization Checks**: Strict validation of user permissions and ownership
4. **Emergency Controls**: Contract can be paused in case of emergencies
5. **Validation Checks**: Comprehensive input validation for all operations

## Best Practices for Integration

1. **Staking**:

   - Consider lock periods carefully as they affect reward multipliers
   - Monitor health factors and maintain adequate collateral
   - Be aware of cooldown periods when planning unstaking

2. **Governance**:

   - Ensure sufficient voting power before creating proposals
   - Review proposal parameters carefully
   - Consider voting period duration impacts

3. **Error Handling**:
   - Implement proper error handling for all contract interactions
   - Monitor transaction status and handle failures gracefully
   - Validate inputs before sending transactions

## Development and Testing

For local development and testing:

1. Deploy the contract
2. Initialize the contract using `initialize-contract`
3. Verify tier levels and reward multipliers
4. Test staking and unstaking mechanisms
5. Validate governance functionality
6. Ensure proper error handling
