pub fn integer_sqrt(n: crate::Int) -> crate::Int {
    // missing LLVM builtin: llvm.fptoui.sat.i32.f64
    // return (n as f64).sqrt() as crate::Int;

    let mut bit = (1 as crate::Int) << (std::mem::size_of::<crate::Int>() * 8 / 2 - 1);

    let mut result = 0 as crate::Int;
    while bit != 0 {
        if n >= (result + bit) * (result + bit) {
            result += bit;
        }

        bit = bit >> 1;
    }

    result
}
