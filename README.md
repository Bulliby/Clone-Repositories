# Clone Repositories

Permit to clone all my github repositories in one place. Each repo is categorized by it's language and a directory is created for it.

## Configuration

Two dotenv variables have to be set  (see .env.example) :

* USERNAME
* TOKEN

> Reffers to this link for personal token creation : https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

## Installation

```bash
pip install -r requirements.txt
```

## Usage

```bash
./clone.sh --target /home/bulliby/dev
```
