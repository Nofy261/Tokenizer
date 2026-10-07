# Documentation — Nofy42 Token (NF42)

> Version française 

Ce document explique ce qu'est le token **Nofy42 Token (NF42)**, comment il
fonctionne et comment l'utiliser.

---

## 1. Présentation

**Nofy42 Token (NF42)** est un token **BEP-20** déployé sur le
**BNB Smart Chain Testnet**. Il a été créé dans le cadre du projet *Tokenizer*
de l'école 42.

C'est un **token pédagogique** : il sert à démontrer la création, le
déploiement et l'utilisation d'un token sur une blockchain publique. Il n'a
**aucune valeur financière** (il vit sur un testnet).

| Caractéristique | Valeur |
|---|---|
| Nom | Nofy42 Token |
| Ticker (symbole) | NF42 |
| Standard | BEP-20 (identique à ERC-20) |
| Décimales | 18 |
| Supply totale | 1 000 000 NF42 (fixe) |
| Réseau | BNB Smart Chain Testnet (Chain ID `97`) |
| Adresse du contrat | `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754` |
| Explorateur | https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754 |
| Code source | [`../code/nofy42.sol`](../code/nofy42.sol) |

---

## 2. Notions de base

- **Blockchain** : un registre public partagé par des milliers d'ordinateurs,
  où toutes les transactions sont enregistrées et ne peuvent pas être modifiées.
- **Smart contract** : un programme déployé sur la blockchain, à une adresse
  précise, qui applique ses règles automatiquement et ne peut plus être modifié.
- **Token** : une monnaie numérique gérée par un smart contract. Le contrat
  tient un registre qui indique combien de tokens possède chaque adresse.
- **BEP-20** : la norme des tokens sur BNB Chain. C'est une liste de fonctions
  communes, qui permet aux wallets (MetaMask) et aux explorateurs (BscScan) de
  reconnaître et d'utiliser n'importe quel token.
- **Gas** : les frais payés en BNB (ici en tBNB) pour chaque opération qui
  modifie la blockchain. La lecture est gratuite.

---

## 3. Fonctionnement du contrat

### Création des tokens

Le contrat hérite du contrat `ERC20` d'**OpenZeppelin**, une bibliothèque de
smart contracts audités et utilisés par toute l'industrie.

Au déploiement, le `constructor` s'exécute **une seule fois** :
1. il donne au token son nom (`Nofy42 Token`) et son ticker (`NF42`) ;
2. il crée **1 000 000 NF42** avec la fonction interne `_mint` ;
3. il les attribue à l'adresse qui a déployé le contrat.

### Les décimales

La blockchain ne connaît pas les nombres à virgule. Chaque NF42 est donc
découpé en **10¹⁸ petites unités** (comme 1 € = 100 centimes) :

```
1 NF42          = 1 000 000 000 000 000 000 unités
1 000 000 NF42  = 1 000 000 000 000 000 000 000 000 unités
```

Le contrat stocke les montants **en unités**. MetaMask et BscScan divisent
automatiquement par 10¹⁸ pour afficher un nombre lisible.

> ⚠️ Quand on appelle le contrat directement (Remix, BscScan), il faut écrire
> les montants en unités : pour envoyer 1 NF42, écrire `1000000000000000000`.
> Dans MetaMask, il suffit d'écrire `1`.

### Les fonctions BEP-20

> **Lecture** : consulter une information sans modifier la blockchain
> (par exemple, un solde). La consultation dans Remix ou BscScan est gratuite.
> **Écriture** : modifier une information sur la blockchain (par exemple,
> transférer des tokens). Il faut signer avec son wallet et payer du gas en tBNB.

- `name()` (**lecture**) : Renvoie le nom du token : `Nofy42 Token`.
- `symbol()` (**lecture**) : Renvoie le ticker : `NF42`.
- `decimals()` (**lecture**) : Renvoie le nombre de décimales : `18`.
- `totalSupply()` (**lecture**) : Renvoie le nombre total de tokens (en unités).
- `balanceOf(adresse)` (**lecture**) : Renvoie le solde d'une adresse (en unités).
- `transfer(to, montant)` (**écriture**) : Envoie des tokens de l'appelant vers `to`.
- `approve(spender, montant)` (**écriture**) : Autorise `spender` à dépenser jusqu'à `montant` des tokens de l'appelant.
- `allowance(owner, spender)` (**lecture**) : Renvoie le montant que `spender` peut encore dépenser pour `owner`.
- `transferFrom(from, to, montant)` (**écriture**) : Le `spender` autorisé envoie des tokens de `from` vers `to`.

Les fonctions de **lecture** sont gratuites. Les fonctions d'**écriture**
coûtent du gas (en tBNB).

Le contrat émet aussi deux **events** (des annonces publiques que les
explorateurs et les wallets écoutent) :
- `Transfer(from, to, value)` à chaque transfert (et à la création, avec
  `from` = adresse `0`) ;
- `Approval(owner, spender, value)` à chaque autorisation.

### `approve` et `transferFrom` : le chèque avec plafond

1. Alice appelle `approve(Bob, 50)` : Bob a le droit de dépenser 50 NF42
   d'Alice. Aucun token ne bouge.
2. Bob appelle `transferFrom(Alice, Charlie, 30)` : 30 NF42 passent d'Alice à
   Charlie.
3. L'autorisation restante de Bob est de 20 NF42.

C'est ce mécanisme qui permet à des applications (exchanges, jeux...) de
déplacer des tokens au nom d'un utilisateur, dans la limite qu'il a fixée.

---

## 4. Sécurité : ownership et privilèges

Le contrat a été conçu **sans owner et sans aucun privilège** :

- **Supply fixe** : les tokens sont créés une seule fois dans le
  `constructor`. `_mint` est une fonction interne qui n'est appelée nulle part
  ailleurs, donc **personne ne peut créer de nouveaux NF42**, pas même le
  créateur.
- **Pas d'owner** : le contrat n'hérite pas de `Ownable`. Personne n'a de
  pouvoir spécial.
- **Pas de fonction d'administration** : pas de `mint`, pas de `pause`, pas de
  liste noire. Personne ne peut bloquer les transferts, geler un compte ou
  prendre les tokens de quelqu'un.
- **Code audité** : la logique BEP-20 vient d'OpenZeppelin, qui vérifie par
  exemple qu'on ne peut pas envoyer plus que son solde
  (erreur `ERC20InsufficientBalance`) ni envoyer vers l'adresse `0`.

**Conséquence** : les utilisateurs n'ont pas besoin de faire confiance au
créateur. Les règles sont dans le code public, vérifié sur BscScan, et ne
peuvent pas changer.

**Risques qui restent pour chaque utilisateur** (ils ne viennent pas du
contrat) :
- un envoi vers une mauvaise adresse est définitif ;
- un `approve` donné à une adresse malhonnête lui permet de dépenser les
  tokens jusqu'à la limite fixée ;
- celui qui possède la phrase secrète (12 mots) d'un wallet contrôle ses tokens.

---

## 5. Utiliser le token

### Prérequis

- L'extension **MetaMask**, avec le réseau **BNB Smart Chain Testnet** ajouté
  (voir [`../deployment/README.md`](../deployment/README.md)).
- Quelques **tBNB** pour payer le gas : https://www.bnbchain.org/en/testnet-faucet

### Voir ses NF42 dans MetaMask

1. MetaMask → **Jetons** → **Gérer les jetons** → **Ajouter un jeton personnalisé**.
2. Coller l'adresse du contrat : `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754`
3. Le symbole `NF42` et les décimales `18` se remplissent automatiquement.
4. Valider : le solde de NF42 s'affiche.

### Envoyer des NF42 avec MetaMask

1. Cliquer sur **NF42**, puis sur **Envoyer**.
2. Coller l'adresse du destinataire et le montant (en NF42, par exemple `10`).
3. Confirmer et payer le gas en tBNB.

### Utiliser le contrat depuis BscScan

Le contrat étant vérifié, on peut appeler ses fonctions directement sur BscScan :

1. Ouvrir la page du contrat, onglet **Contract**.
2. **Read Contract** : appeler les fonctions de lecture (`balanceOf`,
   `totalSupply`...) gratuitement, sans wallet.
3. **Write Contract** : cliquer sur **Connect to Web3** pour connecter
   MetaMask, puis appeler `transfer`, `approve` ou `transferFrom`
   (montants en unités).

---

## 6. Démonstration

Scénario pour montrer le fonctionnement du token (dans la Remix VM ou sur le
testnet) :

1. `name`, `symbol`, `decimals`, `totalSupply` → vérifier l'identité du token.
2. `balanceOf(déployeur)` → le déployeur possède 1 000 000 NF42.
3. `transfer(compte2, 100 NF42)` → `balanceOf` montre 999 900 et 100.
4. Depuis le compte 2, `transfer(compte3, 200 NF42)` → **refusé**
   (`ERC20InsufficientBalance`), car le compte 2 n'a que 100 NF42.
5. `approve(compte3, 50 NF42)` depuis le déployeur → `allowance` = 50.
6. Depuis le compte 3, `transferFrom(déployeur, compte4, 30 NF42)` →
   `allowance` = 20, le compte 4 a 30 NF42.

---

## 7. Déployer le token

