# Onchain Wordle

A decentralized implementation of the popular word-guessing game Wordle, built using Dojo and running entirely onchain.

## Project Overview

Onchain Wordle brings the addictive word-guessing game to the blockchain, allowing players to enjoy Wordle in a decentralized environment. The game logic is implemented as smart contracts using Dojo, with a client interface that interacts with these contracts through the dojo.js SDK.

## Description

Wordle is a game where players attempt to guess a hidden five-letter word. After each guess, feedback is provided showing which letters are correct and in the right position (green), which letters are in the word but in the wrong position (yellow), and which letters are not in the word at all (gray).

This implementation takes the classic Wordle gameplay and brings it onchain, demonstrating how traditional games can be reimagined in a Web3 context. The entire game state and logic is stored and executed on the blockchain, providing transparency and immutability to the gameplay experience.

## Installation

### Prerequisites
- Node.js (v16+)
- pnpm
- Git
- [Dojo toolkit](https://book.dojoengine.org/getting-started/quick-start.html)
- Docker & Docker compose

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/dojoengine/wordle-js.git
   cd wordle-js
   ```

2. Install dependencies:
   ```bash
   pnpm install
   ```
3. Start docker
   ```bash
   docker compose up
   ```

4. Run the development server:
   ```bash
   pnpm dev
   ```

5. Visit `http://localhost:5173` in your browser to play the game.

## Client Development Journey

This project was built incrementally, with each step focusing on a specific aspect of the client development. You can explore this journey by checking out the different feature branches:

### Branch Structure

- `main` - Contains the core Dojo contracts that power the game
- `feat/client-00` to `feat/client-08` - Progressive implementation of the client features

### Client Steps

Each feature branch contains a `STEP-xx.md` file that explains the changes implemented in that branch. Here's a summary of what each step covers:

1. **feat/client-00**: Basic project setup and initialization with dojo.js
2. **feat/client-01**: Creating the game board UI components
3. **feat/client-02**: Implementing keyboard input handling
4. **feat/client-03**: Adding game state management
5. **feat/client-04**: Connecting to the Dojo contracts
6. **feat/client-05**: Implementing guess submission and validation
7. **feat/client-06**: Adding visual feedback for guesses
8. **feat/client-07**: Game completion and restart functionality
9. **feat/client-08**: Final polish and optimizations

To explore a specific development step, checkout the corresponding branch:
```bash
git checkout feat/client-xx
```

Then read the `STEP-xx.md` file to understand the changes implemented in that step.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Built with ❤️ using [Dojo](https://dojoengine.org)
