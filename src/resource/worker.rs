use crate::big_int::*;
use crate::resource::*;
use std::collections::HashMap;

use requirement::{ComposedRequirement, Requirement};
use resource::Resource;
use serde::{Deserialize, Serialize};
use std::fmt;

#[derive(Debug, Serialize, Deserialize)]
pub struct Product {
    name: String,
    efficiency: BigUint,
    #[serde(skip)]
    resource: Resource,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct WorkerBasic {
    name: String,
    amount: BigUint,
    #[serde(rename = "energy")]
    full_energy: i8,
    product: Vec<Product>,
    requirements: ComposedRequirement,
}

#[derive(Debug, Serialize)]
pub struct Worker {
    #[serde(flatten)]
    basic: WorkerBasic,
    #[serde(skip)]
    energy: i8,
}

impl Worker {
    pub fn new(mut basic: WorkerBasic, center: &ResourceCenter) -> Self {
        basic
            .product
            .iter_mut()
            .for_each(|prod| prod.resource = center.get_resource(&prod.name));
        Worker { basic, energy: 0 }
    }
    pub fn charge(&mut self) {
        self.energy += 1;
        if self.energy >= self.full_energy() {
            self.harvest();
            self.energy = 0;
        }
    }

    pub fn try_increase(&mut self, resources: &HashMap<String, Resource>) -> bool {
        if self.basic.requirements.is_satisfied(resources) {
            self.basic.requirements.move_next();
            self.basic.amount += 1;
            true
        } else {
            false
        }
    }

    pub fn full_energy(&self) -> i8 {
        self.basic.full_energy
    }
    pub fn amount(&self) -> &BigUint {
        &self.basic.amount
    }
    pub fn name(&self) -> &str {
        &self.basic.name
    }
    fn harvest(&mut self) {
        let amount = self.amount().to_owned();
        self.basic
            .product
            .iter_mut()
            .for_each(|prod| prod.resource += &amount * &prod.efficiency);
    }
}

impl fmt::Display for Worker {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}: {}\r\n", self.name(), self.amount())?;
        write!(f, "efficiency:\r\n")?;
        for prod in self.basic.product.iter() {
            write!(
                f,
                "\t{}: {}\r\n",
                prod.name,
                &prod.efficiency * self.amount()
            )?;
        }
        write!(f, "upgrade:\r\n{}", self.basic.requirements)?;
        Ok(())
    }
}
