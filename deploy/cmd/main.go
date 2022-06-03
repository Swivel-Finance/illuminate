package main

import (
	"context"
	"crypto/ecdsa"
	"fmt"
	"log"
	"math/big"
	"os"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
)

func main() {
	// arbitrum rinkeby chain ID is 421611
	chainId := big.NewInt(4)

	// whichever fully qualified url your probject uses to establish connection to your node...
	client, err := ethclient.Dial(os.Getenv("CLIENT_URL"))

	if err != nil {
		log.Fatal(err)
	}

	privateKey, err := crypto.HexToECDSA(os.Getenv("PRIVATE_KEY"))
	if err != nil {
		log.Fatal(err)
	}

	publicKey := privateKey.Public()
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("error casting public key to ECDSA")
	}

	fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
	nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Current Nonce: %v\n", nonce)

	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Gas estimate: %v\n", gasPrice)
	// fmt.Println("Attempting to use 70 gwei as gas price")

	auth, err := bind.NewKeyedTransactorWithChainID(privateKey, chainId)
	if err != nil {
		log.Fatal(err)
	}

	auth.Nonce = big.NewInt(int64(nonce))
	auth.Value = big.NewInt(0)      // in wei
	auth.GasLimit = uint64(8000000) // let's see if 8 mill will go...
	//auth.GasPrice = big.NewInt(10000000) // if u wanna just hardcode it - use gwei
	auth.GasPrice = gasPrice // let geth estimate
	fmt.Printf("Using gas price: %v\n", gasPrice)

	fmt.Printf("Transaction options: %v\n", auth)

	// if transferring admin, address here...
	// admin := common.HexToAddress(os.Getenv("ADMIN"))

	// addresses for 3rd party contracts needed
	// swivelAddr := common.HexToAddress("0x3a09584FF42CDFe27Fe72Da0533bba24E9C28AaD")
	// pendleAddr := common.HexToAddress("0x0")
	// tempusAddr := common.HexToAddress("0x0")
	// apwineAddr := common.HexToAddress("0x0")

	/*
		We simply turn these steps on and off by commenting them.
		TODO we _could_ automate it by waiting for receipts etc...

		1. deploy lender
		   a. update lender address var
		2. deploy redeemer
		   a. update redeemer address var
		3. deploy marketplace
		4. set marketplace address in deployed lender
		5. set marketplace address in deployed redeemer
		6. create any desired markets
		7. Transfer admin in contracts if desired
	*/

	// TODO we dont return the address here as we don't try to chain them atm
	// deployLender(auth, client, swivelAddr, pendleAddr, tempusAddr)
	// lenderAddr := common.HexToAddress("0x915c23620aD5c60Fa9F9280A64AD9bD290317D39")

	// deployRedeemer(auth, client, swivelAddr, pendleAddr, tempusAddr, apwineAddr)
	// redeemerAddr := common.HexToAddress("0x936E467Dbb4f73B44E0dcF78aA2138275fca04ba")

	// deployMarketPlace(auth, client, redeemerAddr)
	// marketPlaceAddr := common.HexToAddress("0x1bD3197487E3eac7Ed0fEeb6cB5bc04370639C05")

	// setMarketPlaceAddressLender(auth, client, lenderAddr, marketPlaceAddr)
	// setMarketPlaceAddressRedeemer(auth, client, redeemerAddr, marketPlaceAddr)

	// createMarket(auth, client, marketPlaceAddr)

	// transferAdminLender(auth, client, lenderAddr, admin)
	// transferAdminRedeemer(auth, client, redeemerAddr, admin)
	// transferAdminMarketplace(auth, client, marketPlaceAddr, admin)
}
