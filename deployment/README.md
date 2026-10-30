# Déploiement — Nofy42 Token (NF42)

>Version française  

Ce dossier explique comment le contrat `Nofy42Token` a été déployé sur le
**BNB Smart Chain Testnet**, et comment le redéployer.

Le déploiement se fait avec **Remix IDE** (pour compiler et déployer) et
**MetaMask** (pour signer la transaction et payer le gas). Aucune installation locale n'est nécessaire.

---

## Prérequis

### 1. MetaMask avec le réseau BSC Testnet

Si MetaMask et le réseau sont déjà configurés, ne pas les recréer : vérifier les paramètres ci-dessous. Sinon, installer l'extension MetaMask, créer un portefeuille (ou importer un portefeuille existant), puis ajouter le réseau manuellement
(*Ajouter un réseau → Ajouter un réseau manuellement*) :

- **Nom du réseau :** BNB Smart Chain Testnet
- **URL RPC :** `https://data-seed-prebsc-1-s1.binance.org:8545/`
- **ID de chaîne :** `97`
- **Symbole :** `tBNB`
- **Explorateur de blocs :** `https://testnet.bscscan.com`

> Sur un nouvel ordinateur, si BNB Smart Chain Testnet n'apparaît pas dans
> MetaMask, ajoute ce réseau à nouveau.

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
   Dans **Advanced Configurations**, pour reproduire le déploiement documenté, désactiver l'optimisation et sélectionner la version EVM `osaka` (voir les réglages en fin de document).
3. Cliquer sur **Compile nofy42.sol**. Une coche verte indique la réussite.

### 3. Tester(Facultatif) gratuitement dans la Remix VM

1. Ouvrir l'onglet **Deploy & run transactions**.
2. Environment : **Remix VM**.
3. Déployer `Nofy42Token` et tester `name`, `symbol`, `totalSupply`, `balanceOf`,
   `transfer`, `approve` et `transferFrom` avec les comptes de test.

Rien n'est dépensé : ce sont de faux comptes sur une blockchain locale simulée.

### 4. Déployer sur le BSC Testnet

1. Dans MetaMask, sélectionner le réseau **BNB Smart Chain Testnet**.
2. Dans Remix, onglet **Deploy & run transactions**, choisir Environment
   **Browser extension → MetaMask**, et accepter la connexion dans MetaMask.
3. Vérifier que le compte affiché dans Remix(adresse account1) est bien l'adresse MetaMask.
4. Contract : `Nofy42Token`. Cliquer sur **Deploy**.
5. Confirmer la transaction dans MetaMask (le gas est payé en tBNB).
6. Attendre que la transaction soit confirmée avec succès sur BSC Testnet,
   puis copier l'adresse du contrat affichée sous **Deployed Contracts**.
7. Dans MetaMask, ouvrir **Activité**, sélectionner la transaction de
   déploiement (elle peut apparaître comme **Interaction avec un contrat**),
   puis cliquer sur **Afficher sur l'explorateur de blocs**.
8. Sur BscScan, vérifier que **Status** affiche **Success** et que
   **Transaction Action** indique **Contract Created at** avec la nouvelle
   adresse du contrat. Cela confirme la réussite du déploiement ; la
   vérification du code source est une étape distincte, décrite ci-dessous.

L'adresse qui déploie reçoit toute la supply : **1 000 000 NF42**.

Chaque déploiement crée une nouvelle instance du contrat, avec une nouvelle
adresse et son propre million de NF42. Pour les étapes suivantes, utiliser
**l'adresse obtenue lors de ce déploiement**, pas l'adresse de référence en
fin de document. L'ancien contrat reste inchangé.

### 5. Vérifier le code source sur BscScan

Remix peut demander la vérification au déploiement si l'option
**Verify Contract on Explorers** est cochée avant de cliquer sur **Deploy**
et si le service de vérification est correctement configuré. La vérification
n'est pas garantie : ouvrir la page de la nouvelle adresse sur BscScan et
vérifier que l'onglet **Contract** affiche *Source Code Verified (Exact Match)*.


### 6. Ajouter le token dans MetaMask

