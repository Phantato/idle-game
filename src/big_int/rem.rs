use crate::*;
use core::ops::{Rem, RemAssign};

impl Rem for BigUint {
    type Output = BigUint;
    #[inline]
    fn rem(self, rhs: BigUint) -> Self::Output {
        &self % &rhs
    }
}

impl Rem<&BigUint> for BigUint {
    type Output = BigUint;
    #[inline]
    fn rem(self, rhs: &BigUint) -> Self::Output {
        &self % rhs
    }
}

impl Rem<BigUint> for &BigUint {
    type Output = BigUint;
    #[inline]
    fn rem(self, rhs: BigUint) -> Self::Output {
        self % &rhs
    }
}

impl Rem<&BigUint> for &BigUint {
    type Output = BigUint;
    #[inline]
    fn rem(self, rhs: &BigUint) -> Self::Output {
        let (_, remainder) = self.long_div(rhs);
        remainder
    }
}

impl RemAssign for BigUint {
    #[inline]
    fn rem_assign(&mut self, rhs: BigUint) {
        *self %= &rhs;
    }
}

impl RemAssign<&BigUint> for BigUint {
    #[inline]
    fn rem_assign(&mut self, rhs: &BigUint) {
        let (_, remainder) = self.long_div(rhs);
        *self = remainder;
    }
}

impl<T> Rem<T> for BigUint
where
    T: Into<HalfDigit>,
{
    type Output = BigUint;
    #[inline]
    fn rem(mut self, rhs: T) -> Self::Output {
        self %= rhs;
        self
    }
}

impl<T> RemAssign<T> for BigUint
where
    T: Into<HalfDigit>,
{
    #[inline]
    fn rem_assign(&mut self, rhs: T) {
        let rhs = rhs.into() as Digit;
        let data = &mut self.data;
        for i in (1..data.len()).rev() {
            data[i - 1] += (data[i] % rhs) * THOUSAND;
        }
        data[0] %= rhs;
        data.truncate(1);
        self.normalize();
    }
}
