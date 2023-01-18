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

// SwivelComponents is an auto generated low-level Go binding around an user-defined struct.
type SwivelComponents struct {
	V uint8
	R [32]byte
	S [32]byte
}

// SwivelOrder is an auto generated low-level Go binding around an user-defined struct.
type SwivelOrder struct {
	Key        [32]byte
	Protocol   uint8
	Maker      common.Address
	Underlying common.Address
	Vault      bool
	Exit       bool
	Principal  *big.Int
	Premium    *big.Int
	Maturity   *big.Int
	Expiry     *big.Int
}

// LenderMetaData contains all meta data concerning the Lender contract.
var LenderMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"s\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"p\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"Exception\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[],\"name\":\"BlockFeeChange\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"token\",\"type\":\"address\"}],\"name\":\"BlockWithdrawal\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint8\",\"name\":\"principal\",\"type\":\"uint8\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"returned\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"spent\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"sender\",\"type\":\"address\"}],\"name\":\"Lend\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint8\",\"name\":\"principal\",\"type\":\"uint8\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"Mint\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"bool\",\"name\":\"state\",\"type\":\"bool\"}],\"name\":\"PauseIlluminate\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint8\",\"name\":\"principal\",\"type\":\"uint8\"},{\"indexed\":true,\"internalType\":\"bool\",\"name\":\"state\",\"type\":\"bool\"}],\"name\":\"PausePrincipal\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"when\",\"type\":\"uint256\"}],\"name\":\"ScheduleFeeChange\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"token\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"hold\",\"type\":\"uint256\"}],\"name\":\"ScheduleWithdrawal\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"admin\",\"type\":\"address\"}],\"name\":\"SetAdmin\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"fee\",\"type\":\"uint256\"}],\"name\":\"SetFee\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"HOLD\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"MAX_VALUE\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"MIN_FEENOMINATOR\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"admin\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"r\",\"type\":\"address\"}],\"name\":\"approve\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"e\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"n\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"p\",\"type\":\"address\"}],\"name\":\"approve\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"u\",\"type\":\"address[]\"},{\"internalType\":\"address[]\",\"name\":\"a\",\"type\":\"address[]\"}],\"name\":\"approve\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"apwineAddr\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes[]\",\"name\":\"c\",\"type\":\"bytes[]\"}],\"name\":\"batch\",\"outputs\":[{\"internalType\":\"bytes[]\",\"name\":\"results\",\"type\":\"bytes[]\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"blockFeeChange\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"e\",\"type\":\"address\"}],\"name\":\"blockWithdrawal\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"etherPrice\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"feeChange\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"feenominator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"fees\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"halted\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"r\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"d\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"e\",\"type\":\"address\"},{\"internalType\":\"bytes32\",\"name\":\"i\",\"type\":\"bytes32\"}],\"name\":\"lend\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"r\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"d\",\"type\":\"uint256\"}],\"name\":\"lend\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256[]\",\"name\":\"a\",\"type\":\"uint256[]\"},{\"internalType\":\"address\",\"name\":\"y\",\"type\":\"address\"},{\"components\":[{\"internalType\":\"bytes32\",\"name\":\"key\",\"type\":\"bytes32\"},{\"internalType\":\"uint8\",\"name\":\"protocol\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"maker\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"underlying\",\"type\":\"address\"},{\"internalType\":\"bool\",\"name\":\"vault\",\"type\":\"bool\"},{\"internalType\":\"bool\",\"name\":\"exit\",\"type\":\"bool\"},{\"internalType\":\"uint256\",\"name\":\"principal\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"premium\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"maturity\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"expiry\",\"type\":\"uint256\"}],\"internalType\":\"structSwivel.Order[]\",\"name\":\"o\",\"type\":\"tuple[]\"},{\"components\":[{\"internalType\":\"uint8\",\"name\":\"v\",\"type\":\"uint8\"},{\"internalType\":\"bytes32\",\"name\":\"r\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"s\",\"type\":\"bytes32\"}],\"internalType\":\"structSwivel.Components[]\",\"name\":\"s\",\"type\":\"tuple[]\"},{\"internalType\":\"bool\",\"name\":\"e\",\"type\":\"bool\"},{\"internalType\":\"uint256\",\"name\":\"premiumSlippage\",\"type\":\"uint256\"}],\"name\":\"lend\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint128\",\"name\":\"a\",\"type\":\"uint128\"},{\"internalType\":\"uint256\",\"name\":\"r\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"x\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"s\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"adapter\",\"type\":\"address\"}],\"name\":\"lend\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"y\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"minimum\",\"type\":\"uint256\"}],\"name\":\"lend\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"r\",\"type\":\"uint256\"}],\"name\":\"lend\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"r\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"d\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"x\",\"type\":\"address\"}],\"name\":\"lend\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"marketPlace\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"p\",\"type\":\"uint8\"},{\"internalType\":\"bool\",\"name\":\"b\",\"type\":\"bool\"}],\"name\":\"pause\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bool\",\"name\":\"b\",\"type\":\"bool\"}],\"name\":\"pauseIlluminate\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"}],\"name\":\"paused\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"pendleAddr\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"}],\"name\":\"periodStart\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"premiums\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"}],\"name\":\"protocolFlow\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"scheduleFeeChange\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"e\",\"type\":\"address\"}],\"name\":\"scheduleWithdrawal\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"a\",\"type\":\"address\"}],\"name\":\"setAdmin\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"p\",\"type\":\"uint256\"}],\"name\":\"setEtherPrice\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"f\",\"type\":\"uint256\"}],\"name\":\"setFee\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"m\",\"type\":\"address\"}],\"name\":\"setMarketPlace\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"swivelAddr\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"f\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"a\",\"type\":\"uint256\"}],\"name\":\"transferFYTs\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"u\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"m\",\"type\":\"uint256\"}],\"name\":\"transferPremium\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"e\",\"type\":\"address\"}],\"name\":\"withdraw\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"e\",\"type\":\"address\"}],\"name\":\"withdrawFee\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"withdrawals\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]",
}

// LenderABI is the input ABI used to generate the binding from.
// Deprecated: Use LenderMetaData.ABI instead.
var LenderABI = LenderMetaData.ABI

// Lender is an auto generated Go binding around an Ethereum contract.
type Lender struct {
	LenderCaller     // Read-only binding to the contract
	LenderTransactor // Write-only binding to the contract
	LenderFilterer   // Log filterer for contract events
}

// LenderCaller is an auto generated read-only Go binding around an Ethereum contract.
type LenderCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// LenderTransactor is an auto generated write-only Go binding around an Ethereum contract.
type LenderTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// LenderFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type LenderFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// LenderSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type LenderSession struct {
	Contract     *Lender           // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// LenderCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type LenderCallerSession struct {
	Contract *LenderCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts // Call options to use throughout this session
}

// LenderTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type LenderTransactorSession struct {
	Contract     *LenderTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// LenderRaw is an auto generated low-level Go binding around an Ethereum contract.
type LenderRaw struct {
	Contract *Lender // Generic contract binding to access the raw methods on
}

// LenderCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type LenderCallerRaw struct {
	Contract *LenderCaller // Generic read-only contract binding to access the raw methods on
}

// LenderTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type LenderTransactorRaw struct {
	Contract *LenderTransactor // Generic write-only contract binding to access the raw methods on
}

