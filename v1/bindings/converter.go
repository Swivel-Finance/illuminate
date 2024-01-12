// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package illuminate

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// ConverterMetaData contains all meta data concerning the Converter contract.
var ConverterMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"Exception\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"c\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"convert\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// ConverterABI is the input ABI used to generate the binding from.
// Deprecated: Use ConverterMetaData.ABI instead.
var ConverterABI = ConverterMetaData.ABI

// Converter is an auto generated Go binding around an Ethereum contract.
type Converter struct {
	ConverterCaller     // Read-only binding to the contract
	ConverterTransactor // Write-only binding to the contract
	ConverterFilterer   // Log filterer for contract events
}

// ConverterCaller is an auto generated read-only Go binding around an Ethereum contract.
type ConverterCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ConverterTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ConverterTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ConverterFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ConverterFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ConverterSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ConverterSession struct {
	Contract     *Converter        // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ConverterCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ConverterCallerSession struct {
	Contract *ConverterCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts    // Call options to use throughout this session
}

// ConverterTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ConverterTransactorSession struct {
	Contract     *ConverterTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts    // Transaction auth options to use throughout this session
}

// ConverterRaw is an auto generated low-level Go binding around an Ethereum contract.
type ConverterRaw struct {
	Contract *Converter // Generic contract binding to access the raw methods on
}

// ConverterCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ConverterCallerRaw struct {
	Contract *ConverterCaller // Generic read-only contract binding to access the raw methods on
}

// ConverterTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ConverterTransactorRaw struct {
	Contract *ConverterTransactor // Generic write-only contract binding to access the raw methods on
}

// NewConverter creates a new instance of Converter, bound to a specific deployed contract.
func NewConverter(address common.Address, backend bind.ContractBackend) (*Converter, error) {
	contract, err := bindConverter(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Converter{ConverterCaller: ConverterCaller{contract: contract}, ConverterTransactor: ConverterTransactor{contract: contract}, ConverterFilterer: ConverterFilterer{contract: contract}}, nil
}

// NewConverterCaller creates a new read-only instance of Converter, bound to a specific deployed contract.
func NewConverterCaller(address common.Address, caller bind.ContractCaller) (*ConverterCaller, error) {
	contract, err := bindConverter(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ConverterCaller{contract: contract}, nil
}

// NewConverterTransactor creates a new write-only instance of Converter, bound to a specific deployed contract.
func NewConverterTransactor(address common.Address, transactor bind.ContractTransactor) (*ConverterTransactor, error) {
	contract, err := bindConverter(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ConverterTransactor{contract: contract}, nil
}

// NewConverterFilterer creates a new log filterer instance of Converter, bound to a specific deployed contract.
func NewConverterFilterer(address common.Address, filterer bind.ContractFilterer) (*ConverterFilterer, error) {
	contract, err := bindConverter(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ConverterFilterer{contract: contract}, nil
}

// bindConverter binds a generic wrapper to an already deployed contract.
func bindConverter(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ConverterABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Converter *ConverterRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Converter.Contract.ConverterCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Converter *ConverterRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Converter.Contract.ConverterTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Converter *ConverterRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Converter.Contract.ConverterTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Converter *ConverterCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Converter.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Converter *ConverterTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Converter.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Converter *ConverterTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Converter.Contract.contract.Transact(opts, method, params...)
}

// Convert is a paid mutator transaction binding the contract method 0x248391ff.
//
// Solidity: function convert(address c, address u, uint256 a) returns()
func (_Converter *ConverterTransactor) Convert(opts *bind.TransactOpts, c common.Address, u common.Address, a *big.Int) (*types.Transaction, error) {
	return _Converter.contract.Transact(opts, "convert", c, u, a)
}

// Convert is a paid mutator transaction binding the contract method 0x248391ff.
//
// Solidity: function convert(address c, address u, uint256 a) returns()
func (_Converter *ConverterSession) Convert(c common.Address, u common.Address, a *big.Int) (*types.Transaction, error) {
	return _Converter.Contract.Convert(&_Converter.TransactOpts, c, u, a)
}

// Convert is a paid mutator transaction binding the contract method 0x248391ff.
//
// Solidity: function convert(address c, address u, uint256 a) returns()
func (_Converter *ConverterTransactorSession) Convert(c common.Address, u common.Address, a *big.Int) (*types.Transaction, error) {
	return _Converter.Contract.Convert(&_Converter.TransactOpts, c, u, a)
}
