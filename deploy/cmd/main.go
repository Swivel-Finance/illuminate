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
	auth.Value = big.NewInt(0)          // in wei
	auth.GasLimit = uint64(80000000000) // let's see if 8 mill will go...
	//auth.GasPrice = big.NewInt(10000000) // if u wanna just hardcode it - use gwei
	auth.GasPrice = gasPrice // let geth estimate
	fmt.Printf("Using gas price: %v\n", gasPrice)

	fmt.Printf("Transaction options: %v\n", auth)

	// if transferring admin, address here...
	// admin := common.HexToAddress(os.Getenv("ADMIN"))

	// addresses for 3rd party contracts needed
	// swivelAddr := common.HexToAddress("")
	// pendleAddr := common.HexToAddress("")
	// tempusAddr := common.HexToAddress("")
	// apwineAddr := common.HexToAddress("")

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
	// lenderAddr := common.HexToAddress("")

	// deployRedeemer(auth, client, swivelAddr, pendleAddr, tempusAddr, apwineAddr)
	// redeemerAddr := common.HexToAddress("")

	// deployMarketPlace(auth, client, redeemerAddr)
	// marketPlaceAddr := common.HexToAddress("")

	//setMarketPlaceAddressLender(auth, client, lenderAddr, marketPlaceAddr)
	//setMarketPlaceAddressRedeemer(auth, client, redeemerAddr, marketPlaceAddr)

	// createMarket(auth, client, marketPlaceAddr)

	// transferAdminLender(auth, client, lenderAddr, admin)
	// transferAdminRedeemer(auth, client, redeemerAddr, admin)
	// transferAdminMarketplace(auth, client, marketPlaceAddr, admin)

}
