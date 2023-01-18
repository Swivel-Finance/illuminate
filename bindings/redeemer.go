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

// RedeemerMetaData contains all meta data concerning the Redeemer contract.
var RedeemerMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"l\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"s\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"p\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"t\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"Exception\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"bool\",\"name\":\"state\",\"type\":\"bool\"}],\"name\":\"PauseRedemptions\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint8\",\"name\":\"principal\",\"type\":\"uint8\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"burned\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"sender\",\"type\":\"address\"}],\"name\":\"Redeem\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"when\",\"type\":\"uint256\"}],\"name\":\"ScheduleFeeChange\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"admin\",\"type\":\"address\"}],\"name\":\"SetAdmin\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"converter\",\"type\":\"address\"}],\"name\":\"SetConverter\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"fee\",\"type\":\"uint256\"}],\"name\":\"SetFee\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"HOLD\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"MIN_FEENOMINATOR\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"admin\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"i\",\"type\":\"address\"}],\"name\":\"approve\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"f\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"t\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"authRedeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"address[]\",\"name\":\"f\",\"type\":\"address[]\"}],\"name\":\"autoRedeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"converter\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"feeChange\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"feenominator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"holdings\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"lender\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"marketPlace\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"bool\",\"name\":\"b\",\"type\":\"bool\"}],\"name\":\"pauseRedemptions\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"paused\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"pendleAddr\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"}],\"name\":\"redeem\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint8\",\"name\":\"protocol\",\"type\":\"uint8\"}],\"name\":\"redeem\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"periphery\",\"type\":\"address\"}],\"name\":\"redeem\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"}],\"name\":\"redeem\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"scheduleFeeChange\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"}],\"name\":\"setAdmin\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"c\",\"type\":\"address\"},{\"internalType\":\"address[]\",\"name\":\"i\",\"type\":\"address[]\"}],\"name\":\"setConverter\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"f\",\"type\":\"uint256\"}],\"name\":\"setFee\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"l\",\"type\":\"address\"}],\"name\":\"setLender\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"m\",\"type\":\"address\"}],\"name\":\"setMarketPlace\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"swivelAddr\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"tempusAddr\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]",
}

// RedeemerABI is the input ABI used to generate the binding from.
// Deprecated: Use RedeemerMetaData.ABI instead.
var RedeemerABI = RedeemerMetaData.ABI

// Redeemer is an auto generated Go binding around an Ethereum contract.
type Redeemer struct {
	RedeemerCaller     // Read-only binding to the contract
	RedeemerTransactor // Write-only binding to the contract
	RedeemerFilterer   // Log filterer for contract events
}

// RedeemerCaller is an auto generated read-only Go binding around an Ethereum contract.
type RedeemerCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// RedeemerTransactor is an auto generated write-only Go binding around an Ethereum contract.
type RedeemerTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// RedeemerFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type RedeemerFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// RedeemerSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type RedeemerSession struct {
	Contract     *Redeemer         // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// RedeemerCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type RedeemerCallerSession struct {
	Contract *RedeemerCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts   // Call options to use throughout this session
}

// RedeemerTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type RedeemerTransactorSession struct {
	Contract     *RedeemerTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// RedeemerRaw is an auto generated low-level Go binding around an Ethereum contract.
type RedeemerRaw struct {
	Contract *Redeemer // Generic contract binding to access the raw methods on
}

// RedeemerCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type RedeemerCallerRaw struct {
	Contract *RedeemerCaller // Generic read-only contract binding to access the raw methods on
}

// RedeemerTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type RedeemerTransactorRaw struct {
	Contract *RedeemerTransactor // Generic write-only contract binding to access the raw methods on
}

