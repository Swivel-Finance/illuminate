package main

import (
	"fmt"
	"log"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/swivel-finance/illuminate/deploy/internal/lender"
)

func deployLender(a *bind.TransactOpts, c *ethclient.Client, s common.Address, p common.Address, t common.Address) {
	fmt.Println("Deploying Lender...")

	lenderAddr, tx, _, err := lender.DeployLender(a, c, s, p, t)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Deployed to: %v\n", lenderAddr.Hex())
	fmt.Printf("Transaction hash: %v\n", tx.Hash().Hex())
}
