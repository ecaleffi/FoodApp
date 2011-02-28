package FoodApp::Controller::Maps;
use Moose;
use namespace::autoclean;
use HTML::GoogleMaps;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

FoodApp::Controller::Maps - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::Maps in Maps.');
}

=head2 view

Azione per visualizzare una mappa che mostri il percorso per collegare l'utente al distributore più vicino.

=cut

sub view :Local :Args(0) {
	my ( $self, $c ) = @_;

	$c->stash->{'template'} = 'maps/view.tt';

	my $map_key = 'ABQIAAAATU-uL8yHHSLQrbHQma3vgBTJQa0g3IQ9GZqIMmInSLzwtGDKaBSae_KOwxt2dISQ24FoRpbnnzja-Q';
	my $map = HTML::GoogleMaps->new(key => $map_key);
	$map->center(point => "Via tagliate, Mirandola");
	$map->add_marker(point => "Via tagliate, Mirandola");
	my $point1 = "44.88734, 11.05997";
	my $point2 = "44.89107, 11.08864";
	#$map->add_polyline(points => [$point1, $point2 ]);
	my ($head, $map_div, $map_script) = $map->render;

	$c->stash(	head => $head,
			map_div => $map_div,
			map_script => $map_script );
	$c->stash( 	point1 => $point1,
				point2 => $point2);
}


=head1 AUTHOR

Enrico Caleffi

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