// NewLender creates a new instance of Lender, bound to a specific deployed contract.
func NewLender(address common.Address, backend bind.ContractBackend) (*Lender, error) {
	contract, err := bindLender(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Lender{LenderCaller: LenderCaller{contract: contract}, LenderTransactor: LenderTransactor{contract: contract}, LenderFilterer: LenderFilterer{contract: contract}}, nil
}

// NewLenderCaller creates a new read-only instance of Lender, bound to a specific deployed contract.
func NewLenderCaller(address common.Address, caller bind.ContractCaller) (*LenderCaller, error) {
	contract, err := bindLender(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &LenderCaller{contract: contract}, nil
}

// NewLenderTransactor creates a new write-only instance of Lender, bound to a specific deployed contract.
func NewLenderTransactor(address common.Address, transactor bind.ContractTransactor) (*LenderTransactor, error) {
	contract, err := bindLender(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &LenderTransactor{contract: contract}, nil
}

// NewLenderFilterer creates a new log filterer instance of Lender, bound to a specific deployed contract.
func NewLenderFilterer(address common.Address, filterer bind.ContractFilterer) (*LenderFilterer, error) {
	contract, err := bindLender(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &LenderFilterer{contract: contract}, nil
}

// bindLender binds a generic wrapper to an already deployed contract.
func bindLender(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(LenderABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Lender *LenderRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Lender.Contract.LenderCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Lender *LenderRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Lender.Contract.LenderTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Lender *LenderRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Lender.Contract.LenderTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Lender *LenderCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Lender.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Lender *LenderTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Lender.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Lender *LenderTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Lender.Contract.contract.Transact(opts, method, params...)
}

// HOLD is a free data retrieval call binding the contract method 0xd0886f97.
//
// Solidity: function HOLD() view returns(uint256)
func (_Lender *LenderCaller) HOLD(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "HOLD")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// HOLD is a free data retrieval call binding the contract method 0xd0886f97.
//
// Solidity: function HOLD() view returns(uint256)
func (_Lender *LenderSession) HOLD() (*big.Int, error) {
	return _Lender.Contract.HOLD(&_Lender.CallOpts)
}

// HOLD is a free data retrieval call binding the contract method 0xd0886f97.
//
// Solidity: function HOLD() view returns(uint256)
func (_Lender *LenderCallerSession) HOLD() (*big.Int, error) {
	return _Lender.Contract.HOLD(&_Lender.CallOpts)
}

// MAXVALUE is a free data retrieval call binding the contract method 0x063bde24.
//
// Solidity: function MAX_VALUE() view returns(uint256)
func (_Lender *LenderCaller) MAXVALUE(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "MAX_VALUE")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MAXVALUE is a free data retrieval call binding the contract method 0x063bde24.
//
// Solidity: function MAX_VALUE() view returns(uint256)
func (_Lender *LenderSession) MAXVALUE() (*big.Int, error) {
	return _Lender.Contract.MAXVALUE(&_Lender.CallOpts)
}

// MAXVALUE is a free data retrieval call binding the contract method 0x063bde24.
//
// Solidity: function MAX_VALUE() view returns(uint256)
func (_Lender *LenderCallerSession) MAXVALUE() (*big.Int, error) {
	return _Lender.Contract.MAXVALUE(&_Lender.CallOpts)
}

// MINFEENOMINATOR is a free data retrieval call binding the contract method 0x0d3f5352.
//
// Solidity: function MIN_FEENOMINATOR() view returns(uint256)
func (_Lender *LenderCaller) MINFEENOMINATOR(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "MIN_FEENOMINATOR")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MINFEENOMINATOR is a free data retrieval call binding the contract method 0x0d3f5352.
//
// Solidity: function MIN_FEENOMINATOR() view returns(uint256)
func (_Lender *LenderSession) MINFEENOMINATOR() (*big.Int, error) {
	return _Lender.Contract.MINFEENOMINATOR(&_Lender.CallOpts)
}

// MINFEENOMINATOR is a free data retrieval call binding the contract method 0x0d3f5352.
//
// Solidity: function MIN_FEENOMINATOR() view returns(uint256)
func (_Lender *LenderCallerSession) MINFEENOMINATOR() (*big.Int, error) {
	return _Lender.Contract.MINFEENOMINATOR(&_Lender.CallOpts)
}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_Lender *LenderCaller) Admin(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "admin")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_Lender *LenderSession) Admin() (common.Address, error) {
	return _Lender.Contract.Admin(&_Lender.CallOpts)
}

// Admin is a free data retrieval call binding the contract method 0xf851a440.
//
// Solidity: function admin() view returns(address)
func (_Lender *LenderCallerSession) Admin() (common.Address, error) {
	return _Lender.Contract.Admin(&_Lender.CallOpts)
}

// ApwineAddr is a free data retrieval call binding the contract method 0x37a3eeec.
//
// Solidity: function apwineAddr() view returns(address)
func (_Lender *LenderCaller) ApwineAddr(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "apwineAddr")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// ApwineAddr is a free data retrieval call binding the contract method 0x37a3eeec.
//
// Solidity: function apwineAddr() view returns(address)
func (_Lender *LenderSession) ApwineAddr() (common.Address, error) {
	return _Lender.Contract.ApwineAddr(&_Lender.CallOpts)
}

// ApwineAddr is a free data retrieval call binding the contract method 0x37a3eeec.
//
// Solidity: function apwineAddr() view returns(address)
func (_Lender *LenderCallerSession) ApwineAddr() (common.Address, error) {
	return _Lender.Contract.ApwineAddr(&_Lender.CallOpts)
}

// EtherPrice is a free data retrieval call binding the contract method 0x9e307955.
//
// Solidity: function etherPrice() view returns(uint256)
func (_Lender *LenderCaller) EtherPrice(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "etherPrice")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EtherPrice is a free data retrieval call binding the contract method 0x9e307955.
//
// Solidity: function etherPrice() view returns(uint256)
func (_Lender *LenderSession) EtherPrice() (*big.Int, error) {
	return _Lender.Contract.EtherPrice(&_Lender.CallOpts)
}

// EtherPrice is a free data retrieval call binding the contract method 0x9e307955.
//
// Solidity: function etherPrice() view returns(uint256)
func (_Lender *LenderCallerSession) EtherPrice() (*big.Int, error) {
	return _Lender.Contract.EtherPrice(&_Lender.CallOpts)
}

// FeeChange is a free data retrieval call binding the contract method 0x35197f9e.
//
// Solidity: function feeChange() view returns(uint256)
func (_Lender *LenderCaller) FeeChange(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "feeChange")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// FeeChange is a free data retrieval call binding the contract method 0x35197f9e.
//
// Solidity: function feeChange() view returns(uint256)
func (_Lender *LenderSession) FeeChange() (*big.Int, error) {
	return _Lender.Contract.FeeChange(&_Lender.CallOpts)
}

// FeeChange is a free data retrieval call binding the contract method 0x35197f9e.
//
// Solidity: function feeChange() view returns(uint256)
func (_Lender *LenderCallerSession) FeeChange() (*big.Int, error) {
	return _Lender.Contract.FeeChange(&_Lender.CallOpts)
}

// Feenominator is a free data retrieval call binding the contract method 0x9e6b5173.
//
// Solidity: function feenominator() view returns(uint256)
func (_Lender *LenderCaller) Feenominator(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "feenominator")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Feenominator is a free data retrieval call binding the contract method 0x9e6b5173.
//
// Solidity: function feenominator() view returns(uint256)
func (_Lender *LenderSession) Feenominator() (*big.Int, error) {
	return _Lender.Contract.Feenominator(&_Lender.CallOpts)
}

// Feenominator is a free data retrieval call binding the contract method 0x9e6b5173.
//
// Solidity: function feenominator() view returns(uint256)
func (_Lender *LenderCallerSession) Feenominator() (*big.Int, error) {
	return _Lender.Contract.Feenominator(&_Lender.CallOpts)
}

// Fees is a free data retrieval call binding the contract method 0xfaaebd21.
//
// Solidity: function fees(address ) view returns(uint256)
func (_Lender *LenderCaller) Fees(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "fees", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Fees is a free data retrieval call binding the contract method 0xfaaebd21.
//
// Solidity: function fees(address ) view returns(uint256)
func (_Lender *LenderSession) Fees(arg0 common.Address) (*big.Int, error) {
	return _Lender.Contract.Fees(&_Lender.CallOpts, arg0)
}

// Fees is a free data retrieval call binding the contract method 0xfaaebd21.
//
// Solidity: function fees(address ) view returns(uint256)
func (_Lender *LenderCallerSession) Fees(arg0 common.Address) (*big.Int, error) {
	return _Lender.Contract.Fees(&_Lender.CallOpts, arg0)
}

// Halted is a free data retrieval call binding the contract method 0xb9b8af0b.
//
// Solidity: function halted() view returns(bool)
func (_Lender *LenderCaller) Halted(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "halted")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// Halted is a free data retrieval call binding the contract method 0xb9b8af0b.
//
// Solidity: function halted() view returns(bool)
func (_Lender *LenderSession) Halted() (bool, error) {
	return _Lender.Contract.Halted(&_Lender.CallOpts)
}

// Halted is a free data retrieval call binding the contract method 0xb9b8af0b.
//
// Solidity: function halted() view returns(bool)
func (_Lender *LenderCallerSession) Halted() (bool, error) {
	return _Lender.Contract.Halted(&_Lender.CallOpts)
}

// MarketPlace is a free data retrieval call binding the contract method 0x2e25d2a6.
//
// Solidity: function marketPlace() view returns(address)
func (_Lender *LenderCaller) MarketPlace(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "marketPlace")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// MarketPlace is a free data retrieval call binding the contract method 0x2e25d2a6.
//
// Solidity: function marketPlace() view returns(address)
func (_Lender *LenderSession) MarketPlace() (common.Address, error) {
	return _Lender.Contract.MarketPlace(&_Lender.CallOpts)
}

// MarketPlace is a free data retrieval call binding the contract method 0x2e25d2a6.
//
// Solidity: function marketPlace() view returns(address)
func (_Lender *LenderCallerSession) MarketPlace() (common.Address, error) {
	return _Lender.Contract.MarketPlace(&_Lender.CallOpts)
}

// Paused is a free data retrieval call binding the contract method 0x5ac86ab7.
//
// Solidity: function paused(uint8 ) view returns(bool)
func (_Lender *LenderCaller) Paused(opts *bind.CallOpts, arg0 uint8) (bool, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "paused", arg0)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// Paused is a free data retrieval call binding the contract method 0x5ac86ab7.
//
// Solidity: function paused(uint8 ) view returns(bool)
func (_Lender *LenderSession) Paused(arg0 uint8) (bool, error) {
	return _Lender.Contract.Paused(&_Lender.CallOpts, arg0)
}

// Paused is a free data retrieval call binding the contract method 0x5ac86ab7.
//
// Solidity: function paused(uint8 ) view returns(bool)
func (_Lender *LenderCallerSession) Paused(arg0 uint8) (bool, error) {
	return _Lender.Contract.Paused(&_Lender.CallOpts, arg0)
}

// PendleAddr is a free data retrieval call binding the contract method 0xef603569.
//
// Solidity: function pendleAddr() view returns(address)
func (_Lender *LenderCaller) PendleAddr(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "pendleAddr")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// PendleAddr is a free data retrieval call binding the contract method 0xef603569.
//
// Solidity: function pendleAddr() view returns(address)
func (_Lender *LenderSession) PendleAddr() (common.Address, error) {
	return _Lender.Contract.PendleAddr(&_Lender.CallOpts)
}

// PendleAddr is a free data retrieval call binding the contract method 0xef603569.
//
// Solidity: function pendleAddr() view returns(address)
func (_Lender *LenderCallerSession) PendleAddr() (common.Address, error) {
	return _Lender.Contract.PendleAddr(&_Lender.CallOpts)
}

// PeriodStart is a free data retrieval call binding the contract method 0x62a4520e.
//
// Solidity: function periodStart(uint8 ) view returns(uint256)
func (_Lender *LenderCaller) PeriodStart(opts *bind.CallOpts, arg0 uint8) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "periodStart", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PeriodStart is a free data retrieval call binding the contract method 0x62a4520e.
//
// Solidity: function periodStart(uint8 ) view returns(uint256)
func (_Lender *LenderSession) PeriodStart(arg0 uint8) (*big.Int, error) {
	return _Lender.Contract.PeriodStart(&_Lender.CallOpts, arg0)
}

// PeriodStart is a free data retrieval call binding the contract method 0x62a4520e.
//
// Solidity: function periodStart(uint8 ) view returns(uint256)
func (_Lender *LenderCallerSession) PeriodStart(arg0 uint8) (*big.Int, error) {
	return _Lender.Contract.PeriodStart(&_Lender.CallOpts, arg0)
}

// Premiums is a free data retrieval call binding the contract method 0x0cdc7ec6.
//
// Solidity: function premiums(address , uint256 ) view returns(uint256)
func (_Lender *LenderCaller) Premiums(opts *bind.CallOpts, arg0 common.Address, arg1 *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "premiums", arg0, arg1)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Premiums is a free data retrieval call binding the contract method 0x0cdc7ec6.
//
// Solidity: function premiums(address , uint256 ) view returns(uint256)
func (_Lender *LenderSession) Premiums(arg0 common.Address, arg1 *big.Int) (*big.Int, error) {
	return _Lender.Contract.Premiums(&_Lender.CallOpts, arg0, arg1)
}

// Premiums is a free data retrieval call binding the contract method 0x0cdc7ec6.
//
// Solidity: function premiums(address , uint256 ) view returns(uint256)
func (_Lender *LenderCallerSession) Premiums(arg0 common.Address, arg1 *big.Int) (*big.Int, error) {
	return _Lender.Contract.Premiums(&_Lender.CallOpts, arg0, arg1)
}

// ProtocolFlow is a free data retrieval call binding the contract method 0xadea3844.
//
// Solidity: function protocolFlow(uint8 ) view returns(uint256)
func (_Lender *LenderCaller) ProtocolFlow(opts *bind.CallOpts, arg0 uint8) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "protocolFlow", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ProtocolFlow is a free data retrieval call binding the contract method 0xadea3844.
//
// Solidity: function protocolFlow(uint8 ) view returns(uint256)
func (_Lender *LenderSession) ProtocolFlow(arg0 uint8) (*big.Int, error) {
	return _Lender.Contract.ProtocolFlow(&_Lender.CallOpts, arg0)
}

// ProtocolFlow is a free data retrieval call binding the contract method 0xadea3844.
//
// Solidity: function protocolFlow(uint8 ) view returns(uint256)
func (_Lender *LenderCallerSession) ProtocolFlow(arg0 uint8) (*big.Int, error) {
	return _Lender.Contract.ProtocolFlow(&_Lender.CallOpts, arg0)
}

// SwivelAddr is a free data retrieval call binding the contract method 0xea08c031.
//
// Solidity: function swivelAddr() view returns(address)
func (_Lender *LenderCaller) SwivelAddr(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "swivelAddr")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// SwivelAddr is a free data retrieval call binding the contract method 0xea08c031.
//
// Solidity: function swivelAddr() view returns(address)
func (_Lender *LenderSession) SwivelAddr() (common.Address, error) {
	return _Lender.Contract.SwivelAddr(&_Lender.CallOpts)
}

// SwivelAddr is a free data retrieval call binding the contract method 0xea08c031.
//
// Solidity: function swivelAddr() view returns(address)
func (_Lender *LenderCallerSession) SwivelAddr() (common.Address, error) {
	return _Lender.Contract.SwivelAddr(&_Lender.CallOpts)
}

// Withdrawals is a free data retrieval call binding the contract method 0x7a9262a2.
//
// Solidity: function withdrawals(address ) view returns(uint256)
func (_Lender *LenderCaller) Withdrawals(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Lender.contract.Call(opts, &out, "withdrawals", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Withdrawals is a free data retrieval call binding the contract method 0x7a9262a2.
//
// Solidity: function withdrawals(address ) view returns(uint256)
func (_Lender *LenderSession) Withdrawals(arg0 common.Address) (*big.Int, error) {
	return _Lender.Contract.Withdrawals(&_Lender.CallOpts, arg0)
}

// Withdrawals is a free data retrieval call binding the contract method 0x7a9262a2.
//
// Solidity: function withdrawals(address ) view returns(uint256)
func (_Lender *LenderCallerSession) Withdrawals(arg0 common.Address) (*big.Int, error) {
	return _Lender.Contract.Withdrawals(&_Lender.CallOpts, arg0)
}

// Approve is a paid mutator transaction binding the contract method 0x1271f09a.
//
// Solidity: function approve(address u, uint256 m, address r) returns(bool)
func (_Lender *LenderTransactor) Approve(opts *bind.TransactOpts, u common.Address, m *big.Int, r common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "approve", u, m, r)
}

// Approve is a paid mutator transaction binding the contract method 0x1271f09a.
//
// Solidity: function approve(address u, uint256 m, address r) returns(bool)
func (_Lender *LenderSession) Approve(u common.Address, m *big.Int, r common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Approve(&_Lender.TransactOpts, u, m, r)
}

// Approve is a paid mutator transaction binding the contract method 0x1271f09a.
//
// Solidity: function approve(address u, uint256 m, address r) returns(bool)
func (_Lender *LenderTransactorSession) Approve(u common.Address, m *big.Int, r common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Approve(&_Lender.TransactOpts, u, m, r)
}

// Approve0 is a paid mutator transaction binding the contract method 0x355d63f1.
//
// Solidity: function approve(address u, address a, address e, address n, address p) returns()
func (_Lender *LenderTransactor) Approve0(opts *bind.TransactOpts, u common.Address, a common.Address, e common.Address, n common.Address, p common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "approve0", u, a, e, n, p)
}

// Approve0 is a paid mutator transaction binding the contract method 0x355d63f1.
//
// Solidity: function approve(address u, address a, address e, address n, address p) returns()
func (_Lender *LenderSession) Approve0(u common.Address, a common.Address, e common.Address, n common.Address, p common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Approve0(&_Lender.TransactOpts, u, a, e, n, p)
}

// Approve0 is a paid mutator transaction binding the contract method 0x355d63f1.
//
// Solidity: function approve(address u, address a, address e, address n, address p) returns()
func (_Lender *LenderTransactorSession) Approve0(u common.Address, a common.Address, e common.Address, n common.Address, p common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Approve0(&_Lender.TransactOpts, u, a, e, n, p)
}

// Approve1 is a paid mutator transaction binding the contract method 0x65dff1e1.
//
// Solidity: function approve(address[] u, address[] a) returns(bool)
func (_Lender *LenderTransactor) Approve1(opts *bind.TransactOpts, u []common.Address, a []common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "approve1", u, a)
}

// Approve1 is a paid mutator transaction binding the contract method 0x65dff1e1.
//
// Solidity: function approve(address[] u, address[] a) returns(bool)
func (_Lender *LenderSession) Approve1(u []common.Address, a []common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Approve1(&_Lender.TransactOpts, u, a)
}

// Approve1 is a paid mutator transaction binding the contract method 0x65dff1e1.
//
// Solidity: function approve(address[] u, address[] a) returns(bool)
func (_Lender *LenderTransactorSession) Approve1(u []common.Address, a []common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Approve1(&_Lender.TransactOpts, u, a)
}

// Batch is a paid mutator transaction binding the contract method 0x1e897afb.
//
// Solidity: function batch(bytes[] c) payable returns(bytes[] results)
func (_Lender *LenderTransactor) Batch(opts *bind.TransactOpts, c [][]byte) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "batch", c)
}

// Batch is a paid mutator transaction binding the contract method 0x1e897afb.
//
// Solidity: function batch(bytes[] c) payable returns(bytes[] results)
func (_Lender *LenderSession) Batch(c [][]byte) (*types.Transaction, error) {
	return _Lender.Contract.Batch(&_Lender.TransactOpts, c)
}

// Batch is a paid mutator transaction binding the contract method 0x1e897afb.
//
// Solidity: function batch(bytes[] c) payable returns(bytes[] results)
func (_Lender *LenderTransactorSession) Batch(c [][]byte) (*types.Transaction, error) {
	return _Lender.Contract.Batch(&_Lender.TransactOpts, c)
}

// BlockFeeChange is a paid mutator transaction binding the contract method 0xf9ad473d.
//
// Solidity: function blockFeeChange() returns(bool)
func (_Lender *LenderTransactor) BlockFeeChange(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "blockFeeChange")
}

