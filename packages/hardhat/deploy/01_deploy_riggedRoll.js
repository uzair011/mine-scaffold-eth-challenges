const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const diceGame = await ethers.getContract("DiceGame", deployer);

  await deploy("RiggedRoll", {
    from: deployer,
    args: [diceGame.address],
    log: true,
  });

  const riggedRoll = await ethers.getContract("RiggedRoll", deployer);

  const ownershipTransaction = await riggedRoll.transferOwnership(
    // "0x3c2b8e7d1e618accaacdc1e0451f52c2c3568c13"
    "0x97f99a87acdce92e4e9f283b43799a195fa3ea05"
  );

  const params = {
    to: riggedRoll.address,
    value: ethers.utils.parseUnits("0.1", "ether"),
  };

  [owner] = await ethers.getSigners();
  const tx = await owner.sendTransaction(params);
};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["RiggedRoll"];
