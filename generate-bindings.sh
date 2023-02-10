#!bin/bash

# A script that generates ABIs, go bindings and flattened contracts.

# Lender
forge flatten src/Lender.sol --output flattened/Lender.flattened.sol

forge inspect flattened/Lender.flattened.sol:Lender abi > abi/Lender.abi

abigen --abi ./abi/Lender.abi -pkg illuminate -type Lender -out ./bindings/lender.go

# Redeemer
forge flatten src/Redeemer.sol --output flattened/Redeemer.flattened.sol

forge inspect flattened/Redeemer.flattened.sol:Redeemer abi > abi/Redeemer.abi

abigen --abi ./abi/Redeemer.abi -pkg illuminate -type Redeemer -out ./bindings/redeemer.go

# MarketPlace
forge flatten src/MarketPlace.sol --output flattened/MarketPlace.flattened.sol

forge inspect flattened/MarketPlace.flattened.sol:MarketPlace abi > abi/MarketPlace.abi

abigen --abi ./abi/MarketPlace.abi -pkg illuminate -type MarketPlace -out ./bindings/marketplace.go

# Converter
forge flatten src/Converter.sol --output flattened/Converter.flattened.sol

forge inspect flattened/Converter.flattened.sol:Converter abi > abi/Converter.abi

abigen --abi ./abi/Converter.abi -pkg illuminate -type Converter -out ./bindings/converter.go

# Creator
forge flatten src/Creator.sol --output flattened/Creator.flattened.sol

forge inspect flattened/Creator.flattened.sol:Creator abi > abi/Creator.abi

abigen --abi ./abi/Creator.abi -pkg illuminate -type Creator -out ./bindings/creator.go

# ERC5095
forge flatten src/tokens/ERC5095.sol --output flattened/ERC5095.flattened.sol

forge inspect flattened/ERC5095.flattened.sol:ERC5095 abi > abi/ERC5095.abi

abigen --abi ./abi/ERC5095.abi -pkg illuminate -type ERC5095 -out ./bindings/erc5095.go