// NewRedeemer creates a new instance of Redeemer, bound to a specific deployed contract.
func NewRedeemer(address common.Address, backend bind.ContractBackend) (*Redeemer, error) {
	contract, err := bindRedeemer(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Redeemer{RedeemerCaller: RedeemerCaller{contract: contract}, RedeemerTransactor: RedeemerTransactor{contract: contract}, RedeemerFilterer: RedeemerFilterer{contract: contract}}, nil
}

// NewRedeemerCaller creates a new read-only instance of Redeemer, bound to a specific deployed contract.
func NewRedeemerCaller(address common.Address, caller bind.ContractCaller) (*RedeemerCaller, error) {
	contract, err := bindRedeemer(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &RedeemerCaller{contract: contract}, nil
}

// NewRedeemerTransactor creates a new write-only instance of Redeemer, bound to a specific deployed contract.
func NewRedeemerTransactor(address common.Address, transactor bind.ContractTransactor) (*RedeemerTransactor, error) {
	contract, err := bindRedeemer(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &RedeemerTransactor{contract: contract}, nil
}

// NewRedeemerFilterer creates a new log filterer instance of Redeemer, bound to a specific deployed contract.
func NewRedeemerFilterer(address common.Address, filterer bind.ContractFilterer) (*RedeemerFilterer, error) {
	contract, err := bindRedeemer(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &RedeemerFilterer{contract: contract}, nil
}

// bindRedeemer binds a generic wrapper to an already deployed contract.
func bindRedeemer(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(RedeemerABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Redeemer *RedeemerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Redeemer.Contract.RedeemerCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Redeemer *RedeemerRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Redeemer.Contract.RedeemerTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Redeemer *RedeemerRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Redeemer.Contract.RedeemerTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Redeemer *RedeemerCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Redeemer.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Redeemer *RedeemerTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Redeemer.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Redeemer *RedeemerTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Redeemer.Contract.contract.Transact(opts, method, params...)
}

// HOLD is a free data retrieval call binding the contract method 0xd0886f97.
//
// Solidity: function HOLD() view returns(uint256)
func (_Redeemer *RedeemerCaller) HOLD(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "HOLD")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// HOLD is a free data retrieval call binding the contract method 0xd0886f97.
//
// Solidity: function HOLD() view returns(uint256)
func (_Redeemer *RedeemerSession) HOLD() (*big.Int, error) {
	return _Redeemer.Contract.HOLD(&_Redeemer.CallOpts)
}

// HOLD is a free data retrieval call binding the contract method 0xd0886f97.
//
// Solidity: function HOLD() view returns(uint256)
func (_Redeemer *RedeemerCallerSession) HOLD() (*big.Int, error) {
	return _Redeemer.Contract.HOLD(&_Redeemer.CallOpts)
}

// MINFEENOMINATOR is a free data retrieval call binding the contract method 0x0d3f5352.
//
// Solidity: function MIN_FEENOMINATOR() view returns(uint256)
func (_Redeemer *RedeemerCaller) MINFEENOMINATOR(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "MIN_FEENOMINATOR")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MINFEENOMINATOR is a free data retrieval call binding the contract method 0x0d3f5352.
//
// Solidity: function MIN_FEENOMINATOR() view returns(uint256)
func (_Redeemer *RedeemerSession) MINFEENOMINATOR() (*big.Int, error) {
	return _Redeemer.Contract.MINFEENOMINATOR(&_Redeemer.CallOpts)
}

// MINFEENOMINATOR is a free data retrieval call binding the contract method 0x0d3f5352.
//
// Solidity: function MIN_FEENOMINATOR() view returns(uint256)
func (_Redeemer *RedeemerCallerSession) MINFEENOMINATOR() (*big.Int, error) {
	return _Redeemer.Contract.MINFEENOMINATOR(&_Redeemer.CallOpts)
}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_Redeemer *RedeemerCaller) Admin(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "admin")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_Redeemer *RedeemerSession) Admin() (common.Address, error) {
	return _Redeemer.Contract.Admin(&_Redeemer.CallOpts)
}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_Redeemer *RedeemerCallerSession) Admin() (common.Address, error) {
	return _Redeemer.Contract.Admin(&_Redeemer.CallOpts)
}

// Converter is a free data retrieval call binding the contract method 0xbd38837b.
//
// Solidity: function converter() view returns(address)
func (_Redeemer *RedeemerCaller) Converter(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "converter")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Converter is a free data retrieval call binding the contract method 0xbd38837b.
//
// Solidity: function converter() view returns(address)
func (_Redeemer *RedeemerSession) Converter() (common.Address, error) {
	return _Redeemer.Contract.Converter(&_Redeemer.CallOpts)
}

// Converter is a free data retrieval call binding the contract method 0xbd38837b.
//
// Solidity: function converter() view returns(address)
func (_Redeemer *RedeemerCallerSession) Converter() (common.Address, error) {
	return _Redeemer.Contract.Converter(&_Redeemer.CallOpts)
}

// FeeChange is a free data retrieval call binding the contract method 0x35197f9e.
//
// Solidity: function feeChange() view returns(uint256)
func (_Redeemer *RedeemerCaller) FeeChange(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "feeChange")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// FeeChange is a free data retrieval call binding the contract method 0x35197f9e.
//
// Solidity: function feeChange() view returns(uint256)
func (_Redeemer *RedeemerSession) FeeChange() (*big.Int, error) {
	return _Redeemer.Contract.FeeChange(&_Redeemer.CallOpts)
}

// FeeChange is a free data retrieval call binding the contract method 0x35197f9e.
//
// Solidity: function feeChange() view returns(uint256)
func (_Redeemer *RedeemerCallerSession) FeeChange() (*big.Int, error) {
	return _Redeemer.Contract.FeeChange(&_Redeemer.CallOpts)
}

// Feenominator is a free data retrieval call binding the contract method 0x9e6b5173.
//
// Solidity: function feenominator() view returns(uint256)
func (_Redeemer *RedeemerCaller) Feenominator(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "feenominator")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Feenominator is a free data retrieval call binding the contract method 0x9e6b5173.
//
// Solidity: function feenominator() view returns(uint256)
func (_Redeemer *RedeemerSession) Feenominator() (*big.Int, error) {
	return _Redeemer.Contract.Feenominator(&_Redeemer.CallOpts)
}

// Feenominator is a free data retrieval call binding the contract method 0x9e6b5173.
//
// Solidity: function feenominator() view returns(uint256)
func (_Redeemer *RedeemerCallerSession) Feenominator() (*big.Int, error) {
	return _Redeemer.Contract.Feenominator(&_Redeemer.CallOpts)
}

// Holdings is a free data retrieval call binding the contract method 0x91b46a91.
//
// Solidity: function holdings(address , uint256 ) view returns(uint256)
func (_Redeemer *RedeemerCaller) Holdings(opts *bind.CallOpts, arg0 common.Address, arg1 *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "holdings", arg0, arg1)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Holdings is a free data retrieval call binding the contract method 0x91b46a91.
//
// Solidity: function holdings(address , uint256 ) view returns(uint256)
func (_Redeemer *RedeemerSession) Holdings(arg0 common.Address, arg1 *big.Int) (*big.Int, error) {
	return _Redeemer.Contract.Holdings(&_Redeemer.CallOpts, arg0, arg1)
}

// Holdings is a free data retrieval call binding the contract method 0x91b46a91.
//
// Solidity: function holdings(address , uint256 ) view returns(uint256)
func (_Redeemer *RedeemerCallerSession) Holdings(arg0 common.Address, arg1 *big.Int) (*big.Int, error) {
	return _Redeemer.Contract.Holdings(&_Redeemer.CallOpts, arg0, arg1)
}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_Redeemer *RedeemerCaller) Lender(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "lender")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_Redeemer *RedeemerSession) Lender() (common.Address, error) {
	return _Redeemer.Contract.Lender(&_Redeemer.CallOpts)
}

