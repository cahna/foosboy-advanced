
FBA
===

An API for Foosball statistics tracking

## Dependencies

The versions listed are those that FBA has been developed against on Linux.

* [Moonscript](http://moonscript.org/) &ge; 0.2.5
* [Lapis](http://leafo.net/lapis/) 0.0.10
* [PostgreSQL](http://www.postgresql.org/) 9.3.4
* [ngx_openresty](http://openresty.org/) &ge; 1.5.11.1 compiled (_at least_) 
  with these configuration flags:
  - `--with-luajit`
  - `--with-http_postgres_module`
  - `--with-file-aio`

## Setup

1. Install and configure dependencies

2. Get the source

```bash
$ git clone https://github.com/cahna/foosboy-advanced.git
$ cd foosboy-advanced
```

3. Configure postgres

  - Create a database for FBA to use
  - Configure connection and credentials in `secret/environment_vars.moon`
    (see `secret/environment_vars.example.moon` for usage)

4. Create the database schema and run migrations (this will also compile the
   configuration files).

> __NOTE__: `lapis migrate` will not work. Use `make db` or `make migrate`.

```bash
# `make db` compiles configurations, so `make lapis` isn't necessary yet
$ make db
```

5. [ _optionally_ ] Run tests

```bash
$ make test
```

## Usage

* Start the server with:

```bash
# Compile everything
$ make lapis

# Run the server
$ lapis server
```

* Access the API via `localhost:8080/api/v1/` (see the [API docs](docs/api.md))

## MIT License

Copyright (C) 2014 Conor Heine

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.