Le token se déploie avec **Remix IDE** et **MetaMask**, sans installation :

1. Ajouter le réseau **BNB Smart Chain Testnet** dans MetaMask et obtenir des
   tBNB sur le faucet.
2. Ouvrir https://remix.ethereum.org et coller le contenu de
   [`../code/nofy42.sol`](../code/nofy42.sol).
3. Compiler avec la version `0.8.34` (onglet **Solidity Compiler**).
4. Onglet **Deploy & run transactions** : Environment **Browser extension →
   MetaMask**, contrat `Nofy42Token`, puis **Deploy** et confirmer dans MetaMask.
5. Vérifier le code source sur BscScan, puis ajouter le token dans MetaMask
   avec l'adresse du contrat.

L'adresse qui déploie reçoit les 1 000 000 NF42. Les étapes détaillées et les
réglages de compilation sont dans [`../deployment/README.md`](../deployment/README.md).

---

## 8. Bonus — MultiSig

Le fonctionnement du coffre multisignature, la configuration **2 sur 3**
et les étapes de démonstration sont expliqués dans la
[documentation du bonus](../bonus/README.md).

---

> English version
# Documentation — Nofy42 Token (NF42)

This document explains what the **Nofy42 Token (NF42)** is, how it works and
how to use it.

---

## 1. Overview

**Nofy42 Token (NF42)** is a **BEP-20** token deployed on the
**BNB Smart Chain Testnet**. It was created for the *Tokenizer* project at
42 school.

It is an **educational token**: it demonstrates how to create, deploy and use
a token on a public blockchain. It has **no financial value** (it lives on a
testnet).

| Property | Value |
|---|---|
| Name | Nofy42 Token |
| Ticker (symbol) | NF42 |
| Standard | BEP-20 (identical to ERC-20) |
| Decimals | 18 |
| Total supply | 1,000,000 NF42 (fixed) |
| Network | BNB Smart Chain Testnet (Chain ID `97`) |
| Contract address | `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754` |
| Explorer | https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754 |
| Source code | [`../code/nofy42.sol`](../code/nofy42.sol) |

---

## 2. Basic concepts

- **Blockchain**: a public ledger shared by thousands of computers, where all
  transactions are recorded and cannot be modified.
- **Smart contract**: a program deployed on the blockchain at a specific
  address, which applies its rules automatically and can no longer be changed.
- **Token**: a digital currency managed by a smart contract. The contract keeps
  a ledger of how many tokens each address owns.
- **BEP-20**: the token standard on BNB Chain. It is a list of common functions
  that lets wallets (MetaMask) and explorers (BscScan) recognize and use any
  token.
- **Gas**: the fee paid in BNB (here tBNB) for every operation that modifies
  the blockchain. Reading is free.

---

## 3. How the contract works

### Token creation

The contract inherits from **OpenZeppelin**'s `ERC20` contract, a library of
audited smart contracts used across the industry.

At deployment, the `constructor` runs **only once**:
1. it sets the token name (`Nofy42 Token`) and ticker (`NF42`);
2. it creates **1,000,000 NF42** with the internal `_mint` function;
3. it assigns them to the address that deployed the contract.

### Decimals

The blockchain has no decimal numbers. Each NF42 is therefore split into
**10¹⁸ small units** (like 1 € = 100 cents):

```
1 NF42          = 1 000 000 000 000 000 000 units
1 000 000 NF42  = 1 000 000 000 000 000 000 000 000 units
```

The contract stores amounts **in units**. MetaMask and BscScan automatically
divide by 10¹⁸ to display a readable number.

> ⚠️ When calling the contract directly (Remix, BscScan), amounts must be
> written in units: to send 1 NF42, write `1000000000000000000`.
> In MetaMask, just write `1`.

### BEP-20 functions

> **Read**: look up information without changing the blockchain
> (for example, a balance). Reading in Remix or BscScan is free.
> **Write**: change information on the blockchain (for example, transfer
> tokens). You must sign with your wallet and pay gas in tBNB.

- `name()` (**read**) : Returns the token name: `Nofy42 Token`.
- `symbol()` (**read**) : Returns the ticker: `NF42`.
- `decimals()` (**read**) : Returns the number of decimals: `18`.
- `totalSupply()` (**read**) : Returns the total number of tokens (in units).
- `balanceOf(address)` (**read**) : Returns the balance of an address (in units).
- `transfer(to, amount)` (**write**) : Sends tokens from the caller to `to`.
- `approve(spender, amount)` (**write**) : Allows `spender` to spend up to `amount` of the caller's tokens.
- `allowance(owner, spender)` (**read**) : Returns how much `spender` can still spend for `owner`.
- `transferFrom(from, to, amount)` (**write**) : The approved `spender` sends tokens from `from` to `to`.

