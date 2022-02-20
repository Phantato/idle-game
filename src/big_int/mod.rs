mod add;
mod cmp;
mod div;
mod mul;
mod neg;
mod rem;
mod sub;

mod convert;

use core::fmt;
use std::collections::VecDeque;
use serde::{Serialize, Deserialize};

pub type Digit = i32;
pub type HalfDigit = i16;
pub const THOUSAND: Digit = 1000;
pub const HUNDRED: Digit = 100;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(from = "VecDeque<Digit>")]
pub struct BigUint {
    data: VecDeque<Digit>,
    #[serde(skip)]
    unit: VecDeque<String>,
}

impl BigUint {
    pub fn zero() -> BigUint {
        BigUint {
            data: vec![0].into(),
            unit: vec!["".to_owned()].into(),
        }
    }
    pub fn one() -> BigUint {
        BigUint {
            data: vec![1].into(),
            unit: vec!["".to_owned()].into(),
        }
    }

    pub fn long_div(&self, rhs: &BigUint) -> (BigUint, BigUint) {
        if self < rhs {
            (BigUint::zero(), self.to_owned())
        } else {
            let mut quotient = BigUint::zero();
            let mut remainder = BigUint::zero();
            for num in self.data.iter().rev() {
                quotient *= THOUSAND as HalfDigit;
                remainder *= THOUSAND as HalfDigit;
                remainder += *num;
                while remainder >= rhs {
                    quotient += BigUint::one();
                    remainder -= rhs;
                }
            }
            (quotient, remainder)
        }
    }

    fn normalize(&mut self) {
        let mut i = 0;
        while i < self.data.len() {
            i += 1;
            if self.data[i - 1] >= THOUSAND {
                if i == self.data.len() {
                    self.data.push_back(0);
                }
                self.data[i] += self.data[i - 1] / THOUSAND;
                self.data[i - 1] %= THOUSAND;
            } else if self.data[i - 1] < 0 {
                if i == self.data.len() {
                    self.data[i - 1] = -self.data[i - 1];
                    break;
                }
                self.data[i] += self.data[i - 1] / THOUSAND;
                self.data[i - 1] %= THOUSAND;
                if self.data[i - 1] < 0 {
                    self.data[i] -= 1;
                    self.data[i - 1] += THOUSAND;
                }
            }
        }

        while i > 1 && self.data[i - 1] == 0 {
            i -= 1;
        }
        self.data.truncate(i);
        self.unit.truncate(1);
        for _ in 1..self.data.len() {
            self.unit.push_back(self.next_unit());
        }
    }

    fn is_validate(&self) -> bool {
        self.data.len() > 0 && self.data.len() == self.unit.len()
    }

    fn next_unit(&self) -> String {
        debug_assert!(self.unit.len() > 0, "Unit should alway be at leat 1 len");
        if self.unit.len() == 1 {
            "a".to_owned()
        } else {
            let mut cur = self.unit.back().unwrap().clone().into_bytes();
            *cur.last_mut().unwrap() += 1;
            for i in (0..cur.len()).rev() {
                if cur[i] != b'z' + 1 {
                    break;
                }
                cur[i] = b'a';
                if i == 0 {
                    return "a".to_owned() + &String::from_utf8(cur).unwrap();
                } else {
                    cur[i - 1] += 1;
                }
            }
            String::from_utf8(cur).unwrap()
        }
    }
}

impl<T> From<T> for BigUint
where
    T: Into<VecDeque<Digit>>,
{
    fn from(data: T) -> BigUint {
        let data = data.into();
        let mut ret = BigUint {
            data,
            unit: vec!["".to_owned()].into(),
        };
        ret.normalize();
        ret
    }
}

impl fmt::Display for BigUint {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        debug_assert!(self.is_validate(), "corrupted BigUint");
        let len = self.data.len();
        if len == 1 {
            write!(f, "{}", self.data[len - 1])
        } else {
            write!(
                f,
                "{}.{} {}",
                self.data[len - 1],
                self.data[len - 2] / HUNDRED,
                self.unit[len - 1]
            )
        }
    }
}

// struct BigUintVisitor {}

// impl<'de> Visitor<'de> for BigUintVisitor {
//     type Value = VecDeque<Digit>;
//     fn expecting(&self, f: &mut fmt::Formatter) -> fmt::Result {
//         write!(f, "global resource state")
//     }

//     fn visit_seq<A>(self, seq: A) -> Result<Self::Value, A::Error>
//     where
//         A: SeqAccess<'de>,
//     {
//         let mut ret =  Self::Value::default();
//         while let Ok(Some(num)) = seq.next_element() {
//             ret.push_back(num);
//         }
//         Ok(ret)
//     }
// }

// impl<'de> Deserialize<'de> for BigUintVisitor {
//     fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
//         Ok(deserializer.deserialize_seq(BigUintVisitor {})?.into())
//     }
// }