const Token = artifacts.require("Token");

contract("Token", (accounts) => {
  const [bob, alice] = accounts;
  it("tottle suppy", async () => {
    const TokenValue = await Token.deployed();
    const totalSupply = await TokenValue.totalSupply.call();
    console.log(await totalSupply, "totalSupplytotalSupply");
  });
});
