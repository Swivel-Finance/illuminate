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

// MarketPlaceMetaData contains all meta data concerning the MarketPlace contract.
var MarketPlaceMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"l\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"c\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"Exception\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"tokensBurned\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"underlyingReceived\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"principalTokensReceived\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"burner\",\"type\":\"address\"}],\"name\":\"Burn\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"address[9]\",\"name\":\"tokens\",\"type\":\"address[9]\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"element\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"apwine\",\"type\":\"address\"}],\"name\":\"CreateMarket\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"underlyingIn\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"principalTokensIn\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"minted\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"minter\",\"type\":\"address\"}],\"name\":\"Mint\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"admin\",\"type\":\"address\"}],\"name\":\"SetAdmin\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"pool\",\"type\":\"address\"}],\"name\":\"SetPool\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"principal\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint8\",\"name\":\"protocol\",\"type\":\"uint8\"}],\"name\":\"SetPrincipal\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"sold\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"bought\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"received\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"spent\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"}],\"name\":\"Swap\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"admin\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes[]\",\"name\":\"c\",\"type\":\"bytes[]\"}],\"name\":\"batch\",\"outputs\":[{\"internalType\":\"bytes[]\",\"name\":\"results\",\"type\":\"bytes[]\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"minRatio\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"maxRatio\",\"type\":\"uint256\"}],\"name\":\"burn\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"minRatio\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"maxRatio\",\"type\":\"uint256\"}],\"name\":\"burnForUnderlying\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint128\",\"name\":\"a\",\"type\":\"uint128\"},{\"internalType\":\"uint128\",\"name\":\"s\",\"type\":\"uint128\"}],\"name\":\"buyPrincipalToken\",\"outputs\":[{\"internalType\":\"uint128\",\"name\":\"\",\"type\":\"uint128\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint128\",\"name\":\"a\",\"type\":\"uint128\"},{\"internalType\":\"uint128\",\"name\":\"s\",\"type\":\"uint128\"}],\"name\":\"buyUnderlying\",\"outputs\":[{\"internalType\":\"uint128\",\"name\":\"\",\"type\":\"uint128\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"address[8]\",\"name\":\"t\",\"type\":\"address[8]\"},{\"internalType\":\"string\",\"name\":\"n\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"s\",\"type\":\"string\"},{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"e\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"h\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"sensePeriphery\",\"type\":\"address\"}],\"name\":\"createMarket\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"creator\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"lender\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"markets\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"b\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"p\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"minRatio\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"maxRatio\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"p\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"minRatio\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"maxRatio\",\"type\":\"uint256\"}],\"name\":\"mintWithUnderlying\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"pools\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"redeemer\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint128\",\"name\":\"a\",\"type\":\"uint128\"},{\"internalType\":\"uint128\",\"name\":\"s\",\"type\":\"uint128\"}],\"name\":\"sellPrincipalToken\",\"outputs\":[{\"internalType\":\"uint128\",\"name\":\"\",\"type\":\"uint128\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint128\",\"name\":\"a\",\"type\":\"uint128\"},{\"internalType\":\"uint128\",\"name\":\"s\",\"type\":\"uint128\"}],\"name\":\"sellUnderlying\",\"outputs\":[{\"internalType\":\"uint128\",\"name\":\"\",\"type\":\"uint128\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"}],\"name\":\"setAdmin\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"}],\"name\":\"setPool\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"h\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"sensePeriphery\",\"type\":\"address\"}],\"name\":\"setPrincipal\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// MarketPlaceABI is the input ABI used to generate the binding from.
// Deprecated: Use MarketPlaceMetaData.ABI instead.
var MarketPlaceABI = MarketPlaceMetaData.ABI

// MarketPlace is an auto generated Go binding around an Ethereum contract.
type MarketPlace struct {
	MarketPlaceCaller     // Read-only binding to the contract
	MarketPlaceTransactor // Write-only binding to the contract
	MarketPlaceFilterer   // Log filterer for contract events
}

// MarketPlaceCaller is an auto generated read-only Go binding around an Ethereum contract.
type MarketPlaceCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MarketPlaceTransactor is an auto generated write-only Go binding around an Ethereum contract.
type MarketPlaceTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MarketPlaceFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type MarketPlaceFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MarketPlaceSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type MarketPlaceSession struct {
	Contract     *MarketPlace      // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// MarketPlaceCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type MarketPlaceCallerSession struct {
	Contract *MarketPlaceCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts      // Call options to use throughout this session
}

// MarketPlaceTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type MarketPlaceTransactorSession struct {
	Contract     *MarketPlaceTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts      // Transaction auth options to use throughout this session
}

// MarketPlaceRaw is an auto generated low-level Go binding around an Ethereum contract.
type MarketPlaceRaw struct {
	Contract *MarketPlace // Generic contract binding to access the raw methods on
}

// MarketPlaceCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type MarketPlaceCallerRaw struct {
	Contract *MarketPlaceCaller // Generic read-only contract binding to access the raw methods on
}

// MarketPlaceTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type MarketPlaceTransactorRaw struct {
	Contract *MarketPlaceTransactor // Generic write-only contract binding to access the raw methods on
}