// BlockFeeChange is a paid mutator transaction binding the contract method 0xf9ad473d.
//
// Solidity: function blockFeeChange() returns(bool)
func (_Lender *LenderSession) BlockFeeChange() (*types.Transaction, error) {
	return _Lender.Contract.BlockFeeChange(&_Lender.TransactOpts)
}

// BlockFeeChange is a paid mutator transaction binding the contract method 0xf9ad473d.
//
// Solidity: function blockFeeChange() returns(bool)
func (_Lender *LenderTransactorSession) BlockFeeChange() (*types.Transaction, error) {
	return _Lender.Contract.BlockFeeChange(&_Lender.TransactOpts)
}

// BlockWithdrawal is a paid mutator transaction binding the contract method 0xa102e384.
//
// Solidity: function blockWithdrawal(address e) returns(bool)
func (_Lender *LenderTransactor) BlockWithdrawal(opts *bind.TransactOpts, e common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "blockWithdrawal", e)
}

// BlockWithdrawal is a paid mutator transaction binding the contract method 0xa102e384.
//
// Solidity: function blockWithdrawal(address e) returns(bool)
func (_Lender *LenderSession) BlockWithdrawal(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.BlockWithdrawal(&_Lender.TransactOpts, e)
}

// BlockWithdrawal is a paid mutator transaction binding the contract method 0xa102e384.
//
// Solidity: function blockWithdrawal(address e) returns(bool)
func (_Lender *LenderTransactorSession) BlockWithdrawal(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.BlockWithdrawal(&_Lender.TransactOpts, e)
}

