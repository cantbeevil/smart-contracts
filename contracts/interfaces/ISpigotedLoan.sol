pragma solidity ^0.8.9;
import { ISpigot } from "./ISpigot.sol";
interface ISpigotedLoan {
  event RevenuePayment(
    address indexed token,
    uint256 indexed amount
    // dont need to track value like other events because _repay already emits
    // this event is just semantics/helper to track payments from revenue specifically
  );

  event TradeSpigotRevenue(
    address indexed revenueToken,
    uint256 revenueTokenAmount,
    address indexed debtToken,
    uint256 indexed debtTokensBought
  );

  error NoSpigot();
  error TradeFailed();
  error ReleaseSpigotFailed();

  function addSpigot(address revenueContract, ISpigot.Setting calldata setting) external returns(bool);
  function updateOwnerSplit(address revenueContract) external returns(bool);
  function updateWhitelist(bytes4 func, bool allowed) external returns(bool);
  function releaseSpigot() external returns(bool);
  
  function unused(address token) external returns(uint256);

  function claimAndTrade(
    address claimToken, 
    bytes calldata zeroExTradeData
  ) external returns(uint256 tokensBought);

  function claimAndRepay(
    address token,
    bytes calldata zeroExTradeData
  ) external returns(uint256);

  function sweep(address token) external returns(uint256);
}
