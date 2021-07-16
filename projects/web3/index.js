const Web3 = require("web3");

//connect web3 to Ganache via Http
const web3provider = new Web3("http://127.0.0.1:7545");

const run = async () => {
  const allAddresses = await web3provider.eth.getAccounts();
  console.log(allAddresses);

  const testAddress = allAddresses[0];
  const testAddress2 = allAddresses[1];

  const balance = await web3provider.eth.getBalance(testAddress);
  //convert balance to ether
  const etherBalance = web3provider.utils.fromWei(balance);
  console.log("Balance of TA1 before transaction", etherBalance);

  const transactionResult = await web3provider.eth.sendTransaction(
    {
      from: testAddress,
      to: testAddress2,
      value: "100000000000",
    },
    (error) => console.error(error)
  );

  console.log("TX_Result", transactionResult);

  const TA1balance = await web3provider.eth.getBalance(testAddress);
  const TA2balance = await web3provider.eth.getBalance(testAddress2);

  console.log("TA1 Bal after tx", TA1balance);
  console.log("TA2 bal after tx", TA2balance);
};

run();
