// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.9.6/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.6/token/ERC20/ERC20.sol";

contract Token is ERC20, Ownable {
    uint public constant MODE_NORMAL = 0;
    uint public constant MODE_TRANSFER_RESTRICTED = 1;
    uint public constant MODE_TRANSFER_CONTROLLED = 2;
    uint public _mode;

    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply) ERC20(name, symbol) {
        _mint(owner(), totalSupply);
        _mode = MODE_TRANSFER_RESTRICTED;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        if (_mode == MODE_TRANSFER_RESTRICTED) {
            revert("Token: Transfer is restricted");
        }
        if (_mode == MODE_TRANSFER_CONTROLLED) {
            require(from == owner() || to == owner(), "Token: Invalid transfer");
        }
    }

    function setMode(uint v) public onlyOwner {
        if (_mode != MODE_NORMAL) {
            _mode = v;
        }
    }
}
