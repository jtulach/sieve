mod collection;
mod int_sqrt;
mod list;
mod primes;
mod time;

//type Instant = std::time::Instant;
type Instant = time::Instant;

use primes::Primes;

type Int = u32;

fn main() {
    loop {
        let mut p = Primes::default();
        let start = Instant::now();
        let _value = p.compute();
        let took = Instant::now() - start;
        let millis = took.as_millis();

        println!("Hundred thousand primes computed in {} ms", millis,);
    }
}
