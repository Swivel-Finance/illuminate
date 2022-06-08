package main

import (
	"fmt"
	"log"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/swivel-finance/illuminate/deploy/internal/redeemer"
)

func deployRedeemer(a *bind.TransactOpts, c *ethclient.Client, s common.Address, p common.Address, t common.Address, w common.Address, l common.Address) {
	fmt.Println("Deploying Redeemer...")

	redeemerAddr, tx, _, err := redeemer.DeployRedeemer(a, c, s, p, t, w, l)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Deployed to: %v\n", redeemerAddr.Hex())
	fmt.Printf("Transaction hash: %v\n", tx.Hash().Hex())
}
