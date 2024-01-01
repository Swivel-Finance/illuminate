// import all major contracts
import "../ETHWrapper.sol";

contract ETHWrapperTest {

    address ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address curvePool = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022;

    address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

    uint256 startingBalance = 100000 ether;

    ETHWrapper ethWrapper = ETHWrapper(0x45aE791cd6346528e9eD247A7ce1f79DFD70472b);

    function testWrapETH() public payable {

            uint256 amount = msg.value;
            // DelegateCall the ETHWrapper.wrap
            (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
                abi.encodeWithSignature(
                    "swap(address,address,address,uint256,uint256)",
                    curvePool,
                    ETH,
                    stETH,
                    amount,
                    0
                )
            );
    }
}