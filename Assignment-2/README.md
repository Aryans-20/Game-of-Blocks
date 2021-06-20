## About the Assignment
In this assignment we learnt about the basics of **solidity** and **smart contracts** and implemented a Loan contract which provides the following functionalities.
### 1. getCompoundInterest : 
allows anyone to use it to calculate the amount of interest for given values of P, R, T (in years). 0Remember that solidity does not have a good support for floats though, so enter the rate as a whole number (like if the rate is 83%, enter 83).

### 2. reqLoan: 
anyone is able to use it to request the Owner to settle his loan. The P, R, T entered is used to calculate the dues, and is added to a mapping. It emits the Request event.

### 3. getOwnerBalance: 
anyone can use it to get the amount of MetaCoins owned by the owner.

### 4. viewDues : 
only the owner can access this to view the amount of loan he owes to the input address, which is stored in the loans mapping.

### 5. settleDues: 
only the owner can use this to settle the amount of loan he owes to the input address.
