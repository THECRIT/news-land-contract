const main = async () => {
  const landContractFactory = await hre.ethers.getContractFactory("LandPortal");
  const landContract = await landContractFactory.deploy();
  await landContract.deployed();
  console.log("Contract deployed to:", landContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
