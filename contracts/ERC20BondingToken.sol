pragma solidity 0.5.6;

import "./vendor/ERC20.sol";
import "./BondingCurveToken.sol";

/**
 * @title Token Bonding Curve
 * @dev Token backed Bonding curve contract
 */
contract ERC20BondingToken is BondingCurveToken {

    /* Reserve Token */
    ERC20 public reserveToken;

    constructor(ERC20 _reserveToken)
        public
    {
        reserveToken = _reserveToken;
    }

    /**
    * @dev Mint tokens
    *
    * @param amount Amount of tokens to deposit
    */
    function _curvedMint(uint256 amount) internal returns (uint256) {
        require(
            reserveToken.transferFrom(
                msg.sender,
                address(this),
                amount
            )
        );
        super._curvedMint(amount);
    }

  /**
   * @dev Burn tokens
   *
   * @param amount Amount of tokens to burn
   */
    function _curvedBurn(uint256 amount)
        internal
        returns (uint256)
    {
        uint256 reimbursement = super._curvedBurn(amount);
        reserveToken.transfer(msg.sender, reimbursement);
    }

  function poolBalance()
    public
    view
    returns(uint256)
    {
        return reserveToken.balanceOf(address(this));
    }
}
