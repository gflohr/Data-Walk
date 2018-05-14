# Data-Walk

Data::Walk is for data, what File::Find is for file systems.  You can
use it for traversing arbitrarily complex Perl data structures.

Its closest relatives on CPAN are currently Data::Traverse and
Data::Walker.  Data::Traverse is very similar but can only handle
unblessed references and has less options.  Data::Walker offers an
interactive approach for traversing data structures.

Data::Dumper also offers some callbacks when traversing the structures,
but not the ones that I needed.  That was motivation enough for writing
Data::Walk.
