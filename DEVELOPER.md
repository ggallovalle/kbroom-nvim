# Task Runner

The project uses [Mask](https://github.com/jacobdeichert/mask) as a task runner.
The tasks are defined in the `maskfile.md` file.

To run the tasks, you need to install mask first.

```bash
# Install mask
$ brew install mask
# OR
$ cargo install mask

# List all the tasks
$ mask --help
```

# Tests

```bash
# Ruan all the tests
$ mask test

# Run an specific test
$ mask test tests/root_spec/filename_spec.lua
```