// NewMarketPlace creates a new instance of MarketPlace, bound to a specific deployed contract.
func NewMarketPlace(address common.Address, backend bind.ContractBackend) (*MarketPlace, error) {
	contract, err := bindMarketPlace(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &MarketPlace{MarketPlaceCaller: MarketPlaceCaller{contract: contract}, MarketPlaceTransactor: MarketPlaceTransactor{contract: contract}, MarketPlaceFilterer: MarketPlaceFilterer{contract: contract}}, nil
}

// NewMarketPlaceCaller creates a new read-only instance of MarketPlace, bound to a specific deployed contract.
func NewMarketPlaceCaller(address common.Address, caller bind.ContractCaller) (*MarketPlaceCaller, error) {
	contract, err := bindMarketPlace(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceCaller{contract: contract}, nil
}

// NewMarketPlaceTransactor creates a new write-only instance of MarketPlace, bound to a specific deployed contract.
func NewMarketPlaceTransactor(address common.Address, transactor bind.ContractTransactor) (*MarketPlaceTransactor, error) {
	contract, err := bindMarketPlace(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceTransactor{contract: contract}, nil
}

// NewMarketPlaceFilterer creates a new log filterer instance of MarketPlace, bound to a specific deployed contract.
func NewMarketPlaceFilterer(address common.Address, filterer bind.ContractFilterer) (*MarketPlaceFilterer, error) {
	contract, err := bindMarketPlace(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceFilterer{contract: contract}, nil
}

// bindMarketPlace binds a generic wrapper to an already deployed contract.
func bindMarketPlace(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(MarketPlaceABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_MarketPlace *MarketPlaceRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _MarketPlace.Contract.MarketPlaceCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_MarketPlace *MarketPlaceRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MarketPlace.Contract.MarketPlaceTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_MarketPlace *MarketPlaceRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _MarketPlace.Contract.MarketPlaceTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_MarketPlace *MarketPlaceCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _MarketPlace.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_MarketPlace *MarketPlaceTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MarketPlace.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_MarketPlace *MarketPlaceTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _MarketPlace.Contract.contract.Transact(opts, method, params...)
}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_MarketPlace *MarketPlaceCaller) Admin(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MarketPlace.contract.Call(opts, &out, "admin")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_MarketPlace *MarketPlaceSession) Admin() (common.Address, error) {
	return _MarketPlace.Contract.Admin(&_MarketPlace.CallOpts)
}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_MarketPlace *MarketPlaceCallerSession) Admin() (common.Address, error) {
	return _MarketPlace.Contract.Admin(&_MarketPlace.CallOpts)
}

// Creator is a free data retrieval call binding the contract method 0x02d05d3f.
//
// Solidity: function creator() view returns(address)
func (_MarketPlace *MarketPlaceCaller) Creator(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MarketPlace.contract.Call(opts, &out, "creator")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Creator is a free data retrieval call binding the contract method 0x02d05d3f.
//
// Solidity: function creator() view returns(address)
func (_MarketPlace *MarketPlaceSession) Creator() (common.Address, error) {
	return _MarketPlace.Contract.Creator(&_MarketPlace.CallOpts)
}

// Creator is a free data retrieval call binding the contract method 0x02d05d3f.
//
// Solidity: function creator() view returns(address)
func (_MarketPlace *MarketPlaceCallerSession) Creator() (common.Address, error) {
	return _MarketPlace.Contract.Creator(&_MarketPlace.CallOpts)
}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_MarketPlace *MarketPlaceCaller) Lender(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MarketPlace.contract.Call(opts, &out, "lender")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_MarketPlace *MarketPlaceSession) Lender() (common.Address, error) {
	return _MarketPlace.Contract.Lender(&_MarketPlace.CallOpts)
}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_MarketPlace *MarketPlaceCallerSession) Lender() (common.Address, error) {
	return _MarketPlace.Contract.Lender(&_MarketPlace.CallOpts)
}

// Markets is a free data retrieval call binding the contract method 0x125cf47f.
//
// Solidity: function markets(address , uint256 , uint256 ) view returns(address)
func (_MarketPlace *MarketPlaceCaller) Markets(opts *bind.CallOpts, arg0 common.Address, arg1 *big.Int, arg2 *big.Int) (common.Address, error) {
	var out []interface{}
	err := _MarketPlace.contract.Call(opts, &out, "markets", arg0, arg1, arg2)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Markets is a free data retrieval call binding the contract method 0x125cf47f.
//
// Solidity: function markets(address , uint256 , uint256 ) view returns(address)
func (_MarketPlace *MarketPlaceSession) Markets(arg0 common.Address, arg1 *big.Int, arg2 *big.Int) (common.Address, error) {
	return _MarketPlace.Contract.Markets(&_MarketPlace.CallOpts, arg0, arg1, arg2)
}

// Markets is a free data retrieval call binding the contract method 0x125cf47f.
//
// Solidity: function markets(address , uint256 , uint256 ) view returns(address)
func (_MarketPlace *MarketPlaceCallerSession) Markets(arg0 common.Address, arg1 *big.Int, arg2 *big.Int) (common.Address, error) {
	return _MarketPlace.Contract.Markets(&_MarketPlace.CallOpts, arg0, arg1, arg2)
}

// Pools is a free data retrieval call binding the contract method 0x8f38a555.
//
// Solidity: function pools(address , uint256 ) view returns(address)
func (_MarketPlace *MarketPlaceCaller) Pools(opts *bind.CallOpts, arg0 common.Address, arg1 *big.Int) (common.Address, error) {
	var out []interface{}
	err := _MarketPlace.contract.Call(opts, &out, "pools", arg0, arg1)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Pools is a free data retrieval call binding the contract method 0x8f38a555.
//
// Solidity: function pools(address , uint256 ) view returns(address)
func (_MarketPlace *MarketPlaceSession) Pools(arg0 common.Address, arg1 *big.Int) (common.Address, error) {
	return _MarketPlace.Contract.Pools(&_MarketPlace.CallOpts, arg0, arg1)
}

// Pools is a free data retrieval call binding the contract method 0x8f38a555.
//
// Solidity: function pools(address , uint256 ) view returns(address)
func (_MarketPlace *MarketPlaceCallerSession) Pools(arg0 common.Address, arg1 *big.Int) (common.Address, error) {
	return _MarketPlace.Contract.Pools(&_MarketPlace.CallOpts, arg0, arg1)
}

// Redeemer is a free data retrieval call binding the contract method 0x2ba29d38.
//
// Solidity: function redeemer() view returns(address)
func (_MarketPlace *MarketPlaceCaller) Redeemer(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MarketPlace.contract.Call(opts, &out, "redeemer")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Redeemer is a free data retrieval call binding the contract method 0x2ba29d38.
//
// Solidity: function redeemer() view returns(address)
func (_MarketPlace *MarketPlaceSession) Redeemer() (common.Address, error) {
	return _MarketPlace.Contract.Redeemer(&_MarketPlace.CallOpts)
}

// Redeemer is a free data retrieval call binding the contract method 0x2ba29d38.
//
// Solidity: function redeemer() view returns(address)
func (_MarketPlace *MarketPlaceCallerSession) Redeemer() (common.Address, error) {
	return _MarketPlace.Contract.Redeemer(&_MarketPlace.CallOpts)
}

// Batch is a paid mutator transaction binding the contract method 0x1e897afb.
//
// Solidity: function batch(bytes[] c) payable returns(bytes[] results)
func (_MarketPlace *MarketPlaceTransactor) Batch(opts *bind.TransactOpts, c [][]byte) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "batch", c)
}

// Batch is a paid mutator transaction binding the contract method 0x1e897afb.
//
// Solidity: function batch(bytes[] c) payable returns(bytes[] results)
func (_MarketPlace *MarketPlaceSession) Batch(c [][]byte) (*types.Transaction, error) {
	return _MarketPlace.Contract.Batch(&_MarketPlace.TransactOpts, c)
}

// Batch is a paid mutator transaction binding the contract method 0x1e897afb.
//
// Solidity: function batch(bytes[] c) payable returns(bytes[] results)
func (_MarketPlace *MarketPlaceTransactorSession) Batch(c [][]byte) (*types.Transaction, error) {
	return _MarketPlace.Contract.Batch(&_MarketPlace.TransactOpts, c)
}

// Burn is a paid mutator transaction binding the contract method 0x1a116511.
//
// Solidity: function burn(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceTransactor) Burn(opts *bind.TransactOpts, u common.Address, m *big.Int, a *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "burn", u, m, a, minRatio, maxRatio)
}

// Burn is a paid mutator transaction binding the contract method 0x1a116511.
//
// Solidity: function burn(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceSession) Burn(u common.Address, m *big.Int, a *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.Burn(&_MarketPlace.TransactOpts, u, m, a, minRatio, maxRatio)
}

// Burn is a paid mutator transaction binding the contract method 0x1a116511.
//
// Solidity: function burn(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceTransactorSession) Burn(u common.Address, m *big.Int, a *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.Burn(&_MarketPlace.TransactOpts, u, m, a, minRatio, maxRatio)
}

