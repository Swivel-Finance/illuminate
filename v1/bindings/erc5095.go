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

// ERC5095MetaData contains all meta data concerning the ERC5095 contract.
var ERC5095MetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_underlying\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_maturity\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"_redeemer\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_lender\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_marketplace\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"name_\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"symbol_\",\"type\":\"string\"},{\"internalType\":\"uint8\",\"name\":\"decimals_\",\"type\":\"uint8\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"Exception\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"DOMAIN_SEPARATOR\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"PERMIT_TYPEHASH\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"wad\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"approveMarketPlace\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"o\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"s\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"authApprove\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"f\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"authBurn\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"t\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"authMint\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"guy\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"convertToShares\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"}],\"name\":\"convertToUnderlying\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"deploymentChainId\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"}],\"name\":\"deposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"}],\"name\":\"deposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"lender\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"marketplace\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"maturity\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"o\",\"type\":\"address\"}],\"name\":\"maxRedeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"o\",\"type\":\"address\"}],\"name\":\"maxWithdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"nonces\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"deadline\",\"type\":\"uint256\"},{\"internalType\":\"uint8\",\"name\":\"v\",\"type\":\"uint8\"},{\"internalType\":\"bytes32\",\"name\":\"r\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"s\",\"type\":\"bytes32\"}],\"name\":\"permit\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"pool\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"previewDeposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"}],\"name\":\"previewMint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"}],\"name\":\"previewRedeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"previewWithdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"o\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"}],\"name\":\"redeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"o\",\"type\":\"address\"}],\"name\":\"redeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"redeemer\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"p\",\"type\":\"address\"}],\"name\":\"setPool\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"dst\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"wad\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"src\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"dst\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"wad\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"underlying\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"version\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"o\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"}],\"name\":\"withdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"o\",\"type\":\"address\"}],\"name\":\"withdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// ERC5095ABI is the input ABI used to generate the binding from.
// Deprecated: Use ERC5095MetaData.ABI instead.
var ERC5095ABI = ERC5095MetaData.ABI

// ERC5095 is an auto generated Go binding around an Ethereum contract.
type ERC5095 struct {
	ERC5095Caller     // Read-only binding to the contract
	ERC5095Transactor // Write-only binding to the contract
	ERC5095Filterer   // Log filterer for contract events
}

// ERC5095Caller is an auto generated read-only Go binding around an Ethereum contract.
type ERC5095Caller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ERC5095Transactor is an auto generated write-only Go binding around an Ethereum contract.
type ERC5095Transactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ERC5095Filterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ERC5095Filterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ERC5095Session is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ERC5095Session struct {
	Contract     *ERC5095          // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ERC5095CallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ERC5095CallerSession struct {
	Contract *ERC5095Caller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts  // Call options to use throughout this session
}

// ERC5095TransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ERC5095TransactorSession struct {
	Contract     *ERC5095Transactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// ERC5095Raw is an auto generated low-level Go binding around an Ethereum contract.
type ERC5095Raw struct {
	Contract *ERC5095 // Generic contract binding to access the raw methods on
}

// ERC5095CallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ERC5095CallerRaw struct {
	Contract *ERC5095Caller // Generic read-only contract binding to access the raw methods on
}

// ERC5095TransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ERC5095TransactorRaw struct {
	Contract *ERC5095Transactor // Generic write-only contract binding to access the raw methods on
}

