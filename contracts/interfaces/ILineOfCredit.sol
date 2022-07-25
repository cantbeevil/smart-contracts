pragma solidity 0.8.9;

import { LoanLib } from "../utils/LoanLib.sol";
import { ILoan } from "./ILoan.sol";

interface ILineOfCredit is ILoan {
  // Lender data
  struct Credit {
    //  all denominated in token, not USD
    uint256 deposit;          // total liquidity provided by lender for token
    uint256 principal;        // amount actively lent out
    uint256 interestAccrued;  // interest accrued but not repaid
    uint256 interestRepaid;   // interest repaid by borrower but not withdrawn by lender
    uint8 decimals;           // decimals of credit token for calcs
    address token;            // token being lent out
    address lender;           // person to repay
  }

  event SetRates(bytes32 indexed id, uint128 indexed drawnRate, uint128 indexed facilityRate);


  // Access Errors
  error NotActive();
  error NotBorrowing();
  error CallerAccessDenied();
  
  // Tokens
  error TokenTransferFailed();
  error NoTokenPrice();

  // Loan
  error NoLiquidity();
  error PositionExists();
  error CloseFailedWithPrincipal();


  function addCredit(
    uint128 drate,
    uint128 frate,
    uint256 amount,
    address token,
    address lender
  ) external returns(bytes32);

  function setRates(
    bytes32 id,
    address lender,
    uint128 drate,
    uint128 frate
  ) external returns(bool);

  function increaseCredit(
    bytes32 id,
    address lender,
    uint256 amount,
    uint256 principal
  ) external returns(bool);

  function borrow(bytes32 id, uint256 amount) external returns(bool);
  function close(bytes32 id) external returns(bool);
}