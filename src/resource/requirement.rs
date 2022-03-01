use crate::resource::resource::Resource;
use crate::BigUint;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fmt;

pub(crate) trait Requirement {
    fn is_satisfied(&self, resources: &HashMap<String, Resource>) -> bool;
    fn move_next(&mut self);
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ComposedRequirement(Vec<RequirementEnum>);

impl Default for ComposedRequirement {
    fn default() -> Self {
        ComposedRequirement(vec![])
    }
}

impl<T: Into<Vec<RequirementEnum>>> From<T> for ComposedRequirement {
    fn from(v: T) -> ComposedRequirement {
        ComposedRequirement(v.into())
    }
}

impl fmt::Display for ComposedRequirement {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for req in self.0.iter() {
            write!(f, "{}", req)?;
        }
        Ok(())
    }
}

impl Requirement for ComposedRequirement {
    fn is_satisfied(&self, resources: &HashMap<String, Resource>) -> bool {
        self.0.iter().fold(true, |acc, requirement| {
            acc && requirement.is_satisfied(resources)
        })
    }
    fn move_next(&mut self) {
        self.0.iter_mut().for_each(|req| req.move_next());
    }
}

macro_rules! requirement_enum {
    ($($t:ident), * )=> {
        #[derive(Debug, Serialize, Deserialize)]
        #[serde(untagged)]
        pub enum RequirementEnum {
            $($t($t),)*
        }

        impl fmt::Display for RequirementEnum {
            fn fmt(&self, fmt: &mut fmt::Formatter) -> fmt::Result {
                match self {
                    $(RequirementEnum::$t(v) => write!(fmt, "{}", v),)*
                }
            }
        }

        impl Requirement for RequirementEnum {
            fn is_satisfied(&self, resources: &HashMap<String, Resource>) -> bool {
                match self {
                    $(RequirementEnum::$t(v) => v.is_satisfied(resources),)*
                }
            }
            fn move_next(&mut self) {
                match self {
                    $(RequirementEnum::$t(v) => v.move_next(),)*
                }
            }
        }
        $(
            impl From<$t> for RequirementEnum {
                fn from(value: $t) -> RequirementEnum {
                    RequirementEnum::$t(value)
                }
            }
        )*
    }
}

requirement_enum![ComposedRequirement, SingleResourceRequirement];

#[derive(Debug, Serialize, Deserialize)]
pub struct SingleResourceRequirement {
    name: String,
    amount: BigUint,
    growth: BigUint,
}

impl fmt::Display for SingleResourceRequirement {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "\t{}: {}\r\n", self.name, self.amount)
    }
}

impl Requirement for SingleResourceRequirement {
    fn is_satisfied(&self, resources: &HashMap<String, Resource>) -> bool {
        resources[&self.name] >= self.amount
    }
    fn move_next(&mut self) {
        self.amount += &self.growth;
    }
}
