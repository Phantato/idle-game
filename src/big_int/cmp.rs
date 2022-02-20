use crate::*;
use core::cmp::Ordering;

impl PartialOrd for BigUint {
    #[inline]
    fn partial_cmp(&self, rhs: &BigUint) -> Option<Ordering> {
        Some(self.cmp(rhs))
    }
}

impl PartialOrd<&BigUint> for BigUint {
    #[inline]
    fn partial_cmp(&self, rhs: &&BigUint) -> Option<Ordering> {
        Some(self.cmp(rhs))
    }
}

impl PartialOrd<BigUint> for &BigUint {
    #[inline]
    fn partial_cmp(&self, rhs: &BigUint) -> Option<Ordering> {
        Some(self.cmp(&rhs))
    }
}

impl Ord for BigUint {
    fn cmp(&self, rhs: &BigUint) -> Ordering {
        debug_assert!(rhs.is_validate(), "corrupted BigUint");
        debug_assert!(self.is_validate(), "corrupted BigUint");
        fn cmp_helper(lhs: &BigUint, rhs: &BigUint, index: usize) -> Ordering {
            if index == lhs.data.len() {
                Ordering::Equal
            } else {
                match lhs.data[index].cmp(&rhs.data[index]) {
                    Ordering::Less => Ordering::Less,
                    Ordering::Greater => Ordering::Greater,
                    Ordering::Equal => cmp_helper(lhs, rhs, index + 1),
                }
            }
        }

        match self.data.len().cmp(&rhs.data.len()) {
            Ordering::Less => Ordering::Less,
            Ordering::Greater => Ordering::Greater,
            Ordering::Equal => cmp_helper(self, rhs, 0),
        }
    }
}

impl PartialEq<BigUint> for &BigUint {
    #[inline]
    fn eq(&self, rhs: &BigUint) -> bool {
        (*self).eq(rhs)
    }
}

impl PartialEq<&BigUint> for BigUint {
    #[inline]
    fn eq(&self, rhs: &&BigUint) -> bool {
        self.eq(*rhs)
    }
}

impl PartialEq for BigUint {
    #[inline]
    fn eq(&self, rhs: &BigUint) -> bool {
        self.data == rhs.data
    }
}

impl Eq for BigUint {}