// NewERC5095 creates a new instance of ERC5095, bound to a specific deployed contract.
func NewERC5095(address common.Address, backend bind.ContractBackend) (*ERC5095, error) {
	contract, err := bindERC5095(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ERC5095{ERC5095Caller: ERC5095Caller{contract: contract}, ERC5095Transactor: ERC5095Transactor{contract: contract}, ERC5095Filterer: ERC5095Filterer{contract: contract}}, nil
}

// NewERC5095Caller creates a new read-only instance of ERC5095, bound to a specific deployed contract.
func NewERC5095Caller(address common.Address, caller bind.ContractCaller) (*ERC5095Caller, error) {
	contract, err := bindERC5095(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ERC5095Caller{contract: contract}, nil
}

// NewERC5095Transactor creates a new write-only instance of ERC5095, bound to a specific deployed contract.
func NewERC5095Transactor(address common.Address, transactor bind.ContractTransactor) (*ERC5095Transactor, error) {
	contract, err := bindERC5095(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ERC5095Transactor{contract: contract}, nil
}

// NewERC5095Filterer creates a new log filterer instance of ERC5095, bound to a specific deployed contract.
func NewERC5095Filterer(address common.Address, filterer bind.ContractFilterer) (*ERC5095Filterer, error) {
	contract, err := bindERC5095(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ERC5095Filterer{contract: contract}, nil
}

// bindERC5095 binds a generic wrapper to an already deployed contract.
func bindERC5095(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ERC5095ABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ERC5095 *ERC5095Raw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ERC5095.Contract.ERC5095Caller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ERC5095 *ERC5095Raw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ERC5095.Contract.ERC5095Transactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ERC5095 *ERC5095Raw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ERC5095.Contract.ERC5095Transactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ERC5095 *ERC5095CallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ERC5095.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ERC5095 *ERC5095TransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ERC5095.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ERC5095 *ERC5095TransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ERC5095.Contract.contract.Transact(opts, method, params...)
}

// DOMAINSEPARATOR is a free data retrieval call binding the contract method 0x3644e515.
//
// Solidity: function DOMAIN_SEPARATOR() view returns(bytes32)
func (_ERC5095 *ERC5095Caller) DOMAINSEPARATOR(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "DOMAIN_SEPARATOR")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// DOMAINSEPARATOR is a free data retrieval call binding the contract method 0x3644e515.
//
// Solidity: function DOMAIN_SEPARATOR() view returns(bytes32)
func (_ERC5095 *ERC5095Session) DOMAINSEPARATOR() ([32]byte, error) {
	return _ERC5095.Contract.DOMAINSEPARATOR(&_ERC5095.CallOpts)
}

// DOMAINSEPARATOR is a free data retrieval call binding the contract method 0x3644e515.
//
// Solidity: function DOMAIN_SEPARATOR() view returns(bytes32)
func (_ERC5095 *ERC5095CallerSession) DOMAINSEPARATOR() ([32]byte, error) {
	return _ERC5095.Contract.DOMAINSEPARATOR(&_ERC5095.CallOpts)
}

// PERMITTYPEHASH is a free data retrieval call binding the contract method 0x30adf81f.
//
// Solidity: function PERMIT_TYPEHASH() view returns(bytes32)
func (_ERC5095 *ERC5095Caller) PERMITTYPEHASH(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "PERMIT_TYPEHASH")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// PERMITTYPEHASH is a free data retrieval call binding the contract method 0x30adf81f.
//
// Solidity: function PERMIT_TYPEHASH() view returns(bytes32)
func (_ERC5095 *ERC5095Session) PERMITTYPEHASH() ([32]byte, error) {
	return _ERC5095.Contract.PERMITTYPEHASH(&_ERC5095.CallOpts)
}

// PERMITTYPEHASH is a free data retrieval call binding the contract method 0x30adf81f.
//
// Solidity: function PERMIT_TYPEHASH() view returns(bytes32)
func (_ERC5095 *ERC5095CallerSession) PERMITTYPEHASH() ([32]byte, error) {
	return _ERC5095.Contract.PERMITTYPEHASH(&_ERC5095.CallOpts)
}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_ERC5095 *ERC5095Caller) Allowance(opts *bind.CallOpts, owner common.Address, spender common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "allowance", owner, spender)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_ERC5095 *ERC5095Session) Allowance(owner common.Address, spender common.Address) (*big.Int, error) {
	return _ERC5095.Contract.Allowance(&_ERC5095.CallOpts, owner, spender)
}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) Allowance(owner common.Address, spender common.Address) (*big.Int, error) {
	return _ERC5095.Contract.Allowance(&_ERC5095.CallOpts, owner, spender)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address guy) view returns(uint256)
func (_ERC5095 *ERC5095Caller) BalanceOf(opts *bind.CallOpts, guy common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "balanceOf", guy)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address guy) view returns(uint256)
func (_ERC5095 *ERC5095Session) BalanceOf(guy common.Address) (*big.Int, error) {
	return _ERC5095.Contract.BalanceOf(&_ERC5095.CallOpts, guy)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address guy) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) BalanceOf(guy common.Address) (*big.Int, error) {
	return _ERC5095.Contract.BalanceOf(&_ERC5095.CallOpts, guy)
}

// ConvertToShares is a free data retrieval call binding the contract method 0xc6e6f592.
//
// Solidity: function convertToShares(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095Caller) ConvertToShares(opts *bind.CallOpts, a *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "convertToShares", a)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ConvertToShares is a free data retrieval call binding the contract method 0xc6e6f592.
//
// Solidity: function convertToShares(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095Session) ConvertToShares(a *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.ConvertToShares(&_ERC5095.CallOpts, a)
}

// ConvertToShares is a free data retrieval call binding the contract method 0xc6e6f592.
//
// Solidity: function convertToShares(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) ConvertToShares(a *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.ConvertToShares(&_ERC5095.CallOpts, a)
}

// ConvertToUnderlying is a free data retrieval call binding the contract method 0x1dc7f521.
//
// Solidity: function convertToUnderlying(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095Caller) ConvertToUnderlying(opts *bind.CallOpts, s *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "convertToUnderlying", s)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ConvertToUnderlying is a free data retrieval call binding the contract method 0x1dc7f521.
//
// Solidity: function convertToUnderlying(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095Session) ConvertToUnderlying(s *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.ConvertToUnderlying(&_ERC5095.CallOpts, s)
}

