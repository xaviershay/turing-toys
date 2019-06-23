Turing Toys
===========

A collection of fun turing machines and assorted other computers.

    > cd ruby
    > bin/turing-toy AddOne 5
    Q1:  _ 1 0[1]_
    Q1:  _ 1[0]0 _
    Q2:  _ 1 1[0]_
    Q2:  _ 1 1 0[_]
    Q2:  _ 1 1 0[!]
    > bin/turing-toy AddOne 5 -d 1 | tail -n-1
    6

    > bin/tag-toy DivideTwoTag 3
    Aaaaaa
    aaaaB
    aaBb
    Bbb
    bccc
    ccc
    c
    > bin/tag-toy DivideTwoTag 3 -d 1 | tail -n-1
    1

A more complicated beast can be found in the `haskell` subdirectory: _Magic: The
Gathering: The Computer._ It's an impletation of [this
paper](https://arxiv.org/abs/1904.09828) showing that MtG is turing complete.

    TAPE=$(ruby/bin/format-for-mtgtc DivideTwoRogozhin218 2)
    cd haskell
    stack build
    stack exec mtgtc -- "$TAPE"

You might be waiting a while...

Benchmarking
------------

Add `benchmark-plot' to `Gemfile`, then:

    brew install imagemagick@6
    export LDFLAGS="-L/usr/local/opt/imagemagick@6/lib"
    export CPPFLAGS="-I/usr/local/opt/imagemagick@6/include"
    export PKG_CONFIG_PATH="/usr/local/opt/imagemagick@6/lib/pkgconfig"
    bundle install
    bundle exec ruby benchmark/*.rb
