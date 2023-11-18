mod dot;
use crate::dot::dot_product;
use dep::std::{wrapping_add, wrapping_sub, println};


// LWE params, this contains the gaussian distribution being used for the error
// As well as the size of the matricies being checked
// 
struct LWEParams {
    sigma: u32,
    n: u32,
}

// Learning With Errors Function
//
// Learning with errors is a foundational component in FHE encryption
// This function proves the encryption of a w, 
// We assume that plaintext has already been shifted above error
pub fn encrypt_lwe<N, M>(a_samples: [u32; N], sk: [u32; N], e: u32, plaintext: u32) -> [u32; M] {

    // TODO: assert error guassian sample is correct

    let mut a_s: u32 = dot_product(a_samples, sk);

    a_s = wrapping_add(a_s, e);
    a_s = wrapping_add(a_s, plaintext);

    let mut ciphertext: [u32; M] = [0; M];
    for i in 0..N {
        ciphertext[i] = a_samples[i];
    }
    ciphertext[M-1] = a_s;

    ciphertext
}

// Decrypt learning with errors function
pub fn decrypt_lwe<N,M>(ciphertext: [u32; M], sk: [u32; N]) -> u32 {
    let mut a_samples: [u32; N] = [0; N];
    for i in 0..N {
        a_samples[i] = ciphertext[i];
    }

    let a_s = dot_product(a_samples, sk);

    // We extract our b as the last element in the ciphertext
    let b = ciphertext[M-1];

    let plaintext = wrapping_sub(b, a_s);
    plaintext
}

#[test]
fn encrypt_and_decrypt() {
    // These should be random in practice, but for testing we can use deterministic values
    // TODO: maybe change this to use a mocked random number generator oracle call
    let error_size: u32 = 4;
    let plaintext = 2;
    let plaintext_shift: u32 = plaintext as u32 << error_size;
    let a_samples: [u32; 7] = [1,2,1,2,1,2,1];
    let secret_key: [u32; 7] = [11,12,11,12,11,12,11];

    let error: u32 = 1;

    // Note: need to denote the return length for generic compilation
    let ciphertext: [u32; 8] = encrypt_lwe(a_samples, secret_key, error, plaintext_shift);
    let decrypted_plaintext_pre_shift = decrypt_lwe(ciphertext, secret_key);
    let decrypted_plaintext = decrypted_plaintext_pre_shift >> error_size;

    assert(plaintext == decrypted_plaintext);
}