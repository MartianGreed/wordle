use core::integer::u256;

pub mod systems {
    pub mod actions;
    pub mod word;
}
pub mod models;

pub mod mocks {
    pub mod vrf_provider_mock;
}

const SECONDS_PER_DAY: u64 = 86400;

pub fn get_next_day(timestamp: u64) -> u64 {
    ((timestamp / SECONDS_PER_DAY) * SECONDS_PER_DAY) + SECONDS_PER_DAY
}

pub fn pack_attempt(states: Span<u8>) -> u16 {
    assert(states.len() == 5, 'state len should be 6');
    let mut result: u16 = 0;
    let mut i: u32 = 0;

    loop {
        if i == 5_u32 {
            break;
        }

        let state = *states.at(i.try_into().unwrap());
        assert(state <= 2, 'state must be 0, 1, or 2');

        // Pack the state using base-3
        let base: u16 = 3;
        let exp: u32 = i;
        let multiplier = pow(base, exp);
        result = result + (state.into() * multiplier);

        i += 1;
    };

    result
}

pub fn unpack_attempt(packed: u16) -> Span<u8> {
    let mut remaining = packed;
    let mut arr = ArrayTrait::new();
    let mut i: u32 = 0;

    loop {
        if i == 5_u32 {
            break;
        }

        let state: u8 = (remaining % 3).try_into().unwrap();
        arr.append(state);
        remaining = remaining / 3;

        i += 1;
    };

    arr.span()
}

fn pow(base: u16, exp: u32) -> u16 {
    if exp == 0 {
        return 1;
    }
    let mut result: u16 = 1;
    let mut i: u32 = 0;

    loop {
        if i == exp {
            break;
        }
        result = result * base;
        i += 1;
    };

    result
}

pub fn get_hint_for_attempt(word: felt252, attempt: felt252) -> Array<u8> {
    let mut result = ArrayTrait::new();
    let mut i: u32 = 4;
    let word_str = ascii_to_string(word);
    let attempt_str = ascii_to_string(attempt);

    loop {
        if i == 0_u32 {
            // Handle last character
            append_hint_for_char(0, word_str.span(), attempt_str.span(), ref result);
            break;
        }

        append_hint_for_char(i, word_str.span(), attempt_str.span(), ref result);
        i -= 1;
    };

    result
}

fn append_hint_for_char(
    position: u32, word: Span<u256>, attempt: Span<u256>, ref result: Array<u8>,
) {
    let word_char = *word.at(position);
    let attempt_char = *attempt.at(position);

    if word_char == attempt_char {
        result.append(2_u8); // Correct position
    } else if char_exists_in_word(attempt_char, word) {
        result.append(1_u8); // Exists but wrong position
    } else {
        result.append(0_u8); // Doesn't exist
    }
}

fn char_exists_in_word(char: u256, word: Span<u256>) -> bool {
    let mut j: u32 = 4;

    loop {
        if j == 0_u32 {
            if char == *word.at(0) {
                break true;
            }
            break false;
        }

        if char == *word.at(j) {
            break true;
        }
        j -= 1;
    }
}

pub fn ascii_to_string(value: felt252) -> Array<u256> {
    let mut result = ArrayTrait::new();
    let mut remaining: u256 = value.into();
    let mut i: u32 = 0;

    loop {
        if 0 == remaining {
            break;
        }

        let char = remaining % u256 { low: 256, high: 0 }; // Get ASCII value
        result.append(char);
        remaining = remaining / u256 { low: 256, high: 0 };

        i += 1;
    };

    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_next_day() {
        let next = get_next_day(1739278200);
        assert(next == 1739318400, 'timestamp doesnt match');
        let next = get_next_day(1739318400);
        assert(next == 1739404800, 'timestamp doesnt match');
        let next = get_next_day(1739404800);
        assert(next == 1739491200, 'timestamp doesnt match');
    }


    #[test]
    fn test_pack_attempts() {
        let state: Array<u8> = array![1, 2, 1, 0, 2];
        let packed = pack_attempt(state.span());
        let unpacked = unpack_attempt(packed);
        assert(state.span() == unpacked, 'invalid packing');
    }

    #[test]
    fn test_get_hint_for_attempt() {
        let result = get_hint_for_attempt('hello', 'house');
        let expected = array![2, 1, 0, 0, 1];
        assert(expected == result, 'invalid hint');

        let result = get_hint_for_attempt('sauce', 'bruce');
        let expected = array![0, 0, 2, 2, 2];
        assert(expected == result, 'invalid hint');
    }
}

