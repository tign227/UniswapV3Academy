const { ethers } = require("hardhat");
const { whaleTransfer } = require("../util/TestHelper.js");



describe("SingleSwap", async ()  =>{
  let singleSwap;
  let router_addr;

  let dai_address;
  let dai_whale_address;

  let amount;
  let deployer;

  beforeEach(async () => {
    [deployer] = await ethers.getSigners();
    dai_address = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
    dai_whale_address = "0x60FaAe176336dAb62e284Fe19B885B095d29fB7F"


    amount = ethers.parseUnits("1", 18);
    whaleTransfer(dai_address, dai_whale_address, deployer, amount);

    router_addr = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
    const SingleSwap = await ethers.getContractFactory("SingleSwap");
    singleSwap = await SingleSwap.deploy(router_addr);
  });

  it("Should swapExtractInputSignle correctly", async () => {
    // const balanceOfDeployer_DAI_before = await dai.balanceOf(deployer);
    // console.log("balanceOfDeployer_DAI_before", balanceOfDeployer_DAI_before.toString());
    // await singleSwap.swapExtractInputSignle(dai_address, amountIn);
    // const balanceOfDeployer_DAI = await dai.balanceOf(deployer);
    // console.log("balanceOfDeployer_DAI", balanceOfDeployer_DAI.toString());
    // const balanceOfDeployer_WETH = await weth.balanceOf(deployer);
    // console.log("balanceOfDeployer_WETH", balanceOfDeployer_WETH.toString());
  });

  it("Should swapExtractOutputSignle correctly", async function () {
    // Perform the swapExtractOutputSignle function call here and assert the results
  });
});
