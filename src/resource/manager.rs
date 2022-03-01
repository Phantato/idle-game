use std::collections::HashMap;
use std::env;
use std::fmt;
use std::fs::File;
use std::io::Read;

pub type Page = std::ops::Range<usize>;

extern crate serde;
extern crate toml;

use serde::de;

use crate::resource;
use resource::resource::Resource;
use resource::worker::{Worker, WorkerBasic};

#[derive(Debug, Default)]
pub struct ResourceCenter {
    names: Vec<String>,
    resources: HashMap<String, Resource>,
    workers: Vec<Worker>,
}
impl ResourceCenter {
    pub fn load_from_config() -> ResourceCenter {
        let path = env::current_exe().unwrap().parent().unwrap().join("cfg");

        let mut file = File::open(path.join("resources.toml")).unwrap();
        let mut bytes = Vec::new();
        file.read_to_end(&mut bytes).unwrap();
        let mut center: ResourceCenter = toml::from_slice(&bytes).unwrap();
        let mut file = File::open(path.join("worker.toml")).unwrap();
        let mut bytes = Vec::new();
        file.read_to_end(&mut bytes).unwrap();
        let mut workers: HashMap<String, Vec<WorkerBasic>> = toml::from_slice(&bytes).unwrap();
        let mut worker = workers.remove("worker").unwrap();
        let wo: Vec<Worker> = worker
            .drain(..)
            .map(|worker| Worker::new(worker, &center))
            .collect();
        center.workers = wo;
        // center.workers = workers
        //     .remove("worker")
        //     .unwrap()
        //     .drain(..)
        //     .map(|worker| Worker::new(worker, &center))
        //     .collect();
        center
    }

    pub(crate) fn get_resource(&self, name: &String) -> Resource {
        self.resources[name].clone()
    }

    pub fn main(&mut self) {
        self.workers.iter_mut().for_each(|worker| worker.charge());
    }
    pub fn print_resources(&self) {
        self.resources
            .iter()
            .for_each(|(k, v)| print!("{}: {}\n\r", k, v))
    }
    pub fn total_workers_pages(&self, step: usize) -> usize {
        (self.workers.len() - 1) / step + 1
    }
    pub fn print_workers(&self, page: Page) {
        self.workers[page].iter().enumerate().for_each(|(i, w)| {
            print!("{}:\t{}", i, w);
        });
    }
    pub fn employ_worker(&mut self, index: usize, page: Page) -> bool {
        if page.end - page.start > index {
            self.workers[page][index].try_increase(&self.resources)
        } else {
            false
        }
    }
}

impl fmt::Display for ResourceCenter {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.resources
            .iter()
            .for_each(|(name, resource)| writeln!(f, "{}: {}", name, resource).unwrap());
        Ok(())
    }
}

struct ResourceCenterVisitor {}

impl<'de> de::Visitor<'de> for ResourceCenterVisitor {
    type Value = ResourceCenter;
    fn expecting(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "global resource state")
    }

    fn visit_map<M>(self, mut access: M) -> Result<Self::Value, M::Error>
    where
        M: de::MapAccess<'de>,
    {
        let mut state = ResourceCenter::default();
        while let Some((key, value)) = access.next_entry::<String, Vec<i32>>()? {
            state.names.push(key);
            let key = state.names.last().unwrap();
            state.resources.insert(key.to_string(), value.into());
        }

        Ok(state)
    }
}

impl<'de> de::Deserialize<'de> for ResourceCenter {
    fn deserialize<D: de::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        deserializer.deserialize_map(ResourceCenterVisitor {})
    }
}
