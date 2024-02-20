const { ethers } = require("hardhat");

describe("SingleSwap", async ()  =>{
  let singleSwap;
  let router_addr;

  let dai_address;
  let weth_address;

  let dai;
  let weth;

  let dai_whale_address;
  let dai_whale;

  let amountIn;
  let amountOut;

  let deployer;

  beforeEach(async () => {
    [deployer] = await ethers.getSigners();
    dai_address = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
    weth_address = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

    dai = await ethers.getContractAt("IERC20", dai_address);
    weth = await ethers.getContractAt("IERC20", weth_address);

    router_addr = "0xE592427A0AEce92De3Edee1F18E0157C05861564";

    dai_whale_address = "0x60FaAe176336dAb62e284Fe19B885B095d29fB7F";

    dai_whale = await ethers.getImpersonatedSigner(dai_whale_address);
    await deployer.sendTransaction({
      to: dai_whale.address,
      value: ethers.parseEther("50.0"),
    });

    amountIn = ethers.parseUnits("600", 16);
    amountOut = ethers.parseUnits("1", 16);

    [deployer] = await ethers.getSigners();

    const SingleSwap = await ethers.getContractFactory("SingleSwap");
    singleSwap = await SingleSwap.deploy(router_addr);
  });

  it("Should swapExtractInputSignle correctly", async () => {
    await dai.connect(dai_whale).transfer(deployer, amountIn);
    const balanceOfDeployer_DAI_before = await dai.balanceOf(deployer);
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
