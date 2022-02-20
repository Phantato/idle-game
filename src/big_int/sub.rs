use crate::*;
use core::ops::{Sub, SubAssign};

impl Sub for BigUint {
    type Output = BigUint;
    #[inline]
    fn sub(self, rhs: BigUint) -> Self::Output {
        self - &rhs
    }
}

impl Sub<&BigUint> for BigUint {
    type Output = BigUint;
    #[inline]
    fn sub(mut self, rhs: &BigUint) -> Self::Output {
        self -= rhs;
        self
    }
}

impl Sub<BigUint> for &BigUint {
    type Output = BigUint;
    #[inline]
    fn sub(self, rhs: BigUint) -> Self::Output {
        rhs - self
    }
}

impl Sub for &BigUint {
    type Output = BigUint;
    #[inline]
    fn sub(self, rhs: &BigUint) -> Self::Output {
        self.clone() - rhs
    }
}

impl SubAssign for BigUint {
    #[inline]
    fn sub_assign(&mut self, rhs: BigUint) {
        *self -= &rhs
    }
}

impl SubAssign<&BigUint> for BigUint {
    #[inline]
    fn sub_assign(&mut self, rhs: &BigUint) {
        debug_assert!(rhs.is_validate(), "corrupted BigUint: {:?}", rhs);
        debug_assert!(self.is_validate(), "corrupted BigUint {:?}", self);
        // debug_assert!(*self >= *rhs, "sub_assign resulting a negative BigUint");
        for i in 0..rhs.data.len() {
            if i == self.data.len() {
                self.data.push_back(rhs.data[i]);
            } else {
                self.data[i] -= rhs.data[i];
            }
        }
        self.normalize();
    }
}
impl<T> Sub<T> for BigUint
where
    T: Into<Digit>,
{
    type Output = BigUint;
    #[inline]
    fn sub(mut self, rhs: T) -> Self::Output {
        self -= rhs;
        self
    }
}

impl<T> SubAssign<T> for BigUint
where
    T: Into<Digit>,
{
    #[inline]
    fn sub_assign(&mut self, rhs: T) {
        self.data[0] -= rhs.into();
        self.normalize();
    }
}