// Lender is a free data retrieval call binding the contract method 0xbcead63e.
//
// Solidity: function lender() view returns(address)
func (_Redeemer *RedeemerCallerSession) Lender() (common.Address, error) {
	return _Redeemer.Contract.Lender(&_Redeemer.CallOpts)
}

// MarketPlace is a free data retrieval call binding the contract method 0x2e25d2a6.
//
// Solidity: function marketPlace() view returns(address)
func (_Redeemer *RedeemerCaller) MarketPlace(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "marketPlace")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// MarketPlace is a free data retrieval call binding the contract method 0x2e25d2a6.
//
// Solidity: function marketPlace() view returns(address)
func (_Redeemer *RedeemerSession) MarketPlace() (common.Address, error) {
	return _Redeemer.Contract.MarketPlace(&_Redeemer.CallOpts)
}

// MarketPlace is a free data retrieval call binding the contract method 0x2e25d2a6.
//
// Solidity: function marketPlace() view returns(address)
func (_Redeemer *RedeemerCallerSession) MarketPlace() (common.Address, error) {
	return _Redeemer.Contract.MarketPlace(&_Redeemer.CallOpts)
}

// Paused is a free data retrieval call binding the contract method 0xf3896131.
//
// Solidity: function paused(address , uint256 ) view returns(bool)
func (_Redeemer *RedeemerCaller) Paused(opts *bind.CallOpts, arg0 common.Address, arg1 *big.Int) (bool, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "paused", arg0, arg1)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// Paused is a free data retrieval call binding the contract method 0xf3896131.
//
// Solidity: function paused(address , uint256 ) view returns(bool)
func (_Redeemer *RedeemerSession) Paused(arg0 common.Address, arg1 *big.Int) (bool, error) {
	return _Redeemer.Contract.Paused(&_Redeemer.CallOpts, arg0, arg1)
}

// Paused is a free data retrieval call binding the contract method 0xf3896131.
//
// Solidity: function paused(address , uint256 ) view returns(bool)
func (_Redeemer *RedeemerCallerSession) Paused(arg0 common.Address, arg1 *big.Int) (bool, error) {
	return _Redeemer.Contract.Paused(&_Redeemer.CallOpts, arg0, arg1)
}

// PendleAddr is a free data retrieval call binding the contract method 0xef603569.
//
// Solidity: function pendleAddr() view returns(address)
func (_Redeemer *RedeemerCaller) PendleAddr(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "pendleAddr")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// PendleAddr is a free data retrieval call binding the contract method 0xef603569.
//
// Solidity: function pendleAddr() view returns(address)
func (_Redeemer *RedeemerSession) PendleAddr() (common.Address, error) {
	return _Redeemer.Contract.PendleAddr(&_Redeemer.CallOpts)
}

// PendleAddr is a free data retrieval call binding the contract method 0xef603569.
//
// Solidity: function pendleAddr() view returns(address)
func (_Redeemer *RedeemerCallerSession) PendleAddr() (common.Address, error) {
	return _Redeemer.Contract.PendleAddr(&_Redeemer.CallOpts)
}

// SwivelAddr is a free data retrieval call binding the contract method 0xea08c031.
//
// Solidity: function swivelAddr() view returns(address)
func (_Redeemer *RedeemerCaller) SwivelAddr(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "swivelAddr")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// SwivelAddr is a free data retrieval call binding the contract method 0xea08c031.
//
// Solidity: function swivelAddr() view returns(address)
func (_Redeemer *RedeemerSession) SwivelAddr() (common.Address, error) {
	return _Redeemer.Contract.SwivelAddr(&_Redeemer.CallOpts)
}

// SwivelAddr is a free data retrieval call binding the contract method 0xea08c031.
//
// Solidity: function swivelAddr() view returns(address)
func (_Redeemer *RedeemerCallerSession) SwivelAddr() (common.Address, error) {
	return _Redeemer.Contract.SwivelAddr(&_Redeemer.CallOpts)
}

// TempusAddr is a free data retrieval call binding the contract method 0xde1d3cb5.
//
// Solidity: function tempusAddr() view returns(address)
func (_Redeemer *RedeemerCaller) TempusAddr(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Redeemer.contract.Call(opts, &out, "tempusAddr")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// TempusAddr is a free data retrieval call binding the contract method 0xde1d3cb5.
//
// Solidity: function tempusAddr() view returns(address)
func (_Redeemer *RedeemerSession) TempusAddr() (common.Address, error) {
	return _Redeemer.Contract.TempusAddr(&_Redeemer.CallOpts)
}

// TempusAddr is a free data retrieval call binding the contract method 0xde1d3cb5.
//
// Solidity: function tempusAddr() view returns(address)
func (_Redeemer *RedeemerCallerSession) TempusAddr() (common.Address, error) {
	return _Redeemer.Contract.TempusAddr(&_Redeemer.CallOpts)
}

// Approve is a paid mutator transaction binding the contract method 0xdaea85c5.
//
// Solidity: function approve(address i) returns()
func (_Redeemer *RedeemerTransactor) Approve(opts *bind.TransactOpts, i common.Address) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "approve", i)
}

// Approve is a paid mutator transaction binding the contract method 0xdaea85c5.
//
// Solidity: function approve(address i) returns()
func (_Redeemer *RedeemerSession) Approve(i common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.Approve(&_Redeemer.TransactOpts, i)
}

// Approve is a paid mutator transaction binding the contract method 0xdaea85c5.
//
// Solidity: function approve(address i) returns()
func (_Redeemer *RedeemerTransactorSession) Approve(i common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.Approve(&_Redeemer.TransactOpts, i)
}

