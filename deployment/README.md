# Déploiement — Nofy42 Token (NF42)

>Version française  

Ce dossier explique comment le contrat `Nofy42Token` a été déployé sur le
**BNB Smart Chain Testnet**, et comment le redéployer.

Le déploiement se fait avec **Remix IDE** (pour compiler et déployer) et
**MetaMask** (pour signer la transaction et payer le gas). Aucune installation
locale n'est nécessaire.

---

## Contrat déployé

| Élément | Valeur |
|---|---|
| Réseau | BNB Smart Chain Testnet (Chain ID `97`) |
| Adresse du contrat | `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754` |
| Adresse du déployeur | `0x30E60e59368fe5bFB6AED7431980ed6366543b4d` |
| Explorateur | https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754 |
| Code source | [`../code/nofy42.sol`](../code/nofy42.sol) |
| Vérification | Vérifié sur BscScan (Exact Match) |

---

## Réglages de compilation

Ces réglages doivent être repris à l'identique pour vérifier le contrat sur BscScan.

| Réglage | Valeur |
|---|---|
| Compilateur | `v0.8.34+commit.80d5c536` |
| Optimisation | Désactivée |
| Version EVM | `osaka` |
| Licence | MIT |

---

## Prérequis

### 1. MetaMask avec le réseau BSC Testnet

Installer l'extension MetaMask, puis ajouter le réseau manuellement
(*Ajouter un réseau → Ajouter un réseau manuellement*) :

| Champ | Valeur |
|---|---|
| Nom du réseau | BNB Smart Chain Testnet |
| URL RPC | `https://data-seed-prebsc-1-s1.binance.org:8545/` |
| ID de chaîne | `97` |
| Symbole | `tBNB` |
| Explorateur de blocs | `https://testnet.bscscan.com` |

> Les réseaux personnalisés sont enregistrés dans le navigateur, pas dans la
> phrase secrète. Il faut les rajouter sur chaque nouvel ordinateur.

### 2. Des BNB de test (tBNB) pour payer le gas

Obtenir des tBNB gratuits sur le faucet officiel : https://www.bnbchain.org/en/testnet-faucet

Environ `0.01 tBNB` suffit pour déployer le contrat et faire quelques transferts.

---

## Étapes

### 1. Charger le contrat dans Remix

1. Ouvrir https://remix.ethereum.org
2. Créer un fichier `nofy42.sol` et y coller le contenu de
   [`../code/nofy42.sol`](../code/nofy42.sol).

Remix télécharge automatiquement l'import OpenZeppelin.

### 2. Compiler

1. Ouvrir l'onglet **Solidity Compiler**.
2. Choisir la version de compilateur `0.8.34`.
3. Cliquer sur **Compile nofy42.sol**. Une coche verte indique la réussite.

### 3. (Facultatif) Tester gratuitement dans la Remix VM

1. Ouvrir l'onglet **Deploy & run transactions**.
2. Environment : **Remix VM**.
3. Déployer `Nofy42Token` et tester `name`, `symbol`, `totalSupply`, `balanceOf`,
   `transfer`, `approve` et `transferFrom` avec les comptes de test.

Rien n'est dépensé : ce sont de faux comptes sur une blockchain locale simulée.

### 4. Déployer sur le BSC Testnet

1. Dans MetaMask, sélectionner le réseau **BNB Smart Chain Testnet**.
2. Dans Remix, onglet **Deploy & run transactions**, choisir Environment
   **Browser extension → MetaMask**, et accepter la connexion dans MetaMask.
3. Vérifier que le compte affiché dans Remix est bien l'adresse MetaMask.
4. Contract : `Nofy42Token`. Cliquer sur **Deploy**.
5. Confirmer la transaction dans MetaMask (le gas est payé en tBNB).
6. Copier l'adresse du contrat affichée sous **Deployed Contracts**.

L'adresse qui déploie reçoit toute la supply : **1 000 000 NF42**.

### 5. Vérifier le code source sur BscScan

Les versions récentes de Remix vérifient le contrat automatiquement après le
déploiement. Pour le confirmer, ouvrir la page du contrat : l'onglet **Contract**
doit afficher *Source Code Verified (Exact Match)*.

S'il n'est pas vérifié :

1. Dans Remix, clic droit sur `nofy42.sol` → **Flatten**. Cela crée
   `nofy42_flattened.sol`, un seul fichier qui inclut le code d'OpenZeppelin.
2. Ouvrir `https://testnet.bscscan.com/verifyContract?a=<ADRESSE_DU_CONTRAT>`
3. Compiler type : *Solidity (Single file)*, version du compilateur et licence
   selon le tableau ci-dessus.