**Read** functions are free. **Write** functions cost gas (in tBNB).

The contract also emits two **events** (public announcements that explorers
and wallets listen to):
- `Transfer(from, to, value)` on every transfer (and at creation, with
  `from` = address `0`);
- `Approval(owner, spender, value)` on every approval.

### `approve` and `transferFrom`: a cheque with a limit

1. Alice calls `approve(Bob, 50)`: Bob may spend 50 of Alice's NF42.
   No token moves.
2. Bob calls `transferFrom(Alice, Charlie, 30)`: 30 NF42 move from Alice to
   Charlie.
3. Bob's remaining allowance is 20 NF42.

This mechanism lets applications (exchanges, games...) move tokens on behalf
of a user, within the limit the user has set.

---

## 4. Security: ownership and privileges

The contract was designed **with no owner and no privilege**:

- **Fixed supply**: tokens are created only once, in the `constructor`.
  `_mint` is an internal function that is called nowhere else, so
  **nobody can create new NF42**, not even the creator.
- **No owner**: the contract does not inherit from `Ownable`. Nobody has any
  special power.
- **No admin function**: no `mint`, no `pause`, no blacklist. Nobody can block
  transfers, freeze an account or take someone's tokens.
- **Audited code**: the BEP-20 logic comes from OpenZeppelin, which checks for
  example that nobody can send more than their balance
  (`ERC20InsufficientBalance` error) or send to address `0`.

**Consequence**: users do not need to trust the creator. The rules are in the
public code, verified on BscScan, and cannot change.

**Remaining risks for each user** (they do not come from the contract):
- sending to a wrong address is final;
- an `approve` given to a dishonest address lets it spend tokens up to the
  set limit;
- whoever holds a wallet's recovery phrase (12 words) controls its tokens.

---

## 5. Using the token

### Prerequisites

- The **MetaMask** extension, with the **BNB Smart Chain Testnet** network
  added (see [`../deployment/README.md`](../deployment/README.md)).
- Some **tBNB** to pay the gas: https://www.bnbchain.org/en/testnet-faucet

### See your NF42 in MetaMask

1. MetaMask → **Tokens** → **Manage tokens** → **Add a custom token**.
2. Paste the contract address: `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754`
3. Symbol `NF42` and decimals `18` are filled in automatically.
4. Confirm: the NF42 balance is displayed.

### Send NF42 with MetaMask

1. Click **NF42**, then **Send**.
2. Paste the recipient address and the amount (in NF42, for example `10`).
3. Confirm and pay the gas in tBNB.

### Use the contract from BscScan

Since the contract is verified, its functions can be called directly on BscScan:

1. Open the contract page, **Contract** tab.
2. **Read Contract**: call read functions (`balanceOf`, `totalSupply`...)
   for free, without a wallet.
3. **Write Contract**: click **Connect to Web3** to connect MetaMask, then call
   `transfer`, `approve` or `transferFrom` (amounts in units).

---

## 6. Demonstration

Scenario to show how the token works (in the Remix VM or on the testnet):

1. `name`, `symbol`, `decimals`, `totalSupply` → check the token identity.
2. `balanceOf(deployer)` → the deployer owns 1,000,000 NF42.
3. `transfer(account2, 100 NF42)` → `balanceOf` shows 999,900 and 100.
4. From account 2, `transfer(account3, 200 NF42)` → **rejected**
   (`ERC20InsufficientBalance`), since account 2 only has 100 NF42.
5. `approve(account3, 50 NF42)` from the deployer → `allowance` = 50.
6. From account 3, `transferFrom(deployer, account4, 30 NF42)` →
   `allowance` = 20, account 4 has 30 NF42.

---

## 7. Deploying the token

The token is deployed with **Remix IDE** and **MetaMask**, with no installation:

1. Add the **BNB Smart Chain Testnet** network to MetaMask and get tBNB from
   the faucet.
2. Open https://remix.ethereum.org and paste the content of
   [`../code/nofy42.sol`](../code/nofy42.sol).
3. Compile with version `0.8.34` (**Solidity Compiler** tab).
4. **Deploy & run transactions** tab: Environment **Browser extension →
   MetaMask**, contract `Nofy42Token`, then **Deploy** and confirm in MetaMask.
5. Verify the source code on BscScan, then add the token to MetaMask with the
   contract address.

The deployer address receives the 1,000,000 NF42. Detailed steps and compiler
settings are in [`../deployment/README.md`](../deployment/README.md).

---

## 8. Bonus — MultiSig

The multisignature vault, the **2 out of 3** configuration and the
demonstration steps are explained in the
[bonus documentation](../bonus/README.md).

---