// BurnForUnderlying is a paid mutator transaction binding the contract method 0xf8ed3ac0.
//
// Solidity: function burnForUnderlying(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256)
func (_MarketPlace *MarketPlaceTransactor) BurnForUnderlying(opts *bind.TransactOpts, u common.Address, m *big.Int, a *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "burnForUnderlying", u, m, a, minRatio, maxRatio)
}

// BurnForUnderlying is a paid mutator transaction binding the contract method 0xf8ed3ac0.
//
// Solidity: function burnForUnderlying(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256)
func (_MarketPlace *MarketPlaceSession) BurnForUnderlying(u common.Address, m *big.Int, a *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.BurnForUnderlying(&_MarketPlace.TransactOpts, u, m, a, minRatio, maxRatio)
}

// BurnForUnderlying is a paid mutator transaction binding the contract method 0xf8ed3ac0.
//
// Solidity: function burnForUnderlying(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256)
func (_MarketPlace *MarketPlaceTransactorSession) BurnForUnderlying(u common.Address, m *big.Int, a *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.BurnForUnderlying(&_MarketPlace.TransactOpts, u, m, a, minRatio, maxRatio)
}

// BuyPrincipalToken is a paid mutator transaction binding the contract method 0x6ba06f1b.
//
// Solidity: function buyPrincipalToken(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactor) BuyPrincipalToken(opts *bind.TransactOpts, u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "buyPrincipalToken", u, m, a, s)
}

// BuyPrincipalToken is a paid mutator transaction binding the contract method 0x6ba06f1b.
//
// Solidity: function buyPrincipalToken(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceSession) BuyPrincipalToken(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.BuyPrincipalToken(&_MarketPlace.TransactOpts, u, m, a, s)
}

// BuyPrincipalToken is a paid mutator transaction binding the contract method 0x6ba06f1b.
//
// Solidity: function buyPrincipalToken(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactorSession) BuyPrincipalToken(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.BuyPrincipalToken(&_MarketPlace.TransactOpts, u, m, a, s)
}

// BuyUnderlying is a paid mutator transaction binding the contract method 0xfde382ea.
//
// Solidity: function buyUnderlying(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactor) BuyUnderlying(opts *bind.TransactOpts, u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "buyUnderlying", u, m, a, s)
}

// BuyUnderlying is a paid mutator transaction binding the contract method 0xfde382ea.
//
// Solidity: function buyUnderlying(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceSession) BuyUnderlying(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.BuyUnderlying(&_MarketPlace.TransactOpts, u, m, a, s)
}

// BuyUnderlying is a paid mutator transaction binding the contract method 0xfde382ea.
//
// Solidity: function buyUnderlying(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactorSession) BuyUnderlying(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.BuyUnderlying(&_MarketPlace.TransactOpts, u, m, a, s)
}