4. Coller le code aplati, mettre Optimization sur *No* et EVM version sur
   `osaka`, puis valider.

### 6. Ajouter le token dans MetaMask

1. MetaMask → **Jetons** → **Gérer les jetons** → **Ajouter un jeton personnalisé**.
2. Coller l'adresse du contrat. Le symbole `NF42` et les décimales `18` se
   remplissent automatiquement.
3. Le compte déployeur affiche **1 000 000 NF42**.

---
---


> English version

# Deployment — Nofy42 Token (NF42)

This folder explains how the `Nofy42Token` contract was deployed on the
**BNB Smart Chain Testnet**, and how to deploy it again.

Deployment is done with **Remix IDE** (to compile and deploy) and **MetaMask**
(to sign the transaction and pay the gas). No local installation is needed.

---

## Deployed contract

| Item | Value |
|---|---|
| Network | BNB Smart Chain Testnet (Chain ID `97`) |
| Contract address | `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754` |
| Deployer address | `0x30E60e59368fe5bFB6AED7431980ed6366543b4d` |
| Explorer | https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754 |
| Source code | [`../code/nofy42.sol`](../code/nofy42.sol) |
| Verification status | Verified on BscScan (Exact Match) |

---

## Compiler settings

These settings must be reused exactly to verify the contract on BscScan.

| Setting | Value |
|---|---|
| Compiler | `v0.8.34+commit.80d5c536` |
| Optimization | Disabled |
| EVM version | `osaka` |
| License | MIT |

---

## Prerequisites

### 1. MetaMask with the BSC Testnet network

Install the MetaMask browser extension, then add the network manually
(*Add network → Add a network manually*):

| Field | Value |
|---|---|
| Network name | BNB Smart Chain Testnet |
| RPC URL | `https://data-seed-prebsc-1-s1.binance.org:8545/` |
| Chain ID | `97` |
| Currency symbol | `tBNB` |
| Block explorer | `https://testnet.bscscan.com` |

> Custom networks are stored locally in the browser, not in the recovery
> phrase. They must be added again on every new computer.

### 2. Test BNB (tBNB) to pay the gas

Get free tBNB from the official faucet: https://www.bnbchain.org/en/testnet-faucet

About `0.01 tBNB` is enough to deploy the contract and make a few transfers.

---

## Steps

### 1. Load the contract in Remix

1. Open https://remix.ethereum.org
2. Create a file `nofy42.sol` and paste the content of
   [`../code/nofy42.sol`](../code/nofy42.sol).

Remix downloads the OpenZeppelin import automatically.

### 2. Compile

1. Open the **Solidity Compiler** tab.
2. Select compiler version `0.8.34`.
3. Click **Compile nofy42.sol**. A green check mark means success.

### 3. (Optional) Test for free in the Remix VM

1. Open the **Deploy & run transactions** tab.
2. Environment: **Remix VM**.
3. Deploy `Nofy42Token` and test `name`, `symbol`, `totalSupply`, `balanceOf`,
   `transfer`, `approve` and `transferFrom` with the test accounts.

Nothing is spent: these are fake accounts on a local, simulated blockchain.

### 4. Deploy on the BSC Testnet

1. In MetaMask, select the **BNB Smart Chain Testnet** network.
2. In Remix, **Deploy & run transactions** tab, set Environment to
   **Browser extension → MetaMask**, and accept the connection in MetaMask.
3. Check that the account shown in Remix is your MetaMask address.
4. Contract: `Nofy42Token`. Click **Deploy**.
5. Confirm the transaction in MetaMask (gas is paid in tBNB).
6. Copy the contract address shown under **Deployed Contracts**.

The deployer address receives the whole supply: **1,000,000 NF42**.

### 5. Verify the source code on BscScan

Recent versions of Remix verify the contract automatically after deployment.
Check it on the contract page: the **Contract** tab must show
*Source Code Verified (Exact Match)*.

If it is not verified:

1. In Remix, right-click `nofy42.sol` → **Flatten**. This creates
   `nofy42_flattened.sol`, a single file including the OpenZeppelin code.
2. Open `https://testnet.bscscan.com/verifyContract?a=<CONTRACT_ADDRESS>`
3. Compiler type: *Solidity (Single file)*, compiler version and license from
   the table above.
4. Paste the flattened code, set Optimization to *No* and EVM version to
   `osaka`, then submit.

### 6. Add the token to MetaMask

1. MetaMask → **Tokens** → **Manage tokens** → **Add a custom token**.
2. Paste the contract address. Symbol `NF42` and decimals `18` are filled in
   automatically.
3. The deployer account shows **1,000,000 NF42**.
