# Ethereum Mini Project

## Requirements
Write a simple voting contract in Solidity with the following features:

- The voting has only 3 fixed options to choose from: 0 or 1 or 2. 
- The votes can come only from the addresses that are marked as "verified". Thus, the creator of the contract must 
   mark all permitted addresses as "verified" before the voting can begin (write a function that would help the creator 
   to mark an address as "verified"). 
- To prevent cheating, each verified address can vote only once - after voting, the address is marked as "unverified" 
  and thus can't vote again ... unless the owner of the contract marks it as "verified" again.

### Minimum requirements:

- contract should compile without errors and warnings
- basic functionality should be working

### Expected output:
Submit only one file, <YOUR_NAME>.sol. Documentation should be part of the contract's source code.

