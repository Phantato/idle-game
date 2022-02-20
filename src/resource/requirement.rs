use crate::BigUint;
use serde::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct ComposedRequirement(Vec<SingleRequirement>);

#[derive(Debug, Serialize, Deserialize)]
pub struct SingleRequirement {
    name: String,
    amount: BigUint,
    growth: BigUint,
}

pub trait Requirement {
    fn is_satisfied(&self) -> bool;
    fn move_next(&mut self);
}

impl<T: Into<Vec<SingleRequirement>>> From<T> for ComposedRequirement {
    fn from(v: T) -> ComposedRequirement {
        ComposedRequirement(v.into())
    }
}

impl Requirement for ComposedRequirement {
    fn is_satisfied(&self) -> bool {
        self.0.iter().fold(true, |acc, requirement| acc && requirement.is_satisfied())
    }
    fn move_next(&mut self) {
        self.0.iter_mut().for_each(|req| req.move_next());
    }
}

impl Requirement for SingleRequirement {
    fn is_satisfied(&self) -> bool {
        true
    }
    fn move_next(&mut self) {
        self.amount += &self.growth;
    }
}
