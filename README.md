# Neo
Neo is a terminal wrapper for Nasa's (Near Earth Object)[https://cneos.jpl.nasa.gov/] detection system.

## Compiling
- (Install nim)[https://nim-lang.org/install.html]
- Run `nim c -d:ssl main.nim` (must be compiled with `ssl` to requests with the `https` schema)
