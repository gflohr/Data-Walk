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
    plan tests => 20;
}

my $data = {
    foo => 'bar',
    baz => 'bazoo',
};

Data::Walk::walk + {
    wanted => sub {
        if ( $Data::Walk::depth == 1 ) {
            ok $Data::Walk::type,      undef;
            ok $Data::Walk::container, undef;
        }
        elsif ( $Data::Walk::depth == 2 ) {
            ok $Data::Walk::type,      'HASH';
            ok $Data::Walk::container, $data;
        }
    },
    bydepth => 1
}, $data;
Data::Walk::walk + {
    wanted => sub {
        if ( $Data::Walk::depth == 1 ) {
            ok $Data::Walk::type,      undef;
            ok $Data::Walk::container, undef;
        }
        elsif ( $Data::Walk::depth == 2 ) {
            ok $Data::Walk::type,      'HASH';
            ok $Data::Walk::container, $data;
        }
    },
    bydepth => 0
}, $data;
__END__
