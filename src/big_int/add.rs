use crate::*;
use core::ops::{Add, AddAssign};

impl Add for BigUint {
    type Output = BigUint;
    #[inline]
    fn add(self, rhs: BigUint) -> Self::Output {
        self + &rhs
    }
}

impl Add<&BigUint> for BigUint {
    type Output = BigUint;
    #[inline]
    fn add(mut self, rhs: &BigUint) -> Self::Output {
        self += rhs;
        self
    }
}

impl Add<BigUint> for &BigUint {
    type Output = BigUint;
    #[inline]
    fn add(self, rhs: BigUint) -> Self::Output {
        rhs + self
    }
}

impl Add for &BigUint {
    type Output = BigUint;
    #[inline]
    fn add(self, rhs: &BigUint) -> Self::Output {
        self.clone() + rhs
    }
}

impl AddAssign for BigUint {
    #[inline]
    fn add_assign(&mut self, rhs: BigUint) {
        *self += &rhs
    }
}

impl AddAssign<&BigUint> for BigUint {
    #[inline]
    fn add_assign(&mut self, rhs: &BigUint) {
        debug_assert!(rhs.is_validate(), "corrupted BigUint {:?}", self);
        debug_assert!(self.is_validate(), "corrupted BigUint {:?}", self);

        for i in 0..rhs.data.len() {
            if i == self.data.len() {
                self.data.push_back(rhs.data[i]);
            } else {
                self.data[i] += rhs.data[i];
            }
        }
        self.normalize();
    }
}

impl<T> Add<T> for BigUint
where
    T: Into<Digit>,
{
    type Output = BigUint;
    #[inline]
    fn add(mut self, rhs: T) -> Self::Output {
        self += rhs;
        self
    }
}

impl<T> AddAssign<T> for BigUint
where
    T: Into<Digit>,
{
    #[inline]
    fn add_assign(&mut self, rhs: T) {
        self.data[0] += rhs.into();
        self.normalize();
    }
}
