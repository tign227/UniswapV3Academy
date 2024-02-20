// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

contract MultihopSwap {
    ISwapRouter public immutable ROUTER;
    uint24 public immutable FEE = 3000;

    event Log(string messge, uint256 value);

    constructor(address _router) {
        ROUTER = ISwapRouter(_router);
    }

    function swapExtractInputMultihop(address tokenIn, bytes path, address tokenOut,uint amountIn) external returns (uint256 amountOut){
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
        TransferHelper.safeApprove(tokenIn, address(ROUTER), amountIn);


        ISwapRouter.ExactInputParams memory params = 
            ISwapRouter.ExactInputParams({
                path: path,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0
        });
        amountOut = ISwapRouter.exactInput(params);
        emit Log("amountOut in swapExtractInputMultihop :", amountOut);

    }

    function swapExtractOutputMultihop(address tokenIn, address tokenOut, uint amountOut, uint amountInMaximun) external returns (uint amountIn) {
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountInMaximun);
        TransferHelper.safeApprove(tokenIn, address(ROUTER), amountInMaximun);


        ISwapRouter.ExacOutputParams memory params = 
            ISwapRouter.ExacOutputParams({
                path: path,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximun: amountInMaximun
        });
        amountIn = ISwapRouter.exactOutput(params);
        emit Log("amountIn in swapExtractOutputMultihop :", amountIn);

        if(amountIn < amountInMaximun) {
            //revoke
            TransferHelper.safeApprove(tokenIn, address(ROUTER), 0);
            //transfer back the remainning
            TransferHelper.safeTransfer(tokenIn, msg.sender, (amountInMaximun - amountIn));
        }

    }





}
