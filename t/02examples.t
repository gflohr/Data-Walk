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
    plan tests => 11;
}

my ($data, $wanted, $pre_process, $concat);

# We don't really untaint here, because we don't want to rely
# on external modules or on running with -T.
$data = {
    foo => [
	'bar', [ 'baz', "bazoo\nbazaar" ],
    ],
};
   
$concat = '';
my $expect = "foobarbazbazoo\nbazaar";
$wanted = sub {
    s/(.*)/$1/s unless ref $_;
    $concat .= $1 unless ref $_;
};
walk $wanted, $data;
ok $concat, $expect;

$data =[ 
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

$pre_process = sub {
    if ($Data::Walk::depth > 3) {
        return ();
    } else {
        return @_;
    }
};
    
$concat = '';
$wanted = sub {
    ok($_ ne 'Ouch!') unless ref $_;
    $concat .= $_ unless ref $_;
};

walk { wanted => $wanted, preprocess => $pre_process }, $data;
$expect = "ffofoobbabarbbabaz";
ok $concat, $expect;

