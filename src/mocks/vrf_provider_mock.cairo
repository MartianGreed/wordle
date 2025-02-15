use starknet::ContractAddress;

#[derive(Drop, Copy, Clone, Serde)]
pub enum Source {
    Nonce: ContractAddress,
    Salt: felt252,
}

#[starknet::interface]
pub trait IVrfProvider<T> {
    fn request_random(self: @T, caller: ContractAddress, source: Source);
    fn consume_random(ref self: T, source: Source) -> felt252;
}

#[dojo::contract]
mod vrf_provider_mock {
    use core::poseidon::poseidon_hash_span;
    use super::{IVrfProvider, Source};
    use starknet::{ContractAddress};
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map,
    };

    #[storage]
    struct Storage {
        nonce: Map<ContractAddress, felt252>,
    }

    #[abi(embed_v0)]
    impl IVrfProviderMock of IVrfProvider<ContractState> {
        fn request_random(self: @ContractState, caller: ContractAddress, source: Source) {}
        fn consume_random(ref self: ContractState, source: Source) -> felt252 {
            let caller = starknet::get_caller_address();
            let tx_info = starknet::get_execution_info().tx_info.unbox();
            match source {
                Source::Nonce(addr) => {
                    let nonce = self.nonce.entry(addr).read();
                    self.nonce.entry(addr).write(nonce + 1);
                    poseidon_hash_span(array![nonce, caller.into(), tx_info.chain_id].span())
                },
                Source::Salt(salt) => {
                    poseidon_hash_span(array![salt, caller.into(), tx_info.chain_id].span())
                },
            }
        }
    }
}
