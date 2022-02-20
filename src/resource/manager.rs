use std::env;
use std::fmt;
use std::fs::File;
use std::io::Read;

extern crate serde;
extern crate toml;

use serde::de;

use crate::resource;
use resource::farmer::Farmer;
use resource::resource::Resource;
use std::collections::HashMap;


static mut RESOURCE_CACHE: Option<Resource> = None;

#[derive(Debug, Default)]
pub struct ResourceCenter {
    names: Vec<String>,
    resources: Vec<Resource>,
    farmers: Vec<Vec<Farmer>>,
}
impl ResourceCenter {
    pub fn load_from_config() -> ResourceCenter {
        let path = env::current_exe().unwrap().parent().unwrap().join("cfg");

        let mut file = File::open(path.join("resources.toml")).unwrap();
        let mut bytes = Vec::new();
        file.read_to_end(&mut bytes).unwrap();
        let mut center: ResourceCenter = toml::from_slice(&bytes).unwrap();
        center.names.iter().enumerate().for_each(|(i, name)| {
            unsafe {
                RESOURCE_CACHE = Some(center.resources[i].clone());
            }
            file = File::open(path.join(name.to_owned() + ".toml")).unwrap();
            bytes.clear();
            file.read_to_end(&mut bytes).unwrap();
            let mut farmers: HashMap<String, Vec<Farmer>> = toml::from_slice(&bytes).unwrap();
            let mut farmers = farmers.remove("farmer").unwrap();
            // farmers
            //     .iter_mut()
            //     .for_each(|farmer| farmer.set_resource(&center.resources[i]));
            center.farmers.push(farmers);
        });
        unsafe {RESOURCE_CACHE = None;}
        center
    }

    pub(super) fn current_resource() -> Resource {
        unsafe { RESOURCE_CACHE.clone().unwrap() }
    }

    pub fn main(&mut self) {
        self.farmers
            .iter_mut()
            .flatten()
            .for_each(|farmer| farmer.charge());
    }
    pub fn print(&self) {
        self.names
            .iter()
            .zip(self.resources.iter())
            .for_each(|(n, r)| print!("{}: {}\n\r", n, r))
    }
}

impl fmt::Display for ResourceCenter {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.names
            .iter()
            .zip(self.resources.iter())
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
            state.resources.push(value.into());
        }

        Ok(state)
    }
}

impl<'de> de::Deserialize<'de> for ResourceCenter {
    fn deserialize<D: de::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        deserializer.deserialize_map(ResourceCenterVisitor {})
    }
}
