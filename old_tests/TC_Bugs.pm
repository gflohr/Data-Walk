#! /bin/false

# $Id: TC_Bugs.pm,v 1.4 2006/05/11 13:56:28 guido Exp $

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

package TC_Bugs;

use strict;

use base qw (Test::Unit::TestCase);

use Data::Walk;

sub testKeepBlessing {
    my ($self) = @_;

    my $data;

    $data = {
	foo => 'bar',
	baz => 'bazoo',
    };
    bless $data;
    walk { wanted => sub {} }, $data;
    $self->assert_str_equals (__PACKAGE__, ref $data);

    $data = [ 0, 1, 2, 3 ];
    bless $data;
    walk { wanted => sub {} }, $data;
    $self->assert_str_equals (__PACKAGE__, ref $data);

    $data = {
	foo => 'bar',
	baz => 'bazoo',
    };
    walk { wanted => sub {} }, $data;
    $self->assert_str_equals ('HASH', ref $data);
    my $success = $data =~ /^HASH\(0x[0-9a-f]+\)$/;
    $self->assert ($success, "Simple hash has been blessed: $data.");


    $data = [ 0, 1, 2, 3];
    walk { wanted => sub {} }, $data;
    $self->assert_str_equals ('ARRAY', ref $data);
    $success = $data =~ /^ARRAY\(0x[0-9a-f]+\)$/;
    $self->assert ($success, "Simple array has been blessed: $data.");
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