// ConvertToUnderlying is a free data retrieval call binding the contract method 0x1dc7f521.
//
// Solidity: function convertToUnderlying(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) ConvertToUnderlying(s *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.ConvertToUnderlying(&_ERC5095.CallOpts, s)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_ERC5095 *ERC5095Caller) Decimals(opts *bind.CallOpts) (uint8, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "decimals")

	if err != nil {
		return *new(uint8), err
	}

	out0 := *abi.ConvertType(out[0], new(uint8)).(*uint8)

	return out0, err

}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_ERC5095 *ERC5095Session) Decimals() (uint8, error) {
	return _ERC5095.Contract.Decimals(&_ERC5095.CallOpts)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_ERC5095 *ERC5095CallerSession) Decimals() (uint8, error) {
	return _ERC5095.Contract.Decimals(&_ERC5095.CallOpts)
}

// DeploymentChainId is a free data retrieval call binding the contract method 0xcd0d0096.
//
// Solidity: function deploymentChainId() view returns(uint256)
func (_ERC5095 *ERC5095Caller) DeploymentChainId(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "deploymentChainId")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// DeploymentChainId is a free data retrieval call binding the contract method 0xcd0d0096.
//
// Solidity: function deploymentChainId() view returns(uint256)
func (_ERC5095 *ERC5095Session) DeploymentChainId() (*big.Int, error) {
	return _ERC5095.Contract.DeploymentChainId(&_ERC5095.CallOpts)
}

// DeploymentChainId is a free data retrieval call binding the contract method 0xcd0d0096.
//
// Solidity: function deploymentChainId() view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) DeploymentChainId() (*big.Int, error) {
	return _ERC5095.Contract.DeploymentChainId(&_ERC5095.CallOpts)
}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_ERC5095 *ERC5095Caller) Lender(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "lender")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_ERC5095 *ERC5095Session) Lender() (common.Address, error) {
	return _ERC5095.Contract.Lender(&_ERC5095.CallOpts)
}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_ERC5095 *ERC5095CallerSession) Lender() (common.Address, error) {
	return _ERC5095.Contract.Lender(&_ERC5095.CallOpts)
}

// Marketplace is a free data retrieval call binding the contract method 0xabc8c7af.
//
// Solidity: function marketplace() view returns(address)
func (_ERC5095 *ERC5095Caller) Marketplace(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "marketplace")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Marketplace is a free data retrieval call binding the contract method 0xabc8c7af.
//
// Solidity: function marketplace() view returns(address)
func (_ERC5095 *ERC5095Session) Marketplace() (common.Address, error) {
	return _ERC5095.Contract.Marketplace(&_ERC5095.CallOpts)
}

// Marketplace is a free data retrieval call binding the contract method 0xabc8c7af.
//
// Solidity: function marketplace() view returns(address)
func (_ERC5095 *ERC5095CallerSession) Marketplace() (common.Address, error) {
	return _ERC5095.Contract.Marketplace(&_ERC5095.CallOpts)
}

// Maturity is a free data retrieval call binding the contract method 0x204f83f9.
//
// Solidity: function maturity() view returns(uint256)
func (_ERC5095 *ERC5095Caller) Maturity(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "maturity")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Maturity is a free data retrieval call binding the contract method 0x204f83f9.
//
// Solidity: function maturity() view returns(uint256)
func (_ERC5095 *ERC5095Session) Maturity() (*big.Int, error) {
	return _ERC5095.Contract.Maturity(&_ERC5095.CallOpts)
}

// Maturity is a free data retrieval call binding the contract method 0x204f83f9.
//
// Solidity: function maturity() view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) Maturity() (*big.Int, error) {
	return _ERC5095.Contract.Maturity(&_ERC5095.CallOpts)
}

// MaxRedeem is a free data retrieval call binding the contract method 0xd905777e.
//
// Solidity: function maxRedeem(address o) view returns(uint256)
func (_ERC5095 *ERC5095Caller) MaxRedeem(opts *bind.CallOpts, o common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "maxRedeem", o)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxRedeem is a free data retrieval call binding the contract method 0xd905777e.
//
// Solidity: function maxRedeem(address o) view returns(uint256)
func (_ERC5095 *ERC5095Session) MaxRedeem(o common.Address) (*big.Int, error) {
	return _ERC5095.Contract.MaxRedeem(&_ERC5095.CallOpts, o)
}

// MaxRedeem is a free data retrieval call binding the contract method 0xd905777e.
//
// Solidity: function maxRedeem(address o) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) MaxRedeem(o common.Address) (*big.Int, error) {
	return _ERC5095.Contract.MaxRedeem(&_ERC5095.CallOpts, o)
}

// MaxWithdraw is a free data retrieval call binding the contract method 0xce96cb77.
//
// Solidity: function maxWithdraw(address o) view returns(uint256)
func (_ERC5095 *ERC5095Caller) MaxWithdraw(opts *bind.CallOpts, o common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "maxWithdraw", o)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxWithdraw is a free data retrieval call binding the contract method 0xce96cb77.
//
// Solidity: function maxWithdraw(address o) view returns(uint256)
func (_ERC5095 *ERC5095Session) MaxWithdraw(o common.Address) (*big.Int, error) {
	return _ERC5095.Contract.MaxWithdraw(&_ERC5095.CallOpts, o)
}

