package FoodApp::Model::Cart;
use strict;
use warnings;

BEGIN {
    use base qw/Catalyst::Model::Handel::Cart/;
};

__PACKAGE__->config(
    connection_info => ['dbi:SQLite:db/handel.db', '', ''],
);

=head1 NAME

FoodApp::Model::Cart - Catalyst cart model component.

=head1 SYNOPSIS

See L<FoodApp>.

=head1 DESCRIPTION

Catalyst cart model component.

=head1 AUTHOR

enrico,,,

=cut

1;
