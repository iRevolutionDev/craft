use std::{error, fmt, result};

#[derive(Debug)]
pub enum Error {
    SystemError(String),
    IoError(std::io::Error),
    MessageError(serde_json::Error),
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Error::SystemError(e) => write!(f, "System error: {}", e),
            Error::IoError(e) => write!(f, "IO error: {}", e),
            Error::MessageError(e) => write!(f, "Message error: {}", e),
        }
    }
}

impl error::Error for Error {}

impl From<std::io::Error> for Error {
    fn from(e: std::io::Error) -> Self {
        Error::IoError(e)
    }
}

impl From<serde_json::Error> for Error {
    fn from(e: serde_json::Error) -> Self {
        Error::MessageError(e)
    }
}

pub type Result<T> = result::Result<T, Error>;