// AuthRedeem is a paid mutator transaction binding the contract method 0x70a03ced.
//
// Solidity: function authRedeem(address u, uint256 m, address f, address t, uint256 a) returns(uint256)
func (_Redeemer *RedeemerTransactor) AuthRedeem(opts *bind.TransactOpts, u common.Address, m *big.Int, f common.Address, t common.Address, a *big.Int) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "authRedeem", u, m, f, t, a)
}

// AuthRedeem is a paid mutator transaction binding the contract method 0x70a03ced.
//
// Solidity: function authRedeem(address u, uint256 m, address f, address t, uint256 a) returns(uint256)
func (_Redeemer *RedeemerSession) AuthRedeem(u common.Address, m *big.Int, f common.Address, t common.Address, a *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.AuthRedeem(&_Redeemer.TransactOpts, u, m, f, t, a)
}

// AuthRedeem is a paid mutator transaction binding the contract method 0x70a03ced.
//
// Solidity: function authRedeem(address u, uint256 m, address f, address t, uint256 a) returns(uint256)
func (_Redeemer *RedeemerTransactorSession) AuthRedeem(u common.Address, m *big.Int, f common.Address, t common.Address, a *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.AuthRedeem(&_Redeemer.TransactOpts, u, m, f, t, a)
}

// AutoRedeem is a paid mutator transaction binding the contract method 0xad86b83e.
//
// Solidity: function autoRedeem(address u, uint256 m, address[] f) returns(uint256)
func (_Redeemer *RedeemerTransactor) AutoRedeem(opts *bind.TransactOpts, u common.Address, m *big.Int, f []common.Address) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "autoRedeem", u, m, f)
}

// AutoRedeem is a paid mutator transaction binding the contract method 0xad86b83e.
//
// Solidity: function autoRedeem(address u, uint256 m, address[] f) returns(uint256)
func (_Redeemer *RedeemerSession) AutoRedeem(u common.Address, m *big.Int, f []common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.AutoRedeem(&_Redeemer.TransactOpts, u, m, f)
}

// AutoRedeem is a paid mutator transaction binding the contract method 0xad86b83e.
//
// Solidity: function autoRedeem(address u, uint256 m, address[] f) returns(uint256)
func (_Redeemer *RedeemerTransactorSession) AutoRedeem(u common.Address, m *big.Int, f []common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.AutoRedeem(&_Redeemer.TransactOpts, u, m, f)
}

// PauseRedemptions is a paid mutator transaction binding the contract method 0xa4ad5115.
//
// Solidity: function pauseRedemptions(address u, uint256 m, bool b) returns()
func (_Redeemer *RedeemerTransactor) PauseRedemptions(opts *bind.TransactOpts, u common.Address, m *big.Int, b bool) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "pauseRedemptions", u, m, b)
}

// PauseRedemptions is a paid mutator transaction binding the contract method 0xa4ad5115.
//
// Solidity: function pauseRedemptions(address u, uint256 m, bool b) returns()
func (_Redeemer *RedeemerSession) PauseRedemptions(u common.Address, m *big.Int, b bool) (*types.Transaction, error) {
	return _Redeemer.Contract.PauseRedemptions(&_Redeemer.TransactOpts, u, m, b)
}

// PauseRedemptions is a paid mutator transaction binding the contract method 0xa4ad5115.
//
// Solidity: function pauseRedemptions(address u, uint256 m, bool b) returns()
func (_Redeemer *RedeemerTransactorSession) PauseRedemptions(u common.Address, m *big.Int, b bool) (*types.Transaction, error) {
	return _Redeemer.Contract.PauseRedemptions(&_Redeemer.TransactOpts, u, m, b)
}

// Redeem is a paid mutator transaction binding the contract method 0x1e9a6950.
//
// Solidity: function redeem(address u, uint256 m) returns()
func (_Redeemer *RedeemerTransactor) Redeem(opts *bind.TransactOpts, u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "redeem", u, m)
}

// Redeem is a paid mutator transaction binding the contract method 0x1e9a6950.
//
// Solidity: function redeem(address u, uint256 m) returns()
func (_Redeemer *RedeemerSession) Redeem(u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem(&_Redeemer.TransactOpts, u, m)
}

// Redeem is a paid mutator transaction binding the contract method 0x1e9a6950.
//
// Solidity: function redeem(address u, uint256 m) returns()
func (_Redeemer *RedeemerTransactorSession) Redeem(u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem(&_Redeemer.TransactOpts, u, m)
}

// Redeem0 is a paid mutator transaction binding the contract method 0x769065b9.
//
// Solidity: function redeem(uint8 p, address u, uint256 m, uint8 protocol) returns(bool)
func (_Redeemer *RedeemerTransactor) Redeem0(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, protocol uint8) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "redeem0", p, u, m, protocol)
}

// Redeem0 is a paid mutator transaction binding the contract method 0x769065b9.
//
// Solidity: function redeem(uint8 p, address u, uint256 m, uint8 protocol) returns(bool)
func (_Redeemer *RedeemerSession) Redeem0(p uint8, u common.Address, m *big.Int, protocol uint8) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem0(&_Redeemer.TransactOpts, p, u, m, protocol)
}

// Redeem0 is a paid mutator transaction binding the contract method 0x769065b9.
//
// Solidity: function redeem(uint8 p, address u, uint256 m, uint8 protocol) returns(bool)
func (_Redeemer *RedeemerTransactorSession) Redeem0(p uint8, u common.Address, m *big.Int, protocol uint8) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem0(&_Redeemer.TransactOpts, p, u, m, protocol)
}

// Redeem1 is a paid mutator transaction binding the contract method 0x80252724.
//
// Solidity: function redeem(uint8 p, address u, uint256 m, uint256 s, uint256 a, address periphery) returns(bool)
func (_Redeemer *RedeemerTransactor) Redeem1(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, s *big.Int, a *big.Int, periphery common.Address) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "redeem1", p, u, m, s, a, periphery)
}