// Lend is a paid mutator transaction binding the contract method 0x03799f87.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address e, bytes32 i) returns(uint256)
func (_Lender *LenderTransactor) Lend(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int, e common.Address, i [32]byte) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "lend", p, u, m, a, r, d, e, i)
}

// Lend is a paid mutator transaction binding the contract method 0x03799f87.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address e, bytes32 i) returns(uint256)
func (_Lender *LenderSession) Lend(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int, e common.Address, i [32]byte) (*types.Transaction, error) {
	return _Lender.Contract.Lend(&_Lender.TransactOpts, p, u, m, a, r, d, e, i)
}

// Lend is a paid mutator transaction binding the contract method 0x03799f87.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address e, bytes32 i) returns(uint256)
func (_Lender *LenderTransactorSession) Lend(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int, e common.Address, i [32]byte) (*types.Transaction, error) {
	return _Lender.Contract.Lend(&_Lender.TransactOpts, p, u, m, a, r, d, e, i)
}

// Lend0 is a paid mutator transaction binding the contract method 0x4135c9d1.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d) returns(uint256)
func (_Lender *LenderTransactor) Lend0(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "lend0", p, u, m, a, r, d)
}

// Lend0 is a paid mutator transaction binding the contract method 0x4135c9d1.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d) returns(uint256)
func (_Lender *LenderSession) Lend0(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend0(&_Lender.TransactOpts, p, u, m, a, r, d)
}

// Lend0 is a paid mutator transaction binding the contract method 0x4135c9d1.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d) returns(uint256)
func (_Lender *LenderTransactorSession) Lend0(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend0(&_Lender.TransactOpts, p, u, m, a, r, d)
}

// Lend1 is a paid mutator transaction binding the contract method 0x7114d92c.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256[] a, address y, (bytes32,uint8,address,address,bool,bool,uint256,uint256,uint256,uint256)[] o, (uint8,bytes32,bytes32)[] s, bool e, uint256 premiumSlippage) returns(uint256)
func (_Lender *LenderTransactor) Lend1(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a []*big.Int, y common.Address, o []SwivelOrder, s []SwivelComponents, e bool, premiumSlippage *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "lend1", p, u, m, a, y, o, s, e, premiumSlippage)
}

// Lend1 is a paid mutator transaction binding the contract method 0x7114d92c.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256[] a, address y, (bytes32,uint8,address,address,bool,bool,uint256,uint256,uint256,uint256)[] o, (uint8,bytes32,bytes32)[] s, bool e, uint256 premiumSlippage) returns(uint256)
func (_Lender *LenderSession) Lend1(p uint8, u common.Address, m *big.Int, a []*big.Int, y common.Address, o []SwivelOrder, s []SwivelComponents, e bool, premiumSlippage *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend1(&_Lender.TransactOpts, p, u, m, a, y, o, s, e, premiumSlippage)
}

// Lend1 is a paid mutator transaction binding the contract method 0x7114d92c.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256[] a, address y, (bytes32,uint8,address,address,bool,bool,uint256,uint256,uint256,uint256)[] o, (uint8,bytes32,bytes32)[] s, bool e, uint256 premiumSlippage) returns(uint256)
func (_Lender *LenderTransactorSession) Lend1(p uint8, u common.Address, m *big.Int, a []*big.Int, y common.Address, o []SwivelOrder, s []SwivelComponents, e bool, premiumSlippage *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend1(&_Lender.TransactOpts, p, u, m, a, y, o, s, e, premiumSlippage)
}

// Lend2 is a paid mutator transaction binding the contract method 0x884e21d6.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint128 a, uint256 r, address x, uint256 s, address adapter) returns(uint256)
func (_Lender *LenderTransactor) Lend2(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, x common.Address, s *big.Int, adapter common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "lend2", p, u, m, a, r, x, s, adapter)
}

// Lend2 is a paid mutator transaction binding the contract method 0x884e21d6.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint128 a, uint256 r, address x, uint256 s, address adapter) returns(uint256)
func (_Lender *LenderSession) Lend2(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, x common.Address, s *big.Int, adapter common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Lend2(&_Lender.TransactOpts, p, u, m, a, r, x, s, adapter)
}

// Lend2 is a paid mutator transaction binding the contract method 0x884e21d6.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint128 a, uint256 r, address x, uint256 s, address adapter) returns(uint256)
func (_Lender *LenderTransactorSession) Lend2(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, x common.Address, s *big.Int, adapter common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Lend2(&_Lender.TransactOpts, p, u, m, a, r, x, s, adapter)
}

// Lend3 is a paid mutator transaction binding the contract method 0xb49e0d72.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, address y, uint256 minimum) returns(uint256)
func (_Lender *LenderTransactor) Lend3(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a *big.Int, y common.Address, minimum *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "lend3", p, u, m, a, y, minimum)
}

// Lend3 is a paid mutator transaction binding the contract method 0xb49e0d72.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, address y, uint256 minimum) returns(uint256)
func (_Lender *LenderSession) Lend3(p uint8, u common.Address, m *big.Int, a *big.Int, y common.Address, minimum *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend3(&_Lender.TransactOpts, p, u, m, a, y, minimum)
}

// Lend3 is a paid mutator transaction binding the contract method 0xb49e0d72.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, address y, uint256 minimum) returns(uint256)
func (_Lender *LenderTransactorSession) Lend3(p uint8, u common.Address, m *big.Int, a *big.Int, y common.Address, minimum *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend3(&_Lender.TransactOpts, p, u, m, a, y, minimum)
}

// Lend4 is a paid mutator transaction binding the contract method 0xc244e1ff.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r) returns(uint256)
func (_Lender *LenderTransactor) Lend4(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "lend4", p, u, m, a, r)
}

// Lend4 is a paid mutator transaction binding the contract method 0xc244e1ff.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r) returns(uint256)
func (_Lender *LenderSession) Lend4(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend4(&_Lender.TransactOpts, p, u, m, a, r)
}

// Lend4 is a paid mutator transaction binding the contract method 0xc244e1ff.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r) returns(uint256)
func (_Lender *LenderTransactorSession) Lend4(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Lend4(&_Lender.TransactOpts, p, u, m, a, r)
}

// Lend5 is a paid mutator transaction binding the contract method 0xeda8ff6b.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address x) returns(uint256)
func (_Lender *LenderTransactor) Lend5(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int, x common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "lend5", p, u, m, a, r, d, x)
}

// Lend5 is a paid mutator transaction binding the contract method 0xeda8ff6b.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address x) returns(uint256)
func (_Lender *LenderSession) Lend5(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int, x common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Lend5(&_Lender.TransactOpts, p, u, m, a, r, d, x)
}

