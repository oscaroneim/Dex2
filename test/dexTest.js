//The user must have ETH deopsited such that deposited eth >= buy order value
//The user must have enough tokens deposited such that token balance >= sell order amount
//The BUY order book should be ordered on price from highest to lowest starting at index 0
//The SELL order book should be ordered on price from lowest ot highest starting at index 0

const Dex = artifacts.require("Dex")
const Link = artifacts.require("Link")
const truffleAssert = require('truffle-assertions');

contract("Dex", accounts => {
    //The user must have ETH deposited such that deposited eth >= BUY order value
   it("should throw an error if ETH balance is too low when creating BUY limit order", async () => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()
       
        await dex.depositEth({value: 10})
         truffleAssert.passes(
            await dex.createLimitOrder(0, web3.utils.fromUtf8("LINK"), 10, 1)
        )
         truffleAssert.reverts(
             await dex.createLimitOrder(0, web3.utils.fromUtf8("LINK"), 10, 1)
         )
    });
    //The user must have enough tokens deposited such that token balance >= sell order amount
    it("should throw an error if token balance is too low when creating SELL limit order", async () => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()

        truffleAssert.reverts(
            await dex.createLimitOrder(1, web3.utils.fromUtf8("LINK"), 10, 1)
       )
       await link.approve(dex.address, 500);
       await dex.deposit(10, web3.utils.fromUtf8("LINK"));
         truffleAssert.passes(
            await dex.createLimitOrder(1, web3.utils.fromUtf8("LINK"), 10, 1)
        )
    });

    
    //The BUY order book should be ordered on price from highest to lowest starting at index 0
    it("The BUY order book should be ordered on price from highest to lowest starting at index 0", async () => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()
        link.approve(dex.address, 500);
        dex.depositEth({value:3000});
        await dex.createLimitOrder(0, web3.utils.fromUtf8("LINK"), 1, 300)
        await dex.createLimitOrder(0, web3.utils.fromUtf8("LINK"), 1, 100)
        await dex.createLimitOrder(0, web3.utils.fromUtf8("LINK"), 1, 200)

        let orderbook = await dex.getOrderBook(web3.utils.fromUtf8("LINK"), 0);

        assert(orderbook.length > 0);

        for (let i = 0; i < orderbook.length - 1; i++) {
             assert(orderbook[i].price >= orderbook[i+1].price,"incorrect order in buy book")
        }
    });
    //The SELL order book should be ordered on price from lowest to highest starting at index 0
    it("The SELL order book should be ordered on price from lowest to highest starting at index 0", async () => {
        let dex = await Dex.deployed()
        let link = await Link.deployed()
        await link.approve(dex.address, 600);
        await dex.createLimitOrder(1, web3.utils.fromUtf8("LINK"), 1, 300);
        await dex.createLimitOrder(1, web3.utils.fromUtf8("LINK"), 1, 100);
        await dex.createLimitOrder(1, web3.utils.fromUtf8("LINK"), 1, 200);

        let orderbook = await dex.getOrderBook(web3.utils.fromUtf8("LINK"), 1);

        assert(orderbook.length > 0);

        for (let i = 0; i < orderbook.length - 1; i++) {
             assert(orderbook[i].price <= orderbook[i+1].price, "incorrect order in buy book")
        }
    });
})