// MaxWithdraw is a free data retrieval call binding the contract method 0xce96cb77.
//
// Solidity: function maxWithdraw(address o) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) MaxWithdraw(o common.Address) (*big.Int, error) {
	return _ERC5095.Contract.MaxWithdraw(&_ERC5095.CallOpts, o)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_ERC5095 *ERC5095Caller) Name(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "name")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_ERC5095 *ERC5095Session) Name() (string, error) {
	return _ERC5095.Contract.Name(&_ERC5095.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_ERC5095 *ERC5095CallerSession) Name() (string, error) {
	return _ERC5095.Contract.Name(&_ERC5095.CallOpts)
}

// Nonces is a free data retrieval call binding the contract method 0x7ecebe00.
//
// Solidity: function nonces(address ) view returns(uint256)
func (_ERC5095 *ERC5095Caller) Nonces(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "nonces", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Nonces is a free data retrieval call binding the contract method 0x7ecebe00.
//
// Solidity: function nonces(address ) view returns(uint256)
func (_ERC5095 *ERC5095Session) Nonces(arg0 common.Address) (*big.Int, error) {
	return _ERC5095.Contract.Nonces(&_ERC5095.CallOpts, arg0)
}

// Nonces is a free data retrieval call binding the contract method 0x7ecebe00.
//
// Solidity: function nonces(address ) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) Nonces(arg0 common.Address) (*big.Int, error) {
	return _ERC5095.Contract.Nonces(&_ERC5095.CallOpts, arg0)
}

// Pool is a free data retrieval call binding the contract method 0x16f0115b.
//
// Solidity: function pool() view returns(address)
func (_ERC5095 *ERC5095Caller) Pool(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "pool")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Pool is a free data retrieval call binding the contract method 0x16f0115b.
//
// Solidity: function pool() view returns(address)
func (_ERC5095 *ERC5095Session) Pool() (common.Address, error) {
	return _ERC5095.Contract.Pool(&_ERC5095.CallOpts)
}

// Pool is a free data retrieval call binding the contract method 0x16f0115b.
//
// Solidity: function pool() view returns(address)
func (_ERC5095 *ERC5095CallerSession) Pool() (common.Address, error) {
	return _ERC5095.Contract.Pool(&_ERC5095.CallOpts)
}

// PreviewDeposit is a free data retrieval call binding the contract method 0xef8b30f7.
//
// Solidity: function previewDeposit(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095Caller) PreviewDeposit(opts *bind.CallOpts, a *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "previewDeposit", a)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewDeposit is a free data retrieval call binding the contract method 0xef8b30f7.
//
// Solidity: function previewDeposit(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095Session) PreviewDeposit(a *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewDeposit(&_ERC5095.CallOpts, a)
}

// PreviewDeposit is a free data retrieval call binding the contract method 0xef8b30f7.
//
// Solidity: function previewDeposit(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) PreviewDeposit(a *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewDeposit(&_ERC5095.CallOpts, a)
}

// PreviewMint is a free data retrieval call binding the contract method 0xb3d7f6b9.
//
// Solidity: function previewMint(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095Caller) PreviewMint(opts *bind.CallOpts, s *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "previewMint", s)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewMint is a free data retrieval call binding the contract method 0xb3d7f6b9.
//
// Solidity: function previewMint(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095Session) PreviewMint(s *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewMint(&_ERC5095.CallOpts, s)
}

// PreviewMint is a free data retrieval call binding the contract method 0xb3d7f6b9.
//
// Solidity: function previewMint(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) PreviewMint(s *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewMint(&_ERC5095.CallOpts, s)
}

// PreviewRedeem is a free data retrieval call binding the contract method 0x4cdad506.
//
// Solidity: function previewRedeem(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095Caller) PreviewRedeem(opts *bind.CallOpts, s *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "previewRedeem", s)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewRedeem is a free data retrieval call binding the contract method 0x4cdad506.
//
// Solidity: function previewRedeem(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095Session) PreviewRedeem(s *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewRedeem(&_ERC5095.CallOpts, s)
}

// PreviewRedeem is a free data retrieval call binding the contract method 0x4cdad506.
//
// Solidity: function previewRedeem(uint256 s) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) PreviewRedeem(s *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewRedeem(&_ERC5095.CallOpts, s)
}

// PreviewWithdraw is a free data retrieval call binding the contract method 0x0a28a477.
//
// Solidity: function previewWithdraw(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095Caller) PreviewWithdraw(opts *bind.CallOpts, a *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "previewWithdraw", a)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewWithdraw is a free data retrieval call binding the contract method 0x0a28a477.
//
// Solidity: function previewWithdraw(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095Session) PreviewWithdraw(a *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewWithdraw(&_ERC5095.CallOpts, a)
}

// PreviewWithdraw is a free data retrieval call binding the contract method 0x0a28a477.
//
// Solidity: function previewWithdraw(uint256 a) view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) PreviewWithdraw(a *big.Int) (*big.Int, error) {
	return _ERC5095.Contract.PreviewWithdraw(&_ERC5095.CallOpts, a)
}

