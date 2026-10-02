# Tokenizer — Nofy42 Token (NF42)

> Version française

Projet *Tokenizer* de l'école 42 : création, déploiement et publication d'un
token **BEP-20** sur une blockchain publique de test.

---

## Le token

| | |
|---|---|
| Nom | Nofy42 Token |
| Ticker | NF42 |
| Standard | BEP-20 |
| Supply | 1 000 000 NF42 (fixe) |
| Décimales | 18 |
| Réseau | **BNB Smart Chain Testnet** (Chain ID `97`) |
| Adresse du contrat | **`0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754`** |
| BscScan | https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754 |

Le code source est vérifié et publié sur BscScan (*Exact Match*).

---

## Structure du repo

| Dossier | Contenu |
|---|---|
| [`code/`](code/) | Le smart contract en Solidity : [`nofy42.sol`](code/nofy42.sol) |
| [`deployment/`](deployment/) | Les étapes et les réglages pour déployer le token |
| [`documentation/`](documentation/) | Le fonctionnement du token et son utilisation |

---

## Choix et justifications

### Blockchain : BNB Smart Chain (Testnet)
- Le sujet est réalisé en partenariat avec BNB Chain.
- BSC est **compatible EVM** : on y utilise Solidity et les mêmes outils
  qu'Ethereum, très bien documentés.
- Les frais (gas) sont faibles, et le **testnet** permet de tout faire avec des
  tBNB gratuits obtenus sur le faucet. Le sujet interdit d'utiliser de l'argent
  réel.

### Standard : BEP-20
- C'est la norme des tokens sur BNB Chain, exigée par le sujet.
- BEP-20 est **identique à ERC-20** (mêmes fonctions, mêmes events). C'est
  pour ça que le contrat hérite du contrat `ERC20` d'OpenZeppelin.
- Respecter la norme rend le token automatiquement compatible avec MetaMask,
  BscScan et toutes les applications de l'écosystème.

### Langage : Solidity
- C'est le langage principal des smart contracts sur les blockchains EVM.
- Version `^0.8.20` : c'est le minimum demandé par OpenZeppelin v5, et depuis
  la 0.8, les dépassements de nombres (overflow) sont bloqués automatiquement.

### Bibliothèque : OpenZeppelin
- C'est le standard de l'industrie : du code **audité** et utilisé par des
  milliers de projets.
- Réécrire les fonctions BEP-20 à la main augmenterait le risque d'erreur et de
  faille. On hérite donc de `ERC20` au lieu de le réimplémenter.
- Le contrat reste ainsi **court et lisible** : toute la logique propre au
  projet tient dans le `constructor`.

### Outils : Remix IDE + MetaMask
- **Remix** permet d'écrire, compiler, tester (Remix VM, gratuitement) et
  déployer sans rien installer. Il importe OpenZeppelin automatiquement et
  vérifie le contrat sur BscScan.
- **MetaMask** signe les transactions et paie le gas en tBNB.

### Nom et ticker : Nofy42 Token / NF42
- Le sujet impose que le nom contienne **42**.
- « Nofy » vient de mon nom d'utilisateur, ce qui rend le token unique et
  facile à reconnaître.

### Supply fixe de 1 000 000 NF42
- Tous les tokens sont créés **une seule fois**, dans le `constructor`, et
  attribués à l'adresse qui déploie.
- `_mint` est une fonction interne appelée nulle part ailleurs : **aucun token
  ne peut être créé après le déploiement**.
- Une supply fixe empêche l'inflation, et les utilisateurs savent exactement
  combien de tokens existent.

### Sécurité : aucun owner, aucun privilège
- Le contrat n'hérite **pas** de `Ownable` : personne n'a de pouvoir spécial,
  pas même le créateur.
- Il n'y a **pas** de fonction `mint`, `pause` ou de liste noire : personne ne
  peut créer des tokens, bloquer les transferts, geler un compte ou prendre les
  tokens de quelqu'un.
- Les utilisateurs n'ont pas besoin de faire confiance au créateur : les règles
  sont dans le code public et ne peuvent pas changer.
