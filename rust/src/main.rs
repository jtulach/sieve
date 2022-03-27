
#[derive(Debug)]
struct Natural {
    n : i32
}
impl Natural {
    fn new() -> Natural {
        return Natural { n : 2 };
    }

    fn next(&mut self) -> i32 {
        let v = self.n;
        self.n = self.n + 1;
        return v;
    }
}

#[derive(Debug)]
struct Filter {
    n : i32,
    next : Option<Box<Filter>>,
}

impl Filter {
    fn new(n : i32) -> Filter {
        Filter { n, next : None }
    }

    fn accept_and_add(f: Box<Filter>, n : i32) -> (bool, Box<Filter>) {
        let upto : i32 = (n as f64).sqrt() as i32;
        if Filter::divides(&f, n, upto) {
            return (false, f);
        }
        let prime = Box::new(Filter::new(n));
        return (true, Filter::append(f, prime));
    }

    fn divides(f: &Box<Filter>, n : i32, upto : i32) -> bool {
        if (n % f.n) == 0 {
            return true;
        }
        if f.n > upto {
            return false;
        }
        return match &f.next {
            None => false,
            Some(go) => Filter::divides(go, n, upto)
        }
    }

    fn append(mut at : Box<Filter>, f : Box<Filter>) -> Box<Filter> {
        let alloc = match at.next.take() {
            None => f,
            Some(item) => Filter::append(item, f)
        };
        at.next = Some(alloc);
        return at;
    }
}

struct Primes {
    natural: Natural,
    filter: Option<Box<Filter>>
}

impl Primes {
    fn new() -> Primes {
        return Primes { natural : Natural::new(), filter : None };
    }

    fn next(&mut self) -> i32 {
        loop {
            let n = self.natural.next();
            match self.filter.take() {
                None => {
                    self.filter = Some(Box::new(Filter::new(n)));
                    return n;
                },
                Some(p) => {
                    let res = Filter::accept_and_add(p, n);
                    self.filter = Some(res.1);
                    if res.0 {
                        return n;
                    }
                }
            };
        }
    }
}

fn main() {
    let mut p = Primes::new();
    let mut last = 0;
    let cnt = 10000;
    let now = std::time::SystemTime::now();
    for _i in 1..cnt {
        last = p.next();
    }
    let then = now.elapsed().ok().unwrap().as_millis();
    println!("{}th prime is {} - computed in {} ms", cnt, last, then);
}


#[cfg(test)]
mod tests {
    use super::Natural;
    use super::Filter;
    use super::Primes;

    #[test]
    fn natural_number_generator() {
        let mut g = Natural::new();
        assert_eq!(g.next(), 2);
        assert_eq!(g.next(), 3);
        assert_eq!(g.next(), 4);
    }

    #[test]
    fn filter_list() {
        let f = Box::new(Filter::new(2));
        let (add3, f3) = Filter::accept_and_add(f, 3);
        assert!(add3);
        let (add4, f4) = Filter::accept_and_add(f3, 4);
        assert!(!add4);
        let (add5, f5) = Filter::accept_and_add(f4, 5);
        assert!(add5);
        println!("Fill {:?}", *f5);
    }

    #[test]
    fn primes() {
        let mut p = Primes::new();
        assert_eq!(p.next(), 2);
        assert_eq!(p.next(), 3);
        assert_eq!(p.next(), 5);
        assert_eq!(p.next(), 7);
        assert_eq!(p.next(), 11);
        assert_eq!(p.next(), 13);
        assert_eq!(p.next(), 17);
        assert_eq!(p.next(), 19);
    }
}
