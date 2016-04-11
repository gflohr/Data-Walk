# Data::Walk - Traverse Perl data structures.
# Copyright (C) 2005-2006 Guido Flohr <guido@imperia.net>,
# all rights reserved.

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public License as published
# by the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.

# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

use strict;

use Test;
use Data::Walk;

BEGIN {
    plan tests => 6;
}

my ($data, $wanted, $count, $preprocess);

$data = {
    foo => 'bar',
    baz => 'bazoo',
};
$count = 0;
$preprocess = sub {
    my %args= @_;
    delete $args{baz};
    return %args;
};
walk { wanted => sub { ++$count }, preprocess => $preprocess }, $data;

ok 'bar', $data->{foo};
ok 'bazoo', $data->{baz};
ok $count, 3;

$data = {
    foo => 'bar',
    baz => 'bazoo',
};
$count = 0;
$preprocess = sub {
    my $args = shift;
    delete $args->{baz};
    return $args;
};
walk { wanted => sub { ++$count }, preprocess => $preprocess,
       copy => 0 }, $data;
ok bar => $data->{foo};
ok (!exists $data->{baz});
ok $count, 3;