// Redeem1 is a paid mutator transaction binding the contract method 0x80252724.
//
// Solidity: function redeem(uint8 p, address u, uint256 m, uint256 s, uint256 a, address periphery) returns(bool)
func (_Redeemer *RedeemerSession) Redeem1(p uint8, u common.Address, m *big.Int, s *big.Int, a *big.Int, periphery common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem1(&_Redeemer.TransactOpts, p, u, m, s, a, periphery)
}

// Redeem1 is a paid mutator transaction binding the contract method 0x80252724.
//
// Solidity: function redeem(uint8 p, address u, uint256 m, uint256 s, uint256 a, address periphery) returns(bool)
func (_Redeemer *RedeemerTransactorSession) Redeem1(p uint8, u common.Address, m *big.Int, s *big.Int, a *big.Int, periphery common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem1(&_Redeemer.TransactOpts, p, u, m, s, a, periphery)
}

// Redeem2 is a paid mutator transaction binding the contract method 0xa1b1138c.
//
// Solidity: function redeem(uint8 p, address u, uint256 m) returns(bool)
func (_Redeemer *RedeemerTransactor) Redeem2(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "redeem2", p, u, m)
}

// Redeem2 is a paid mutator transaction binding the contract method 0xa1b1138c.
//
// Solidity: function redeem(uint8 p, address u, uint256 m) returns(bool)
func (_Redeemer *RedeemerSession) Redeem2(p uint8, u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem2(&_Redeemer.TransactOpts, p, u, m)
}

// Redeem2 is a paid mutator transaction binding the contract method 0xa1b1138c.
//
// Solidity: function redeem(uint8 p, address u, uint256 m) returns(bool)
func (_Redeemer *RedeemerTransactorSession) Redeem2(p uint8, u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.Redeem2(&_Redeemer.TransactOpts, p, u, m)
}

// ScheduleFeeChange is a paid mutator transaction binding the contract method 0x1177ec30.
//
// Solidity: function scheduleFeeChange() returns(bool)
func (_Redeemer *RedeemerTransactor) ScheduleFeeChange(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "scheduleFeeChange")
}

// ScheduleFeeChange is a paid mutator transaction binding the contract method 0x1177ec30.
//
// Solidity: function scheduleFeeChange() returns(bool)
func (_Redeemer *RedeemerSession) ScheduleFeeChange() (*types.Transaction, error) {
	return _Redeemer.Contract.ScheduleFeeChange(&_Redeemer.TransactOpts)
}

// ScheduleFeeChange is a paid mutator transaction binding the contract method 0x1177ec30.
//
// Solidity: function scheduleFeeChange() returns(bool)
func (_Redeemer *RedeemerTransactorSession) ScheduleFeeChange() (*types.Transaction, error) {
	return _Redeemer.Contract.ScheduleFeeChange(&_Redeemer.TransactOpts)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_Redeemer *RedeemerTransactor) SetAdmin(opts *bind.TransactOpts, a common.Address) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "setAdmin", a)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_Redeemer *RedeemerSession) SetAdmin(a common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetAdmin(&_Redeemer.TransactOpts, a)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_Redeemer *RedeemerTransactorSession) SetAdmin(a common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetAdmin(&_Redeemer.TransactOpts, a)
}

// SetConverter is a paid mutator transaction binding the contract method 0x6a97d9ce.
//
// Solidity: function setConverter(address c, address[] i) returns(bool)
func (_Redeemer *RedeemerTransactor) SetConverter(opts *bind.TransactOpts, c common.Address, i []common.Address) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "setConverter", c, i)
}

// SetConverter is a paid mutator transaction binding the contract method 0x6a97d9ce.
//
// Solidity: function setConverter(address c, address[] i) returns(bool)
func (_Redeemer *RedeemerSession) SetConverter(c common.Address, i []common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetConverter(&_Redeemer.TransactOpts, c, i)
}

// SetConverter is a paid mutator transaction binding the contract method 0x6a97d9ce.
//
// Solidity: function setConverter(address c, address[] i) returns(bool)
func (_Redeemer *RedeemerTransactorSession) SetConverter(c common.Address, i []common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetConverter(&_Redeemer.TransactOpts, c, i)
}

// SetFee is a paid mutator transaction binding the contract method 0x69fe0e2d.
//
// Solidity: function setFee(uint256 f) returns(bool)
func (_Redeemer *RedeemerTransactor) SetFee(opts *bind.TransactOpts, f *big.Int) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "setFee", f)
}

// SetFee is a paid mutator transaction binding the contract method 0x69fe0e2d.
//
// Solidity: function setFee(uint256 f) returns(bool)
func (_Redeemer *RedeemerSession) SetFee(f *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.SetFee(&_Redeemer.TransactOpts, f)
}

// SetFee is a paid mutator transaction binding the contract method 0x69fe0e2d.
//
// Solidity: function setFee(uint256 f) returns(bool)
func (_Redeemer *RedeemerTransactorSession) SetFee(f *big.Int) (*types.Transaction, error) {
	return _Redeemer.Contract.SetFee(&_Redeemer.TransactOpts, f)
}

// SetLender is a paid mutator transaction binding the contract method 0x46e368d4.
//
// Solidity: function setLender(address l) returns(bool)
func (_Redeemer *RedeemerTransactor) SetLender(opts *bind.TransactOpts, l common.Address) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "setLender", l)
}

// SetLender is a paid mutator transaction binding the contract method 0x46e368d4.
//
// Solidity: function setLender(address l) returns(bool)
func (_Redeemer *RedeemerSession) SetLender(l common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetLender(&_Redeemer.TransactOpts, l)
}

