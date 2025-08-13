# FundMe Smart Contract

A decentralized fundraising smart contract built with Foundry that allows users to fund projects and withdraw funds.

## Overview

This project demonstrates a basic crowdfunding smart contract where users can contribute ETH and the contract owner can withdraw the accumulated funds. The contract includes price feed integration for USD-based minimum funding requirements.

## Features

- **Fund Collection**: Accept ETH donations from users
- **Minimum Funding**: Enforce minimum funding amount in USD using Chainlink price feeds
- **Withdrawal**: Allow contract owner to withdraw collected funds
- **Contributor Tracking**: Keep track of all funders and their contributions
- **Owner Management**: Only contract owner can withdraw funds

## Example in Sepolia
- [FundMe](https://sepolia.etherscan.io/address/0x6659540010416b8482b316d81364c0800efdc573#code)

## Prerequisites

- [Foundry](https://getfoundry.sh/) - Ethereum development toolkit
- [Node.js](https://nodejs.org/) (optional, for additional tooling)
- An Ethereum wallet with testnet ETH
- Etherscan API key for contract verification

## Installation

1. Clone the repository:
```bash
git clone https://github.com/MagicalNOS/FundMe-smart-contract.git
cd FundMe-smart-contract
```

2. Install Foundry dependencies:
```bash
forge install
```

3. Create a `.env` file in the root directory:
```bash
cp .env.example .env
```

4. Fill in your environment variables in `.env`:
```env
SEPOLIA_RPC_URL=your_sepolia_rpc_url
SEPOLIA_PRIVATE_KEY=your_private_key
ETHSCAN_API_KEY=your_etherscan_api_key
```

## Project Structure

```
├── script/
│   └── DeployFundMe.s.sol    # Deployment script
├── src/
│   └── FundMe.sol            # Main contract
├── test/
│   └── FundMeTest.t.sol      # Contract tests
├── .env                      # Environment variables
├── foundry.toml              # Foundry configuration
├── Makefile                  # Build and deployment commands
└── README.md                 # Project documentation
```

## Usage

### Building the Project

Compile the smart contracts:

```bash
make build
# or
forge build
```

### Testing

Run the test suite:

```bash
forge test
```

Run tests with verbosity:

```bash
forge test -vvv
```

### Deployment

#### Deploy to Sepolia Testnet

Make sure you have:
1. Sepolia ETH in your wallet
2. Updated your `.env` file with the required variables

Deploy the contract:

```bash
make deploy-sepolia
```

This command will:
- Deploy the FundMe contract to Sepolia testnet
- Verify the contract on Etherscan
- Display deployment details

### Interacting with the Contract

After deployment, you can interact with your contract using:

- **Foundry Cast**: Command-line tool for contract interaction
- **Etherscan**: View and interact via the web interface
- **Frontend Integration**: Build a web interface using Web3.js or Ethers.js

#### Example Cast Commands

Fund the contract:
```bash
cast send <CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key $SEPOLIA_PRIVATE_KEY --rpc-url $SEPOLIA_RPC_URL
```

Check contract balance:
```bash
cast balance <CONTRACT_ADDRESS> --rpc-url $SEPOLIA_RPC_URL
```

Withdraw funds (owner only):
```bash
cast send <CONTRACT_ADDRESS> "withdraw()" --private-key $SEPOLIA_PRIVATE_KEY --rpc-url $SEPOLIA_RPC_URL
```

## Configuration

### Environment Variables

| Variable | Description |
|----------|-------------|
| `SEPOLIA_RPC_URL` | RPC endpoint for Sepolia testnet |
| `SEPOLIA_PRIVATE_KEY` | Private key for deployment account |
| `ETHSCAN_API_KEY` | Etherscan API key for contract verification |

### Foundry Configuration

The `foundry.toml` file contains project-specific settings for Foundry. Key configurations include:

- Solidity version
- Optimizer settings
- Library mappings
- Test configurations

## Security Considerations

⚠️ **Important Security Notes:**

1. **Private Keys**: Never commit private keys to version control
2. **Environment Variables**: Keep your `.env` file secure and never share it
3. **Testnet Only**: This setup is configured for testnet deployment
4. **Audit**: Have your contracts audited before mainnet deployment

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing

The project includes comprehensive tests covering:

- Contract deployment
- Funding functionality
- Withdrawal mechanisms
- Access control
- Edge cases and error conditions

Run specific tests:
```bash
forge test --match-test testFunding
```

## Troubleshooting

### Common Issues

1. **"Failed to get EIP-1559 fees"**: Ensure your RPC URL supports EIP-1559
2. **"Invalid private key"**: Check that your private key is correctly formatted (64 characters, no 0x prefix in .env)
3. **"Insufficient funds"**: Ensure your wallet has enough ETH for deployment and gas fees

### Getting Help

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Ethereum Development Resources](https://ethereum.org/developers/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Foundry](https://github.com/foundry-rs/foundry) - Development framework
- [Chainlink](https://chain.link/) - Price feed oracles
- [OpenZeppelin](https://openzeppelin.com/) - Security standards and libraries