// Redeemer is a free data retrieval call binding the contract method 0x2ba29d38.
//
// Solidity: function redeemer() view returns(address)
func (_ERC5095 *ERC5095Caller) Redeemer(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "redeemer")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Redeemer is a free data retrieval call binding the contract method 0x2ba29d38.
//
// Solidity: function redeemer() view returns(address)
func (_ERC5095 *ERC5095Session) Redeemer() (common.Address, error) {
	return _ERC5095.Contract.Redeemer(&_ERC5095.CallOpts)
}

// Redeemer is a free data retrieval call binding the contract method 0x2ba29d38.
//
// Solidity: function redeemer() view returns(address)
func (_ERC5095 *ERC5095CallerSession) Redeemer() (common.Address, error) {
	return _ERC5095.Contract.Redeemer(&_ERC5095.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_ERC5095 *ERC5095Caller) Symbol(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "symbol")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_ERC5095 *ERC5095Session) Symbol() (string, error) {
	return _ERC5095.Contract.Symbol(&_ERC5095.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_ERC5095 *ERC5095CallerSession) Symbol() (string, error) {
	return _ERC5095.Contract.Symbol(&_ERC5095.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_ERC5095 *ERC5095Caller) TotalSupply(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "totalSupply")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_ERC5095 *ERC5095Session) TotalSupply() (*big.Int, error) {
	return _ERC5095.Contract.TotalSupply(&_ERC5095.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_ERC5095 *ERC5095CallerSession) TotalSupply() (*big.Int, error) {
	return _ERC5095.Contract.TotalSupply(&_ERC5095.CallOpts)
}

// Underlying is a free data retrieval call binding the contract method 0x6f307dc3.
//
// Solidity: function underlying() view returns(address)
func (_ERC5095 *ERC5095Caller) Underlying(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "underlying")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Underlying is a free data retrieval call binding the contract method 0x6f307dc3.
//
// Solidity: function underlying() view returns(address)
func (_ERC5095 *ERC5095Session) Underlying() (common.Address, error) {
	return _ERC5095.Contract.Underlying(&_ERC5095.CallOpts)
}

// Underlying is a free data retrieval call binding the contract method 0x6f307dc3.
//
// Solidity: function underlying() view returns(address)
func (_ERC5095 *ERC5095CallerSession) Underlying() (common.Address, error) {
	return _ERC5095.Contract.Underlying(&_ERC5095.CallOpts)
}

// Version is a free data retrieval call binding the contract method 0x54fd4d50.
//
// Solidity: function version() pure returns(string)
func (_ERC5095 *ERC5095Caller) Version(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _ERC5095.contract.Call(opts, &out, "version")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Version is a free data retrieval call binding the contract method 0x54fd4d50.
//
// Solidity: function version() pure returns(string)
func (_ERC5095 *ERC5095Session) Version() (string, error) {
	return _ERC5095.Contract.Version(&_ERC5095.CallOpts)
}

// Version is a free data retrieval call binding the contract method 0x54fd4d50.
//
// Solidity: function version() pure returns(string)
func (_ERC5095 *ERC5095CallerSession) Version() (string, error) {
	return _ERC5095.Contract.Version(&_ERC5095.CallOpts)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095Transactor) Approve(opts *bind.TransactOpts, spender common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "approve", spender, wad)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095Session) Approve(spender common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Approve(&_ERC5095.TransactOpts, spender, wad)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095TransactorSession) Approve(spender common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Approve(&_ERC5095.TransactOpts, spender, wad)
}

// ApproveMarketPlace is a paid mutator transaction binding the contract method 0x92450f20.
//
// Solidity: function approveMarketPlace() returns(bool)
func (_ERC5095 *ERC5095Transactor) ApproveMarketPlace(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "approveMarketPlace")
}

// ApproveMarketPlace is a paid mutator transaction binding the contract method 0x92450f20.
//
// Solidity: function approveMarketPlace() returns(bool)
func (_ERC5095 *ERC5095Session) ApproveMarketPlace() (*types.Transaction, error) {
	return _ERC5095.Contract.ApproveMarketPlace(&_ERC5095.TransactOpts)
}

// ApproveMarketPlace is a paid mutator transaction binding the contract method 0x92450f20.
//
// Solidity: function approveMarketPlace() returns(bool)
func (_ERC5095 *ERC5095TransactorSession) ApproveMarketPlace() (*types.Transaction, error) {
	return _ERC5095.Contract.ApproveMarketPlace(&_ERC5095.TransactOpts)
}

// AuthApprove is a paid mutator transaction binding the contract method 0x9b390684.
//
// Solidity: function authApprove(address o, address s, uint256 a) returns(bool)
func (_ERC5095 *ERC5095Transactor) AuthApprove(opts *bind.TransactOpts, o common.Address, s common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "authApprove", o, s, a)
}