// Lend5 is a paid mutator transaction binding the contract method 0xeda8ff6b.
//
// Solidity: function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address x) returns(uint256)
func (_Lender *LenderTransactorSession) Lend5(p uint8, u common.Address, m *big.Int, a *big.Int, r *big.Int, d *big.Int, x common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Lend5(&_Lender.TransactOpts, p, u, m, a, r, d, x)
}

// Mint is a paid mutator transaction binding the contract method 0xdc4c7ca9.
//
// Solidity: function mint(uint8 p, address u, uint256 m, uint256 a) returns(bool)
func (_Lender *LenderTransactor) Mint(opts *bind.TransactOpts, p uint8, u common.Address, m *big.Int, a *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "mint", p, u, m, a)
}

// Mint is a paid mutator transaction binding the contract method 0xdc4c7ca9.
//
// Solidity: function mint(uint8 p, address u, uint256 m, uint256 a) returns(bool)
func (_Lender *LenderSession) Mint(p uint8, u common.Address, m *big.Int, a *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Mint(&_Lender.TransactOpts, p, u, m, a)
}

// Mint is a paid mutator transaction binding the contract method 0xdc4c7ca9.
//
// Solidity: function mint(uint8 p, address u, uint256 m, uint256 a) returns(bool)
func (_Lender *LenderTransactorSession) Mint(p uint8, u common.Address, m *big.Int, a *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.Mint(&_Lender.TransactOpts, p, u, m, a)
}

// Pause is a paid mutator transaction binding the contract method 0xfe3ee169.
//
// Solidity: function pause(uint8 p, bool b) returns(bool)
func (_Lender *LenderTransactor) Pause(opts *bind.TransactOpts, p uint8, b bool) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "pause", p, b)
}

// Pause is a paid mutator transaction binding the contract method 0xfe3ee169.
//
// Solidity: function pause(uint8 p, bool b) returns(bool)
func (_Lender *LenderSession) Pause(p uint8, b bool) (*types.Transaction, error) {
	return _Lender.Contract.Pause(&_Lender.TransactOpts, p, b)
}

// Pause is a paid mutator transaction binding the contract method 0xfe3ee169.
//
// Solidity: function pause(uint8 p, bool b) returns(bool)
func (_Lender *LenderTransactorSession) Pause(p uint8, b bool) (*types.Transaction, error) {
	return _Lender.Contract.Pause(&_Lender.TransactOpts, p, b)
}

// PauseIlluminate is a paid mutator transaction binding the contract method 0x3faf30ad.
//
// Solidity: function pauseIlluminate(bool b) returns(bool)
func (_Lender *LenderTransactor) PauseIlluminate(opts *bind.TransactOpts, b bool) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "pauseIlluminate", b)
}

// PauseIlluminate is a paid mutator transaction binding the contract method 0x3faf30ad.
//
// Solidity: function pauseIlluminate(bool b) returns(bool)
func (_Lender *LenderSession) PauseIlluminate(b bool) (*types.Transaction, error) {
	return _Lender.Contract.PauseIlluminate(&_Lender.TransactOpts, b)
}

// PauseIlluminate is a paid mutator transaction binding the contract method 0x3faf30ad.
//
// Solidity: function pauseIlluminate(bool b) returns(bool)
func (_Lender *LenderTransactorSession) PauseIlluminate(b bool) (*types.Transaction, error) {
	return _Lender.Contract.PauseIlluminate(&_Lender.TransactOpts, b)
}

// ScheduleFeeChange is a paid mutator transaction binding the contract method 0x1177ec30.
//
// Solidity: function scheduleFeeChange() returns(bool)
func (_Lender *LenderTransactor) ScheduleFeeChange(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "scheduleFeeChange")
}

// ScheduleFeeChange is a paid mutator transaction binding the contract method 0x1177ec30.
//
// Solidity: function scheduleFeeChange() returns(bool)
func (_Lender *LenderSession) ScheduleFeeChange() (*types.Transaction, error) {
	return _Lender.Contract.ScheduleFeeChange(&_Lender.TransactOpts)
}

// ScheduleFeeChange is a paid mutator transaction binding the contract method 0x1177ec30.
//
// Solidity: function scheduleFeeChange() returns(bool)
func (_Lender *LenderTransactorSession) ScheduleFeeChange() (*types.Transaction, error) {
	return _Lender.Contract.ScheduleFeeChange(&_Lender.TransactOpts)
}

// ScheduleWithdrawal is a paid mutator transaction binding the contract method 0xf8eaad35.
//
// Solidity: function scheduleWithdrawal(address e) returns(bool)
func (_Lender *LenderTransactor) ScheduleWithdrawal(opts *bind.TransactOpts, e common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "scheduleWithdrawal", e)
}

// ScheduleWithdrawal is a paid mutator transaction binding the contract method 0xf8eaad35.
//
// Solidity: function scheduleWithdrawal(address e) returns(bool)
func (_Lender *LenderSession) ScheduleWithdrawal(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.ScheduleWithdrawal(&_Lender.TransactOpts, e)
}

// ScheduleWithdrawal is a paid mutator transaction binding the contract method 0xf8eaad35.
//
// Solidity: function scheduleWithdrawal(address e) returns(bool)
func (_Lender *LenderTransactorSession) ScheduleWithdrawal(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.ScheduleWithdrawal(&_Lender.TransactOpts, e)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_Lender *LenderTransactor) SetAdmin(opts *bind.TransactOpts, a common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "setAdmin", a)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_Lender *LenderSession) SetAdmin(a common.Address) (*types.Transaction, error) {
	return _Lender.Contract.SetAdmin(&_Lender.TransactOpts, a)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address a) returns(bool)
func (_Lender *LenderTransactorSession) SetAdmin(a common.Address) (*types.Transaction, error) {
	return _Lender.Contract.SetAdmin(&_Lender.TransactOpts, a)
}

// SetEtherPrice is a paid mutator transaction binding the contract method 0x27187991.
//
// Solidity: function setEtherPrice(uint256 p) returns(bool)
func (_Lender *LenderTransactor) SetEtherPrice(opts *bind.TransactOpts, p *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "setEtherPrice", p)
}

// SetEtherPrice is a paid mutator transaction binding the contract method 0x27187991.
//
// Solidity: function setEtherPrice(uint256 p) returns(bool)
func (_Lender *LenderSession) SetEtherPrice(p *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.SetEtherPrice(&_Lender.TransactOpts, p)
}

// SetEtherPrice is a paid mutator transaction binding the contract method 0x27187991.
//
// Solidity: function setEtherPrice(uint256 p) returns(bool)
func (_Lender *LenderTransactorSession) SetEtherPrice(p *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.SetEtherPrice(&_Lender.TransactOpts, p)
}

// SetFee is a paid mutator transaction binding the contract method 0x69fe0e2d.
//
// Solidity: function setFee(uint256 f) returns(bool)
func (_Lender *LenderTransactor) SetFee(opts *bind.TransactOpts, f *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "setFee", f)
}

// SetFee is a paid mutator transaction binding the contract method 0x69fe0e2d.
//
// Solidity: function setFee(uint256 f) returns(bool)
func (_Lender *LenderSession) SetFee(f *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.SetFee(&_Lender.TransactOpts, f)
}

// SetFee is a paid mutator transaction binding the contract method 0x69fe0e2d.
//
// Solidity: function setFee(uint256 f) returns(bool)
func (_Lender *LenderTransactorSession) SetFee(f *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.SetFee(&_Lender.TransactOpts, f)
}

// SetMarketPlace is a paid mutator transaction binding the contract method 0x30568a8d.
//
// Solidity: function setMarketPlace(address m) returns(bool)
func (_Lender *LenderTransactor) SetMarketPlace(opts *bind.TransactOpts, m common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "setMarketPlace", m)
}

// SetMarketPlace is a paid mutator transaction binding the contract method 0x30568a8d.
//
// Solidity: function setMarketPlace(address m) returns(bool)
func (_Lender *LenderSession) SetMarketPlace(m common.Address) (*types.Transaction, error) {
	return _Lender.Contract.SetMarketPlace(&_Lender.TransactOpts, m)
}

// SetMarketPlace is a paid mutator transaction binding the contract method 0x30568a8d.
//
// Solidity: function setMarketPlace(address m) returns(bool)
func (_Lender *LenderTransactorSession) SetMarketPlace(m common.Address) (*types.Transaction, error) {
	return _Lender.Contract.SetMarketPlace(&_Lender.TransactOpts, m)
}

// TransferFYTs is a paid mutator transaction binding the contract method 0x75a9b172.
//
// Solidity: function transferFYTs(address f, uint256 a) returns()
func (_Lender *LenderTransactor) TransferFYTs(opts *bind.TransactOpts, f common.Address, a *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "transferFYTs", f, a)
}

// TransferFYTs is a paid mutator transaction binding the contract method 0x75a9b172.
//
// Solidity: function transferFYTs(address f, uint256 a) returns()
func (_Lender *LenderSession) TransferFYTs(f common.Address, a *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.TransferFYTs(&_Lender.TransactOpts, f, a)
}

// TransferFYTs is a paid mutator transaction binding the contract method 0x75a9b172.
//
// Solidity: function transferFYTs(address f, uint256 a) returns()
func (_Lender *LenderTransactorSession) TransferFYTs(f common.Address, a *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.TransferFYTs(&_Lender.TransactOpts, f, a)
}

