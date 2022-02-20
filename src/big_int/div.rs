use crate::*;
use core::ops::{Div, DivAssign};

impl Div for BigUint {
    type Output = BigUint;
    #[inline]
    fn div(self, rhs: BigUint) -> Self::Output {
        &self / &rhs
    }
}

impl Div<&BigUint> for BigUint {
    type Output = BigUint;
    #[inline]
    fn div(self, rhs: &BigUint) -> Self::Output {
        &self / rhs
    }
}

impl Div<BigUint> for &BigUint {
    type Output = BigUint;
    #[inline]
    fn div(self, rhs: BigUint) -> Self::Output {
        self / &rhs
    }
}

impl Div<&BigUint> for &BigUint {
    type Output = BigUint;
    #[inline]
    fn div(self, rhs: &BigUint) -> Self::Output {
        let (quotient, _) = self.long_div(rhs);
        quotient
    }
}

impl DivAssign for BigUint {
    #[inline]
    fn div_assign(&mut self, rhs: BigUint) {
        *self /= &rhs;
    }
}

impl DivAssign<&BigUint> for BigUint {
    #[inline]
    fn div_assign(&mut self, rhs: &BigUint) {
        let (quotient, _) = self.long_div(rhs);
        *self = quotient;
    }
}

impl<T> Div<T> for BigUint
where
    T: Into<HalfDigit>,
{
    type Output = BigUint;
    #[inline]
    fn div(mut self, rhs: T) -> Self::Output {
        self /= rhs;
        self
    }
}

impl<T> DivAssign<T> for BigUint
where
    T: Into<HalfDigit>,
{
    #[inline]
    fn div_assign(&mut self, rhs: T) {
        let rhs = rhs.into() as Digit;
        let data = &mut self.data;
        for i in (1..data.len()).rev() {
            data[i - 1] += (data[i] % rhs) * THOUSAND;
            data[i] /= rhs;
        }
        data[0] /=rhs;
        self.normalize();
    }
}
