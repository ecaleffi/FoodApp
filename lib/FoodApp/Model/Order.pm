package FoodApp::Model::Order;
use strict;
use warnings;

BEGIN {
    use base qw/Catalyst::Model::Handel::Order/;
};

__PACKAGE__->config(
    connection_info => ['dbi:SQLite:db/handel.db', '', '']
);

=head1 NAME

FoodApp::Model::Order - Catalyst cart model component.

=head1 SYNOPSIS

See L<FoodApp>.

=head1 DESCRIPTION

Catalyst cart model component.

=head1 AUTHOR

enrico,,,

=cut

1;