// CreateMarket is a paid mutator transaction binding the contract method 0xa6e98c39.
//
// Solidity: function createMarket(address u, uint256 m, address[8] t, string n, string s, address a, address e, address h, address sensePeriphery) returns(bool)
func (_MarketPlace *MarketPlaceTransactor) CreateMarket(opts *bind.TransactOpts, u common.Address, m *big.Int, t [8]common.Address, n string, s string, a common.Address, e common.Address, h common.Address, sensePeriphery common.Address) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "createMarket", u, m, t, n, s, a, e, h, sensePeriphery)
}

// CreateMarket is a paid mutator transaction binding the contract method 0xa6e98c39.
//
// Solidity: function createMarket(address u, uint256 m, address[8] t, string n, string s, address a, address e, address h, address sensePeriphery) returns(bool)
func (_MarketPlace *MarketPlaceSession) CreateMarket(u common.Address, m *big.Int, t [8]common.Address, n string, s string, a common.Address, e common.Address, h common.Address, sensePeriphery common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.CreateMarket(&_MarketPlace.TransactOpts, u, m, t, n, s, a, e, h, sensePeriphery)
}

// CreateMarket is a paid mutator transaction binding the contract method 0xa6e98c39.
//
// Solidity: function createMarket(address u, uint256 m, address[8] t, string n, string s, address a, address e, address h, address sensePeriphery) returns(bool)
func (_MarketPlace *MarketPlaceTransactorSession) CreateMarket(u common.Address, m *big.Int, t [8]common.Address, n string, s string, a common.Address, e common.Address, h common.Address, sensePeriphery common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.CreateMarket(&_MarketPlace.TransactOpts, u, m, t, n, s, a, e, h, sensePeriphery)
}

// Mint is a paid mutator transaction binding the contract method 0xdfc8fff6.
//
// Solidity: function mint(address u, uint256 m, uint256 b, uint256 p, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceTransactor) Mint(opts *bind.TransactOpts, u common.Address, m *big.Int, b *big.Int, p *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "mint", u, m, b, p, minRatio, maxRatio)
}

// Mint is a paid mutator transaction binding the contract method 0xdfc8fff6.
//
// Solidity: function mint(address u, uint256 m, uint256 b, uint256 p, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceSession) Mint(u common.Address, m *big.Int, b *big.Int, p *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.Mint(&_MarketPlace.TransactOpts, u, m, b, p, minRatio, maxRatio)
}

// Mint is a paid mutator transaction binding the contract method 0xdfc8fff6.
//
// Solidity: function mint(address u, uint256 m, uint256 b, uint256 p, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceTransactorSession) Mint(u common.Address, m *big.Int, b *big.Int, p *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.Mint(&_MarketPlace.TransactOpts, u, m, b, p, minRatio, maxRatio)
}

// MintWithUnderlying is a paid mutator transaction binding the contract method 0x23f86bef.
//
// Solidity: function mintWithUnderlying(address u, uint256 m, uint256 a, uint256 p, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceTransactor) MintWithUnderlying(opts *bind.TransactOpts, u common.Address, m *big.Int, a *big.Int, p *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "mintWithUnderlying", u, m, a, p, minRatio, maxRatio)
}

// MintWithUnderlying is a paid mutator transaction binding the contract method 0x23f86bef.
//
// Solidity: function mintWithUnderlying(address u, uint256 m, uint256 a, uint256 p, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceSession) MintWithUnderlying(u common.Address, m *big.Int, a *big.Int, p *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.MintWithUnderlying(&_MarketPlace.TransactOpts, u, m, a, p, minRatio, maxRatio)
}

// MintWithUnderlying is a paid mutator transaction binding the contract method 0x23f86bef.
//
// Solidity: function mintWithUnderlying(address u, uint256 m, uint256 a, uint256 p, uint256 minRatio, uint256 maxRatio) returns(uint256, uint256, uint256)
func (_MarketPlace *MarketPlaceTransactorSession) MintWithUnderlying(u common.Address, m *big.Int, a *big.Int, p *big.Int, minRatio *big.Int, maxRatio *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.MintWithUnderlying(&_MarketPlace.TransactOpts, u, m, a, p, minRatio, maxRatio)
}

// SellPrincipalToken is a paid mutator transaction binding the contract method 0xd744e269.
//
// Solidity: function sellPrincipalToken(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactor) SellPrincipalToken(opts *bind.TransactOpts, u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "sellPrincipalToken", u, m, a, s)
}

// SellPrincipalToken is a paid mutator transaction binding the contract method 0xd744e269.
//
// Solidity: function sellPrincipalToken(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceSession) SellPrincipalToken(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.SellPrincipalToken(&_MarketPlace.TransactOpts, u, m, a, s)
}

// SellPrincipalToken is a paid mutator transaction binding the contract method 0xd744e269.
//
// Solidity: function sellPrincipalToken(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactorSession) SellPrincipalToken(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.SellPrincipalToken(&_MarketPlace.TransactOpts, u, m, a, s)
}

// SellUnderlying is a paid mutator transaction binding the contract method 0x00ee3aea.
//
// Solidity: function sellUnderlying(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactor) SellUnderlying(opts *bind.TransactOpts, u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "sellUnderlying", u, m, a, s)
}

// SellUnderlying is a paid mutator transaction binding the contract method 0x00ee3aea.
//
// Solidity: function sellUnderlying(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceSession) SellUnderlying(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.SellUnderlying(&_MarketPlace.TransactOpts, u, m, a, s)
}

// SellUnderlying is a paid mutator transaction binding the contract method 0x00ee3aea.
//
// Solidity: function sellUnderlying(address u, uint256 m, uint128 a, uint128 s) returns(uint128)
func (_MarketPlace *MarketPlaceTransactorSession) SellUnderlying(u common.Address, m *big.Int, a *big.Int, s *big.Int) (*types.Transaction, error) {
	return _MarketPlace.Contract.SellUnderlying(&_MarketPlace.TransactOpts, u, m, a, s)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_MarketPlace *MarketPlaceTransactor) SetAdmin(opts *bind.TransactOpts, a common.Address) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "setAdmin", a)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_MarketPlace *MarketPlaceSession) SetAdmin(a common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.SetAdmin(&_MarketPlace.TransactOpts, a)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_MarketPlace *MarketPlaceTransactorSession) SetAdmin(a common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.SetAdmin(&_MarketPlace.TransactOpts, a)
}

