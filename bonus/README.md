> Version française

# Bonus — MultiSig

### Présentation et choix

Le contrat [`MultiSig`](../bonus/multisig.sol) est un **coffre séparé** qui
détient des NF42. Plusieurs propriétaires doivent confirmer un transfert
avant que les tokens puissent sortir du coffre.

La configuration choisie pour ce projet est **2 confirmations sur 3
propriétaires**. Une seule personne ne peut donc pas envoyer les tokens du
coffre, et deux propriétaires peuvent agir si le troisième est absent.
Cette configuration est fixée au déploiement : le constructeur reçoit
l'adresse du token NF42, les **3 adresses distinctes** et la valeur **`2`**.

Les propriétaires du coffre n'ont aucun pouvoir sur le contrat NF42 : ils
contrôlent seulement les tokens déposés dans le multisig. Les transferts
ordinaires entre wallets restent inchangés.

### Coffre déployé

- **Réseau :** BNB Smart Chain Testnet (Chain ID `97`).
- **Adresse du coffre :** `0xac0e161f238ec1d73d2dbbae3f713a79ff74933a`.
- **Explorateur du coffre :** [Voir le MultiSig sur BscScan](https://testnet.bscscan.com/address/0xac0e161f238ec1d73d2dbbae3f713a79ff74933a).
- **Code source du coffre :** vérifié sur BscScan (**Exact Match**).
- **Token NF42 utilisé (`token()`) :** `0x45DE859Ab16f0c2d5ac49353f33018a6d31eeAAD`.
- **Explorateur du token :** [Voir le NF42 utilisé par le coffre](https://testnet.bscscan.com/address/0x45DE859Ab16f0c2d5ac49353f33018a6d31eeAAD).
- **Configuration choisie :** 3 propriétaires, 2 confirmations nécessaires.

Ce NF42 est une nouvelle instance du contrat du projet, déployée pour les
révisions. Il est distinct de l'ancien contrat
`0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754` présenté dans la documentation
principale, même si les deux tokens portent le même nom et le même symbole.
Le coffre utilise uniquement le contrat indiqué par `token()`.

**Pour alimenter le coffre, envoyer uniquement les NF42 de ce contrat.**
Le code actuel ne possède aucune fonction pour récupérer d'autres tokens
qui lui seraient envoyés par erreur.

### Vérifications réalisées

- Dans Remix VM : transfert après deux confirmations ; refus avec une seule
  confirmation ; refus d'une confirmation en double, d'une seconde exécution,
  d'un appel par un non-propriétaire, d'une proposition inexistante, d'un
  montant nul et d'un destinataire nul ; refus pour solde insuffisant, puis
  réussite de la même proposition après un nouveau dépôt.
- Sur BSC Testnet : dépôt de NF42 dans le coffre, création de propositions,
  confirmations par deux propriétaires distincts et exécutions réussies de
  transferts de 30 NF42 vers Account 2, puis Account 3. Les soldes ont été
  consultés sur le contrat NF42 et les numéros `txId` retrouvés dans les logs.
- Code du coffre consulté sur BscScan avec la mention **Exact Match**.

Les refus testés dans Remix VM ne sont pas présentés ici comme déjà retestés
sur BSC Testnet. Les adresses des trois propriétaires du coffre déployé
peuvent être consultées avec `owners(0)`, `owners(1)` et `owners(2)`.

### Fonctionnement

1. Un utilisateur envoie des NF42 à l'adresse du coffre avec `transfer` sur
   le contrat du token. Aucun `approve` n'est nécessaire pour ce dépôt.
2. Un propriétaire appelle `propose(to, amount)` : une proposition est créée,
   avec **0 confirmation**. Proposer ne compte pas comme confirmer.
3. Deux propriétaires distincts appellent chacun `confirm(txId)`. Chaque
   confirmation est une transaction signée par le wallet du propriétaire.
4. Un propriétaire appelle `execute(txId)` : le coffre appelle `transfer`
   sur NF42 et envoie les tokens depuis **son propre solde**.

Le numéro `txId` identifie la proposition : `0` pour la première, `1` pour
la deuxième, etc. Les montants sont en unités : **100 NF42 =
`100000000000000000000` unités**.

### Fonctions et suivi

> **Lecture** : consulter une information sans modifier la blockchain
> (par exemple, les confirmations). La consultation dans Remix ou BscScan est gratuite.
> **Écriture** : modifier une information sur la blockchain (par exemple,
> enregistrer une confirmation). Il faut signer avec son wallet et payer du gas en tBNB.

- `token()` (**lecture**) : Renvoie l'adresse du token utilisé par le coffre.
- `owners(index)` (**lecture**) : Renvoie un propriétaire (indices `0`, `1`, `2` pour la configuration choisie).
- `isOwner(adresse)` (**lecture**) : Indique si une adresse est propriétaire.
- `requiredConfirmations()` (**lecture**) : Renvoie le seuil fixé au déploiement : `2` pour ce projet.
- `transactions(txId)` (**lecture**) : Renvoie le destinataire, le montant, le nombre de confirmations et l'état d'exécution.
- `isConfirmed(txId, adresse)` (**lecture**) : Indique si ce propriétaire a déjà confirmé cette proposition.
- `propose(to, amount)` (**écriture**) : Propose un transfert, uniquement depuis un compte propriétaire.
- `confirm(txId)` (**écriture**) : Confirme une proposition, uniquement depuis un compte propriétaire.
- `execute(txId)` (**écriture**) : Exécute une proposition suffisamment confirmée, uniquement depuis un compte propriétaire.

Pour consulter le solde du coffre, appeler `balanceOf(adresseDuCoffre)` sur
le **contrat NF42**. Les événements `TransactionProposed`,
`TransactionConfirmed` et `TransactionExecuted` permettent de suivre les
actions ; le transfert effectif émet aussi l'événement `Transfer` de NF42.

### Sécurité et erreurs

- Seuls les propriétaires peuvent proposer, confirmer ou exécuter.
- Un propriétaire ne peut pas confirmer deux fois la même proposition.
- Une proposition ne peut pas être exécutée sans le nombre requis de
  confirmations, ni être exécutée deux fois.
- Le constructeur refuse les propriétaires en double, l'adresse zéro et un
  seuil nul ou supérieur au nombre de propriétaires.
- Une proposition vers l'adresse zéro ou avec un montant nul est refusée.
- Si le coffre n'a pas assez de NF42, le transfert échoue. Toute l'exécution
  est annulée : la proposition reste non exécutée et peut être réessayée
  après un nouveau dépôt.
- L'état `executed` est marqué avant l'appel au token pour empêcher une
  nouvelle exécution de la même proposition pendant cet appel.


### Mise en place et démonstration

Les étapes suivantes permettent de reproduire la mise en place et une
démonstration. Les montants de 200 et 100 NF42 sont des exemples : les
résultats indiqués supposent un coffre initialement vide et un destinataire
sans NF42 de ce contrat. Sur le coffre existant, comparer les soldes avant
et après l'opération plutôt que supposer un solde initial nul.

1. Charger `bonus/multisig.sol` dans Remix et compiler. Dans la Remix VM,
   utiliser l'adresse d'un token NF42 déployé dans cette même VM ; sur BSC
   Testnet, utiliser le contrat NF42 indiqué dans « Coffre déployé » ci-dessus.
   La [documentation du token](../documentation/README.md) explique son
   fonctionnement, mais son adresse historique correspond à l'autre instance.
2. Déployer `MultiSig` avec l'adresse NF42, une liste de 3 adresses distinctes
   (`["adresse1", "adresse2", "adresse3"]`, à remplacer par les adresses
   choisies) et `required = 2`. Sur le testnet, chaque propriétaire doit avoir
   des tBNB pour payer ses transactions.
3. Sur le testnet, vérifier le code source du coffre sur BscScan avec les
   réglages de compilation et les arguments du constructeur utilisés, puis
   conserver son adresse et le lien vers sa page. Après vérification,
   **Read Contract** et **Write Contract** permettent de consulter et
   d'appeler ses fonctions avec MetaMask.
4. Envoyer **200 NF42** au coffre, puis vérifier son solde avec `balanceOf`.
5. Depuis le propriétaire 1, proposer **100 NF42** vers un destinataire et
   noter le `txId` (sur un nouveau coffre, la première proposition vaut `0`).
6. Confirmer avec le propriétaire 1. Essayer d'exécuter : **refusé** avec
   `Not enough confirmations`.
7. Confirmer avec le propriétaire 2, puis exécuter depuis un propriétaire :
   le destinataire reçoit 100 NF42 et le coffre conserve 100 NF42.
8. Vérifier `transactions(txId)` : 2 confirmations et `executed = true`.
   Montrer aussi le transfert NF42 sur l'explorateur pour la démonstration
   sur le testnet.

Vérifications complémentaires à reproduire pour tester les refus : confirmation en double, appel
depuis un non-propriétaire, numéro de proposition inexistant, seconde
exécution, destinataire nul, montant nul et solde du coffre insuffisant.
Ces usages doivent être refusés.

---

> English version

# Bonus — MultiSig

### Overview and choices

The [`MultiSig`](../bonus/multisig.sol) contract is a **separate vault** that
holds NF42. Several owners must confirm a transfer before tokens can leave
the vault.

The configuration chosen for this project is **2 confirmations out of 3
owners**. One person cannot send the vault's tokens alone, and two owners
can act when the third is absent. This configuration is set at deployment:
the constructor receives the NF42 token address, **3 distinct owner
addresses** and the value **`2`**.

Vault owners have no special power over the NF42 contract: they control
only the tokens deposited in the multisig. Ordinary wallet-to-wallet
transfers remain unchanged.

### Deployed vault

- **Network:** BNB Smart Chain Testnet (Chain ID `97`).
- **Vault address:** `0xac0e161f238ec1d73d2dbbae3f713a79ff74933a`.
- **Vault explorer:** [View the MultiSig on BscScan](https://testnet.bscscan.com/address/0xac0e161f238ec1d73d2dbbae3f713a79ff74933a).
- **Vault source code:** verified on BscScan (**Exact Match**).
- **NF42 token used (`token()`):** `0x45DE859Ab16f0c2d5ac49353f33018a6d31eeAAD`.
- **Token explorer:** [View the NF42 used by the vault](https://testnet.bscscan.com/address/0x45DE859Ab16f0c2d5ac49353f33018a6d31eeAAD).
- **Chosen configuration:** 3 owners, 2 required confirmations.

This NF42 is a new instance of the project's token contract, deployed for
practice. It is separate from the original contract
`0x8B2EeC6F2937725e5feE787578aCA7E1eFec8754` described in the main
documentation, even though both tokens have the same name and symbol.
The vault uses only the contract returned by `token()`.

**Fund the vault only with NF42 from this contract.** The current code has
no function to recover other tokens sent to it by mistake.

### Completed checks

- In Remix VM: transfer after two confirmations; rejection with only one
  confirmation; rejection of duplicate confirmation, second execution,
  non-owner calls, nonexistent proposals, zero amounts and zero recipients;
  insufficient-balance rejection followed by successful execution of the
  same proposal after another deposit.
- On BSC Testnet: NF42 deposits, proposal creation, confirmations from two
  distinct owners and successful transfers of 30 NF42 to Account 2 and then
  Account 3. Balances were read on the NF42 contract and proposal IDs `txId`
  were located in the logs.
- Vault source code viewed on BscScan with the **Exact Match** label.

Rejection cases tested in Remix VM are not claimed here as already retested
on BSC Testnet. The three deployed vault owners can be inspected with
`owners(0)`, `owners(1)` and `owners(2)`.

### How it works

1. A user sends NF42 to the vault address with `transfer` on the token
   contract. No `approve` is needed for this deposit.
2. An owner calls `propose(to, amount)`: a proposal is created with
   **0 confirmations**. Proposing does not count as confirming.
3. Two distinct owners each call `confirm(txId)`. Each confirmation is a
   transaction signed by the owner's wallet.
4. An owner calls `execute(txId)`: the vault calls `transfer` on NF42 and
   sends tokens from **its own balance**.

The `txId` identifies the proposal: `0` for the first, `1` for the second,
and so on. Amounts are in units: **100 NF42 = `100000000000000000000`
units**.

### Functions and tracking

> **Read**: look up information without changing the blockchain
> (for example, confirmations). Reading in Remix or BscScan is free.
> **Write**: change information on the blockchain (for example, record a
> confirmation). You must sign with your wallet and pay gas in tBNB.

- `token()` (**read**) : Returns the token address used by the vault.
- `owners(index)` (**read**) : Returns an owner (indices `0`, `1`, `2` for the chosen configuration).
- `isOwner(address)` (**read**) : Indicates whether an address is an owner.
- `requiredConfirmations()` (**read**) : Returns the threshold set at deployment: `2` for this project.
- `transactions(txId)` (**read**) : Returns the recipient, amount, confirmation count and execution status.
- `isConfirmed(txId, address)` (**read**) : Indicates whether this owner has already confirmed this proposal.
- `propose(to, amount)` (**write**) : Proposes a transfer, only from an owner account.
- `confirm(txId)` (**write**) : Confirms a proposal, only from an owner account.
- `execute(txId)` (**write**) : Executes a sufficiently confirmed proposal, only from an owner account.

To read the vault balance, call `balanceOf(vaultAddress)` on the **NF42
contract**. The `TransactionProposed`, `TransactionConfirmed` and
`TransactionExecuted` events track actions; the actual transfer also emits
NF42's `Transfer` event.

### Security and errors

- Only owners can propose, confirm or execute.
- An owner cannot confirm the same proposal twice.
- A proposal cannot be executed without the required confirmations or
  executed twice.
- The constructor rejects duplicate owners, the zero address and a threshold
  of zero or greater than the number of owners.
- A proposal to the zero address or with a zero amount is rejected.
- If the vault has insufficient NF42, the transfer fails. The entire
  execution is reverted: the proposal remains unexecuted and can be retried
  after another deposit.
- The `executed` flag is set before calling the token to prevent another
  execution of the same proposal during that call.

### Setup and demonstration

The following steps reproduce setup and a demonstration. The amounts of
200 and 100 NF42 are examples: the stated results assume an initially empty
vault and a recipient with no NF42 from this contract. On the existing
vault, compare balances before and after rather than assuming zero initial
balances.

1. Load `bonus/multisig.sol` in Remix and compile. In the Remix VM, use the
   address of an NF42 token deployed in that same VM; on BSC Testnet, use
   the NF42 contract listed under “Deployed vault” above. The
   [token documentation](../documentation/README.md) explains how it works,
   but its historical address refers to the other instance.
2. Deploy `MultiSig` with the NF42 address, a list of 3 distinct addresses
   (`["address1", "address2", "address3"]`, replaced with the chosen
   addresses) and `required = 2`. On the testnet, each owner needs tBNB
   to pay for their transactions.
3. On the testnet, verify the vault source code on BscScan using the compiler
   settings and constructor arguments used, then keep its address and page
   link. After verification, **Read Contract** and **Write Contract** let
   users inspect and call its functions with MetaMask.
4. Send **200 NF42** to the vault, then check its balance with `balanceOf`.
5. From owner 1, propose **100 NF42** to a recipient and note the `txId`
   (on a new vault, the first proposal is `0`).
6. Confirm with owner 1. Try to execute: **rejected** with
   `Not enough confirmations`.
7. Confirm with owner 2, then execute from an owner account: the recipient
   receives 100 NF42 and the vault keeps 100 NF42.
8. Check `transactions(txId)`: 2 confirmations and `executed = true`.
   Also show the NF42 transfer on the explorer for the testnet demonstration.

Additional checks to repeat when testing rejections: duplicate confirmation, calls from a non-owner,
nonexistent proposal ID, second execution, zero recipient, zero amount and
insufficient vault balance. These uses must be rejected.
