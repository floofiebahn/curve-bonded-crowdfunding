pragma solidity 0.5.6;

import "./ERC20BondingToken.sol";

contract TestERC20BondingToken is ERC20BondingToken {

  function mint(uint256 amount) public {
    _curvedMint(amount);
  }

  function burn(uint256 amount) public {
    _curvedBurn(amount);
  }
}
