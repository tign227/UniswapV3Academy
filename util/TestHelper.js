const { ethers } = require("hardhat");

class TestHelper {
  static async whaleTransfer(token_address, wahle_address, deployer, amount) {
    const whale = await ethers.getImpersonatedSigner(wahle_address);
    const token = await ethers.getContractAt("IERC20", token_address);
    await deployer.sendTransaction({
      to: whale.address,
      value: ethers.parseEther("50.0"),
    });
    await token.connect(whale).transfer(deployer, amount);
    const balance = await token.balanceOf(deployer);
    console.log("Whale transfer to Deployer with amount: ", balance.toString());
  }
}
