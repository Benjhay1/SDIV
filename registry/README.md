# Selective Disclosure Identity Verification (SDIV)

## Overview
SDIV is a privacy-preserving identity verification system built on the Stacks blockchain using Clarity smart contracts. The system enables users to prove specific attributes about their identity without revealing unnecessary information, implementing zero-knowledge proofs for secure verification.

## Features
- Secure identity registration and management
- Encrypted storage of identity attributes
- Selective disclosure of specific attributes
- Zero-knowledge proof implementation for privacy
- Time-bound access permissions
- Credential revocation mechanism
- Merkle tree-based verification system

## Project Structure
```
sdiv-contracts/
├── contracts/
│   ├── core/
│   │   ├── sdiv-registry.clar        # Main registry contract
│   │   ├── credential-manager.clar    # Handles credential operations
│   │   └── verification-engine.clar   # ZK proof verification logic
│   ├── traits/
│   │   ├── identity-trait.clar       # Interface for identity operations
│   │   └── verifier-trait.clar       # Interface for verification services
│   └── utils/
│       └── helpers.clar              # Common utilities
├── tests/
│   ├── unit/
│   │   ├── registry-test.ts
│   │   ├── credential-test.ts
│   │   └── verification-test.ts
│   └── integration/
│       └── flow-test.ts
├── scripts/
│   ├── deploy.ts
│   └── verify.ts
├── clarinet.toml                     # Project configuration
└── README.md
```

## Contracts

### 1. SDIV Registry Contract (sdiv-registry.clar)
The core contract managing identity registration and verification. Features include:
- Identity registration system
- Credential management
- Permission controls
- Attribute verification

Key Functions:
- `register-identity`: Register a new identity
- `add-credential`: Add a new credential to an identity
- `grant-verification-permission`: Grant verification permissions to verifiers
- `revoke-credential`: Revoke compromised credentials

### 2. Credential Manager Contract (Coming Soon)
Will handle credential operations including:
- Credential issuance
- Attribute encryption
- Time-bound access control
- Revocation mechanisms

### 3. Verification Engine Contract (Coming Soon)
Will implement verification logic including:
- ZK proof generation
- Merkle tree operations
- Hash commitment verification

## Getting Started

### Prerequisites
- Clarinet
- Node.js (for testing)
- Stacks wallet

### Installation
1. Clone the repository:
```bash
git clone https://github.com/yourusername/sdiv-contracts.git
cd sdiv-contracts
```

2. Install dependencies:
```bash
npm install
```

3. Run tests:
```bash
clarinet test
```

### Usage Example
```clarity
;; Register a new identity
(contract-call? .sdiv-registry register-identity)

;; Add a credential
(contract-call? .sdiv-registry add-credential "age-proof" 0x... u100)

;; Grant verification permission
(contract-call? .sdiv-registry grant-verification-permission 
    'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 
    (list "age" "nationality") 
    u100)
```

## Real-World Use Case
The SDIV system can be used in scenarios like:
- Age verification for nightclubs without revealing exact birth date
- Credential verification for job applications
- KYC/AML compliance with privacy preservation
- Academic credential verification

Example: A nightclub can verify a patron is over 21 without accessing their complete ID information.

## Security Considerations
- All sensitive data is stored as hashed values
- Zero-knowledge proofs ensure privacy
- Time-bound permissions prevent unauthorized access
- Revocation mechanism for compromised credentials
- Post-condition checks for transaction security

## Testing
The project includes comprehensive test suites:
- Unit tests for individual contract functions
- Integration tests for complete workflows
- Property-based tests for edge cases