// TransferPremium is a paid mutator transaction binding the contract method 0x6b42450d.
//
// Solidity: function transferPremium(address u, uint256 m) returns()
func (_Lender *LenderTransactor) TransferPremium(opts *bind.TransactOpts, u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "transferPremium", u, m)
}

// TransferPremium is a paid mutator transaction binding the contract method 0x6b42450d.
//
// Solidity: function transferPremium(address u, uint256 m) returns()
func (_Lender *LenderSession) TransferPremium(u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.TransferPremium(&_Lender.TransactOpts, u, m)
}

// TransferPremium is a paid mutator transaction binding the contract method 0x6b42450d.
//
// Solidity: function transferPremium(address u, uint256 m) returns()
func (_Lender *LenderTransactorSession) TransferPremium(u common.Address, m *big.Int) (*types.Transaction, error) {
	return _Lender.Contract.TransferPremium(&_Lender.TransactOpts, u, m)
}

// Withdraw is a paid mutator transaction binding the contract method 0x51cff8d9.
//
// Solidity: function withdraw(address e) returns(bool)
func (_Lender *LenderTransactor) Withdraw(opts *bind.TransactOpts, e common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "withdraw", e)
}

// Withdraw is a paid mutator transaction binding the contract method 0x51cff8d9.
//
// Solidity: function withdraw(address e) returns(bool)
func (_Lender *LenderSession) Withdraw(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Withdraw(&_Lender.TransactOpts, e)
}

// Withdraw is a paid mutator transaction binding the contract method 0x51cff8d9.
//
// Solidity: function withdraw(address e) returns(bool)
func (_Lender *LenderTransactorSession) Withdraw(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.Withdraw(&_Lender.TransactOpts, e)
}

// WithdrawFee is a paid mutator transaction binding the contract method 0x1ac3ddeb.
//
// Solidity: function withdrawFee(address e) returns(bool)
func (_Lender *LenderTransactor) WithdrawFee(opts *bind.TransactOpts, e common.Address) (*types.Transaction, error) {
	return _Lender.contract.Transact(opts, "withdrawFee", e)
}

// WithdrawFee is a paid mutator transaction binding the contract method 0x1ac3ddeb.
//
// Solidity: function withdrawFee(address e) returns(bool)
func (_Lender *LenderSession) WithdrawFee(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.WithdrawFee(&_Lender.TransactOpts, e)
}

// WithdrawFee is a paid mutator transaction binding the contract method 0x1ac3ddeb.
//
// Solidity: function withdrawFee(address e) returns(bool)
func (_Lender *LenderTransactorSession) WithdrawFee(e common.Address) (*types.Transaction, error) {
	return _Lender.Contract.WithdrawFee(&_Lender.TransactOpts, e)
}