// SetPool is a paid mutator transaction binding the contract method 0x6d605fcf.
//
// Solidity: function setPool(address u, uint256 m, address a) returns(bool)
func (_MarketPlace *MarketPlaceTransactor) SetPool(opts *bind.TransactOpts, u common.Address, m *big.Int, a common.Address) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "setPool", u, m, a)
}

// SetPool is a paid mutator transaction binding the contract method 0x6d605fcf.
//
// Solidity: function setPool(address u, uint256 m, address a) returns(bool)
func (_MarketPlace *MarketPlaceSession) SetPool(u common.Address, m *big.Int, a common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.SetPool(&_MarketPlace.TransactOpts, u, m, a)
}

// SetPool is a paid mutator transaction binding the contract method 0x6d605fcf.
//
// Solidity: function setPool(address u, uint256 m, address a) returns(bool)
func (_MarketPlace *MarketPlaceTransactorSession) SetPool(u common.Address, m *big.Int, a common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.SetPool(&_MarketPlace.TransactOpts, u, m, a)
}

// SetPrincipal is a paid mutator transaction binding the contract method 0x90bb7dac.
//
// Solidity: function setPrincipal(uint8 p, address u, uint256 m, address a, address h, address sensePeriphery) returns(bool)
func (_MarketPlace *MarketPlaceTransactor) SetPrincipal(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a common.Address, h common.Address, sensePeriphery common.Address) (*types.Transaction, error) {
	return _MarketPlace.contract.Transact(opts, "setPrincipal", p, u, m, a, h, sensePeriphery)
}

// SetPrincipal is a paid mutator transaction binding the contract method 0x90bb7dac.
//
// Solidity: function setPrincipal(uint8 p, address u, uint256 m, address a, address h, address sensePeriphery) returns(bool)
func (_MarketPlace *MarketPlaceSession) SetPrincipal(p uint8, u common.Address, m *big.Int, a common.Address, h common.Address, sensePeriphery common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.SetPrincipal(&_MarketPlace.TransactOpts, p, u, m, a, h, sensePeriphery)
}

// SetPrincipal is a paid mutator transaction binding the contract method 0x90bb7dac.
//
// Solidity: function setPrincipal(uint8 p, address u, uint256 m, address a, address h, address sensePeriphery) returns(bool)
func (_MarketPlace *MarketPlaceTransactorSession) SetPrincipal(p uint8, u common.Address, m *big.Int, a common.Address, h common.Address, sensePeriphery common.Address) (*types.Transaction, error) {
	return _MarketPlace.Contract.SetPrincipal(&_MarketPlace.TransactOpts, p, u, m, a, h, sensePeriphery)
}

