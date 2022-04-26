pub trait CollectionTrait<T>
where
    for<'a> &'a Self: IntoIterator<Item = &'a T>,
{
    fn new(value: T) -> Self;
    fn push_back(&mut self, value: T);
}

impl<T> CollectionTrait<T> for std::collections::LinkedList<T> {
    fn new(value: T) -> Self {
        let mut c = Self::new();
        c.push_back(value);
        c
    }
    fn push_back(&mut self, value: T) {
        Self::push_back(self, value)
    }
}

impl<T> CollectionTrait<T> for Vec<T> {
    fn new(value: T) -> Self {
        let mut c = Self::new();
        c.push_back(value);
        c
    }
    fn push_back(&mut self, value: T) {
        Self::push(self, value)
    }
}
