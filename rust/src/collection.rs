pub trait CollectionTrait<T>
where
    for<'a> &'a Self: IntoIterator<Item = &'a T>,
    Self: Default,
{
    fn push_back(&mut self, value: T);
}

impl<T> CollectionTrait<T> for std::collections::LinkedList<T> {
    fn push_back(&mut self, value: T) {
        Self::push_back(self, value)
    }
}

impl<T> CollectionTrait<T> for Vec<T> {
    fn push_back(&mut self, value: T) {
        Self::push(self, value)
    }
}
