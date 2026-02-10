On-Chain Warranty Registry

A **Clarity smart contract** for registering, tracking, and verifying product warranties directly on the Stacks blockchain.  
This contract provides a **tamper-proof, transparent, and trustless** registry for warranty issuance, ownership, and validity.

---

Overview

The **On-Chain Warranty Registry** enables manufacturers, sellers, and consumers to manage product warranties without relying on centralized databases. Once registered, warranty records become immutable and verifiable by anyone on-chain.

This contract is suitable for supply-chain systems, NFT-backed products, electronics, appliances, and decentralized marketplaces.

---

Key Features

- **On-chain warranty registration**
- **Warranty ownership transfer**
- **Warranty expiration tracking**
- **Public warranty verification**
- **Tamper-proof and immutable records**
- Minimal logic that passes `clarinet check`

---

Contract Design

Core Concepts

- **Warranty Record**  
  Stores product ID, owner, issuer, issuance block, and expiration block.

- **Ownership Transfer**  
  Allows warranties to move with the product when ownership changes.

- **Validity Checks**  
  Ensures warranties can be verified for authenticity and expiration.

---

Public Functions

| Function | Description |
|-------|------------|
| `register-warranty` | Registers a new product warranty |
| `transfer-warranty` | Transfers warranty ownership |
| `invalidate-warranty` | Marks a warranty as void (if supported) |

---

Read-Only Functions

- `get-warranty` – Returns full warranty details  
- `get-warranty-owner` – Returns current owner  
- `is-warranty-valid` – Checks if warranty is active and unexpired  
- `warranty-exists` – Confirms warranty registration  

---

Example Use Cases

- Consumer electronics warranties
- NFT-backed physical assets
- Supply chain product verification
- Resale markets with transferable warranties
- Decentralized commerce platforms

---

Security Considerations

- No centralized admin privileges
- Immutable warranty records after registration
- Transparent and auditable state
- Minimal attack surface through simple state transitions
- Fully deterministic on-chain logic

---

Deployment

1. Install Clarinet:
   ```bash
   npm install -g @hirosystems/clarinet


License

MIT License
