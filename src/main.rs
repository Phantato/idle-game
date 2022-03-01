mod big_int;
mod resource;
mod timer;

extern crate termion;

use big_int::*;
use resource::*;
use std::fs;
use std::io;
use std::io::{stdout, Read};
use std::sync::{Arc, Condvar, Mutex};
use std::thread;
use std::time::Duration;
use termion::raw::IntoRawMode;
use timer::*;

fn get_tty() -> io::Result<fs::File> {
    fs::OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/tty")
}

enum UIState {
    Main,
    Worker(usize),
}

fn index_to_page(index: usize, step: usize) -> Page {
    index * step..(index + 1) * step
}

fn main() {
    let stdout = stdout().into_raw_mode().unwrap();
    let mut num = BigUint::from([9999]);
    num *= &num.clone();
    let step = 2;
    let center = ResourceCenter::load_from_config();
    let pages = center.total_workers_pages(step);
    let center = Arc::new(Mutex::new(center));
    let m_center = center.clone();
    let mut timer = Timer::new(Duration::from_secs(1), move || {
        let mut guard = center.lock().unwrap();
        guard.main();
    });
    timer.run();
    let mut acc = 0;
    let buf = Arc::new((Mutex::new(0u8), Condvar::new()));
    let m_buf = buf.clone();
    thread::spawn(move || {
        let mut ui_state = UIState::Main;
        loop {
            let (lock, cvar) = &*buf;
            let guard = lock.lock().unwrap();
            let result = cvar.wait_timeout(guard, Duration::from_secs(1)).unwrap();
            acc += 1;
            print!("\x1B[2J\x1B[1;1H");
            print!("time passed: {}\r\n", acc);
            let mut input = result.0;
            let mut guard = m_center.lock().unwrap();
            match (&ui_state, &*input) {
                (UIState::Worker(_), 48) => {
                    ui_state = UIState::Main;
                }
                (UIState::Worker(page), x) if (49..58).contains(x) => {
                    let index = (x - 49).into();
                    if !guard.employ_worker(index, index_to_page(page.to_owned(), step)) {
                        print!("not enough resources\r\n");
                    }
                }
                (UIState::Worker(page), 44) => {
                    ui_state = UIState::Worker((page + pages - 1) % pages)
                }
                (UIState::Worker(page), 46) => ui_state = UIState::Worker((page + 1) % pages),
                (UIState::Worker(_), _) => {}
                (UIState::Main, 49) => {
                    ui_state = UIState::Worker(0);
                }
                _ => {
                    print!("{}\r\n", input);
                }
            }
            match &ui_state {
                UIState::Main => {
                    guard.print_resources();
                    print!("1 => worker menu: \r\n");
                }
                UIState::Worker(page) => {
                    guard.print_workers(index_to_page(page.to_owned(), step));
                    print!("index => to employ worker\r\n(`,`, `.`) for page changes \r\n0 => to return: \r\n");
                }
            }
            *input = 0;
        }
    });

    let stdin = get_tty().unwrap();
    for byte in stdin.bytes() {
        let byte = byte.unwrap();
        if byte == 3 || byte == 4 {
            break;
        }
        let (lock, cvar) = &*m_buf;
        let mut guard = lock.lock().unwrap();
        *guard = byte;
        cvar.notify_one();
    }
}
