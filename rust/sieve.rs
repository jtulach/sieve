#[warn(non_snake_case)]

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
        Filter {
            n : n,
            next : None,
        }
    }

    fn acceptAndAdd(&mut self, n : i32) -> bool {
        let mut filter: &Filter = self;
        let upto : i32 = (n as f64).sqrt() as i32;
        loop {
                if (n % filter.n) == 0 {
                    return false;
                }
                if filter.n > upto {
                    break;
                }
                match &filter.next {
                    None => break,
                    Some(go) => filter = &go,
                }
        }
        let f = Filter::new(n);
        Filter::append(self, f);
        return true;
    }

    fn append(at : &mut Filter, f : Filter) {
        loop {
            match &at.next {
                None => {
                    at.next = Some(Box::new(f));
                    break;
                },
                Some(n) => {
                    at = n;
                },
            }
        }
    }
}

fn main() {
    let mut g = Natural::new();
    for _ in 1..30 {
        print!("{} ", g.next())
    }
    println!("");
    let mut f = Filter::new(2);
    f.acceptAndAdd(3);
    f.acceptAndAdd(4);
    println!("Fill {:?}", f);
}