// SetLender is a paid mutator transaction binding the contract method 0x46e368d4.
//
// Solidity: function setLender(address l) returns(bool)
func (_Redeemer *RedeemerTransactorSession) SetLender(l common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetLender(&_Redeemer.TransactOpts, l)
}

// SetMarketPlace is a paid mutator transaction binding the contract method 0x30568a8d.
//
// Solidity: function setMarketPlace(address m) returns(bool)
func (_Redeemer *RedeemerTransactor) SetMarketPlace(opts *bind.TransactOpts, m common.Address) (*types.Transaction, error) {
	return _Redeemer.contract.Transact(opts, "setMarketPlace", m)
}

// SetMarketPlace is a paid mutator transaction binding the contract method 0x30568a8d.
//
// Solidity: function setMarketPlace(address m) returns(bool)
func (_Redeemer *RedeemerSession) SetMarketPlace(m common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetMarketPlace(&_Redeemer.TransactOpts, m)
}

// SetMarketPlace is a paid mutator transaction binding the contract method 0x30568a8d.
//
// Solidity: function setMarketPlace(address m) returns(bool)
func (_Redeemer *RedeemerTransactorSession) SetMarketPlace(m common.Address) (*types.Transaction, error) {
	return _Redeemer.Contract.SetMarketPlace(&_Redeemer.TransactOpts, m)
}

