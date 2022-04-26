use std::time::Instant;

mod collection;
mod list;

use collection::CollectionTrait;

type Int = u32;

struct Natural {
    cnt: Int,
}

impl Default for Natural {
    fn default() -> Self {
        Self { cnt: 2 }
    }
}

impl Natural {
    fn next(&self) -> Self {
        Self { cnt: self.cnt + 1 }
    }
}

//type Collection<T> = Vec<T>;
//type Collection<T> = std::collections::LinkedList<T>;
type Collection<T> = list::List<T>;

struct Filter {
    prime: Int,
}

impl Filter {
    fn divides(&self, number: Int) -> bool {
        number % self.prime == 0
    }
}

struct Filters {
    filters: Collection<Filter>,
}

impl Filters {
    fn new() -> Self {
        Self {
            filters: <Collection<Filter> as CollectionTrait<Filter>>::new(Filter { prime: 2 }),
        }
    }

    fn accept_and_add(&mut self, number: Int) -> bool {
        let upto = (number as f32).sqrt() as Int;
        let res = !(&self.filters)
            .into_iter()
            .take_while(|f| f.prime <= upto)
            .any(|f| f.divides(number));
        if res {
            self.filters.push_back(Filter { prime: number });
        }
        res
    }
}

struct Primes {
    natural: Natural,
    filters: Filters,
}

impl Default for Primes {
    fn default() -> Self {
        Self {
            natural: Natural::default(),
            filters: Filters::new(),
        }
    }
}

impl Primes {
    fn next(&mut self) -> Int {
        loop {
            self.natural = self.natural.next();

            if self.filters.accept_and_add(self.natural.cnt) {
                break self.natural.cnt;
            }
        }
    }

    fn compute(&mut self) -> Int {
        let start = Instant::now();
        let mut cnt = 1;
        let mut prnt_cnt = 97;
        loop {
            let res = self.next();
            cnt += 1;
            if cnt % prnt_cnt == 0 {
                println!(
                    "Computed {cnt} primes in {} ms. Last one is {res}",
                    (Instant::now() - start).as_millis()
                );
                prnt_cnt *= 2;
            }
            if cnt >= 100000 {
                break res;
            }
        }
    }
}

fn main() {
    loop {
        let mut p = Primes::default();
        let start = Instant::now();
        let value = p.compute();
        let took = Instant::now() - start;
        println!(
            "Hundred thousand primes computed in {} ms",
            took.as_millis(),
        );
    }
}