// AuthApprove is a paid mutator transaction binding the contract method 0x9b390684.
//
// Solidity: function authApprove(address o, address s, uint256 a) returns(bool)
func (_ERC5095 *ERC5095Session) AuthApprove(o common.Address, s common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.AuthApprove(&_ERC5095.TransactOpts, o, s, a)
}

// AuthApprove is a paid mutator transaction binding the contract method 0x9b390684.
//
// Solidity: function authApprove(address o, address s, uint256 a) returns(bool)
func (_ERC5095 *ERC5095TransactorSession) AuthApprove(o common.Address, s common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.AuthApprove(&_ERC5095.TransactOpts, o, s, a)
}

// AuthBurn is a paid mutator transaction binding the contract method 0x88ba33df.
//
// Solidity: function authBurn(address f, uint256 a) returns(bool)
func (_ERC5095 *ERC5095Transactor) AuthBurn(opts *bind.TransactOpts, f common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "authBurn", f, a)
}

// AuthBurn is a paid mutator transaction binding the contract method 0x88ba33df.
//
// Solidity: function authBurn(address f, uint256 a) returns(bool)
func (_ERC5095 *ERC5095Session) AuthBurn(f common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.AuthBurn(&_ERC5095.TransactOpts, f, a)
}

// AuthBurn is a paid mutator transaction binding the contract method 0x88ba33df.
//
// Solidity: function authBurn(address f, uint256 a) returns(bool)
func (_ERC5095 *ERC5095TransactorSession) AuthBurn(f common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.AuthBurn(&_ERC5095.TransactOpts, f, a)
}

// AuthMint is a paid mutator transaction binding the contract method 0x0fa9d3b1.
//
// Solidity: function authMint(address t, uint256 a) returns(bool)
func (_ERC5095 *ERC5095Transactor) AuthMint(opts *bind.TransactOpts, t common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "authMint", t, a)
}

// AuthMint is a paid mutator transaction binding the contract method 0x0fa9d3b1.
//
// Solidity: function authMint(address t, uint256 a) returns(bool)
func (_ERC5095 *ERC5095Session) AuthMint(t common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.AuthMint(&_ERC5095.TransactOpts, t, a)
}

// AuthMint is a paid mutator transaction binding the contract method 0x0fa9d3b1.
//
// Solidity: function authMint(address t, uint256 a) returns(bool)
func (_ERC5095 *ERC5095TransactorSession) AuthMint(t common.Address, a *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.AuthMint(&_ERC5095.TransactOpts, t, a)
}

// Deposit is a paid mutator transaction binding the contract method 0x6e553f65.
//
// Solidity: function deposit(uint256 a, address r) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Deposit(opts *bind.TransactOpts, a *big.Int, r common.Address) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "deposit", a, r)
}

// Deposit is a paid mutator transaction binding the contract method 0x6e553f65.
//
// Solidity: function deposit(uint256 a, address r) returns(uint256)
func (_ERC5095 *ERC5095Session) Deposit(a *big.Int, r common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Deposit(&_ERC5095.TransactOpts, a, r)
}

// Deposit is a paid mutator transaction binding the contract method 0x6e553f65.
//
// Solidity: function deposit(uint256 a, address r) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Deposit(a *big.Int, r common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Deposit(&_ERC5095.TransactOpts, a, r)
}

// Deposit0 is a paid mutator transaction binding the contract method 0xbc157ac1.
//
// Solidity: function deposit(uint256 a, address r, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Deposit0(opts *bind.TransactOpts, a *big.Int, r common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "deposit0", a, r, m)
}

// Deposit0 is a paid mutator transaction binding the contract method 0xbc157ac1.
//
// Solidity: function deposit(uint256 a, address r, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Session) Deposit0(a *big.Int, r common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Deposit0(&_ERC5095.TransactOpts, a, r, m)
}

// Deposit0 is a paid mutator transaction binding the contract method 0xbc157ac1.
//
// Solidity: function deposit(uint256 a, address r, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Deposit0(a *big.Int, r common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Deposit0(&_ERC5095.TransactOpts, a, r, m)
}

// Mint is a paid mutator transaction binding the contract method 0x836a1040.
//
// Solidity: function mint(uint256 s, address r, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Mint(opts *bind.TransactOpts, s *big.Int, r common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "mint", s, r, m)
}

// Mint is a paid mutator transaction binding the contract method 0x836a1040.
//
// Solidity: function mint(uint256 s, address r, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Session) Mint(s *big.Int, r common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Mint(&_ERC5095.TransactOpts, s, r, m)
}

// Mint is a paid mutator transaction binding the contract method 0x836a1040.
//
// Solidity: function mint(uint256 s, address r, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Mint(s *big.Int, r common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Mint(&_ERC5095.TransactOpts, s, r, m)
}

// Mint0 is a paid mutator transaction binding the contract method 0x94bf804d.
//
// Solidity: function mint(uint256 s, address r) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Mint0(opts *bind.TransactOpts, s *big.Int, r common.Address) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "mint0", s, r)
}

