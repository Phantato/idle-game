use crate::BigUint;
use core::fmt;
use core::ops::AddAssign;
use std::sync::{Arc, RwLock};

#[derive(Debug, Clone)]
pub struct Resource(Arc<RwLock<BigUint>>);

impl<T: Into<BigUint>> From<T> for Resource {
    fn from(num: T) -> Resource {
        Resource(Arc::new(RwLock::new(num.into())))
    }
}

impl fmt::Display for Resource {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", *self.0.read().unwrap())
    }
}

impl AddAssign<BigUint> for Resource {
    fn add_assign(&mut self, amount: BigUint) {
        let mut guard = self.0.write().unwrap();
        *guard += amount;
    }
}
