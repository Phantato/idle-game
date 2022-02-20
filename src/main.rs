mod big_int;
mod resource;
mod timer;

extern crate termion;

use std::sync::{Arc, Mutex, RwLock};
use std::thread::{sleep, spawn};
use std::time::Duration;

use big_int::*;
use resource::*;
use timer::*;

use std::io::{stdout, Read};
use termion::{raw::IntoRawMode};

use std::fs;
use std::io;

pub fn get_tty() -> io::Result<fs::File> {
    fs::OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/tty")
}
fn main() {
    stdout().into_raw_mode().unwrap();
    let mut num = BigUint::from([9999]);
    num *= &num.clone();

    let center = Arc::new(RwLock::new(ResourceCenter::load_from_config()));
    let m_center = center.clone();
    let mut timer = Timer::new(Duration::from_secs(1), move || {
        let mut guard = center.write().unwrap();
        guard.main();
    });
    timer.run();
    let mut acc = 0;
    let buf: Arc<Mutex<u8>> = Arc::new(Mutex::new(0));
    let m_buf = buf.clone();
    spawn(move || loop {
        sleep(Duration::from_secs(1));
        acc += 1;
        print!("\x1B[2J\x1B[1;1Htime passed: {}\n\r", acc);
        {
            let guard = m_center.read().unwrap();
            guard.print();
        }
        let input = *buf.lock().unwrap();
        print!("user input: {}\n\r", input);
    });
    loop{}
    // let stdin = get_tty().unwrap();
    // for byte in stdin.bytes() {
    //     let mut guard = m_buf.lock().unwrap();
    //     *guard = byte.unwrap();
    //     if *guard == 3 || *guard == 4 {
    //         break;
    //     }
    // }
    
}
