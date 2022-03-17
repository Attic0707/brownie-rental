from scripts.helpfulScripts import getAccount
from scripts.contract import getContract
from scripts.deploy import deployRental

# arrange
account = getAccount()
rental = deployRental()
expectedResult = rental.itemList[0]

# act
getContract()
actualResult = rental.itemList[0]
# assert
assert expectedResult == actualResult
