#! /bin/false

# $Id: TC_PostProcess.pm,v 1.3 2006/05/11 13:56:28 guido Exp $

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

package TC_PostProcess;

use strict;

use base qw (Test::Unit::TestCase);

use Data::Walk;

sub testCalling {
    my ($self) = @_;

    my %data = ('A' .. 'Z', 'a' .. 'z');

    my $postprocessor_calls = 0;
    my $container;
    
    my $postprocess = sub {
	++$postprocessor_calls;
	$container = $Data::Walk::container;
    };

    my $wanted = sub {};
    walk { wanted => $wanted, postprocess => $postprocess}, \%data;

    $self->assert ($postprocessor_calls,
		   "Postprocessing function never called.");

    $self->assert_equals (\%data, $container);
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
