// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

contract SingleSwap {
    ISwapRouter public immutable ROUTER;
    uint24 public immutable FEE = 3000;

    event Log(string messge, uint256 value);

    constructor(address _router) {
        ROUTER = ISwapRouter(_router);
    }

    function swapExtractInputSignle(
        address tokenIn,
        address tokenOut,
        uint amountIn
    ) external returns (uint256 amountOut) {
        TransferHelper.safeTransferFrom(
            tokenIn,
            msg.sender,
            address(this),
            amountIn
        );
        TransferHelper.safeApprove(tokenIn, address(ROUTER), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: FEE,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = ROUTER.exactInputSingle(params);
        emit Log("amountOut in swapExtractInputSignle :", amountOut);
    }

    function swapExtractOutputSignle(
        address tokenIn,
        address tokenOut,
        uint amountInMaximum,
        uint amountOut
    ) external returns (uint256 amountIn) {
        TransferHelper.safeTransferFrom(
            tokenIn,
            msg.sender,
            address(this),
            amountInMaximum
        );
        TransferHelper.safeApprove(tokenIn, address(ROUTER), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: FEE,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = ROUTER.exactOutputSingle(params);
        emit Log("amountIn in swapExtractOutputSignle :", amountIn);

        if (amountIn < amountInMaximum) {
            //revoke
            TransferHelper.safeApprove(tokenIn, address(ROUTER), 0);
            //transfer remaining token back to msg.sender
            TransferHelper.safeTransfer(
                tokenIn,
                msg.sender,
                (amountInMaximum - amountIn)
            );
        }
    }
}
