package main

import (
	"fmt"
	"log"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/swivel-finance/illuminate/deploy/internal/marketplace"
)

func deployMarketPlace(a *bind.TransactOpts, c *ethclient.Client, r common.Address) {
	fmt.Println("Deploying MarketPlace...")

	marketPlaceAddr, tx, _, err := marketplace.DeployMarketPlace(a, c, r)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Deployed to: %v\n", marketPlaceAddr.Hex())
	fmt.Printf("Transaction hash: %v\n", tx.Hash().Hex())
}