1. MetaMask → **Jetons** → **Gérer les jetons** → **Ajouter un jeton personnalisé**.
2. Coller l'adresse du contrat. Le symbole `NF42` et les décimales `18` se
   remplissent automatiquement.
3. Le compte déployeur affiche **1 000 000 NF42**.


---

## Référence — Contrat déjà déployé

- **Réseau :** BNB Smart Chain Testnet (Chain ID `97`)
- **Adresse du contrat :** `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754`
- **Adresse du déployeur :** `0x30E60e59368fe5bFB6AED7431980ed6366543b4d`
- **Explorateur :** https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754
- **Code source :** [`../code/nofy42.sol`](../code/nofy42.sol)
- **Vérification :** Vérifié sur BscScan (Exact Match)

---

## Réglages de compilation

Ces réglages doivent être repris à l'identique pour vérifier le contrat sur BscScan.

- **Compilateur :** `v0.8.34+commit.80d5c536`
- **Optimisation :** Désactivée
- **Version EVM :** `osaka`
- **Licence :** MIT

---

> English version

# Deployment — Nofy42 Token (NF42)

This folder explains how the `Nofy42Token` contract was deployed on the
**BNB Smart Chain Testnet**, and how to deploy it again.

Deployment is done with **Remix IDE** (to compile and deploy) and **MetaMask**
(to sign the transaction and pay the gas). No local installation is needed.

---

## Prerequisites

### 1. MetaMask with the BSC Testnet network

If MetaMask and the network are already configured, do not recreate them:
check the settings below. Otherwise, install the MetaMask browser extension,
create a wallet (or import an existing wallet), then add the network manually
(*Add network → Add a network manually*):

- **Network name :** BNB Smart Chain Testnet
- **RPC URL :** `https://data-seed-prebsc-1-s1.binance.org:8545/`
- **Chain ID :** `97`
- **Currency symbol :** `tBNB`
- **Block explorer :** `https://testnet.bscscan.com`

> On a new computer, if BNB Smart Chain Testnet does not appear in MetaMask,
> add this network again.

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
   In **Advanced Configurations**, to reproduce the documented deployment, disable optimization and select
   EVM version `osaka` (see the settings at the end of this document).
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
6. Wait for the transaction to be successfully confirmed on BSC Testnet,
   then copy the contract address shown under **Deployed Contracts**.
7. In MetaMask, open **Activity**, select the deployment transaction
   (it may appear as **Contract interaction**), then click **View on block
   explorer**.
8. On BscScan, check that **Status** shows **Success** and **Transaction
   Action** shows **Contract Created at** with the new contract address.
   This confirms successful deployment; source code verification is a
   separate step, described below.

The deployer address receives the whole supply: **1,000,000 NF42**.

Each deployment creates a new contract instance, with a new address and its
own million NF42. For the following steps, use **the address obtained from
this deployment**, not the reference address at the end of this document.
The previous contract remains unchanged.

### 5. Verify the source code on BscScan

Remix can request verification during deployment if **Verify Contract on
Explorers** is checked before clicking **Deploy** and the verification
service is configured correctly. Verification is not guaranteed: open the
new address on BscScan and check that the **Contract** tab shows
*Source Code Verified (Exact Match)*.

### 6. Add the token to MetaMask

1. MetaMask → **Tokens** → **Manage tokens** → **Add a custom token**.
2. Paste the contract address. Symbol `NF42` and decimals `18` are filled in
   automatically.
3. The deployer account shows **1,000,000 NF42**.

---

## Reference — Previously deployed contract

- **Network :** BNB Smart Chain Testnet (Chain ID `97`)
- **Contract address :** `0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754`
- **Deployer address :** `0x30E60e59368fe5bFB6AED7431980ed6366543b4d`
- **Explorer :** https://testnet.bscscan.com/address/0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754
- **Source code :** [`../code/nofy42.sol`](../code/nofy42.sol)
- **Verification status :** Verified on BscScan (Exact Match)

---

## Compiler settings

These settings must be reused exactly to verify the contract on BscScan.

- **Compiler :** `v0.8.34+commit.80d5c536`
- **Optimization :** Disabled
- **EVM version :** `osaka`
- **License :** MIT

---

