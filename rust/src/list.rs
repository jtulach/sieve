// Quick own implementation of linked list - as with most datastructures "unsafe" code is required for performant/straightforward implementation.
// But the interface is safe - no UB can be caused by using this interface.

use std::ptr::NonNull;

struct Node<T> {
    next: Option<NonNull<Self>>,
    value: T,
}

impl<T> Node<T> {
    fn new_ptr(value: T) -> NonNull<Self> {
        unsafe { NonNull::new_unchecked(Box::into_raw(Box::new(Node { next: None, value }))) }
    }
}

pub struct NodeIterator<'a, T> {
    node: Option<&'a Node<T>>,
}

impl<'a, T> Iterator for NodeIterator<'a, T> {
    type Item = &'a T;
    fn next(&mut self) -> Option<Self::Item> {
        let node = self.node?;
        self.node = node.next.map(|r| unsafe { r.as_ref() });
        Some(&node.value)
    }
}

pub struct List<T> {
    first: Option<NonNull<Node<T>>>,
    last: Option<NonNull<Node<T>>>,
}

impl<T> Default for List<T> {
    fn default() -> Self {
        Self {
            first: None,
            last: None,
        }
    }
}

impl<'a, T> IntoIterator for &'a List<T> {
    type Item = &'a T;
    type IntoIter = NodeIterator<'a, T>;
    fn into_iter(self) -> Self::IntoIter {
        NodeIterator {
            node: self.first.map(|f| unsafe { f.as_ref() }),
        }
    }
}

impl<T> crate::collection::CollectionTrait<T> for List<T> {
    fn push_back(&mut self, value: T) {
        let ptr = Node::new_ptr(value);
        match &mut self.last {
            Some(last) => unsafe { last.as_mut() }.next = Some(ptr),
            None => self.first = Some(ptr),
        }
        self.last = Some(ptr);
    }
}

impl<T> Drop for List<T> {
    fn drop(&mut self) {
        let mut node = self.first;
        while let Some(ptr) = node {
            node = unsafe { ptr.as_ref().next };

            //dealloc
            unsafe { Box::from_raw(ptr.as_ptr()) };
        }
    }
}
