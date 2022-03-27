
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

    fn acceptAndAdd(f: Box<Filter>, n : i32) -> (bool, Box<Filter>) {
        let mut filter = f;
        let upto : i32 = (n as f64).sqrt() as i32;
        loop {
                if (n % filter.n) == 0 {
                    return (false, filter);
                }
                if filter.n > upto {
                    break;
                }
                match filter.next {
                    None => break,
                    Some(go) => filter = go
                }
        }
        let f = Filter::new(n);
        return (true, Filter::append(filter, Box::new(f)));
    }

    fn append(mut at : Box<Filter>, f : Box<Filter>) -> Box<Filter> {
        let my = at.next.take();
        let alloc = match my {
            None => f,
            Some(item) => {
                let mut r = item;
                let n = Filter::append(r, f);
                n
            },
        };
        at.next = Some(alloc);
        return at;
    }
}

fn main() {
    let g = Natural::new();
    println!("Fill {:?}", g);
}


#[cfg(test)]
mod tests {
    use super::Natural;
    use super::Filter;

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
        let (add3, f3) = Filter::acceptAndAdd(f, 3);
        assert!(add3);
        let (add4, f4) = Filter::acceptAndAdd(f3, 4);
        assert!(!add4);
        let (add5, f5) = Filter::acceptAndAdd(f4, 5);
        assert!(add5);
        println!("Fill {:?}", *f5);
    }
}
