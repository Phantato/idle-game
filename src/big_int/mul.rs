use crate::*;
use core::ops::{Mul, MulAssign};

impl Mul for BigUint {
    type Output = BigUint;
    #[inline]
    fn mul(self, rhs: BigUint) -> Self::Output {
        self * &rhs
    }
}

impl Mul<&BigUint> for BigUint {
    type Output = BigUint;
    #[inline]
    fn mul(mut self, rhs: &BigUint) -> Self::Output {
        self *= rhs;
        self
    }
}

impl Mul<BigUint> for &BigUint {
    type Output = BigUint;
    #[inline]
    fn mul(self, rhs: BigUint) -> Self::Output {
        rhs * self
    }
}

impl Mul for &BigUint {
    type Output = BigUint;
    #[inline]
    fn mul(self, rhs: &BigUint) -> Self::Output {
        self.clone() * rhs
    }
}

impl MulAssign for BigUint
{
    #[inline]
    fn mul_assign(&mut self, rhs: BigUint) {
        *self *= &rhs
    }
}

impl MulAssign<&BigUint> for BigUint {
    fn mul_assign(&mut self, rhs: &BigUint) {
        debug_assert!(rhs.is_validate(), "corrupted BigUint: {:?}", rhs);
        debug_assert!(self.is_validate(), "corrupted BigUint {:?}", self);
        let n = self.data.len();
        let m = rhs.data.len();
        let tot = m + n;
        self.data.resize(tot, 0);
        for i in 0..n {
            let mut carry = 0;
            for j in 0..m {
                let index = i + j + n;
                self.data[index % tot] += self.data[i] * rhs.data[j] + carry;
                carry = self.data[index % tot] / THOUSAND;
                self.data[(index) % tot] %= THOUSAND;
            }
            self.data[i] = carry;
        }
        self.data.rotate_left(n);
        
        self.normalize();
    }
}

impl<T> Mul<T> for BigUint
where
    T: Into<HalfDigit>,
{
    type Output = BigUint;
    #[inline]
    fn mul(mut self, rhs: T) -> Self::Output {
        self *= rhs;
        self
    }
}

impl<T> MulAssign<T> for BigUint
where
    T: Into<HalfDigit>,
{
    #[inline]
    fn mul_assign(&mut self, rhs: T) {
        let rhs = rhs.into() as Digit;
        for num in self.data.iter_mut() {
            *num *= rhs;
        }
        self.normalize();
    }
}
