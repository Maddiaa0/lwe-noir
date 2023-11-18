mod dot;
use crate::dot::dot_product;
use dep::std::wrapping_add;

// Learning With Errors Function
//
// Learning with errors is a foundational component in FHE encryption
// This function proves the encryption of a w, 
// We assume that plaintext has already been shifted above error
fn lwe_nr<N,M>(a_samples: [u32; N], s: [u32; N], e: u32, plaintext: u32, ) -> [u32; M] {
    assert(M == N+1);

    let mut a_s = dot_product(a_samples, s);

    a_s = wrapping_add(a_s, e);
    a_s = wrapping_add(a_s, plaintext);

    let mut ciphertext: [u32; M] = [0; M];
    for i in 0..N {
        ciphertext[i] = a_samples[i];
    }
    let ciphertext_len = ciphertext.len();
    ciphertext[ciphertext_len-1] = a_s;

    ciphertext
}