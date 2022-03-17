from brownie import accounts, network, config, Rental, MockV3Aggregator
from scripts.helpfulScripts import (
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    getAccount,
    deployMocks,
)


def deployRental():
    account = getAccount()
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        priceFeedAddress = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]
    else:
        deployMocks()
        priceFeedAddress = MockV3Aggregator[-1].address

    rental = Rental.deploy(
        priceFeedAddress,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(f"Rental is deployed: {rental}")
    return rental


def main():
    deployRental()
