use crate::BigUint;
use serde::{Deserialize, Serialize};
use std::cmp;
use std::fmt;
use std::ops::AddAssign;
use std::sync::{Arc, RwLock};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Resource(Arc<RwLock<BigUint>>);

impl Default for Resource {
    fn default() -> Self {
        Resource(Arc::new(RwLock::new(BigUint::zero())))
    }
}

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

impl PartialOrd<BigUint> for Resource {
    fn partial_cmp(&self, other: &BigUint) -> Option<cmp::Ordering> {
        let guard = self.0.read().unwrap();
        guard.partial_cmp(other)
    }
}

impl PartialEq<BigUint> for Resource {
    fn eq(&self, other: &BigUint) -> bool {
        let guard = self.0.read().unwrap();
        *guard == other
    }
}

impl AddAssign<BigUint> for Resource {
    fn add_assign(&mut self, amount: BigUint) {
        let mut guard = self.0.write().unwrap();
        *guard += amount;
    }
}