// Mint0 is a paid mutator transaction binding the contract method 0x94bf804d.
//
// Solidity: function mint(uint256 s, address r) returns(uint256)
func (_ERC5095 *ERC5095Session) Mint0(s *big.Int, r common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Mint0(&_ERC5095.TransactOpts, s, r)
}

// Mint0 is a paid mutator transaction binding the contract method 0x94bf804d.
//
// Solidity: function mint(uint256 s, address r) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Mint0(s *big.Int, r common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Mint0(&_ERC5095.TransactOpts, s, r)
}

// Permit is a paid mutator transaction binding the contract method 0xd505accf.
//
// Solidity: function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_ERC5095 *ERC5095Transactor) Permit(opts *bind.TransactOpts, owner common.Address, spender common.Address, amount *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "permit", owner, spender, amount, deadline, v, r, s)
}

// Permit is a paid mutator transaction binding the contract method 0xd505accf.
//
// Solidity: function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_ERC5095 *ERC5095Session) Permit(owner common.Address, spender common.Address, amount *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _ERC5095.Contract.Permit(&_ERC5095.TransactOpts, owner, spender, amount, deadline, v, r, s)
}

// Permit is a paid mutator transaction binding the contract method 0xd505accf.
//
// Solidity: function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_ERC5095 *ERC5095TransactorSession) Permit(owner common.Address, spender common.Address, amount *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _ERC5095.Contract.Permit(&_ERC5095.TransactOpts, owner, spender, amount, deadline, v, r, s)
}

// Redeem is a paid mutator transaction binding the contract method 0x9f40a7b3.
//
// Solidity: function redeem(uint256 s, address r, address o, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Redeem(opts *bind.TransactOpts, s *big.Int, r common.Address, o common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "redeem", s, r, o, m)
}

// Redeem is a paid mutator transaction binding the contract method 0x9f40a7b3.
//
// Solidity: function redeem(uint256 s, address r, address o, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Session) Redeem(s *big.Int, r common.Address, o common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Redeem(&_ERC5095.TransactOpts, s, r, o, m)
}

// Redeem is a paid mutator transaction binding the contract method 0x9f40a7b3.
//
// Solidity: function redeem(uint256 s, address r, address o, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Redeem(s *big.Int, r common.Address, o common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Redeem(&_ERC5095.TransactOpts, s, r, o, m)
}

// Redeem0 is a paid mutator transaction binding the contract method 0xba087652.
//
// Solidity: function redeem(uint256 s, address r, address o) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Redeem0(opts *bind.TransactOpts, s *big.Int, r common.Address, o common.Address) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "redeem0", s, r, o)
}

// Redeem0 is a paid mutator transaction binding the contract method 0xba087652.
//
// Solidity: function redeem(uint256 s, address r, address o) returns(uint256)
func (_ERC5095 *ERC5095Session) Redeem0(s *big.Int, r common.Address, o common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Redeem0(&_ERC5095.TransactOpts, s, r, o)
}

// Redeem0 is a paid mutator transaction binding the contract method 0xba087652.
//
// Solidity: function redeem(uint256 s, address r, address o) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Redeem0(s *big.Int, r common.Address, o common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Redeem0(&_ERC5095.TransactOpts, s, r, o)
}

// SetPool is a paid mutator transaction binding the contract method 0x4437152a.
//
// Solidity: function setPool(address p) returns(bool)
func (_ERC5095 *ERC5095Transactor) SetPool(opts *bind.TransactOpts, p common.Address) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "setPool", p)
}

// SetPool is a paid mutator transaction binding the contract method 0x4437152a.
//
// Solidity: function setPool(address p) returns(bool)
func (_ERC5095 *ERC5095Session) SetPool(p common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.SetPool(&_ERC5095.TransactOpts, p)
}

// SetPool is a paid mutator transaction binding the contract method 0x4437152a.
//
// Solidity: function setPool(address p) returns(bool)
func (_ERC5095 *ERC5095TransactorSession) SetPool(p common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.SetPool(&_ERC5095.TransactOpts, p)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address dst, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095Transactor) Transfer(opts *bind.TransactOpts, dst common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "transfer", dst, wad)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address dst, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095Session) Transfer(dst common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Transfer(&_ERC5095.TransactOpts, dst, wad)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address dst, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095TransactorSession) Transfer(dst common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Transfer(&_ERC5095.TransactOpts, dst, wad)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address src, address dst, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095Transactor) TransferFrom(opts *bind.TransactOpts, src common.Address, dst common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "transferFrom", src, dst, wad)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address src, address dst, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095Session) TransferFrom(src common.Address, dst common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.TransferFrom(&_ERC5095.TransactOpts, src, dst, wad)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address src, address dst, uint256 wad) returns(bool)
func (_ERC5095 *ERC5095TransactorSession) TransferFrom(src common.Address, dst common.Address, wad *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.TransferFrom(&_ERC5095.TransactOpts, src, dst, wad)
}

// Withdraw is a paid mutator transaction binding the contract method 0xa318c1a4.
//
// Solidity: function withdraw(uint256 a, address r, address o, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Withdraw(opts *bind.TransactOpts, a *big.Int, r common.Address, o common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "withdraw", a, r, o, m)
}

