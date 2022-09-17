// using wrapping versions of instructions, because with debug mode and GraalVM:
// missing LLVM builtin: llvm.smul.with.overflow.i128
// and it is not possible to overflow anyway

#[derive(Clone)]
pub struct Instant {
    us: i128,
}

impl Instant {
    pub fn now() -> Self {
        let mut s = libc::timeval {
            tv_sec: 0,
            tv_usec: 0,
        };
        let err = unsafe { libc::gettimeofday(&mut s, std::ptr::null_mut()) };
        if err == -1 {
            panic!("libc::gettimeofday error");
        }

        Self {
            us: (s.tv_sec as i128)
                .wrapping_mul(1_000_000)
                .wrapping_add(s.tv_usec as i128),
        }
    }
}

impl std::ops::Sub for Instant {
    type Output = Duration;

    fn sub(self, rhs: Self) -> Self::Output {
        Duration {
            us: (self.us.wrapping_sub(rhs.us)) as u128,
        }
    }
}

pub struct Duration {
    us: u128,
}

impl Duration {
    pub fn as_millis(&self) -> u128 {
        self.us / 1000
    }
}
