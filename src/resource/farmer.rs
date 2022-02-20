use crate::big_int::*;
use crate::resource::*;

use requirement::ComposedRequirement;
use resource::Resource;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Farmer {
    name: String,
    amount: BigUint,
    #[serde(rename = "energy")]
    full_energy: i8,
    efficiency: BigUint,
    requirements: ComposedRequirement,
    #[serde(skip)]
    energy: i8,
    #[serde(skip, default = "ResourceCenter::current_resource")]
    resource: Resource,
}

impl Farmer {
    pub fn charge(&mut self) {
        self.energy += 1;
        if self.energy >= self.get_full_energy() {
            self.harvest();
            self.energy = 0;
        }
    }
    fn get_full_energy(&self) -> i8 {
        self.full_energy
    }
    fn harvest(&mut self) {
        self.resource += &self.efficiency * &self.amount;
    }
}