// LenderBlockFeeChangeIterator is returned from FilterBlockFeeChange and is used to iterate over the raw logs and unpacked data for BlockFeeChange events raised by the Lender contract.
type LenderBlockFeeChangeIterator struct {
	Event *LenderBlockFeeChange // Event containing the contract specifics and raw log

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
func (it *LenderBlockFeeChangeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderBlockFeeChange)
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
		it.Event = new(LenderBlockFeeChange)
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
func (it *LenderBlockFeeChangeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderBlockFeeChangeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderBlockFeeChange represents a BlockFeeChange event raised by the Lender contract.
type LenderBlockFeeChange struct {
	Raw types.Log // Blockchain specific contextual infos
}

// FilterBlockFeeChange is a free log retrieval operation binding the contract event 0x6875685eb5dbc8e2796d75d2dc9e9cb607b610d0558ee7336df418a26d4846e8.
//
// Solidity: event BlockFeeChange()
func (_Lender *LenderFilterer) FilterBlockFeeChange(opts *bind.FilterOpts) (*LenderBlockFeeChangeIterator, error) {

	logs, sub, err := _Lender.contract.FilterLogs(opts, "BlockFeeChange")
	if err != nil {
		return nil, err
	}
	return &LenderBlockFeeChangeIterator{contract: _Lender.contract, event: "BlockFeeChange", logs: logs, sub: sub}, nil
}

// WatchBlockFeeChange is a free log subscription operation binding the contract event 0x6875685eb5dbc8e2796d75d2dc9e9cb607b610d0558ee7336df418a26d4846e8.
//
// Solidity: event BlockFeeChange()
func (_Lender *LenderFilterer) WatchBlockFeeChange(opts *bind.WatchOpts, sink chan<- *LenderBlockFeeChange) (event.Subscription, error) {

	logs, sub, err := _Lender.contract.WatchLogs(opts, "BlockFeeChange")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderBlockFeeChange)
				if err := _Lender.contract.UnpackLog(event, "BlockFeeChange", log); err != nil {
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

// ParseBlockFeeChange is a log parse operation binding the contract event 0x6875685eb5dbc8e2796d75d2dc9e9cb607b610d0558ee7336df418a26d4846e8.
//
// Solidity: event BlockFeeChange()
func (_Lender *LenderFilterer) ParseBlockFeeChange(log types.Log) (*LenderBlockFeeChange, error) {
	event := new(LenderBlockFeeChange)
	if err := _Lender.contract.UnpackLog(event, "BlockFeeChange", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderBlockWithdrawalIterator is returned from FilterBlockWithdrawal and is used to iterate over the raw logs and unpacked data for BlockWithdrawal events raised by the Lender contract.
type LenderBlockWithdrawalIterator struct {
	Event *LenderBlockWithdrawal // Event containing the contract specifics and raw log

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
func (it *LenderBlockWithdrawalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderBlockWithdrawal)
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
		it.Event = new(LenderBlockWithdrawal)
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
func (it *LenderBlockWithdrawalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderBlockWithdrawalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderBlockWithdrawal represents a BlockWithdrawal event raised by the Lender contract.
type LenderBlockWithdrawal struct {
	Token common.Address
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterBlockWithdrawal is a free log retrieval operation binding the contract event 0xb1c1232c5dd039bb1c46cc05eaf25828e4f8596b7f68bdb23073ba78b9ca382d.
//
// Solidity: event BlockWithdrawal(address indexed token)
func (_Lender *LenderFilterer) FilterBlockWithdrawal(opts *bind.FilterOpts, token []common.Address) (*LenderBlockWithdrawalIterator, error) {

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _Lender.contract.FilterLogs(opts, "BlockWithdrawal", tokenRule)
	if err != nil {
		return nil, err
	}
	return &LenderBlockWithdrawalIterator{contract: _Lender.contract, event: "BlockWithdrawal", logs: logs, sub: sub}, nil
}

// WatchBlockWithdrawal is a free log subscription operation binding the contract event 0xb1c1232c5dd039bb1c46cc05eaf25828e4f8596b7f68bdb23073ba78b9ca382d.
//
// Solidity: event BlockWithdrawal(address indexed token)
func (_Lender *LenderFilterer) WatchBlockWithdrawal(opts *bind.WatchOpts, sink chan<- *LenderBlockWithdrawal, token []common.Address) (event.Subscription, error) {

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _Lender.contract.WatchLogs(opts, "BlockWithdrawal", tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderBlockWithdrawal)
				if err := _Lender.contract.UnpackLog(event, "BlockWithdrawal", log); err != nil {
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

// ParseBlockWithdrawal is a log parse operation binding the contract event 0xb1c1232c5dd039bb1c46cc05eaf25828e4f8596b7f68bdb23073ba78b9ca382d.
//
// Solidity: event BlockWithdrawal(address indexed token)
func (_Lender *LenderFilterer) ParseBlockWithdrawal(log types.Log) (*LenderBlockWithdrawal, error) {
	event := new(LenderBlockWithdrawal)
	if err := _Lender.contract.UnpackLog(event, "BlockWithdrawal", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderLendIterator is returned from FilterLend and is used to iterate over the raw logs and unpacked data for Lend events raised by the Lender contract.
type LenderLendIterator struct {
	Event *LenderLend // Event containing the contract specifics and raw log

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
func (it *LenderLendIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderLend)
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
		it.Event = new(LenderLend)
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
func (it *LenderLendIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderLendIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderLend represents a Lend event raised by the Lender contract.
type LenderLend struct {
	Principal  uint8
	Underlying common.Address
	Maturity   *big.Int
	Returned   *big.Int
	Spent      *big.Int
	Sender     common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterLend is a free log retrieval operation binding the contract event 0x4dcca373512f0049f0e5732bf8deedaf846a121102837227c421cb8d8fc83522.
//
// Solidity: event Lend(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 returned, uint256 spent, address sender)
func (_Lender *LenderFilterer) FilterLend(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int) (*LenderLendIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _Lender.contract.FilterLogs(opts, "Lend", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return &LenderLendIterator{contract: _Lender.contract, event: "Lend", logs: logs, sub: sub}, nil
}

// WatchLend is a free log subscription operation binding the contract event 0x4dcca373512f0049f0e5732bf8deedaf846a121102837227c421cb8d8fc83522.
//
// Solidity: event Lend(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 returned, uint256 spent, address sender)
func (_Lender *LenderFilterer) WatchLend(opts *bind.WatchOpts, sink chan<- *LenderLend, underlying []common.Address, maturity []*big.Int) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _Lender.contract.WatchLogs(opts, "Lend", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderLend)
				if err := _Lender.contract.UnpackLog(event, "Lend", log); err != nil {
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

// ParseLend is a log parse operation binding the contract event 0x4dcca373512f0049f0e5732bf8deedaf846a121102837227c421cb8d8fc83522.
//
// Solidity: event Lend(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 returned, uint256 spent, address sender)
func (_Lender *LenderFilterer) ParseLend(log types.Log) (*LenderLend, error) {
	event := new(LenderLend)
	if err := _Lender.contract.UnpackLog(event, "Lend", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderMintIterator is returned from FilterMint and is used to iterate over the raw logs and unpacked data for Mint events raised by the Lender contract.
type LenderMintIterator struct {
	Event *LenderMint // Event containing the contract specifics and raw log

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
func (it *LenderMintIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderMint)
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
		it.Event = new(LenderMint)
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
func (it *LenderMintIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderMintIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderMint represents a Mint event raised by the Lender contract.
type LenderMint struct {
	Principal  uint8
	Underlying common.Address
	Maturity   *big.Int
	Amount     *big.Int
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterMint is a free log retrieval operation binding the contract event 0x309b03ba657e17f1beadbc6eb3c06ba79b38084eb8d0e5452cc222462a17f1f6.
//
// Solidity: event Mint(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 amount)
func (_Lender *LenderFilterer) FilterMint(opts *bind.FilterOpts, underlying []common.Address, maturity []*big.Int) (*LenderMintIterator, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _Lender.contract.FilterLogs(opts, "Mint", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return &LenderMintIterator{contract: _Lender.contract, event: "Mint", logs: logs, sub: sub}, nil
}

// WatchMint is a free log subscription operation binding the contract event 0x309b03ba657e17f1beadbc6eb3c06ba79b38084eb8d0e5452cc222462a17f1f6.
//
// Solidity: event Mint(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 amount)
func (_Lender *LenderFilterer) WatchMint(opts *bind.WatchOpts, sink chan<- *LenderMint, underlying []common.Address, maturity []*big.Int) (event.Subscription, error) {

	var underlyingRule []interface{}
	for _, underlyingItem := range underlying {
		underlyingRule = append(underlyingRule, underlyingItem)
	}
	var maturityRule []interface{}
	for _, maturityItem := range maturity {
		maturityRule = append(maturityRule, maturityItem)
	}

	logs, sub, err := _Lender.contract.WatchLogs(opts, "Mint", underlyingRule, maturityRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderMint)
				if err := _Lender.contract.UnpackLog(event, "Mint", log); err != nil {
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

// ParseMint is a log parse operation binding the contract event 0x309b03ba657e17f1beadbc6eb3c06ba79b38084eb8d0e5452cc222462a17f1f6.
//
// Solidity: event Mint(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 amount)
func (_Lender *LenderFilterer) ParseMint(log types.Log) (*LenderMint, error) {
	event := new(LenderMint)
	if err := _Lender.contract.UnpackLog(event, "Mint", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderPauseIlluminateIterator is returned from FilterPauseIlluminate and is used to iterate over the raw logs and unpacked data for PauseIlluminate events raised by the Lender contract.
type LenderPauseIlluminateIterator struct {
	Event *LenderPauseIlluminate // Event containing the contract specifics and raw log

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
func (it *LenderPauseIlluminateIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderPauseIlluminate)
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
		it.Event = new(LenderPauseIlluminate)
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
func (it *LenderPauseIlluminateIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderPauseIlluminateIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderPauseIlluminate represents a PauseIlluminate event raised by the Lender contract.
type LenderPauseIlluminate struct {
	State bool
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterPauseIlluminate is a free log retrieval operation binding the contract event 0xb4252ba7ada6e65ca524b94dd554b37a638732fc8c63021e66782fc6e75bbb0c.
//
// Solidity: event PauseIlluminate(bool state)
func (_Lender *LenderFilterer) FilterPauseIlluminate(opts *bind.FilterOpts) (*LenderPauseIlluminateIterator, error) {

	logs, sub, err := _Lender.contract.FilterLogs(opts, "PauseIlluminate")
	if err != nil {
		return nil, err
	}
	return &LenderPauseIlluminateIterator{contract: _Lender.contract, event: "PauseIlluminate", logs: logs, sub: sub}, nil
}

// WatchPauseIlluminate is a free log subscription operation binding the contract event 0xb4252ba7ada6e65ca524b94dd554b37a638732fc8c63021e66782fc6e75bbb0c.
//
// Solidity: event PauseIlluminate(bool state)
func (_Lender *LenderFilterer) WatchPauseIlluminate(opts *bind.WatchOpts, sink chan<- *LenderPauseIlluminate) (event.Subscription, error) {

	logs, sub, err := _Lender.contract.WatchLogs(opts, "PauseIlluminate")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderPauseIlluminate)
				if err := _Lender.contract.UnpackLog(event, "PauseIlluminate", log); err != nil {
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

// ParsePauseIlluminate is a log parse operation binding the contract event 0xb4252ba7ada6e65ca524b94dd554b37a638732fc8c63021e66782fc6e75bbb0c.
//
// Solidity: event PauseIlluminate(bool state)
func (_Lender *LenderFilterer) ParsePauseIlluminate(log types.Log) (*LenderPauseIlluminate, error) {
	event := new(LenderPauseIlluminate)
	if err := _Lender.contract.UnpackLog(event, "PauseIlluminate", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderPausePrincipalIterator is returned from FilterPausePrincipal and is used to iterate over the raw logs and unpacked data for PausePrincipal events raised by the Lender contract.
type LenderPausePrincipalIterator struct {
	Event *LenderPausePrincipal // Event containing the contract specifics and raw log

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
func (it *LenderPausePrincipalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderPausePrincipal)
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
		it.Event = new(LenderPausePrincipal)
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
func (it *LenderPausePrincipalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderPausePrincipalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderPausePrincipal represents a PausePrincipal event raised by the Lender contract.
type LenderPausePrincipal struct {
	Principal uint8
	State     bool
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterPausePrincipal is a free log retrieval operation binding the contract event 0x09f6e15731965d66c152a2c1c1b62c94420ba4530dafe8818e1a01906641fb1e.
//
// Solidity: event PausePrincipal(uint8 principal, bool indexed state)
func (_Lender *LenderFilterer) FilterPausePrincipal(opts *bind.FilterOpts, state []bool) (*LenderPausePrincipalIterator, error) {

	var stateRule []interface{}
	for _, stateItem := range state {
		stateRule = append(stateRule, stateItem)
	}

	logs, sub, err := _Lender.contract.FilterLogs(opts, "PausePrincipal", stateRule)
	if err != nil {
		return nil, err
	}
	return &LenderPausePrincipalIterator{contract: _Lender.contract, event: "PausePrincipal", logs: logs, sub: sub}, nil
}

// WatchPausePrincipal is a free log subscription operation binding the contract event 0x09f6e15731965d66c152a2c1c1b62c94420ba4530dafe8818e1a01906641fb1e.
//
// Solidity: event PausePrincipal(uint8 principal, bool indexed state)
func (_Lender *LenderFilterer) WatchPausePrincipal(opts *bind.WatchOpts, sink chan<- *LenderPausePrincipal, state []bool) (event.Subscription, error) {

	var stateRule []interface{}
	for _, stateItem := range state {
		stateRule = append(stateRule, stateItem)
	}

	logs, sub, err := _Lender.contract.WatchLogs(opts, "PausePrincipal", stateRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderPausePrincipal)
				if err := _Lender.contract.UnpackLog(event, "PausePrincipal", log); err != nil {
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

// ParsePausePrincipal is a log parse operation binding the contract event 0x09f6e15731965d66c152a2c1c1b62c94420ba4530dafe8818e1a01906641fb1e.
//
// Solidity: event PausePrincipal(uint8 principal, bool indexed state)
func (_Lender *LenderFilterer) ParsePausePrincipal(log types.Log) (*LenderPausePrincipal, error) {
	event := new(LenderPausePrincipal)
	if err := _Lender.contract.UnpackLog(event, "PausePrincipal", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderScheduleFeeChangeIterator is returned from FilterScheduleFeeChange and is used to iterate over the raw logs and unpacked data for ScheduleFeeChange events raised by the Lender contract.
type LenderScheduleFeeChangeIterator struct {
	Event *LenderScheduleFeeChange // Event containing the contract specifics and raw log

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
func (it *LenderScheduleFeeChangeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderScheduleFeeChange)
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
		it.Event = new(LenderScheduleFeeChange)
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
func (it *LenderScheduleFeeChangeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderScheduleFeeChangeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderScheduleFeeChange represents a ScheduleFeeChange event raised by the Lender contract.
type LenderScheduleFeeChange struct {
	When *big.Int
	Raw  types.Log // Blockchain specific contextual infos
}

// FilterScheduleFeeChange is a free log retrieval operation binding the contract event 0xf339d7864b1b8839e8a8870c012fc6eb9a89844861a87a26ce35979018603a1b.
//
// Solidity: event ScheduleFeeChange(uint256 when)
func (_Lender *LenderFilterer) FilterScheduleFeeChange(opts *bind.FilterOpts) (*LenderScheduleFeeChangeIterator, error) {

	logs, sub, err := _Lender.contract.FilterLogs(opts, "ScheduleFeeChange")
	if err != nil {
		return nil, err
	}
	return &LenderScheduleFeeChangeIterator{contract: _Lender.contract, event: "ScheduleFeeChange", logs: logs, sub: sub}, nil
}

// WatchScheduleFeeChange is a free log subscription operation binding the contract event 0xf339d7864b1b8839e8a8870c012fc6eb9a89844861a87a26ce35979018603a1b.
//
// Solidity: event ScheduleFeeChange(uint256 when)
func (_Lender *LenderFilterer) WatchScheduleFeeChange(opts *bind.WatchOpts, sink chan<- *LenderScheduleFeeChange) (event.Subscription, error) {

	logs, sub, err := _Lender.contract.WatchLogs(opts, "ScheduleFeeChange")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderScheduleFeeChange)
				if err := _Lender.contract.UnpackLog(event, "ScheduleFeeChange", log); err != nil {
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
func (_Lender *LenderFilterer) ParseScheduleFeeChange(log types.Log) (*LenderScheduleFeeChange, error) {
	event := new(LenderScheduleFeeChange)
	if err := _Lender.contract.UnpackLog(event, "ScheduleFeeChange", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderScheduleWithdrawalIterator is returned from FilterScheduleWithdrawal and is used to iterate over the raw logs and unpacked data for ScheduleWithdrawal events raised by the Lender contract.
type LenderScheduleWithdrawalIterator struct {
	Event *LenderScheduleWithdrawal // Event containing the contract specifics and raw log

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
func (it *LenderScheduleWithdrawalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderScheduleWithdrawal)
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
		it.Event = new(LenderScheduleWithdrawal)
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
func (it *LenderScheduleWithdrawalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderScheduleWithdrawalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderScheduleWithdrawal represents a ScheduleWithdrawal event raised by the Lender contract.
type LenderScheduleWithdrawal struct {
	Token common.Address
	Hold  *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterScheduleWithdrawal is a free log retrieval operation binding the contract event 0xe4b67652e856f57a7747dd2473850ce987087f4b1744a870504f1c047cb56f4f.
//
// Solidity: event ScheduleWithdrawal(address indexed token, uint256 hold)
func (_Lender *LenderFilterer) FilterScheduleWithdrawal(opts *bind.FilterOpts, token []common.Address) (*LenderScheduleWithdrawalIterator, error) {

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _Lender.contract.FilterLogs(opts, "ScheduleWithdrawal", tokenRule)
	if err != nil {
		return nil, err
	}
	return &LenderScheduleWithdrawalIterator{contract: _Lender.contract, event: "ScheduleWithdrawal", logs: logs, sub: sub}, nil
}

// WatchScheduleWithdrawal is a free log subscription operation binding the contract event 0xe4b67652e856f57a7747dd2473850ce987087f4b1744a870504f1c047cb56f4f.
//
// Solidity: event ScheduleWithdrawal(address indexed token, uint256 hold)
func (_Lender *LenderFilterer) WatchScheduleWithdrawal(opts *bind.WatchOpts, sink chan<- *LenderScheduleWithdrawal, token []common.Address) (event.Subscription, error) {

	var tokenRule []interface{}
	for _, tokenItem := range token {
		tokenRule = append(tokenRule, tokenItem)
	}

	logs, sub, err := _Lender.contract.WatchLogs(opts, "ScheduleWithdrawal", tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderScheduleWithdrawal)
				if err := _Lender.contract.UnpackLog(event, "ScheduleWithdrawal", log); err != nil {
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

// ParseScheduleWithdrawal is a log parse operation binding the contract event 0xe4b67652e856f57a7747dd2473850ce987087f4b1744a870504f1c047cb56f4f.
//
// Solidity: event ScheduleWithdrawal(address indexed token, uint256 hold)
func (_Lender *LenderFilterer) ParseScheduleWithdrawal(log types.Log) (*LenderScheduleWithdrawal, error) {
	event := new(LenderScheduleWithdrawal)
	if err := _Lender.contract.UnpackLog(event, "ScheduleWithdrawal", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderSetAdminIterator is returned from FilterSetAdmin and is used to iterate over the raw logs and unpacked data for SetAdmin events raised by the Lender contract.
type LenderSetAdminIterator struct {
	Event *LenderSetAdmin // Event containing the contract specifics and raw log

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
func (it *LenderSetAdminIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderSetAdmin)
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
		it.Event = new(LenderSetAdmin)
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
func (it *LenderSetAdminIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderSetAdminIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderSetAdmin represents a SetAdmin event raised by the Lender contract.
type LenderSetAdmin struct {
	Admin common.Address
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterSetAdmin is a free log retrieval operation binding the contract event 0x5a272403b402d892977df56625f4164ccaf70ca3863991c43ecfe76a6905b0a1.
//
// Solidity: event SetAdmin(address indexed admin)
func (_Lender *LenderFilterer) FilterSetAdmin(opts *bind.FilterOpts, admin []common.Address) (*LenderSetAdminIterator, error) {

	var adminRule []interface{}
	for _, adminItem := range admin {
		adminRule = append(adminRule, adminItem)
	}

	logs, sub, err := _Lender.contract.FilterLogs(opts, "SetAdmin", adminRule)
	if err != nil {
		return nil, err
	}
	return &LenderSetAdminIterator{contract: _Lender.contract, event: "SetAdmin", logs: logs, sub: sub}, nil
}

// WatchSetAdmin is a free log subscription operation binding the contract event 0x5a272403b402d892977df56625f4164ccaf70ca3863991c43ecfe76a6905b0a1.
//
// Solidity: event SetAdmin(address indexed admin)
func (_Lender *LenderFilterer) WatchSetAdmin(opts *bind.WatchOpts, sink chan<- *LenderSetAdmin, admin []common.Address) (event.Subscription, error) {

	var adminRule []interface{}
	for _, adminItem := range admin {
		adminRule = append(adminRule, adminItem)
	}

	logs, sub, err := _Lender.contract.WatchLogs(opts, "SetAdmin", adminRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderSetAdmin)
				if err := _Lender.contract.UnpackLog(event, "SetAdmin", log); err != nil {
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
func (_Lender *LenderFilterer) ParseSetAdmin(log types.Log) (*LenderSetAdmin, error) {
	event := new(LenderSetAdmin)
	if err := _Lender.contract.UnpackLog(event, "SetAdmin", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// LenderSetFeeIterator is returned from FilterSetFee and is used to iterate over the raw logs and unpacked data for SetFee events raised by the Lender contract.
type LenderSetFeeIterator struct {
	Event *LenderSetFee // Event containing the contract specifics and raw log

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
func (it *LenderSetFeeIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(LenderSetFee)
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
		it.Event = new(LenderSetFee)
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
func (it *LenderSetFeeIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *LenderSetFeeIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// LenderSetFee represents a SetFee event raised by the Lender contract.
type LenderSetFee struct {
	Fee *big.Int
	Raw types.Log // Blockchain specific contextual infos
}

// FilterSetFee is a free log retrieval operation binding the contract event 0x00172ddfc5ae88d08b3de01a5a187667c37a5a53989e8c175055cb6c993792a7.
//
// Solidity: event SetFee(uint256 indexed fee)
func (_Lender *LenderFilterer) FilterSetFee(opts *bind.FilterOpts, fee []*big.Int) (*LenderSetFeeIterator, error) {

	var feeRule []interface{}
	for _, feeItem := range fee {
		feeRule = append(feeRule, feeItem)
	}

	logs, sub, err := _Lender.contract.FilterLogs(opts, "SetFee", feeRule)
	if err != nil {
		return nil, err
	}
	return &LenderSetFeeIterator{contract: _Lender.contract, event: "SetFee", logs: logs, sub: sub}, nil
}

// WatchSetFee is a free log subscription operation binding the contract event 0x00172ddfc5ae88d08b3de01a5a187667c37a5a53989e8c175055cb6c993792a7.
//
// Solidity: event SetFee(uint256 indexed fee)
func (_Lender *LenderFilterer) WatchSetFee(opts *bind.WatchOpts, sink chan<- *LenderSetFee, fee []*big.Int) (event.Subscription, error) {

	var feeRule []interface{}
	for _, feeItem := range fee {
		feeRule = append(feeRule, feeItem)
	}

	logs, sub, err := _Lender.contract.WatchLogs(opts, "SetFee", feeRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(LenderSetFee)
				if err := _Lender.contract.UnpackLog(event, "SetFee", log); err != nil {
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
func (_Lender *LenderFilterer) ParseSetFee(log types.Log) (*LenderSetFee, error) {
	event := new(LenderSetFee)
	if err := _Lender.contract.UnpackLog(event, "SetFee", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
