// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin's ERC20: audited implementation of the ERC-20 standard.
// BEP-20 (BNB Chain) is identical to ERC-20: same functions, same events.
// We therefore inherit: name, symbol, decimals, totalSupply, balanceOf,
// transfer, approve, allowance, transferFrom, and the Transfer / Approval events.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Nofy42Token
 * @notice Fixed-supply BEP-20 token, deployed on the BNB Smart Chain Testnet.
 * @dev Security choices:
 *      - No owner, no admin role: nobody has any privilege.
 *      - No public mint function: the whole supply is created once
 *        in the constructor and can never increase.
 *      - No function to block, freeze or seize tokens.
 */
contract Nofy42Token is ERC20 {

    // Total number of tokens created at deployment (without decimals)
    uint256 private constant INITIAL_SUPPLY = 1_000_000;

    /**
     * @notice Runs only once, when the contract is deployed.
     * @dev Sets the token name and ticker, then creates the whole supply
     *      and assigns it to the deployer address (msg.sender).
     *      decimals() is 18 by default: 1 token = 10**18 units.
     */
    constructor() ERC20("Nofy42 Token", "NF42") {
        _mint(msg.sender, INITIAL_SUPPLY * 10 ** decimals());
    }
}

/**
* OpenZeppelin est une bibliothèque de code déjà écrit, vérifié et utilisé par des milliers de projets.
* Au lieu de réécrire toutes les fonctions du standard toi-même (avec un risque d'erreur), tu les récupères toutes faites.
* BEP-20 et ERC-20, c'est la même chose, donc ça marche sur BNB Chain.
* import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
*/

contract Nofy42Token is ERC20 {