// MarketPlaceBurnIterator is returned from FilterBurn and is used to iterate over the raw logs and unpacked data for Burn events raised by the MarketPlace contract.
type MarketPlaceBurnIterator struct {
	Event *MarketPlaceBurn // Event containing the contract specifics and raw log

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
func (it *MarketPlaceBurnIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MarketPlaceBurn)
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
		it.Event = new(MarketPlaceBurn)
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
func (it *MarketPlaceBurnIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MarketPlaceBurnIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MarketPlaceBurn represents a Burn event raised by the MarketPlace contract.
type MarketPlaceBurn struct {
	Underlying              common.Address
	Maturity                *big.Int
	TokensBurned            *big.Int
	UnderlyingReceived      *big.Int
	PrincipalTokensReceived *big.Int
	Burner                  common.Address
	Raw                     types.Log // Blockchain specific contextual infos
}

// FilterBurn is a free log retrieval operation binding the contract event 0xa6a919b3314fbbdb84c4a64d62f381f104d0c1747b789163262d2fcfeec29268.
//
// Solidity: event Burn(address indexed underlying, uint256 indexed maturity, uint256 tokensBurned, uint256 underlyingReceived, uint256 principalTokensReceived, address burner)
func (_MarketPlace *MarketPlaceFilterer) FilterBurn(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int) (*MarketPlaceBurnIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.FilterLogs(opts, "Burn", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceBurnIterator{contract: _MarketPlace.contract, event: "Burn", logs: logs, sub: sub}, nil
}

// WatchBurn is a free log subscription operation binding the contract event 0xa6a919b3314fbbdb84c4a64d62f381f104d0c1747b789163262d2fcfeec29268.
//
// Solidity: event Burn(address indexed underlying, uint256 indexed maturity, uint256 tokensBurned, uint256 underlyingReceived, uint256 principalTokensReceived, address burner)
func (_MarketPlace *MarketPlaceFilterer) WatchBurn(opts *bind.WatchOpts, sink chan<- *MarketPlaceBurn, underlying []common.Address, maturity []*big.Int) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.WatchLogs(opts, "Burn", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MarketPlaceBurn)
				if err := _MarketPlace.contract.UnpackLog(event, "Burn", log); err != nil {
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

// ParseBurn is a log parse operation binding the contract event 0xa6a919b3314fbbdb84c4a64d62f381f104d0c1747b789163262d2fcfeec29268.
//
// Solidity: event Burn(address indexed underlying, uint256 indexed maturity, uint256 tokensBurned, uint256 underlyingReceived, uint256 principalTokensReceived, address burner)
func (_MarketPlace *MarketPlaceFilterer) ParseBurn(log types.Log) (*MarketPlaceBurn, error) {
	event := new(MarketPlaceBurn)
	if err := _MarketPlace.contract.UnpackLog(event, "Burn", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MarketPlaceCreateMarketIterator is returned from FilterCreateMarket and is used to iterate over the raw logs and unpacked data for CreateMarket events raised by the MarketPlace contract.
type MarketPlaceCreateMarketIterator struct {
	Event *MarketPlaceCreateMarket // Event containing the contract specifics and raw log

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
func (it *MarketPlaceCreateMarketIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MarketPlaceCreateMarket)
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
		it.Event = new(MarketPlaceCreateMarket)
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
func (it *MarketPlaceCreateMarketIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MarketPlaceCreateMarketIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MarketPlaceCreateMarket represents a CreateMarket event raised by the MarketPlace contract.
type MarketPlaceCreateMarket struct {
	Underlying common.Address
	Maturity   *big.Int
	Tokens     [9]common.Address
	Element    common.Address
	Apwine     common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterCreateMarket is a free log retrieval operation binding the contract event 0xb02abdc1b2e46d6aa310c4e8bcab63f9ec42f82c0bba87fefe442f2b21d60871.
//
// Solidity: event CreateMarket(address indexed underlying, uint256 indexed maturity, address[9] tokens, address element, address apwine)
func (_MarketPlace *MarketPlaceFilterer) FilterCreateMarket(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int) (*MarketPlaceCreateMarketIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.FilterLogs(opts, "CreateMarket", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceCreateMarketIterator{contract: _MarketPlace.contract, event: "CreateMarket", logs: logs, sub: sub}, nil
}

// WatchCreateMarket is a free log subscription operation binding the contract event 0xb02abdc1b2e46d6aa310c4e8bcab63f9ec42f82c0bba87fefe442f2b21d60871.
//
// Solidity: event CreateMarket(address indexed underlying, uint256 indexed maturity, address[9] tokens, address element, address apwine)
func (_MarketPlace *MarketPlaceFilterer) WatchCreateMarket(opts *bind.WatchOpts, sink chan<- *MarketPlaceCreateMarket, underlying []common.Address, maturity []*big.Int) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.WatchLogs(opts, "CreateMarket", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MarketPlaceCreateMarket)
				if err := _MarketPlace.contract.UnpackLog(event, "CreateMarket", log); err != nil {
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

// ParseCreateMarket is a log parse operation binding the contract event 0xb02abdc1b2e46d6aa310c4e8bcab63f9ec42f82c0bba87fefe442f2b21d60871.
//
// Solidity: event CreateMarket(address indexed underlying, uint256 indexed maturity, address[9] tokens, address element, address apwine)
func (_MarketPlace *MarketPlaceFilterer) ParseCreateMarket(log types.Log) (*MarketPlaceCreateMarket, error) {
	event := new(MarketPlaceCreateMarket)
	if err := _MarketPlace.contract.UnpackLog(event, "CreateMarket", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MarketPlaceMintIterator is returned from FilterMint and is used to iterate over the raw logs and unpacked data for Mint events raised by the MarketPlace contract.
type MarketPlaceMintIterator struct {
	Event *MarketPlaceMint // Event containing the contract specifics and raw log

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
func (it *MarketPlaceMintIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MarketPlaceMint)
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
		it.Event = new(MarketPlaceMint)
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
func (it *MarketPlaceMintIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MarketPlaceMintIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MarketPlaceMint represents a Mint event raised by the MarketPlace contract.
type MarketPlaceMint struct {
	Underlying        common.Address
	Maturity          *big.Int
	UnderlyingIn      *big.Int
	PrincipalTokensIn *big.Int
	Minted            *big.Int
	Minter            common.Address
	Raw               types.Log // Blockchain specific contextual infos
}

// FilterMint is a free log retrieval operation binding the contract event 0x265ee4cff6cdf714e68c02e61a7864cf66bc04e372a41b6cc425acbb737cd395.
//
// Solidity: event Mint(address indexed underlying, uint256 indexed maturity, uint256 underlyingIn, uint256 principalTokensIn, uint256 minted, address minter)
func (_MarketPlace *MarketPlaceFilterer) FilterMint(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int) (*MarketPlaceMintIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.FilterLogs(opts, "Mint", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceMintIterator{contract: _MarketPlace.contract, event: "Mint", logs: logs, sub: sub}, nil
}

// WatchMint is a free log subscription operation binding the contract event 0x265ee4cff6cdf714e68c02e61a7864cf66bc04e372a41b6cc425acbb737cd395.
//
// Solidity: event Mint(address indexed underlying, uint256 indexed maturity, uint256 underlyingIn, uint256 principalTokensIn, uint256 minted, address minter)
func (_MarketPlace *MarketPlaceFilterer) WatchMint(opts *bind.WatchOpts, sink chan<- *MarketPlaceMint, underlying []common.Address, maturity []*big.Int) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.WatchLogs(opts, "Mint", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MarketPlaceMint)
				if err := _MarketPlace.contract.UnpackLog(event, "Mint", log); err != nil {
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

// ParseMint is a log parse operation binding the contract event 0x265ee4cff6cdf714e68c02e61a7864cf66bc04e372a41b6cc425acbb737cd395.
//
// Solidity: event Mint(address indexed underlying, uint256 indexed maturity, uint256 underlyingIn, uint256 principalTokensIn, uint256 minted, address minter)
func (_MarketPlace *MarketPlaceFilterer) ParseMint(log types.Log) (*MarketPlaceMint, error) {
	event := new(MarketPlaceMint)
	if err := _MarketPlace.contract.UnpackLog(event, "Mint", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MarketPlaceSetAdminIterator is returned from FilterSetAdmin and is used to iterate over the raw logs and unpacked data for SetAdmin events raised by the MarketPlace contract.
type MarketPlaceSetAdminIterator struct {
	Event *MarketPlaceSetAdmin // Event containing the contract specifics and raw log

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
func (it *MarketPlaceSetAdminIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MarketPlaceSetAdmin)
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
		it.Event = new(MarketPlaceSetAdmin)
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
func (it *MarketPlaceSetAdminIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MarketPlaceSetAdminIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MarketPlaceSetAdmin represents a SetAdmin event raised by the MarketPlace contract.
type MarketPlaceSetAdmin struct {
	Admin common.Address
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterSetAdmin is a free log retrieval operation binding the contract event 0x5a272403b402d892977df56625f4164ccaf70ca3863991c43ecfe76a6905b0a1.
//
// Solidity: event SetAdmin(address indexed admin)
func (_MarketPlace *MarketPlaceFilterer) FilterSetAdmin(opts *bind.FilterOpts, admin []common.Address) (*MarketPlaceSetAdminIterator, error) {

	var adminRule []interface{}
	for _, adminItem := range admin {
		adminRule = append(adminRule, adminItem)
	}

	logs, sub, err := _MarketPlace.contract.FilterLogs(opts, "SetAdmin", adminRule)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceSetAdminIterator{contract: _MarketPlace.contract, event: "SetAdmin", logs: logs, sub: sub}, nil
}

// WatchSetAdmin is a free log subscription operation binding the contract event 0x5a272403b402d892977df56625f4164ccaf70ca3863991c43ecfe76a6905b0a1.
//
// Solidity: event SetAdmin(address indexed admin)
func (_MarketPlace *MarketPlaceFilterer) WatchSetAdmin(opts *bind.WatchOpts, sink chan<- *MarketPlaceSetAdmin, admin []common.Address) (event.Subscription, error) {

	var adminRule []interface{}
	for _, adminItem := range admin {
		adminRule = append(adminRule, adminItem)
	}

	logs, sub, err := _MarketPlace.contract.WatchLogs(opts, "SetAdmin", adminRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MarketPlaceSetAdmin)
				if err := _MarketPlace.contract.UnpackLog(event, "SetAdmin", log); err != nil {
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

// ParseSetAdmin is a log parse operation binding the contract event 0x5a272403b402d892977df56625f4164ccaf70ca3863991c43ecfe76a6905b0a1.
//
// Solidity: event SetAdmin(address indexed admin)
func (_MarketPlace *MarketPlaceFilterer) ParseSetAdmin(log types.Log) (*MarketPlaceSetAdmin, error) {
	event := new(MarketPlaceSetAdmin)
	if err := _MarketPlace.contract.UnpackLog(event, "SetAdmin", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MarketPlaceSetPoolIterator is returned from FilterSetPool and is used to iterate over the raw logs and unpacked data for SetPool events raised by the MarketPlace contract.
type MarketPlaceSetPoolIterator struct {
	Event *MarketPlaceSetPool // Event containing the contract specifics and raw log

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
func (it *MarketPlaceSetPoolIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MarketPlaceSetPool)
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
		it.Event = new(MarketPlaceSetPool)
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
func (it *MarketPlaceSetPoolIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MarketPlaceSetPoolIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MarketPlaceSetPool represents a SetPool event raised by the MarketPlace contract.
type MarketPlaceSetPool struct {
	Underlying common.Address
	Maturity   *big.Int
	Pool       common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterSetPool is a free log retrieval operation binding the contract event 0x55209e3c7f85dc20f4a87c5797c01f02e573346bef47c8b034f89ace44a985a4.
//
// Solidity: event SetPool(address indexed underlying, uint256 indexed maturity, address indexed pool)
func (_MarketPlace *MarketPlaceFilterer) FilterSetPool(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int, pool []common.Address) (*MarketPlaceSetPoolIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}
	var poolRule []interface{}
	for _, poolItem := range pool {
		poolRule = append(poolRule, poolItem)
	}

	logs, sub, err := _MarketPlace.contract.FilterLogs(opts, "SetPool", underlyingRule, maturityRule, poolRule)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceSetPoolIterator{contract: _MarketPlace.contract, event: "SetPool", logs: logs, sub: sub}, nil
}

// WatchSetPool is a free log subscription operation binding the contract event 0x55209e3c7f85dc20f4a87c5797c01f02e573346bef47c8b034f89ace44a985a4.
//
// Solidity: event SetPool(address indexed underlying, uint256 indexed maturity, address indexed pool)
func (_MarketPlace *MarketPlaceFilterer) WatchSetPool(opts *bind.WatchOpts, sink chan<- *MarketPlaceSetPool, underlying []common.Address, maturity []*big.Int, pool []common.Address) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}
	var poolRule []interface{}
	for _, poolItem := range pool {
		poolRule = append(poolRule, poolItem)
	}

	logs, sub, err := _MarketPlace.contract.WatchLogs(opts, "SetPool", underlyingRule, maturityRule, poolRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MarketPlaceSetPool)
				if err := _MarketPlace.contract.UnpackLog(event, "SetPool", log); err != nil {
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

// ParseSetPool is a log parse operation binding the contract event 0x55209e3c7f85dc20f4a87c5797c01f02e573346bef47c8b034f89ace44a985a4.
//
// Solidity: event SetPool(address indexed underlying, uint256 indexed maturity, address indexed pool)
func (_MarketPlace *MarketPlaceFilterer) ParseSetPool(log types.Log) (*MarketPlaceSetPool, error) {
	event := new(MarketPlaceSetPool)
	if err := _MarketPlace.contract.UnpackLog(event, "SetPool", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MarketPlaceSetPrincipalIterator is returned from FilterSetPrincipal and is used to iterate over the raw logs and unpacked data for SetPrincipal events raised by the MarketPlace contract.
type MarketPlaceSetPrincipalIterator struct {
	Event *MarketPlaceSetPrincipal // Event containing the contract specifics and raw log

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
func (it *MarketPlaceSetPrincipalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MarketPlaceSetPrincipal)
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
		it.Event = new(MarketPlaceSetPrincipal)
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
func (it *MarketPlaceSetPrincipalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MarketPlaceSetPrincipalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MarketPlaceSetPrincipal represents a SetPrincipal event raised by the MarketPlace contract.
type MarketPlaceSetPrincipal struct {
	Underlying common.Address
	Maturity   *big.Int
	Principal  common.Address
	Protocol   uint8
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterSetPrincipal is a free log retrieval operation binding the contract event 0x8ba24479c926c0dce3c1d2f5d67f7702d828d848c9cc6f3e040bd8a3ea8293ec.
//
// Solidity: event SetPrincipal(address indexed underlying, uint256 indexed maturity, address indexed principal, uint8 protocol)
func (_MarketPlace *MarketPlaceFilterer) FilterSetPrincipal(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int, principal []common.Address) (*MarketPlaceSetPrincipalIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}
	var principalRule []interface{}
	for _, principalItem := range principal {
		principalRule = append(principalRule, principalItem)
	}

	logs, sub, err := _MarketPlace.contract.FilterLogs(opts, "SetPrincipal", underlyingRule, maturityRule, principalRule)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceSetPrincipalIterator{contract: _MarketPlace.contract, event: "SetPrincipal", logs: logs, sub: sub}, nil
}

// WatchSetPrincipal is a free log subscription operation binding the contract event 0x8ba24479c926c0dce3c1d2f5d67f7702d828d848c9cc6f3e040bd8a3ea8293ec.
//
// Solidity: event SetPrincipal(address indexed underlying, uint256 indexed maturity, address indexed principal, uint8 protocol)
func (_MarketPlace *MarketPlaceFilterer) WatchSetPrincipal(opts *bind.WatchOpts, sink chan<- *MarketPlaceSetPrincipal, underlying []common.Address, maturity []*big.Int, principal []common.Address) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}
	var principalRule []interface{}
	for _, principalItem := range principal {
		principalRule = append(principalRule, principalItem)
	}

	logs, sub, err := _MarketPlace.contract.WatchLogs(opts, "SetPrincipal", underlyingRule, maturityRule, principalRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MarketPlaceSetPrincipal)
				if err := _MarketPlace.contract.UnpackLog(event, "SetPrincipal", log); err != nil {
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

// ParseSetPrincipal is a log parse operation binding the contract event 0x8ba24479c926c0dce3c1d2f5d67f7702d828d848c9cc6f3e040bd8a3ea8293ec.
//
// Solidity: event SetPrincipal(address indexed underlying, uint256 indexed maturity, address indexed principal, uint8 protocol)
func (_MarketPlace *MarketPlaceFilterer) ParseSetPrincipal(log types.Log) (*MarketPlaceSetPrincipal, error) {
	event := new(MarketPlaceSetPrincipal)
	if err := _MarketPlace.contract.UnpackLog(event, "SetPrincipal", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MarketPlaceSwapIterator is returned from FilterSwap and is used to iterate over the raw logs and unpacked data for Swap events raised by the MarketPlace contract.
type MarketPlaceSwapIterator struct {
	Event *MarketPlaceSwap // Event containing the contract specifics and raw log

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
func (it *MarketPlaceSwapIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MarketPlaceSwap)
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
		it.Event = new(MarketPlaceSwap)
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
func (it *MarketPlaceSwapIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MarketPlaceSwapIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MarketPlaceSwap represents a Swap event raised by the MarketPlace contract.
type MarketPlaceSwap struct {
	Underlying common.Address
	Maturity   *big.Int
	Sold       common.Address
	Bought     common.Address
	Received   *big.Int
	Spent      *big.Int
	Spender    common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterSwap is a free log retrieval operation binding the contract event 0xac50a83c5dcd42ce33ea749192a73b769e02b8b4fd4aecd74f4adb25515ac506.
//
// Solidity: event Swap(address indexed underlying, uint256 indexed maturity, address sold, address bought, uint256 received, uint256 spent, address spender)
func (_MarketPlace *MarketPlaceFilterer) FilterSwap(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int) (*MarketPlaceSwapIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.FilterLogs(opts, "Swap", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return &MarketPlaceSwapIterator{contract: _MarketPlace.contract, event: "Swap", logs: logs, sub: sub}, nil
}

// WatchSwap is a free log subscription operation binding the contract event 0xac50a83c5dcd42ce33ea749192a73b769e02b8b4fd4aecd74f4adb25515ac506.
//
// Solidity: event Swap(address indexed underlying, uint256 indexed maturity, address sold, address bought, uint256 received, uint256 spent, address spender)
func (_MarketPlace *MarketPlaceFilterer) WatchSwap(opts *bind.WatchOpts, sink chan<- *MarketPlaceSwap, underlying []common.Address, maturity []*big.Int) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _MarketPlace.contract.WatchLogs(opts, "Swap", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MarketPlaceSwap)
				if err := _MarketPlace.contract.UnpackLog(event, "Swap", log); err != nil {
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

// ParseSwap is a log parse operation binding the contract event 0xac50a83c5dcd42ce33ea749192a73b769e02b8b4fd4aecd74f4adb25515ac506.
//
// Solidity: event Swap(address indexed underlying, uint256 indexed maturity, address sold, address bought, uint256 received, uint256 spent, address spender)
func (_MarketPlace *MarketPlaceFilterer) ParseSwap(log types.Log) (*MarketPlaceSwap, error) {
	event := new(MarketPlaceSwap)
	if err := _MarketPlace.contract.UnpackLog(event, "Swap", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
