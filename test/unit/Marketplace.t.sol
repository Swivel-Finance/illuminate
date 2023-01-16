// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'forge-std/Test.sol';

import 'src/MarketPlace.sol';

import 'src/mocks/Redeemer.sol' as mock_r;
import 'src/mocks/Lender.sol' as mock_l;
import 'src/mocks/Creator.sol' as mock_c;
import 'src/mocks/ERC20.sol' as mock_erc20;
import 'src/mocks/ERC5095.sol' as mock_erc5095;
import 'src/mocks/Pool.sol' as mock_pool;
import 'src/mocks/PendleToken.sol' as mock_pt;
import 'src/mocks/APWineToken.sol' as mock_apwt;
import 'src/mocks/APWineFutureVault.sol' as mock_apfv;

using stdStorage for StdStorage;

contract MarketplaceTest is Test {
    MarketPlace mp;

    // Mocks
    mock_r.Redeemer r;
    mock_l.Lender l;
    mock_c.Creator c;

    // Helpers
    uint128 amount = 10000;
    uint128 slippage = 11111;
    address underlying = address(new mock_erc20.ERC20());
    uint256 maturity = block.timestamp + 10000;
    uint8 decimals = 6;
    uint128 preview = 12345;

    // Illuminate PT
    mock_erc5095.ERC5095 ipt;

    // Principal tokens
    mock_erc20.ERC20 token0;
    mock_erc20.ERC20 token1;
    mock_erc20.ERC20 token2;
    mock_pt.PendleToken token3;
    mock_erc20.ERC20 token4;
    mock_erc20.ERC20 token5;
    mock_apwt.APWineToken token6;
    mock_erc20.ERC20 token7;

    // Ancillary contracts
    mock_erc20.ERC20 elementVault;
    mock_erc20.ERC20 apwineRouter;
    mock_erc20.ERC20 sensePeriphery;
    mock_apfv.APWineFutureVault apwfv;

    // Yield Space Pool
    mock_pool.Pool pool;


    function setUp() public {
        // deploy mocked redeemer
        r = new mock_r.Redeemer();
        // deploy mocked lender
        l = new mock_l.Lender();
        // deploy mocked creator
        c = new mock_c.Creator();

        // deploy the real marketplace
        mp = new MarketPlace(address(r), address(l), address(c));

        // deploy a bunch of erc20 principal tokens
        token0 = new mock_erc20.ERC20();
        token1 = new mock_erc20.ERC20();
        token2 = new mock_erc20.ERC20();
        token3 = new mock_pt.PendleToken();
        token4 = new mock_erc20.ERC20();
        token5 = new mock_erc20.ERC20();
        token6 = new mock_apwt.APWineToken();
        token7 = new mock_apwt.ERC20();

        ipt = new mock_erc5095.ERC5095();

        elementVault = new mock_erc20.ERC20();
        apwineRouter = new mock_erc20.ERC20();
        sensePeriphery = new mock_erc20.ERC20();

        apwfv = new mock_apfv.APWineFutureVault();

        pool = new mock_pool.Pool();

        // Set an existing pool for the tests
        stdstore
            .target(address(mp))
            .sig('pools(address,uint256)')
            .with_key(underlying)
            .with_key(maturity)
            .depth(0)
            .checked_write(address(pool));
    }

    function testCreateMarket() public {
        address[8] memory contracts;
        contracts[0] = address(token0); // Swivel
        contracts[1] = address(token1); // Yield
        contracts[2] = address(token2); // Element
        contracts[3] = address(token3); // Pendle
        contracts[4] = address(token4); // Tempus
        contracts[5] = address(token5); // Sense
        contracts[6] = address(token6); // APWine
        contracts[7] = address(token7); // Notional

        mock_erc20.ERC20(underlying).decimalsReturns(10);
        mock_erc20.ERC20 compounding = new mock_erc20.ERC20();
        token6.futureVaultReturns(address(apwfv));
        apwfv.getIBTAddressReturns(address(compounding));
        token3.underlyingYieldTokenReturns(address(compounding));

        c.createReturns(address(ipt));
        ipt.poolReturns(address(pool));
        ipt.setPoolReturns(true);

        uint256 newMaturity = maturity + 20;

        mp.createMarket(
            address(underlying),
            newMaturity,
            contracts,
            'test-token',
            'tt',
            address(apwineRouter),
            address(elementVault),
            address(0),
            address(sensePeriphery)
        );

        // Test that the pool was set
        mp.setPool(underlying, newMaturity, address(pool));
        assertEq(mp.pools(underlying, newMaturity), address(pool));

        // verify pool is set
        assertEq(ipt.pool(), address(pool));

        // verify token creation
        (
            uint256 maturityCalled, 
            address redeemerCalled, 
            address lenderCalled, 
            address marketPlaceCalled, 
            string memory nameCalled, 
            string memory symbolCalled
        ) = c.createCalled(underlying);
        assertEq(newMaturity, maturityCalled);
        assertEq(address(r), redeemerCalled);
        assertEq(address(l), lenderCalled);
        assertEq(address(mp), marketPlaceCalled);
        assertEq(nameCalled, 'test-token');
        assertEq(symbolCalled, 'tt');

        // verify approvals
        assertEq(r.approveCalled(), address(compounding));

        (
            address approvedApwine,
            address approvedElement,
            address approvedNotional,
            address approvedPeriphery
        ) = l.approveCalled(address(underlying));
        assertEq(approvedApwine, address(apwineRouter));
        assertEq(approvedElement, address(elementVault));
        assertEq(approvedNotional, contracts[7]);
        assertEq(approvedPeriphery, address(sensePeriphery));
    }

    function testSetPrincipal() public {
        address[8] memory contracts;

        mock_erc20.ERC20 compounding = new mock_erc20.ERC20();
        token6.futureVaultReturns(address(apwfv));
        apwfv.getIBTAddressReturns(address(compounding));
        token3.underlyingYieldTokenReturns(address(compounding));

        mp.createMarket(
            underlying,
            maturity,
            contracts,
            'test-token',
            'tt',
            address(apwineRouter),
            address(elementVault),
            address(0),
            address(sensePeriphery)
        );

        // verify approvals
        assertEq(r.approveCalled(), contracts[3]);

        (
            address approvedApwine,
            address approvedElement,
            address approvedNotional,
            address approvedPeriphery
        ) = l.approveCalled(underlying);
        assertEq(approvedApwine, address(apwineRouter));
        assertEq(approvedElement, address(elementVault));
        assertEq(approvedNotional, contracts[7]);
        assertEq(approvedPeriphery, address(sensePeriphery));

        mp.setPrincipal(4, underlying, maturity, address(token3), address(0), address(0));
        assertEq(mp.markets(underlying, maturity, 4), address(token3));

        mp.setPrincipal(7, underlying, maturity, address(token6), address(0), address(0));
        assertEq(mp.markets(underlying, maturity, 7), address(token6));
    }

    function testSetNotional() public {
        address[8] memory emptyMarket;
        emptyMarket[0] = address(0); // Swivel
        emptyMarket[1] = address(0); // Yield
        emptyMarket[2] = address(0); // Element
        emptyMarket[3] = address(0); // Pendle
        emptyMarket[4] = address(0); // Tempus
        emptyMarket[5] = address(0); // Sense
        emptyMarket[6] = address(0); // APWine
        emptyMarket[7] = address(0); // Notional

        address u = address(new mock_erc20.ERC20());
        uint256 m = 123456;
        mp.createMarket(
            u,
            m,
            emptyMarket,
            'test-token',
            'tt',
            address(0),
            address(0),
            address(0),
            address(0));


        assertEq(address(0), mp.markets(u, m, 7));

        (
            address approvedApwine,
            address approvedElement,
            address approvedNotional,
            address approvedPeriphery
        ) = l.approveCalled(u);
        assertEq(approvedApwine, address(0));
        assertEq(approvedElement, address(0));
        assertEq(approvedNotional, address(0));
        assertEq(approvedPeriphery, address(0));

        mp.setPrincipal(8, u, m, address(token7), address(0), address(0));

        (
            approvedApwine,
            approvedElement,
            approvedNotional,
            approvedPeriphery
        ) = l.approveCalled(u);
        assertEq(approvedApwine, address(0));
        assertEq(approvedElement, address(0));
        assertEq(approvedNotional, address(token7));
        assertEq(approvedPeriphery, address(0));
    }

    function testSellPrincipalToken() public {
        pool.sellFYTokenPreviewReturns(preview);
        pool.sellFYTokenReturns(preview);

        mp.sellPrincipalToken(underlying, maturity, amount, slippage);

        uint256 amountSold = pool.sellFYTokenCalled(address(this));
        assertEq(amountSold, preview);
    }

    function testBuyPrincipalToken() public {
        pool.buyFYTokenReturns(preview);
        pool.buyFYTokenPreviewReturns(preview);

        mp.buyPrincipalToken(underlying, maturity, amount, type(uint128).max);

        (uint256 previewed, ) = pool.buyFYTokenCalled(address(this));
        assertEq(previewed, amount);
    }

    function testSellUnderlying() public {
        pool.sellBaseReturns(preview);
        pool.sellBasePreviewReturns(preview);

        mp.sellUnderlying(underlying, maturity, amount, slippage);

        uint256 previewed = pool.sellBaseCalled(address(this));
        assertEq(previewed, preview);
    }

    function testBuyUnderlying() public {
        pool.buyBaseReturns(preview);
        pool.sellFYTokenPreviewReturns(preview);

        mp.buyUnderlying(underlying, maturity, amount, type(uint128).max);

        (uint256 previewed, ) = pool.buyBaseCalled(address(this));
        assertEq(previewed, amount);
    }

    function testMint() public {
        pool.baseReturns(address(token1));
        pool.fyTokenReturns(address(token2));
        token1.transferFromReturns(true);
        token2.transferFromReturns(true);
        pool.mintReturns(1, 2, 3);

        uint256 uA = 100;
        uint256 ptA = 140;
        uint256 minRatio = 1;
        uint256 maxRatio = 2;
        mp.mint(underlying, maturity, uA, ptA, minRatio, maxRatio);

        (address recipient, uint256 transferAmount) = token1.transferFromCalled(
            address(this)
        );
        assertEq(recipient, address(pool));
        assertEq(transferAmount, uA);

        (recipient, transferAmount) = token2.transferFromCalled(address(this));
        assertEq(recipient, address(pool));
        assertEq(transferAmount, ptA);

        (address remainder, uint256 min, uint256 max) = pool.mintCalled(
            address(this)
        );
        assertEq(remainder, address(this));
        assertEq(min, minRatio);
        assertEq(max, maxRatio);
    }

    function testMintWithUnderlying() public {
        pool.baseReturns(address(token1));
        token1.transferFromReturns(true);
        pool.mintWithBaseReturns(7, 8, 9);

        uint128 ptBought = 1000;
        uint256 minRatio = 10;
        uint256 maxRatio = 20;
        mp.mintWithUnderlying(
            underlying,
            maturity,
            amount,
            ptBought,
            minRatio,
            maxRatio
        );

        (address recipient, uint256 transferAmount) = token1.transferFromCalled(
            address(this)
        );
        assertEq(recipient, address(pool));
        assertEq(transferAmount, amount);

        pool.mintWithBaseCalled(address(this));
        (
            address remainder,
            uint256 fyTokenToBuy,
            uint256 min,
            uint256 max
        ) = pool.mintWithBaseCalled(address(this));

        assertEq(remainder, address(this));
        assertEq(fyTokenToBuy, ptBought);
        assertEq(min, minRatio);
        assertEq(max, maxRatio);
    }

    function testBurn() public {
        pool.burnReturns(1, 1, 1);

        uint256 minRatio = 124;
        uint256 maxRatio = 893;
        mp.burn(underlying, maturity, amount, minRatio, maxRatio);

        (address remainder, uint256 min, uint256 max) = pool.burnCalled(
            address(this)
        );
        assertEq(remainder, address(this));
        assertEq(min, minRatio);
        assertEq(max, maxRatio);
    }

    function testBurnForUnderlying() public {
        pool.burnForBaseReturns(1, 1);

        uint256 minRatio = 124;
        uint256 maxRatio = 893;
        mp.burnForUnderlying(underlying, maturity, amount, minRatio, maxRatio);

        (uint256 min, uint256 max) = pool.burnForBaseCalled(address(this));
        assertEq(min, minRatio);
        assertEq(max, maxRatio);
    }

    function testFailSlippageExceeded() public {
        uint128 failingPreview = slippage - 1;

        pool.sellFYTokenPreviewReturns(failingPreview);
        vm.expectRevert(Exception.selector);
        mp.sellPrincipalToken(underlying, maturity, amount, slippage);

        pool.sellFYTokenPreviewReturns(failingPreview);
        vm.expectRevert(Exception.selector);
        mp.sellPrincipalToken(underlying, maturity, amount, slippage);

        pool.buyBasePreviewReturns(failingPreview);
        vm.expectRevert(Exception.selector);
        mp.buyPrincipalToken(underlying, maturity, amount, slippage);

        pool.sellBasePreviewReturns(failingPreview);
        vm.expectRevert(Exception.selector);
        mp.sellPrincipalToken(underlying, maturity, amount, slippage);
    }

    function testFailSetExistingPrincipal() public {
        mp.setPrincipal(1, address(0), 0, msg.sender, address(0), address(0));
        vm.expectRevert(Exception.selector);
        mp.setPrincipal(1, address(0), 0, msg.sender, address(0), address(0));
    }

    function testFailSetExistingPool() public {
        vm.expectRevert(Exception.selector);
        mp.setPool(address(0), 0, msg.sender);
    }
}
