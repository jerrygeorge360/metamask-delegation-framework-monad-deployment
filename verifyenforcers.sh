#!/bin/bash
# Fully automated verification of all enforcer contracts on Monad Testnet

CHAIN_ID=10143
COMPILER_VERSION=0.8.23
ETHERSCAN_API_KEY=""  # Hardcoded API key

# Mapping of contract names -> deployed addresses
declare -A DEPLOYED_ADDRESSES=(
    ["AllowedCalldataEnforcer"]="0xc2b0d624c1c4319760C96503BA27C347F3260f55"
    ["AllowedMethodsEnforcer"]="0x2c21fD0Cb9DC8445CB3fb0DC5E7Bb0Aca01842B5"
    ["AllowedTargetsEnforcer"]="0x7F20f61b1f09b08D970938F6fa563634d65c4EeB"
    ["BlockNumberEnforcer"]="0x5d9818dF0AE3f66e9c3D0c5029DAF99d1823ca6c"
    ["DeployedEnforcer"]="0x24ff2AA430D53a8CD6788018E902E098083dcCd2"
    ["ERC20BalanceChangeEnforcer"]="0xcdF6aB796408598Cea671d79506d7D48E97a5437"
    ["ERC20TransferAmountEnforcer"]="0xf100b0819427117EcF76Ed94B358B1A5b5C6D2Fc"
    ["ERC20PeriodTransferEnforcer"]="0x474e3Ae7E169e940607cC624Da8A15Eb120139aB"
    ["ERC20StreamingEnforcer"]="0x56c97aE02f233B29fa03502Ecc0457266d9be00e"
    ["ERC721BalanceChangeEnforcer"]="0x8aFdf96eDBbe7e1eD3f5Cd89C7E084841e12A09e"
    ["ERC721TransferEnforcer"]="0x3790e6B7233f779b09DA74C72b6e94813925b9aF"
    ["ERC1155BalanceChangeEnforcer"]="0x63c322732695cAFbbD488Fc6937A0A7B66fC001A"
    ["ExactCalldataBatchEnforcer"]="0x982FD5C86BBF425d7d1451f974192d4525113DfD"
    ["ExactCalldataEnforcer"]="0x99F2e9bF15ce5eC84685604836F71aB835DBBdED"
    ["ExactExecutionBatchEnforcer"]="0x1e141e455d08721Dd5BCDA1BaA6Ea5633Afd5017"
    ["ExactExecutionEnforcer"]="0x146713078D39eCC1F5338309c28405ccf85Abfbb"
    ["IdEnforcer"]="0xC8B5D93463c893401094cc70e66A206fb5987997"
    ["LimitedCallsEnforcer"]="0x04658B29F6b82ed55274221a06Fc97D318E25416"
    ["LogicalOrWrapperEnforcer"]="0x1685442061469180a0e686D37B334f758A39f198"
    ["MultiTokenPeriodEnforcer"]="0xFB2f1a9BD76d3701B730E5d69C3219D42D80eBb7"
    ["NativeBalanceChangeEnforcer"]="0xbD7B277507723490Cd50b12EaaFe87C616be6880"
    ["ArgsEqualityCheckEnforcer"]="0x44B8C6ae3C304213c3e298495e12497Ed3E56E41"
    ["NativeTokenPaymentEnforcer"]="0xe27fB0d5F1466af7891e1Eca3b894e63744e6419"
    ["NativeTokenTransferAmountEnforcer"]="0xF71af580b9c3078fbc2BBF16FbB8EEd82b330320"
    ["NativeTokenStreamingEnforcer"]="0xD10b97905a320b13a0608f7E9cC506b56747df19"
    ["NativeTokenPeriodTransferEnforcer"]="0x9BC0FAf4Aca5AE429F4c06aEEaC517520CB16BD9"
    ["NonceEnforcer"]="0xDE4f2FAC4B3D87A1d9953Ca5FC09FCa7F366254f"
    ["OwnershipTransferEnforcer"]="0x7EEf9734E7092032B5C56310Eb9BbD1f4A524681"
    ["RedeemerEnforcer"]="0xE144b0b2618071B4E56f746313528a669c7E65c5"
    ["SpecificActionERC20TransferBatchEnforcer"]="0x6649b61c873F6F9686A1E1ae9ee98aC380c7bA13"
    ["TimestampEnforcer"]="0x1046bb45C8d673d4ea75321280DB34899413c069"
    ["ValueLteEnforcer"]="0x92Bf12322527cAA612fd31a0e810472BBB106A8F"
    ["ERC20MultiOperationIncreaseBalanceEnforcer"]="0xeaA1bE91F0ea417820a765df9C5BE542286BFfDC"
    ["ERC721MultiOperationIncreaseBalanceEnforcer"]="0x44877cDAFC0d529ab144bb6B0e202eE377C90229"
    ["ERC1155MultiOperationIncreaseBalanceEnforcer"]="0x9eB86bbdaA71D4D8d5Fb1B8A9457F04D3344797b"
    ["NativeTokenMultiOperationIncreaseBalanceEnforcer"]="0xaD551E9b971C1b0c02c577bFfCFAA20b81777276"
)

# Loop through all enforcer contracts
for FILE in src/enforcers/*.sol; do
    BASENAME=$(basename "$FILE")
    CONTRACT_NAME="${BASENAME%.sol}"
    DEPLOYED_ADDRESS="${DEPLOYED_ADDRESSES[$CONTRACT_NAME]}"

    if [ -z "$DEPLOYED_ADDRESS" ]; then
        echo "Skipping $CONTRACT_NAME: No deployed address found"
        continue
    fi

    echo "--------------------------------------------"
    echo "Verifying $CONTRACT_NAME at $DEPLOYED_ADDRESS..."
    
    forge verify-contract \
        "$DEPLOYED_ADDRESS" \
        "$FILE:$CONTRACT_NAME" \
        --chain-id $CHAIN_ID \
        --compiler-version $COMPILER_VERSION \
        --etherscan-api-key $ETHERSCAN_API_KEY
done

echo "✅ All enforcer verification commands submitted!"
