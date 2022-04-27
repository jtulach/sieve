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

impl Iterator for Natural {
    type Item = Int;
    fn next(&mut self) -> Option<Self::Item> {
        let old = self.cnt;
        self.cnt += 1;
        Some(old)
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
        self.prime != 0 && number % self.prime == 0
    }
}

#[derive(Default)]
struct Filters {
    filters: Collection<Filter>,
}

impl Filters {
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

#[derive(Default)]
struct Primes {
    natural: Natural,
    filters: Filters,
}

impl Primes {
    fn next(&mut self) -> Int {
        while let Some(cnt) = self.natural.next() {
            if self.filters.accept_and_add(cnt) {
                return cnt;
            }
        }
        // should never happen
        0
    }

    fn compute(&mut self) -> Int {
        let start = Instant::now();
        let mut cnt = 0;
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
