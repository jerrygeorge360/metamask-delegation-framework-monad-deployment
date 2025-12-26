# Delegation Framework

> [!NOTE]  
> **Monad Testnet Deployment**: This repository was cloned and deployed to Monad testnet following a network reset. The contracts have been deployed and verified on Monad testnet for testing and development purposes.

> [!WARNING]
> We use tags for audited versions of code releases and the `main` branch is the working development branch. All PRs should be based against `main` branch.

### Getting Started

1. **Fork the repository**:

   - Click the "Fork" button at the top right of the repository page.

2. **Clone your fork**:
   ```shell
   git clone https://github.com/<your-username>/delegation-framework.git
   ```
3. **Create Working Branch**:
   ```shell
   git checkout -b feat/example-branch
   ```

# DeleGator Smart Account

A DeleGator Smart Account is a 4337-compatible Smart Account that implements delegation functionality. An end user will operate through a DeleGatorProxy which uses a chosen DeleGator implementation.

## Overview

An end user controls a DeleGator Proxy that USES a DeleGator Implementation, which IMPLEMENTS DeleGatorCore and interacts with a DelegationManager.

### Delegations

A Delegation enables the ability to share the capability to invoke some onchain action entirely offchain in a secure manner. [Caveats](#caveats) can be combined to create delegations with restricted functionality that users can extend, share or redeem.

A simple example is "Alice delegates the ability to use her USDC to Bob limiting the amount to 100 USDC".

[Read more on "Delegations" ->](/documents/DelegationManager.md#Delegations)

### DeleGator

A DeleGator is the contract an end user controls and uses to interact with other contracts onchain. A DeleGator is an [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967) proxy contract that uses a DeleGator Implementation which defines the granular details of how the DeleGator works. Users are free to migrate their DeleGator Implementation as their needs change.

### DeleGator Core

The DeleGator Core includes the Delegation execution and ERC-4337 functionality to make the Smart Account work.

[Read more on "DeleGator Core" ->](/documents/DeleGatorCore.md)

### EIP7702 DeleGator Core

The DeleGator 7702 Core includes the Delegation execution and ERC-4337 functionality to make the Smart Account work but without UUPS proxy functionalities.

[Read more on "EIP7702 DeleGator Core" ->](/documents/EIP7702DeleGator.md)

### DeleGator Implementation

A DeleGator Implementation contains the logic for a DeleGator Smart Account. Each DeleGator Implementation must include the required methods for a DeleGator Smart Account, namely the signature scheme to be used for verifying access to control the contract. A few examples are the MultiSigDeleGator and the HybridDeleGator.

[Read more on "MultiSig DeleGator" ->](/documents/MultisigDeleGator.md)

[Read more on "Hybrid DeleGator" ->](/documents/HybridDeleGator.md)

[Read more on "EIP7702 Stateless DeleGator" ->](/documents/EIP7702DeleGator.md)

### Delegation Manager

The Delegation Manager includes the logic for validating and executing Delegations.

[Read more on "Delegation Manager" ->](/documents/DelegationManager.md)

### Caveat Enforcers

Caveats are used to add restrictions and rules for Delegations. By default, a Delegation allows the delegate to make **any** onchain action so caveats are strongly recommended. They are managed by Caveat Enforcer contracts.

Developers can build new Caveat Enforcers for their own use cases, and the possibilities are endless. Developers can optimize their Delegations by making extremely specific and granular caveats for their individual use cases.

[Read more on "Caveats" ->](/documents/DelegationManager.md#Caveats)

### Security

See [Security Guidelines](/documents/Security.md) for security considerations.

## Development

### Third Party Developers

There's several touchpoints where developers may be using or extending a DeleGator Smart Account.

- Developers can build custom DeleGator Implementations that use the [DeleGator Core](/src/DeleGatorCore.sol) or [EIP7702 DeleGator Core](/src/EIP7702/EIP7702DeleGatorCore.sol) to create new ways for end users to control and manage their Smart Accounts.
- Developers can write any contract that meets the [DeleGator Core Interface](/src/interfaces/IDeleGatorCore.sol) to create novel ways of delegating functionality.
- Developers can create custom Caveat Enforcers to refine the capabilities of a delegation for any use case they imagine.
- Developers can craft Delegations to then share onchain capabilities entirely offchain.

### Foundry

This repo uses [Foundry](https://book.getfoundry.sh/).

#### Build

```shell
forge build
```

#### Test

```shell
forge test
```

#### Deploying

1. Copy `.env.example` to `.env` and populate the variables depending on the deployment scripts that you will execute.

```shell
source .env
```

2. For local testing, use [Anvil](https://book.getfoundry.sh/reference/anvil/) to run a local fork of a blockchain to develop in an isolated environment. Or obtain the RPC url for the blockchain to deploy.

```shell
# Example of a forked local environment using anvil
anvil -f <your_rpc_url>
```

3. Deploy the necessary contracts.

> NOTE: As this system matures, this step will no longer be required for public chains where the DeleGator is in use.

```shell
# Deploys the Delegation Manager, Multisig and Hybrid DeleGator implementations
forge script script/DeployDelegationFramework.s.sol --rpc-url <your_rpc_url> --private-key $PRIVATE_KEY --broadcast

# Deploys all the caveat enforcers
forge script script/DeployCaveatEnforcers.s.sol --rpc-url <your_rpc_url> --private-key $PRIVATE_KEY --broadcast

# Deploys the EIP7702 Staless DeleGator
forge script script/DeployEIP7702StatelessDeleGator.s.sol --rpc-url <your_rpc_url> --private-key $PRIVATE_KEY --broadcast

# Deploys a MultisigDeleGator on a UUPS proxy
forge script script/DeployMultiSigDeleGator.s.sol --private-key $PRIVATE_KEY --broadcast
```

### Deployments

[Read more on "Deployments" ->](/documents/Deployments.md)

#### Monad Testnet Deployment

The delegation framework has been deployed to Monad testnet (Chain ID: 10143) following a network reset. Key deployment details:

- **Network**: Monad Testnet
- **Chain ID**: 10143  
- **RPC URL**: https://testnet-rpc.monad.xyz
- **Explorer**: https://testnet.monadscan.com

**Core Contract Addresses:**

| Contract | Address |
|----------|---------|
| DelegationManager | [`0x04b8a285e512fd6f3901a9672a6c9ae5ec8a22ec`](https://testnet.monadscan.com/address/0x04b8a285e512fd6f3901a9672a6c9ae5ec8a22ec) |
| MultiSigDeleGator | [`0x2618a497ae6fda0600060fbbb2d3e9ea81904087`](https://testnet.monadscan.com/address/0x2618a497ae6fda0600060fbbb2d3e9ea81904087) |
| HybridDeleGator | [`0x8ed2a135d37d196b47a6ee2b349959e770040aa3`](https://testnet.monadscan.com/address/0x8ed2a135d37d196b47a6ee2b349959e770040aa3) |
| EIP7702StatelessDeleGator | [`0x31e851ddd4c2dd475315bc8449a40e4b44cc3ae2`](https://testnet.monadscan.com/address/0x31e851ddd4c2dd475315bc8449a40e4b44cc3ae2) |
| SimpleFactory | [`0x69aa2f9fe1572f1b640e1bbc512f5c3a734fc77c`](https://testnet.monadscan.com/address/0x69aa2f9fe1572f1b640e1bbc512f5c3a734fc77c) |

**Notable Enforcer Contracts:**

| Contract | Address |
|----------|---------|
| AllowedCalldataEnforcer | [`0xc2b0d624c1c4319760C96503BA27C347F3260f55`](https://testnet.monadscan.com/address/0xc2b0d624c1c4319760C96503BA27C347F3260f55) |
| AllowedMethodsEnforcer | [`0x2c21fD0Cb9DC8445CB3fb0DC5E7Bb0Aca01842B5`](https://testnet.monadscan.com/address/0x2c21fD0Cb9DC8445CB3fb0DC5E7Bb0Aca01842B5) |
| ERC20BalanceChangeEnforcer | [`0xcdF6aB796408598Cea671d79506d7D48E97a5437`](https://testnet.monadscan.com/address/0xcdF6aB796408598Cea671d79506d7D48E97a5437) |
| ERC721TransferEnforcer | [`0x3790e6B7233f779b09DA74C72b6e94813925b9aF`](https://testnet.monadscan.com/address/0x3790e6B7233f779b09DA74C72b6e94813925b9aF) |

All enforcer contracts have been deployed and verified on the Monad testnet. For a complete list of enforcer addresses, see the [`verifyenforcers.sh`](verifyenforcers.sh) script. Verification status can be checked on the Monad testnet explorer.

### Javascript

Currently in Gated Alpha phase. Sign up to be an early partner [here](https://gator.metamask.io).

### Notes

- We're building against Solidity [v0.8.23](https://github.com/ethereum/solidity/releases/tag/v0.8.23) for the time being.
- Format on save using the Forge formatter.

### Style Guide

[Read more on "Style Guide" ->](/documents/StyleGuide.md)

### Core Contributors

[Dan Finlay](https://github.com/danfinlay), [Ryan McPeck](https://github.com/McOso), [Dylan DesRosier](https://github.com/dylandesrosier), [Aditya Sharma](https://github.com/destroyersrt), [Hanzel Anchia Mena](https://github.com/hanzel98), [Idris Bowman](https://github.com/V00D00-child), [Jeff Smale](https://github.com/jeffsmale90), [Kevin Bluer](https://github.com/kevinbluer)

## Relevant Documents

- [EIP-712](https://eips.ethereum.org/EIPS/eip-712)
- [EIP-1014](https://eips.ethereum.org/EIPS/eip-1014)
- [EIP-1271](https://eips.ethereum.org/EIPS/eip-1271)
- [EIP-1822](https://eips.ethereum.org/EIPS/eip-1822)
- [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967)
- [EIP-4337](https://eips.ethereum.org/EIPS/eip-4337)
- [EIP-7201](https://eips.ethereum.org/EIPS/eip-7201)
- [EIP-7212](https://eips.ethereum.org/EIPS/eip-7212)
- [EIP-7579](https://eips.ethereum.org/EIPS/eip-7579)
- [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702)
- [EIP-7710](https://eips.ethereum.org/EIPS/eip-7710)
- [EIP-7821](https://eips.ethereum.org/EIPS/eip-7821)