// Withdraw is a paid mutator transaction binding the contract method 0xa318c1a4.
//
// Solidity: function withdraw(uint256 a, address r, address o, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095Session) Withdraw(a *big.Int, r common.Address, o common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Withdraw(&_ERC5095.TransactOpts, a, r, o, m)
}

// Withdraw is a paid mutator transaction binding the contract method 0xa318c1a4.
//
// Solidity: function withdraw(uint256 a, address r, address o, uint256 m) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Withdraw(a *big.Int, r common.Address, o common.Address, m *big.Int) (*types.Transaction, error) {
	return _ERC5095.Contract.Withdraw(&_ERC5095.TransactOpts, a, r, o, m)
}

// Withdraw0 is a paid mutator transaction binding the contract method 0xb460af94.
//
// Solidity: function withdraw(uint256 a, address r, address o) returns(uint256)
func (_ERC5095 *ERC5095Transactor) Withdraw0(opts *bind.TransactOpts, a *big.Int, r common.Address, o common.Address) (*types.Transaction, error) {
	return _ERC5095.contract.Transact(opts, "withdraw0", a, r, o)
}

// Withdraw0 is a paid mutator transaction binding the contract method 0xb460af94.
//
// Solidity: function withdraw(uint256 a, address r, address o) returns(uint256)
func (_ERC5095 *ERC5095Session) Withdraw0(a *big.Int, r common.Address, o common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Withdraw0(&_ERC5095.TransactOpts, a, r, o)
}

// Withdraw0 is a paid mutator transaction binding the contract method 0xb460af94.
//
// Solidity: function withdraw(uint256 a, address r, address o) returns(uint256)
func (_ERC5095 *ERC5095TransactorSession) Withdraw0(a *big.Int, r common.Address, o common.Address) (*types.Transaction, error) {
	return _ERC5095.Contract.Withdraw0(&_ERC5095.TransactOpts, a, r, o)
}

// ERC5095ApprovalIterator is returned from FilterApproval and is used to iterate over the raw logs and unpacked data for Approval events raised by the ERC5095 contract.
type ERC5095ApprovalIterator struct {
	Event *ERC5095Approval // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ERC5095ApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ERC5095Approval)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ERC5095Approval)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ERC5095ApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ERC5095ApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ERC5095Approval represents a Approval event raised by the ERC5095 contract.
type ERC5095Approval struct {
	Owner   common.Address
	Spender common.Address
	Value   *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterApproval is a free log retrieval operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_ERC5095 *ERC5095Filterer) FilterApproval(opts *bind.FilterOpts, owner []common.Address, spender []common.Address) (*ERC5095ApprovalIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _ERC5095.contract.FilterLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return &ERC5095ApprovalIterator{contract: _ERC5095.contract, event: "Approval", logs: logs, sub: sub}, nil
}

// WatchApproval is a free log subscription operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_ERC5095 *ERC5095Filterer) WatchApproval(opts *bind.WatchOpts, sink chan<- *ERC5095Approval, owner []common.Address, spender []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _ERC5095.contract.WatchLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ERC5095Approval)
				if err := _ERC5095.contract.UnpackLog(event, "Approval", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseApproval is a log parse operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_ERC5095 *ERC5095Filterer) ParseApproval(log types.Log) (*ERC5095Approval, error) {
	event := new(ERC5095Approval)
	if err := _ERC5095.contract.UnpackLog(event, "Approval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ERC5095TransferIterator is returned from FilterTransfer and is used to iterate over the raw logs and unpacked data for Transfer events raised by the ERC5095 contract.
type ERC5095TransferIterator struct {
	Event *ERC5095Transfer // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ERC5095TransferIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ERC5095Transfer)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ERC5095Transfer)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ERC5095TransferIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ERC5095TransferIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ERC5095Transfer represents a Transfer event raised by the ERC5095 contract.
type ERC5095Transfer struct {
	From  common.Address
	To    common.Address
	Value *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterTransfer is a free log retrieval operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_ERC5095 *ERC5095Filterer) FilterTransfer(opts *bind.FilterOpts, from []common.Address, to []common.Address) (*ERC5095TransferIterator, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _ERC5095.contract.FilterLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return &ERC5095TransferIterator{contract: _ERC5095.contract, event: "Transfer", logs: logs, sub: sub}, nil
}

// WatchTransfer is a free log subscription operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_ERC5095 *ERC5095Filterer) WatchTransfer(opts *bind.WatchOpts, sink chan<- *ERC5095Transfer, from []common.Address, to []common.Address) (event.Subscription, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _ERC5095.contract.WatchLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ERC5095Transfer)
				if err := _ERC5095.contract.UnpackLog(event, "Transfer", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTransfer is a log parse operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_ERC5095 *ERC5095Filterer) ParseTransfer(log types.Log) (*ERC5095Transfer, error) {
	event := new(ERC5095Transfer)
	if err := _ERC5095.contract.UnpackLog(event, "Transfer", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
