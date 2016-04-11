#! /bin/false

# $Id: TC_Examples.pm,v 1.1 2006/05/11 13:49:09 guido Exp $

# Data::Walk - Traverse Perl data structures.
# Copyright (C) 2006 Guido Flohr <guido@imperia.net>,
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

package TC_Examples;

use strict;

use base qw (Test::Unit::TestCase);

use Data::Walk;

sub testRecursiveUntainting {
    my ($self) = @_;

    # We don't really untaint here, because we don't want to rely
    # on external modules or on running with -T.
    my $data = {
    	foo => [
		'bar', [ 'baz', "bazoo\nbazaar" ],
	],
    };
   
    my $concat = '';
    my $expect = "foobarbazbazoo\nbazaar";
    my $wanted = sub {
    	s/(.*)/$1/s unless ref $_;
	$concat .= $1 unless ref $_;
    };
    walk $wanted, $data;
    $self->assert_str_equals ($expect, $concat);
}

sub testMaxDepth {
    my ($self) = @_;

    my $data =[ 
    	f => [
	 fo => [
	   foo => [
	     'Ouch!',
	   ],
	 ],
	],
	b => [
	 ba => [
	   bar => [
	     'Ouch!',
	   ],
	 ],
	],
	b => [
	 ba => [
	   baz => [
	     'Ouch!',
	   ],
	 ],
	],
    ];

    my $pre_process = sub {
    	if ($Data::Walk::depth > 3) {
	    return ();
	} else {
	    return @_;
	}
    };
    
    my $concat = '';
    my $wanted = sub {
        $self->assert_str_not_equals ('Ouch!', $_) unless ref $_;
    	$concat .= $_ unless ref $_;
    };

    walk { wanted => $wanted, preprocess => $pre_process }, $data;
    my $expect = "ffofoobbabarbbabaz";
    $self->assert_str_equals ($expect, $concat);
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
