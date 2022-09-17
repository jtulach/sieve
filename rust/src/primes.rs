use crate::collection::CollectionTrait;

use crate::Instant;
use crate::Int;

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
type Collection<T> = crate::list::List<T>;

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
        let upto = crate::int_sqrt::integer_sqrt(number);
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
pub struct Primes {
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

    pub fn compute(&mut self) -> Int {
        let start = Instant::now();
        let mut cnt = 0;
        let mut prnt_cnt = 97;
        loop {
            let res = self.next();
            cnt += 1;
            if cnt % prnt_cnt == 0 {
                println!(
                    "Computed {} primes in {} ms. Last one is {}",
                    cnt,
                    (Instant::now() - start.clone()).as_millis(),
                    res,
                );
                prnt_cnt *= 2;
            }
            if cnt >= 100000 {
                break res;
            }
        }
    }
}
