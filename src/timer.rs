use std::mem::replace;
use std::sync::mpsc::channel;
use std::sync::{Arc, Condvar, Mutex};
use std::time::Duration;

enum State {
    Paused,
    Running,
    Finished,
}

pub struct Timer<F>
where
    F: FnMut(),
    F: Send + 'static,
{
    dur: Duration,
    fun: Option<F>,
    cond: Arc<(Mutex<State>, Condvar)>,
}

impl<F> Timer<F>
where
    F: FnMut(),
    F: Send + 'static,
{
    pub fn new(dur: Duration, fun: F) -> Timer<F> {
        let cond = Arc::new((Mutex::new(State::Paused), Condvar::new()));
        let fun = Some(fun);
        Timer { dur, fun, cond }
    }

    pub fn run(&mut self) {
        {
            let (lock, cvar) = &*self.cond;
            let mut guard = lock.lock().unwrap();
            *guard = State::Running;
            cvar.notify_one();
        }

        if let Some(mut fun) = replace(&mut self.fun, None) {
            let pair = Arc::clone(&self.cond);
            let dur = self.dur;
            std::thread::spawn(move || {
                let (tx, rx) = channel::<Option<()>>();
                let tx = tx.clone();
                std::thread::spawn(move || loop {
                    let (lock, cvar) = &*pair;
                    let guard = lock.lock().unwrap();
                    let result = cvar.wait_timeout(guard, dur).unwrap();
                    match &*result.0 {
                        State::Finished => {
                            tx.send(None).unwrap();
                            break;
                        }
                        State::Running => {
                            if result.1.timed_out() {
                                tx.send(Some(())).unwrap();
                            }
                        }
                        State::Paused => (),
                    }
                });
                for msg in rx.iter() {
                    match msg {
                        Some(_) => fun(),
                        None => break,
                    }
                }
            });
        }
    }

    pub fn stop(&self) {
        let (lock, cvar) = &*self.cond;
        let mut guard = lock.lock().unwrap();
        *guard = State::Finished;
        cvar.notify_one();
    }

    pub fn pause(&self) {
        let (lock, _) = &*self.cond;
        let mut guard = lock.lock().unwrap();
        *guard = State::Paused;
    }

    pub fn resume(&self) {
        let (lock, cvar) = &*self.cond;
        let mut guard = lock.lock().unwrap();
        *guard = State::Running;
        cvar.notify_one();
    }
}
