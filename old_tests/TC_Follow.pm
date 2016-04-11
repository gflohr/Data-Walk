#! /bin/false

# $Id: TC_Follow.pm,v 1.3 2006/05/11 13:56:28 guido Exp $

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

package TC_Follow;

use strict;

use base qw (Test::Unit::TestCase);

use Data::Walk;

my $data = { foo => 'bar' };
$data->{baz} = $data;

sub testDoNotFollow {
    my ($self) = @_;

    my $count = 0;
    my $wanted = sub {
	++$count;
	$self->assert ($count <= 5, 
		       "Cyclic references were followed although the"
		       . " option 'follow' was not given.");
    };
    walk { wanted => $wanted }, $data;

    $self->assert_equals (5, $count);
}

sub testDoFollow {
    my ($self) = @_;

    my $count = 0;

    my $preprocess = sub {
	my @args = @_;
	
	return () if $count > 10;

	return @args;
    };

    my $wanted = sub {
	++$count;
    };
    walk { wanted => $wanted, 
	       follow => 1, 
	       preprocess => $preprocess,
	   }, $data;

    $self->assert ($count > 5, "Cyclic references were not followed.");
}

sub testAddress {
    my ($self) = @_;

    my $data = {};
    bless $data, 'Data::Walk::Fake';

    my $wanted = sub {
	my $address = int $_;
	$self->assert_equals ($address, $Data::Walk::address);
    };
    walk { wanted => $wanted }, $data;
}

sub testSeen {
    my ($self) = @_;

    my $scalar = 'foobar';

    my $data = [ \$scalar, \$scalar, \$scalar ];
    my $count = 0;

    my $wanted = sub {
	unless ('ARRAY' eq ref $_) {
	    $self->assert_equals ($count++, $Data::Walk::seen);
	}
    };
    walk { wanted => $wanted }, $data;
    $self->assert_equals (@{$data}, $count);
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
