

// Dot product of two 32 bit vectors
pub fn dot_product<N>(a: [u32; N], s: [u32; N]) -> u32 {
    let mut result: u32 = 0;
    for i in 0..N {
        let product = a[i] * s[i];
        result = result + product as u32;
    }

    result
}


#[test]
fn test_dot() {
    let matrix1 = [1,2,3,4,5,6];
    let matrix2 = [1,2,3,4,5,6];
    let result = dot_product(matrix1, matrix2);
    assert(result == 91);
}