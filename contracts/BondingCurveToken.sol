pragma solidity 0.5.6;

import "./vendor/BancorFormula.sol";
import "./vendor/ERC20.sol";
import "./vendor/ERC20Detailed.sol";

/**
 * @title Bonding Curve
 * @dev Bonding curve contract based on Bacor formula
 * inspired by bancor protocol and simondlr
 * https://github.com/bancorprotocol/contracts
 * https://github.com/ConsenSys/curationmarkets/blob/master/CurationMarkets.sol
 */
contract BondingCurveToken is ERC20, BancorFormula {
    //   Reserve ratio, represented in ppm, 1-1000000.
    //
    //   1/3 corresponds to y= multiple * x^2
    //   1/2 corresponds to y= multiple * x
    //   2/3 corresponds to y= multiple * x^1/2
    //
    //   multiple will depends on contract initialization,
    //   specifically totalAmount and poolBalance parameters
    uint32 public reserveRatio;


    // - Front-running attacks are currently mitigated by the following mechanisms:
    // TODO - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
    // - gas price limit prevents users from having control over the order of execution
    uint256 public gasPrice = 0 wei; // maximum gas price for bancor transactions

    event CurvedMint(
        address sender,
        uint256 amount,
        uint256 deposit
    );

    event CurvedBurn(
        address sender,
        uint256 amount,
        uint256 reimbursement
    );

    function calculateCurvedMintReturn(uint256 amount)
        public
        view
        returns (uint256)
    {
    return calculatePurchaseReturn(
        totalSupply(),
        poolBalance(),
        reserveRatio,
        amount
    );
    }

    function calculateCurvedBurnReturn(uint256 amount)
    public
    view
    returns (uint256)
    {
    return calculateSaleReturn(
        totalSupply(),
        poolBalance(),
        reserveRatio,
        amount
    );
    }

    function _curvedMint(uint256 deposit)
    internal
    returns (uint256)
    {
    return _curvedMintFor(msg.sender, deposit);
    }

    function _curvedMintFor(
        address user,
        uint256 deposit
    )
        validGasPrice
        validMint(deposit)
        internal
        returns (uint256)
    {
    uint256 amount = calculateCurvedMintReturn(deposit);
    _mint(user, amount);
    emit CurvedMint(user, amount, deposit);
    return amount;
    }

    function _curvedBurn(uint256 amount)
    internal
    returns (uint256)
    {
    return _curvedBurnFor(msg.sender, amount);
    }

    function _curvedBurnFor(
        address user,
        uint256 amount
    )
        validGasPrice
        validBurn(amount)
        internal
        returns (uint256)
    {
    uint256 reimbursement = calculateCurvedBurnReturn(amount);
    _burn(user, amount);
    emit CurvedBurn(user, amount, reimbursement);
    return reimbursement;
    }

    function _setGasPrice(uint256 _gasPrice)
        internal
    {
        require(_gasPrice > 0);
        gasPrice = _gasPrice;
    }

    /**
    * @dev Abstract method that returns pool balance
    */
    function poolBalance() public view returns (uint256);

    // verifies that the gas price is lower than the universal limit
    modifier validGasPrice() {
        assert(tx.gasprice <= gasPrice);
        _;
    }

    modifier validBurn(uint256 amount) {
        require(amount > 0 && balanceOf(msg.sender) >= amount);
        _;
    }

    modifier validMint(uint256 amount) {
        require(amount > 0);
        _;
    }
}
