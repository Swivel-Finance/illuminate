package main

import (
	"fmt"
	"log"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/swivel-finance/illuminate/deploy/internal/lender"
	"github.com/swivel-finance/illuminate/deploy/internal/redeemer"
)

func setMarketPlaceAddressLender(a *bind.TransactOpts, c *ethclient.Client, l common.Address, m common.Address) {
	opts := &bind.TransactOpts{
		From:   a.From,
		Signer: a.Signer,
	}

	fmt.Println("Setting MarketPlace address in Lender...")

	// get the deployed lender...
	lenderCont, err := lender.NewLender(l, c)
	if err != nil {
		log.Fatal(err)
	}

	tx, err := lenderCont.SetMarketPlaceAddress(opts, m)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Transaction hash: %v\n", tx.Hash().Hex())
}

func setMarketPlaceAddressRedeemer(a *bind.TransactOpts, c *ethclient.Client, r common.Address, m common.Address) {
	opts := &bind.TransactOpts{
		From:   a.From,
		Signer: a.Signer,
	}

	fmt.Println("Setting MarketPlace address in Redeemer...")

	// get the deployed redeemer...
	redeemerCont, err := redeemer.NewRedeemer(r, c)
	if err != nil {
		log.Fatal(err)
	}

	tx, err := redeemerCont.SetMarketPlaceAddress(opts, m)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Transaction hash: %v\n", tx.Hash().Hex())
}
