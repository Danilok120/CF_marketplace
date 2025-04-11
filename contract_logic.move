// CoinFlip Marketplace Move Smart Contracts (Simplified MVP)
// This module assumes NFT objects follow standard Sui object rules

module coinflip::marketplace {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::balance;
    use sui::vector;
    use sui::hash;

    struct Listing has key {
        id: UID,
        nft: object::ID,
        seller: address,
        price: u64,
    }

    public fun list_nft(ctx: &mut TxContext, nft: object::ID, price: u64, pool_balance: u64, alpha: u64): Listing {
        let payout = price * 2 * alpha / 100;
        assert!(payout <= pool_balance, 0); // Ensure pool can afford potential win payout

        let id = object::new(ctx);
        Listing {
            id,
            nft,
            seller: tx_context::sender(ctx),
            price,
        }
    }

    public fun commit_flip(ctx: &mut TxContext, listing: &mut Listing, commit_hash: vector<u8>) {
        // Store the commit_hash in a future version with table storage
        // Placeholder logic for MVP
        assert!(true, 0);
    }

    public fun reveal_and_resolve(
        ctx: &mut TxContext,
        listing: &mut Listing,
        side: u8, // 0 for heads, 1 for tails
        nonce: vector<u8>,
        buyer: address,
        payment: Coin,
        alpha: u64 // alpha is given in percentage, e.g. 50 for 50%
    ) {
        let mut payload = vector::empty<u8>();
        vector::push_back(&mut payload, side);
        vector::extend(&mut payload, nonce);
        let check = hash::sha3_256(&payload);

        let outcome = hash::sha3_256(nonce)[0] % 3; // 0 = win, 1 = draw, 2 = lose

        if (outcome == 0) {
            // WIN → buyer pays nothing, seller gets part of 2P from pool
            let payout = listing.price * 2 * alpha / 100;
            transfer::transfer(listing.nft, buyer);
            // Simulate pool paying payout to seller
            // TODO: deduct from pool in future version
            coin::transfer(payment, buyer); // Refund whole payment to buyer for now (simulate no payment)
        } else if (outcome == 1) {
            // DRAW → pay normal price
            let price = listing.price;
            let (pay, refund) = coin::split(payment, price);
            transfer::transfer(listing.nft, buyer);
            coin::transfer(pay, listing.seller);
            coin::transfer(refund, buyer);
        } else {
            // LOSE → pay double
            let price = listing.price;
            let (double_price, refund) = coin::split(payment, price * 2);
            transfer::transfer(listing.nft, buyer);
            coin::transfer(double_price, listing.seller);
            coin::transfer(refund, buyer);
        }
    }
}
