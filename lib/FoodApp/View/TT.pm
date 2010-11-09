package FoodApp::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

FoodApp::View::TT - TT View for FoodApp

=head1 DESCRIPTION

TT View for FoodApp.

=head1 SEE ALSO

L<FoodApp>

=head1 AUTHOR

enrico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