// RedeemerPauseRedemptionsIterator is returned from FilterPauseRedemptions and is used to iterate over the raw logs and unpacked data for PauseRedemptions events raised by the Redeemer contract.
type RedeemerPauseRedemptionsIterator struct {
	Event *RedeemerPauseRedemptions // Event containing the contract specifics and raw log

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
func (it *RedeemerPauseRedemptionsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(RedeemerPauseRedemptions)
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
		it.Event = new(RedeemerPauseRedemptions)
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
func (it *RedeemerPauseRedemptionsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *RedeemerPauseRedemptionsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// RedeemerPauseRedemptions represents a PauseRedemptions event raised by the Redeemer contract.
type RedeemerPauseRedemptions struct {
	Underlying common.Address
	Maturity   *big.Int
	State      bool
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterPauseRedemptions is a free log retrieval operation binding the contract event 0x1258883257f202b4bfb5c92d9effcc9b5e7775dcbb52c2c31f39f2dff27d3c2d.
//
// Solidity: event PauseRedemptions(address indexed underlying, uint256 maturity, bool state)
func (_Redeemer *RedeemerFilterer) FilterPauseRedemptions(opts *bind.FilterOpts, underlying []common.Address) (*RedeemerPauseRedemptionsIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}

	logs, sub, err := _Redeemer.contract.FilterLogs(opts, "PauseRedemptions", underlyingRule)
	if err != nil {
		return nil, err
	}
	return &RedeemerPauseRedemptionsIterator{contract: _Redeemer.contract, event: "PauseRedemptions", logs: logs, sub: sub}, nil
}

// WatchPauseRedemptions is a free log subscription operation binding the contract event 0x1258883257f202b4bfb5c92d9effcc9b5e7775dcbb52c2c31f39f2dff27d3c2d.
//
// Solidity: event PauseRedemptions(address indexed underlying, uint256 maturity, bool state)
func (_Redeemer *RedeemerFilterer) WatchPauseRedemptions(opts *bind.WatchOpts, sink chan<- *RedeemerPauseRedemptions, underlying []common.Address) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}

	logs, sub, err := _Redeemer.contract.WatchLogs(opts, "PauseRedemptions", underlyingRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(RedeemerPauseRedemptions)
				if err := _Redeemer.contract.UnpackLog(event, "PauseRedemptions", log); err != nil {
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

// ParsePauseRedemptions is a log parse operation binding the contract event 0x1258883257f202b4bfb5c92d9effcc9b5e7775dcbb52c2c31f39f2dff27d3c2d.
//
// Solidity: event PauseRedemptions(address indexed underlying, uint256 maturity, bool state)
func (_Redeemer *RedeemerFilterer) ParsePauseRedemptions(log types.Log) (*RedeemerPauseRedemptions, error) {
	event := new(RedeemerPauseRedemptions)
	if err := _Redeemer.contract.UnpackLog(event, "PauseRedemptions", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// RedeemerRedeemIterator is returned from FilterRedeem and is used to iterate over the raw logs and unpacked data for Redeem events raised by the Redeemer contract.
type RedeemerRedeemIterator struct {
	Event *RedeemerRedeem // Event containing the contract specifics and raw log

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
func (it *RedeemerRedeemIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(RedeemerRedeem)
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
		it.Event = new(RedeemerRedeem)
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
func (it *RedeemerRedeemIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *RedeemerRedeemIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// RedeemerRedeem represents a Redeem event raised by the Redeemer contract.
type RedeemerRedeem struct {
	Principal  uint8
	Underlying common.Address
	Maturity   *big.Int
	Amount     *big.Int
	Burned     *big.Int
	Sender     common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterRedeem is a free log retrieval operation binding the contract event 0xf9820069613a0f200b0791623bec3ed14a17256cf61c3fc2160fdadbbcdda463.
//
// Solidity: event Redeem(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 amount, uint256 burned, address sender)
func (_Redeemer *RedeemerFilterer) FilterRedeem(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int) (*RedeemerRedeemIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _Redeemer.contract.FilterLogs(opts, "Redeem", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return &RedeemerRedeemIterator{contract: _Redeemer.contract, event: "Redeem", logs: logs, sub: sub}, nil
}

// WatchRedeem is a free log subscription operation binding the contract event 0xf9820069613a0f200b0791623bec3ed14a17256cf61c3fc2160fdadbbcdda463.
//
// Solidity: event Redeem(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 amount, uint256 burned, address sender)
func (_Redeemer *RedeemerFilterer) WatchRedeem(opts *bind.WatchOpts, sink chan<- *RedeemerRedeem, underlying []common.Address, maturity []*big.Int) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _Redeemer.contract.WatchLogs(opts, "Redeem", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(RedeemerRedeem)
				if err := _Redeemer.contract.UnpackLog(event, "Redeem", log); err != nil {
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

// ParseRedeem is a log parse operation binding the contract event 0xf9820069613a0f200b0791623bec3ed14a17256cf61c3fc2160fdadbbcdda463.
//
// Solidity: event Redeem(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 amount, uint256 burned, address sender)
func (_Redeemer *RedeemerFilterer) ParseRedeem(log types.Log) (*RedeemerRedeem, error) {
	event := new(RedeemerRedeem)
	if err := _Redeemer.contract.UnpackLog(event, "Redeem", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// RedeemerScheduleFeeChangeIterator is returned from FilterScheduleFeeChange and is used to iterate over the raw logs and unpacked data for ScheduleFeeChange events raised by the Redeemer contract.
type RedeemerScheduleFeeChangeIterator struct {
	Event *RedeemerScheduleFeeChange // Event containing the contract specifics and raw log

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
func (it *RedeemerScheduleFeeChangeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(RedeemerScheduleFeeChange)
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
		it.Event = new(RedeemerScheduleFeeChange)
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
func (it *RedeemerScheduleFeeChangeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *RedeemerScheduleFeeChangeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// RedeemerScheduleFeeChange represents a ScheduleFeeChange event raised by the Redeemer contract.
type RedeemerScheduleFeeChange struct {
	When *big.Int
	Raw  types.Log // Blockchain specific contextual infos
}

// FilterScheduleFeeChange is a free log retrieval operation binding the contract event 0xf339d7864b1b8839e8a8870c012fc6eb9a89844861a87a26ce35979018603a1b.
//
// Solidity: event ScheduleFeeChange(uint256 when)
func (_Redeemer *RedeemerFilterer) FilterScheduleFeeChange(opts *bind.FilterOpts) (*RedeemerScheduleFeeChangeIterator, error) {

	logs, sub, err := _Redeemer.contract.FilterLogs(opts, "ScheduleFeeChange")
	if err != nil {
		return nil, err
	}
	return &RedeemerScheduleFeeChangeIterator{contract: _Redeemer.contract, event: "ScheduleFeeChange", logs: logs, sub: sub}, nil
}

// WatchScheduleFeeChange is a free log subscription operation binding the contract event 0xf339d7864b1b8839e8a8870c012fc6eb9a89844861a87a26ce35979018603a1b.
//
// Solidity: event ScheduleFeeChange(uint256 when)
func (_Redeemer *RedeemerFilterer) WatchScheduleFeeChange(opts *bind.WatchOpts, sink chan<- *RedeemerScheduleFeeChange) (event.Subscription, error) {

	logs, sub, err := _Redeemer.contract.WatchLogs(opts, "ScheduleFeeChange")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(RedeemerScheduleFeeChange)
				if err := _Redeemer.contract.UnpackLog(event, "ScheduleFeeChange", log); err != nil {
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

// ParseScheduleFeeChange is a log parse operation binding the contract event 0xf339d7864b1b8839e8a8870c012fc6eb9a89844861a87a26ce35979018603a1b.
//
// Solidity: event ScheduleFeeChange(uint256 when)
func (_Redeemer *RedeemerFilterer) ParseScheduleFeeChange(log types.Log) (*RedeemerScheduleFeeChange, error) {
	event := new(RedeemerScheduleFeeChange)
	if err := _Redeemer.contract.UnpackLog(event, "ScheduleFeeChange", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// RedeemerSetAdminIterator is returned from FilterSetAdmin and is used to iterate over the raw logs and unpacked data for SetAdmin events raised by the Redeemer contract.
type RedeemerSetAdminIterator struct {
	Event *RedeemerSetAdmin // Event containing the contract specifics and raw log

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
func (it *RedeemerSetAdminIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(RedeemerSetAdmin)
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
		it.Event = new(RedeemerSetAdmin)
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
func (it *RedeemerSetAdminIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *RedeemerSetAdminIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// RedeemerSetAdmin represents a SetAdmin event raised by the Redeemer contract.
type RedeemerSetAdmin struct {
	Admin common.Address
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterSetAdmin is a free log retrieval operation binding the contract event 0x5a272403b402d892977df56625f4164ccaf70ca3863991c43ecfe76a6905b0a1.
//
// Solidity: event SetAdmin(address indexed admin)
func (_Redeemer *RedeemerFilterer) FilterSetAdmin(opts *bind.FilterOpts, admin []common.Address) (*RedeemerSetAdminIterator, error) {

	var adminRule []interface{}
	for _, adminItem := range admin {
		adminRule = append(adminRule, adminItem)
	}

	logs, sub, err := _Redeemer.contract.FilterLogs(opts, "SetAdmin", adminRule)
	if err != nil {
		return nil, err
	}
	return &RedeemerSetAdminIterator{contract: _Redeemer.contract, event: "SetAdmin", logs: logs, sub: sub}, nil
}

// WatchSetAdmin is a free log subscription operation binding the contract event 0x5a272403b402d892977df56625f4164ccaf70ca3863991c43ecfe76a6905b0a1.
//
// Solidity: event SetAdmin(address indexed admin)
func (_Redeemer *RedeemerFilterer) WatchSetAdmin(opts *bind.WatchOpts, sink chan<- *RedeemerSetAdmin, admin []common.Address) (event.Subscription, error) {

	var adminRule []interface{}
	for _, adminItem := range admin {
		adminRule = append(adminRule, adminItem)
	}

	logs, sub, err := _Redeemer.contract.WatchLogs(opts, "SetAdmin", adminRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(RedeemerSetAdmin)
				if err := _Redeemer.contract.UnpackLog(event, "SetAdmin", log); err != nil {
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
func (_Redeemer *RedeemerFilterer) ParseSetAdmin(log types.Log) (*RedeemerSetAdmin, error) {
	event := new(RedeemerSetAdmin)
	if err := _Redeemer.contract.UnpackLog(event, "SetAdmin", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// RedeemerSetConverterIterator is returned from FilterSetConverter and is used to iterate over the raw logs and unpacked data for SetConverter events raised by the Redeemer contract.
type RedeemerSetConverterIterator struct {
	Event *RedeemerSetConverter // Event containing the contract specifics and raw log

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
func (it *RedeemerSetConverterIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(RedeemerSetConverter)
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
		it.Event = new(RedeemerSetConverter)
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
func (it *RedeemerSetConverterIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *RedeemerSetConverterIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// RedeemerSetConverter represents a SetConverter event raised by the Redeemer contract.
type RedeemerSetConverter struct {
	Converter common.Address
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterSetConverter is a free log retrieval operation binding the contract event 0xc06343c9448e37c4ed257861469b4b35c140991c9cf08a4c38d335a1bc6a75d3.
//
// Solidity: event SetConverter(address indexed converter)
func (_Redeemer *RedeemerFilterer) FilterSetConverter(opts *bind.FilterOpts, converter []common.Address) (*RedeemerSetConverterIterator, error) {

	var converterRule []interface{}
	for _, converterItem := range converter {
		converterRule = append(converterRule, converterItem)
	}

	logs, sub, err := _Redeemer.contract.FilterLogs(opts, "SetConverter", converterRule)
	if err != nil {
		return nil, err
	}
	return &RedeemerSetConverterIterator{contract: _Redeemer.contract, event: "SetConverter", logs: logs, sub: sub}, nil
}

// WatchSetConverter is a free log subscription operation binding the contract event 0xc06343c9448e37c4ed257861469b4b35c140991c9cf08a4c38d335a1bc6a75d3.
//
// Solidity: event SetConverter(address indexed converter)
func (_Redeemer *RedeemerFilterer) WatchSetConverter(opts *bind.WatchOpts, sink chan<- *RedeemerSetConverter, converter []common.Address) (event.Subscription, error) {

	var converterRule []interface{}
	for _, converterItem := range converter {
		converterRule = append(converterRule, converterItem)
	}

	logs, sub, err := _Redeemer.contract.WatchLogs(opts, "SetConverter", converterRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(RedeemerSetConverter)
				if err := _Redeemer.contract.UnpackLog(event, "SetConverter", log); err != nil {
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

// ParseSetConverter is a log parse operation binding the contract event 0xc06343c9448e37c4ed257861469b4b35c140991c9cf08a4c38d335a1bc6a75d3.
//
// Solidity: event SetConverter(address indexed converter)
func (_Redeemer *RedeemerFilterer) ParseSetConverter(log types.Log) (*RedeemerSetConverter, error) {
	event := new(RedeemerSetConverter)
	if err := _Redeemer.contract.UnpackLog(event, "SetConverter", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// RedeemerSetFeeIterator is returned from FilterSetFee and is used to iterate over the raw logs and unpacked data for SetFee events raised by the Redeemer contract.
type RedeemerSetFeeIterator struct {
	Event *RedeemerSetFee // Event containing the contract specifics and raw log

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
func (it *RedeemerSetFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(RedeemerSetFee)
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
		it.Event = new(RedeemerSetFee)
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
func (it *RedeemerSetFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *RedeemerSetFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// RedeemerSetFee represents a SetFee event raised by the Redeemer contract.
type RedeemerSetFee struct {
	Fee *big.Int
	Raw types.Log // Blockchain specific contextual infos
}

// FilterSetFee is a free log retrieval operation binding the contract event 0x00172ddfc5ae88d08b3de01a5a187667c37a5a53989e8c175055cb6c993792a7.
//
// Solidity: event SetFee(uint256 indexed fee)
func (_Redeemer *RedeemerFilterer) FilterSetFee(opts *bind.FilterOpts, fee []*big.Int) (*RedeemerSetFeeIterator, error) {

	var feeRule []interface{}
	for _, feeItem := range fee {
		feeRule = append(feeRule, feeItem)
	}

	logs, sub, err := _Redeemer.contract.FilterLogs(opts, "SetFee", feeRule)
	if err != nil {
		return nil, err
	}
	return &RedeemerSetFeeIterator{contract: _Redeemer.contract, event: "SetFee", logs: logs, sub: sub}, nil
}

// WatchSetFee is a free log subscription operation binding the contract event 0x00172ddfc5ae88d08b3de01a5a187667c37a5a53989e8c175055cb6c993792a7.
//
// Solidity: event SetFee(uint256 indexed fee)
func (_Redeemer *RedeemerFilterer) WatchSetFee(opts *bind.WatchOpts, sink chan<- *RedeemerSetFee, fee []*big.Int) (event.Subscription, error) {

	var feeRule []interface{}
	for _, feeItem := range fee {
		feeRule = append(feeRule, feeItem)
	}

	logs, sub, err := _Redeemer.contract.WatchLogs(opts, "SetFee", feeRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(RedeemerSetFee)
				if err := _Redeemer.contract.UnpackLog(event, "SetFee", log); err != nil {
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

// ParseSetFee is a log parse operation binding the contract event 0x00172ddfc5ae88d08b3de01a5a187667c37a5a53989e8c175055cb6c993792a7.
//
// Solidity: event SetFee(uint256 indexed fee)
func (_Redeemer *RedeemerFilterer) ParseSetFee(log types.Log) (*RedeemerSetFee, error) {
	event := new(RedeemerSetFee)
	if err := _Redeemer.contract.UnpackLog(event, "SetFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
