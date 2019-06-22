Turing Toys
===========

A collection of fun turing machines and assorted other computers.

    > cd ruby
    > bin/turing-toy AddOne 5
    0:    1 0[1]
    1:    1[0]0
    2:    1 1[0]
    2:    1 1 0[ ]
    2:    1 1 0[!]

    Output: 6

    > bin/tag-toy DivideTwoTag 3
    Aaaaaa
    aaaaB
    aaBb
    Bbb
    bccc
    ccc
    c
    > bin/tag-toy DivideTwoTag 3 -d 1
    3
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
