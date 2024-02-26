// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import '@uniswap/v3-core/contracts/libraries/TickMath.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/base/LiquidityManagement.sol';

contract LiquidityPosition is IERC721Receiver {

    INonfungiblePositionManager public immutable positionMgr;
    uint24 public immutable poolFee;

    struct Deposit {
        address owner;
        uint128 liquidity;
        address token0;
        address token1;
    }

    mapping(uint256 => Deposit) public deposits;

    constructor (INonfungiblePositionManager _positionMgr, uint24 _poolFee) {
        positionMgr = _positionMgr;
        poolFee = _poolFee;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external override returns (bytes4) {
        _createDeposit(operator, tokenId);
        return this.onERC721Received.selector;
    }

    function _createDeposit(address owner, uint256 tokenId) internal {
        (,
         ,
        address token0,
        address token1,
        ,
        ,
        ,
        uint128 liquidity,
        ,
        ,
        ,
        ) = positionMgr.positions(tokenId);
        deposits[tokenId] = Deposit(owner, liquidity,token0, token1);
    }

    function mintNewPosition(address _token0, address _token1, uint256 _amount0ToMint, uint256 _amount1ToMint) external returns(uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1) {
        TransferHelper.safeApprove(_token0, address (positionMgr), _amount0ToMint);
        TransferHelper.safeApprove(_token1, address (positionMgr), _amount1ToMint);
        INonfungiblePositionManager.MintParams memory params =
                            INonfungiblePositionManager.MintParams({
                token0: _token0,
                token1: _token1,
                fee: poolFee,
                tickLower: TickMath.MIN_TICK,
                tickUpper: TickMath.MAX_TICK,
                amount0Desired: _amount0ToMint,
                amount1Desired: _amount1ToMint,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp
            });

        (tokenId, liquidity, amount0, amount1) = positionMgr.mint(params);
        _createDeposit(msg.sender, tokenId);
        if (amount0 < _amount0ToMint) {
            TransferHelper.safeApprove(_token0, address (positionMgr), 0);
            TransferHelper.safeTransfer(_token0, msg.sender, (_amount0ToMint - amount0));
        }
        if (amount1 < _amount1ToMint) {
            TransferHelper.safeApprove(_token1, address (positionMgr), 0);
            TransferHelper.safeTransfer(_token1, msg.sender, (_amount1ToMint - amount0));
        }

    }



}