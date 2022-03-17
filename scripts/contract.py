from brownie import Rental
from scripts.helpfulScripts import getAccount


def getContract():
    rental = Rental[-1]
    account = getAccount()

    ethPrice = rental.getETHPrice()
    conversionRate = rental.getConversionRate(15)  # 15 ETH to USD
    result = rental.createItem("Samet Violin", account, 100, {"from": account})
    print(f"ethPrice: {ethPrice}")
    print(f"conversionRate: {conversionRate}")
    print(f"result: {result}")


def main():
    getContract()