- Même si la clé du créateur était volée, le voleur ne pourrait prendre que les
  tokens de ce compte, sans pouvoir modifier le token.

### Décimales : 18
- C'est la valeur par défaut d'OpenZeppelin et la convention suivie par BNB,
  ETH et la plupart des tokens BEP-20 : meilleure compatibilité avec les
  wallets et les applications.
- Le token peut être divisé en très petites parts (1 NF42 = 10¹⁸ unités).

---
---

# Tokenizer — Nofy42 Token (NF42)

> English version

42 school *Tokenizer* project: creating, deploying and publishing a **BEP-20**
token on a public test blockchain.

---

## The token

| | |
|---|---|
| Name | Nofy42 Token |
| Ticker | NF42 |
| Standard | BEP-20 |
| Supply | 1,000,000 NF42 (fixed) |
| Decimals | 18 |
| Network | **BNB Smart Chain Testnet** (Chain ID `97`) |
| Contract address | **`0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754`** |
| BscScan | https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754 |

The source code is verified and published on BscScan (*Exact Match*).

---

## Repository structure

| Folder | Content |
|---|---|
| [`code/`](code/) | The Solidity smart contract: [`nofy42.sol`](code/nofy42.sol) |
| [`deployment/`](deployment/) | Steps and settings to deploy the token |
| [`documentation/`](documentation/) | How the token works and how to use it |

---

## Choices and reasons

### Blockchain: BNB Smart Chain (Testnet)
- The subject is a partnership with BNB Chain.
- BSC is **EVM-compatible**: it uses Solidity and the same well-documented
  tools as Ethereum.
- Fees (gas) are low, and the **testnet** lets everything be done with free
  tBNB from the faucet. The subject forbids using real money.

### Standard: BEP-20
- It is the token standard on BNB Chain, required by the subject.
- BEP-20 is **identical to ERC-20** (same functions, same events). That is why
  the contract inherits from OpenZeppelin's `ERC20` contract.
- Following the standard makes the token automatically compatible with
  MetaMask, BscScan and every application of the ecosystem.

### Language: Solidity
- It is the main smart contract language on EVM blockchains.
- Version `^0.8.20`: the minimum required by OpenZeppelin v5, and since 0.8,
  number overflows are blocked automatically.

### Library: OpenZeppelin
- It is the industry standard: **audited** code used by thousands of projects.
- Rewriting the BEP-20 functions by hand would increase the risk of bugs and
  vulnerabilities. The contract inherits from `ERC20` instead of
  re-implementing it.
- The contract stays **short and readable**: all project-specific logic fits in
  the `constructor`.

### Tools: Remix IDE + MetaMask
- **Remix** lets you write, compile, test (Remix VM, for free) and deploy
  without installing anything. It imports OpenZeppelin automatically and
  verifies the contract on BscScan.
- **MetaMask** signs the transactions and pays the gas in tBNB.

### Name and ticker: Nofy42 Token / NF42
- The subject requires the name to contain **42**.
- "Nofy" comes from my username, which makes the token unique and easy to
  recognize.

### Fixed supply of 1,000,000 NF42
- All tokens are created **only once**, in the `constructor`, and assigned to
  the deployer address.
- `_mint` is an internal function called nowhere else: **no token can be
  created after deployment**.
- A fixed supply prevents inflation, and users know exactly how many tokens
  exist.

### Security: no owner, no privilege
- The contract does **not** inherit from `Ownable`: nobody has any special
  power, not even the creator.
- There is **no** `mint`, `pause` or blacklist function: nobody can create
  tokens, block transfers, freeze an account or take someone's tokens.
- Users do not need to trust the creator: the rules are in the public code and
  cannot change.
- Even if the creator's key were stolen, the thief could only take that
  account's tokens, without being able to modify the token.

### Decimals: 18
- It is OpenZeppelin's default and the convention followed by BNB, ETH and most
  BEP-20 tokens: best compatibility with wallets and applications.
- The token can be split into very small parts (1 NF42 = 10¹⁸ units).
