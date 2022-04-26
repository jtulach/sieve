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
    first: NonNull<Node<T>>,
    last: NonNull<Node<T>>,
}

impl<'a, T> IntoIterator for &'a List<T> {
    type Item = &'a T;
    type IntoIter = NodeIterator<'a, T>;
    fn into_iter(self) -> Self::IntoIter {
        NodeIterator {
            node: Some(unsafe { self.first.as_ref() }),
        }
    }
}

impl<T> crate::collection::CollectionTrait<T> for List<T> {
    fn new(starting: T) -> Self {
        let ptr = Node::new_ptr(starting);
        Self {
            first: ptr,
            last: ptr,
        }
    }

    fn push_back(&mut self, value: T) {
        let ptr = Node::new_ptr(value);
        unsafe { self.last.as_mut() }.next = Some(ptr);
        self.last = ptr;
    }
}

impl<T> Drop for List<T> {
    fn drop(&mut self) {
        let mut node_ptr = self.first.as_ptr();
        loop {
            let next_ptr = unsafe { (*node_ptr).next };

            //dealloc
            unsafe { Box::from_raw(node_ptr) };

            match next_ptr {
                Some(next_ptr) => node_ptr = next_ptr.as_ptr(),
                None => break,
            }
        }
    }
}
