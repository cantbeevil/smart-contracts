pragma solidity 0.8.9;

import { IEscrow } from "../../interfaces/IEscrow.sol";
import { LoanLib } from "../../utils/LoanLib.sol";
import { IEscrowedLoan } from "../../interfaces/IEscrowedLoan.sol";

abstract contract EscrowedLoan is IEscrowedLoan {
  // contract holding all collateral for borrower
  IEscrow immutable public escrow;

  constructor(address _escrow) {
    escrow = IEscrow(_escrow);
  }

  function _init() internal virtual returns(LoanLib.STATUS) {
    require(escrow.loan() == address(this));
    return LoanLib.STATUS.ACTIVE;
  }

  /** @dev see BaseLoan._healthcheck */
  function _healthcheck() virtual internal returns(LoanLib.STATUS) {
    if(escrow.isLiquidatable()) {
      return LoanLib.STATUS.LIQUIDATABLE;
    }

    return LoanLib.STATUS.ACTIVE;
  }

  /**
   * @notice sends escrowed tokens to liquidation. 
   *(@dev priviliegad function. Do checks before calling.
   * @param positionId - position being repaid in liquidation
   * @param amount - amount of tokens to take from escrow and liquidate
   * @param targetToken - the token to take from escrow
   * @param to - the liquidator to send tokens to. could be OTC address or smart contract
   * @return amount - the total amount of `targetToken` sold to repay credit
   *  
   
  */
  function _liquidate(
    bytes32 positionId,
    uint256 amount,
    address targetToken,
    address to
  )
    virtual internal
    returns(uint256)
  { 
    require(escrow.liquidate(amount, targetToken, to));

    emit Liquidate(positionId, amount, targetToken);

    return amount;
  }
}


