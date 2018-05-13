# Data::Walk - Traverse Perl data structures.
# Copyright (C) 2005-2016 Guido Flohr <guido.flohr@cantanea.com>,
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
    plan tests => 28;
}

my $hash = {
    foo => 'bar',
    baz => 'bazoo',
};

my $arr = [
  "moo",
  "foo",
  1
];

walk sub {
  if ($Data::Walk::depth == 1) {
    #The top level has no container
    ok $Data::Walk::type, undef;
    #Hence no type for container
    ok $Data::Walk::container, undef;
  }
  elsif ( $Data::Walk::depth == 2) {
    ok $Data::Walk::type, q/HASH/;
    ok $Data::Walk::container, $hash;
  }
}, $hash;


walk sub {
  if ($Data::Walk::depth == 1) {
    #The top level has no container
    ok $Data::Walk::type, undef;
    #Hence no type for container
    ok $Data::Walk::container, undef;
  }
  elsif ( $Data::Walk::depth == 2) {
    ok $Data::Walk::type, q/ARRAY/;
    ok $Data::Walk::container, $arr;
  }
}, $arr;

walk sub {
  if ($Data::Walk::depth == 1) {
    #The top level has no container
    ok $Data::Walk::type, undef;
    #Hence no type for container
    ok $Data::Walk::container, undef;
  }
}, $hash, $arr;

walk sub {
  if ($Data::Walk::depth == 1) {
    #The top level has no container
    ok $Data::Walk::type, undef;
    #Hence no type for container
    ok $Data::Walk::container, undef;
  }
}, 1, $hash, $arr;
