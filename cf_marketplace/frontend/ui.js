// This is a simplified React Native app structure for CoinFlip Market
// It connects to a Sui wallet and interacts with Move-based smart contracts
// We'll also write Move contracts separately (see related files)

import React, { useState } from 'react';
import { View, Text, Button, StyleSheet, TouchableOpacity, TextInput } from 'react-native';

export default function App() {
  const [nftId, setNftId] = useState('');
  const [price, setPrice] = useState('');
  const [side, setSide] = useState(null);

  const connectWallet = async () => {
    // Placeholder for wallet connection logic
    alert('Connect wallet (Sui wallet integration)');
  };

  const listNFT = async () => {
    // Call smart contract to list NFT for sale
    alert(`List NFT ${nftId} for ${price} USDC`);
  };

  const flipToBuy = async () => {
    if (!side) return alert('Choose heads or tails');
    // Call smart contract with commit-reveal logic
    alert(`Flipping for NFT ${nftId} with side: ${side}`);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>CoinFlip Market</Text>
      <Button title="Connect Wallet" onPress={connectWallet} />

      <Text style={styles.label}>NFT ID</Text>
      <TextInput style={styles.input} value={nftId} onChangeText={setNftId} />

      <Text style={styles.label}>Price (USDC)</Text>
      <TextInput style={styles.input} value={price} onChangeText={setPrice} keyboardType="numeric" />

      <Button title="List NFT" onPress={listNFT} />

      <Text style={styles.label}>Choose Side</Text>
      <View style={styles.row}>
        <TouchableOpacity onPress={() => setSide('heads')} style={side === 'heads' ? styles.selected : styles.option}>
          <Text>Heads</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setSide('tails')} style={side === 'tails' ? styles.selected : styles.option}>
          <Text>Tails</Text>
        </TouchableOpacity>
      </View>

      <Button title="Flip & Buy" onPress={flipToBuy} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 },
  title: { fontSize: 24, fontWeight: 'bold', marginBottom: 20 },
  label: { marginTop: 20 },
  input: { borderWidth: 1, width: 200, padding: 8, marginTop: 5 },
  row: { flexDirection: 'row', marginVertical: 10 },
  option: { padding: 10, borderWidth: 1, marginHorizontal: 5 },
  selected: { padding: 10, borderWidth: 2, borderColor: 'blue', backgroundColor: '#ddd', marginHorizontal: 5 },
});
