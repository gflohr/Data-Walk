#! /bin/false

# $Id: TC_ByDepth.pm,v 1.5 2006/05/11 13:56:28 guido Exp $

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

package TC_ByDepth;

use strict;

use base qw (Test::Unit::TestCase);

use Data::Walk;

sub testTraverseDepth {
    my $self = shift;

    my $data = [[[[[ 1 ], 11], 111], 1111], 11111];

    my $wasref = 1;
    my $last = 'undef';
    my $wanted = sub {
	my $isref = ref $_;

	$self->assert (($wasref xor $isref),
		       "References and non-references should "
		       . "alternate.  Last: $last, current: $_.");
	$last = $_;
	$wasref = $isref;
    };

    walkdepth $wanted, $data;
}

sub testDepth {
    my $self = shift;

    # The test data is constructed so that each node that is an
    # array reference has a number of elements equal to its depth.
    # Scalars are also equal to their depth.
    my $data = [
         [
              3, [ 4, 4, 4, ],
         ],
    ];

    my $wanted = sub {
        if (ref $_) {
            my $num = @$_;
            $self->assert_num_equals ($num, $Data::Walk::depth);
        } else {
                $self->assert_num_equals ($_, $Data::Walk::depth);
        }
    };

    walkdepth $wanted, $data;
}

1;

#Local Variables:
#mode: perl
#perl-indent-level: 4
#perl-continued-statement-offset: 4
#perl-continued-brace-offset: 0
#perl-brace-offset: -4
#perl-brace-imaginary-offset: 0
#perl-label-offset: -4
#cperl-indent-level: 4
#cperl-continued-statement-offset: 2
#tab-width: 8
#End:
