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
    > bin/turing-toy AddOne 5 | tail -n-1
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

Benchmarking
------------

Add `benchmark-plot' to `Gemfile`, then:

    brew install imagemagick@6
    export LDFLAGS="-L/usr/local/opt/imagemagick@6/lib"
    export CPPFLAGS="-I/usr/local/opt/imagemagick@6/include"
    export PKG_CONFIG_PATH="/usr/local/opt/imagemagick@6/lib/pkgconfig"
    bundle install
    bundle exec ruby benchmark/*.rb
